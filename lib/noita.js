const ws = require("ws")
const fs = require("fs")
const path = require("path")
class Outcomes {
    constructor(parent) {
        this.parent = parent
        this.dir = path.join(__dirname, "../twitch_fragments/outcomes")
        this.loadOutcomes()
    }

    get settings() {
        return this.parent.settings.get("outcomes")
    }

    drawByType(num, types) {
        const outcomes = this.getOutcomes()
        const gamba_option = outcomes.gamba
        gamba_option.votes = 0
        const permanent_gamba_option = this.parent.settings.get("noita").permanent_gamba_option
        if (permanent_gamba_option) delete outcomes.gamba
        const options = Object.values(outcomes)
        const enabled_options = {}
        options.forEach((val) => {
            if (val.enabled) {
                if (typeof enabled_options[val.type] == "undefined") { enabled_options[val.type] = [] }
                enabled_options[val.type].push(val)
            }
        })
        const counter = {}
        for (let i = 1 + Number(permanent_gamba_option); i <= num;) {
            let type = this.pickRandom(types)
            if (typeof counter[type.name] == "undefined") {
                counter[type.name] = 0
            }
            if (typeof enabled_options[type.name] !== "undefined" && enabled_options[type.name].length > counter[type.name]) {
                counter[type.name] += 1
                i++
            }
        }
        let final = []
        for (const option of Object.keys(counter)) {
            for (let i = 0; i < counter[option]; i++) {
                final.push(this.pickRandom(enabled_options[option], true))
            }
        }

        final = JSON.parse(JSON.stringify(final)).map(val => {
            val.votes = 0
            return val
        }).sort((a, b) => {
            return a.name.length - b.name.length
        })
        if (permanent_gamba_option) final.push(JSON.parse(JSON.stringify(gamba_option)))
        return final
    }

    getOutcomes() {
        return JSON.parse(JSON.stringify(this.settings))
    }

    defaultSettings(data, id) {
        let lines = data.split(/(\r\n|\r|\n)/gm)
        let info = []
        for (let i in lines) {
            if (lines[i].startsWith("--")) {
                info.push(lines[i].substr(2, lines[i].length))
            }
            if (info.length > 4) { break }
        }
        let [name, description, type, rarity, comment] = info
        this.parent.settings.setKey("outcomes", id, {
            id,
            name: name && name.trim() || id,
            enabled: true,
            comment: comment || "What does this do ?",
            description: description || "Description below name in game",
            type: (type && type.trim()) || "unknown",
            rarity: Number(rarity) || 50
        })
    }

    loadOutcomes() {
        const files = fs.readdirSync(this.dir)
        for (const file of files) {
            const name = file.split(".")[0]
            if (typeof this.settings[name] == "undefined") {
                const data = fs.readFileSync(path.join(this.dir, file), "utf8")
                this.defaultSettings(data, name)
            }
        }
    }

    getLua() {
        let lua = ""
        const files = fs.readdirSync(this.dir)
        for (const file of files) {
            const name = file.split(".")[0]
            const data = fs.readFileSync(path.join(this.dir, file), "utf8")
            if (typeof this.settings[name] == "undefined") {
                this.defaultSettings(data, name)
            }
            lua += data + "\n"
        }
        return lua
    }

    pickRandom(options, trim = false) {
        let sum = options.reduce((accumulator, val) => accumulator + val.rarity, 0)
        let rand = Math.random() * sum
        let total = 0
        let lastIdx = -1
        let selectedIdx = null

        for (let i in options) {
            let rarity = options[i].rarity
            total += rarity
            if (rarity > 0) {
                if (rand <= total) {
                    selectedIdx = i
                    break
                }
                lastIdx = i
            }

            if (i === options.length - 1) {
                selectedIdx = lastIdx
            }
        }

        let result = options[selectedIdx]

        if (trim) {
            options.splice(selectedIdx, 1)
        }

        return result
    }
}

class Noita {
    constructor(parent) {
        this.port = 9090
        this.noitaClient = null
        this.server = new ws.Server({ port: this.port })

        this.outcomes = new Outcomes(parent)
        this.twitch = parent.twitch
        this.parent = parent

        this.voting = false
        this.voteOffset = 0
        this.timeLeft = 0
        this.userVotes = {}
        this.choices = []
        this.lastContact = Date.now()
        this.queueDelay = 5000
        this.queue = []

        this.voters = []
        this.lastVotersMessage = Date.now()
        this.timers = { voting: null, between: null }
        this.init()
    }

    get settings() {
        return this.parent.settings.get("noita")
    }

    init() {
        this.twitch.client.on("message", (ch, userstate, message, self) => {
            const displayableName = this.twitch.getDisplayableName(userstate)
            if (self) return
            if (this.voters.indexOf(displayableName) === -1) {
                this.voters.push(`"${displayableName}"`)
            }
            this.handleVote(userstate['user-id'], message)
        })
        this.server.on("connection", (socket) => {
            if (!this.isConnectionLocalhost(socket)) {
                socket.terminate()
                return
            }

            socket.on("message", (data) => {
                this.handleData(data, socket)
            })

            socket.on("close", () => {
                if (this.noitaClient === socket) {
                    console.log("BYE NOITA")
                    this.noitaClient = null
                    this.choices = []
                    //this.voters = []
                    this.updateObsFile(true)
                }
            })
        })
        this.gameLoop()
        this.votersLoop()
    }

    isConnectionLocalhost(ws) {
        const addr = ws._socket.remoteAddress
        return (addr == "::1") || (addr == "127.0.0.1") || (addr == "localhost") || (addr == "::ffff:127.0.0.1")
    }

    handleData(data, ws) {
        let dataJSON = null
        if (data.slice(0, 1) == ">") {
            if (data == ">RES> [no value]") { return }
            console.log(data)
            return
        } else {
            try {
                dataJSON = JSON.parse(data)
            } catch (e) {
                console.log(data)
                console.error(e)
                return
            }
        }

        if (dataJSON.kind === "heartbeat") {
            this.lastContact = Date.now()
            if (this.noitaClient != ws) {
                console.log("Registering game client")
                this.noitaClient = ws
                this.noitaStartTime = Date.now()
                this.choices = []
                this.timers.between = this.randomBetween(this.settings.random_time_between.min, this.settings.random_time_between.max)
                this.timers.voting = this.randomBetween(this.settings.random_voting_time.min, this.settings.random_voting_time.max)
                this.toGame(`set_print_to_socket(true)`)
                this.toGame(`GamePrint('Noita and TwitchBot connected.')`)

                this.noitaFile("game_ui.lua")

                this.noitaFile("action_handlers.lua")
                this.noitaFile("utils.lua")
                this.noitaFile("potion_material.lua")
                this.toGame(this.outcomes.getLua())
                this.sendOutcomesMeta()
            }
        }
    }

    handleVote(user, vote) {
        if (!this.voting) {
            return
        }
        let iv = vote.match(/^-?\d+/)
        iv = iv && iv[0]
        iv = parseInt(iv)
        if (isNaN(iv)) {
            return
        }
        let absIv = Math.abs(iv)
        if (this.voteOffset > 0) {
            absIv = absIv - this.voteOffset
        }        
        if (absIv < 0 || absIv > this.choices.length) {
            return
        }
        iv = Math.sign(iv) * absIv
        this.userVotes[user] = iv
    }

    updateVotes() {
        for (const choice of this.choices) {
            choice.votes = 0
        }
        for (let uid in this.userVotes) {
            let vote = this.userVotes[uid]
            let absVote = Math.abs(this.userVotes[uid])
            if (absVote > 0 && absVote <= this.choices.length) {
                this.choices[absVote - 1].votes += Math.sign(vote)
            }
        }
    }

    inGameChoices() {
        let choices = []
        let index = 1
        let show = this.settings.display_votes

        for (const choice of this.choices) {
            choices.push(`"${index + this.voteOffset}> ${choice.name} ${show ? '(' + choice.votes + ')' : ""}"`)
            index += 1
        }
        return `{${choices.join(",")}}`
    }

    updateObsFile(purge) {
        const obsFile = path.join(__dirname, "../obs.txt")
        if (purge) {
            fs.writeFileSync(obsFile, "")
            return
        }
        const template = this.parent.settings.get("obs_template")

        let index = 1
        let content = []
        let show = this.settings.display_votes
        if (this.voting) {
            content.push(this.interpolate(template.during_voting, { seconds: this.timeLeft }))
        }
        else {
            content.push(this.interpolate(template.between_votes, { seconds: this.timeLeft }))
        }
        for (const choice of this.choices) {
            let votes = choice.votes || 0
            votes = `${template.wrap_votes_left}${votes}${template.wrap_votes_right}`
            let i = `${template.wrap_index_left}${index + this.voteOffset}${template.wrap_index_right}`
            let name = `${template.wrap_choice_left}${choice.name}${template.wrap_choice_right}`
            if (!show) {
                votes = ""
            }
            content.push(this.interpolate(template.choice, { index: i, choice: name, votes }))
            index += 1
        }
        let final = template.vertical ? content.join("\n") : content.join(template.divider)
        fs.writeFileSync(obsFile, final)
    }
    saveVoteHistory ( obj ) 
    {     
        var data = {}
        obj.forEach(v=> data[v.id] = v.votes)        
        let output = {vote: data, time: Date.now() - this.noitaStartTime}
        let text = JSON.stringify(output)
        const obsFile = path.join(__dirname, "../voteHistory.txt")
		fs.appendFile(obsFile, text + '\n', 'utf8', function (err) {
			if (err) {
				console.error("Error appending to the file:", err);
			}
		});
    }
    getWinner() {
        //scuffed_mode
        //multiple_winners
        let winners = null
        this.saveVoteHistory(this.choices)
        if (this.settings.scuffed_mode) {
            this.choices.sort((a, b) => a.votes - b.votes)
            winners = this.choices.filter((val) => val.votes > 0)
            let results = []

            if (!this.settings.random_on_no_votes && winners.length === 0) {
                results.push({ id: 'nobody_voted', name: "Nobody voted!", description: "chat is asleep" })
                return results
            }

            let totalVotes = this.choices.reduce((sum, { votes }) => sum + votes, 0)

            for (const choice of this.choices) {
                let chance = (choice.votes / totalVotes) * 100
                let rng = Math.random() * totalVotes + 1//??
                if (rng >= chance) {
                    results.push(choice)
                    if (!this.settings.multiple_winners) {
                        break
                    }
                }
            }

            if (results.length === 0) {
                results.push(this.choices[this.choices.length - 1])
            }
            return results
        }
        else {
            this.choices.sort((a, b) => b.votes - a.votes)
            winners = this.choices.filter((val) => val.votes == this.choices[0].votes)
            let winner = null
            if (winners.length > 1) {
                if (!this.settings.random_on_no_votes && winners[0].votes == 0 && winners[1].votes == 0) {
                    winner = { id: 'nobody_voted', name: "Nobody voted!", description: "chat is asleep" }
                }
                else {
                    winner = winners[Math.floor(Math.random() * winners.length)]
                }
            }
            else {
                winner = winners[0]
            }
            return [{
                func: winner.id == "nobody_voted" ? "twitch_viewers = {}" : `twitch_${winner.id}()`,
                name: winner.name,
                desc: winner.description
            }]
        }
    }

    toGame(code) {
        if (!this.noitaClient) {
            console.log("Push to queue")
            this.queue.push(code)
            return
        }

        this.noitaClient.send(code)

        if (this.queue.length > 0) {
            setTimeout(() => {
                this.toGame(this.queue.shift())
            }, this.queueDelay)
        }
    }

    noitaFile(filename) {
        let fileData = fs.readFileSync(path.join(__dirname, "../twitch_fragments/" + filename))
        this.toGame(fileData)
    }

    isPaused() {
        return Date.now() - this.lastContact > 3000
    }

    sendVoters() {
        let message = `twitch_viewers = {${this.voters.join(",")}}`
        this.toGame(message)
        this.lastVotersMessage = Date.now()
    }

    sendOutcomesMeta() {
        let outcomes = Object.values(this.outcomes.getOutcomes())
        let message = "\nti_outcomes = {}"
        for (const outcome of outcomes) {
            message += `table.insert(ti_outcomes,{id="${outcome.id}",name="${outcome.name}",description="${outcome.description}",type="${outcome.type}",enabled=${outcome.enabled}, fn=twitch_${outcome.id}})\n`
        }
        this.toGame(message)
    }

    async gameLoop() {
        while (true) {
            this.voting = false
            while (this.noitaClient == null) {
                await this.sleep(5)
            }
            await this.doQuestion()
        }
    }

    async votersLoop() {
        while (true) {
            if (this.settings.named_enemies) {
                if (Date.now() - this.lastVotersMessage > 10000 && !this.isPaused()) {
                    this.sendVoters()
                }
            }
            await this.sleep(2)
        }
    }

    async doQuestion() {
        if (!this.settings.enabled) {
            if (this.settings.game_ui) {
                if (!this.noitaClient) return
                this.noitaClient.send(`clear_display()`)
            }
            await this.sleep(1)
            return
        }

        this.timeLeft = this.getTime("time_between")
        while (this.timeLeft > 0) {
            if (this.noitaClient == null) return

            if (!this.settings.game_ui) {
                this.noitaClient.send(`clear_display()`)
            }

            if (this.settings.game_ui) {
                this.noitaClient.send(`set_countdown(${this.timeLeft})`)
            }

            if (this.settings.obs_overlay) {
                this.updateObsFile()
            }
            this.timeLeft -= 1
            await this.sleep(1)
        }

        if (!this.settings.enabled) {
            if (this.settings.game_ui) {
                if (!this.noitaClient) return
                this.noitaClient.send(`clear_display()`)
            }
            await this.sleep(1)
            return
        }

        if (this.noitaClient == null) return

        this.voting = true
        this.userVotes = {}

        this.choices = this.outcomes.drawByType(this.settings.options_per_vote, this.settings.option_types)
        if (this.settings.game_ui) {
            this.noitaClient.send(`update_outcome_display(${this.inGameChoices()}, "0")`)
        }
        if (this.settings.obs_overlay) {
            this.updateObsFile()
        }

        this.timeLeft = this.getTime("voting_time")

        while (this.timeLeft > 0) {
            if (this.noitaClient == null) return

            if (!this.isPaused()) {
                this.updateVotes()

                if (!this.settings.game_ui) {
                    this.noitaClient.send(`clear_display()`)
                }

                if (this.settings.game_ui) {
                    this.noitaClient.send(`update_outcome_display(${this.inGameChoices()}, ${this.timeLeft})`)
                }

                if (this.settings.obs_overlay) {
                    this.updateObsFile()
                }

                this.timeLeft -= 1
            }
            await this.sleep(1)
        }

        if (!this.settings.enabled) {
            if (this.settings.game_ui) {
                if (!this.noitaClient) return
                this.noitaClient.send(`clear_display()`)
            }
            await this.sleep(1)
            return
        }

        if (this.noitaClient == null) return

        let winners = this.getWinner()
        this.choices = []
        for (const winner of winners) {
            this.noitaClient.send("clear_display()")
            this.noitaClient.send(`GamePrintImportant("${winner.name}","${winner.desc}", "mods/twitch-integration/files/3piece_ti.png")`)
            this.noitaClient.send(winner.func)
        }
        if (this.voteOffset > 0) {
            this.voteOffset = 0
        }
        else {
            this.voteOffset = this.settings.options_per_vote
        }
    }

    getTime(key) {
        let time = 60
        if (key == "time_between") {
            if (this.settings.random_time_between.enabled) {
                if (this.settings.random_time_between.randomize) {
                    time = this.randomBetween(this.settings.random_time_between.min, this.settings.random_time_between.max)
                }
                else {
                    time = this.timers.between
                }
            }
            else {
                time = this.settings.time_between_votes
            }
        }
        else {
            if (this.settings.random_voting_time.enabled) {
                if (this.settings.random_voting_time.randomize) {
                    time = this.randomBetween(this.settings.random_voting_time.min, this.settings.random_voting_time.max)
                }
                else {
                    time = this.timers.voting
                }
            }
            else {
                time = this.settings.voting_time
            }
        }
        return time
    }

    randomBetween(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min
    }

    affectTimer(val) {
        let newVal = this.timeLeft + val
        this.timeLeft = newVal <= 0 ? 3 : newVal
    }

    sleep(secs) {
        return new Promise(res => {
            setTimeout(() => {
                res()
            }, secs * 1000)
        })
    }

    getObjPath(objPath, obj, fallback = '') {
        return objPath.split('.').reduce((res, key) => res[key] || fallback, obj)
    }

    interpolate(template, variables, fallback) {
        const regex = /\${[^{]+}/g
        return template.replace(regex, (match) => {
            const objPath = match.slice(2, -1).trim()
            return this.getObjPath(objPath, variables, fallback)
        })
    }
}

module.exports = Noita
