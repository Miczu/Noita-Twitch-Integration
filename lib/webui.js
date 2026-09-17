const express = require("express")
const path = require("path")
const open = require("open")

const DEFAULT_TYPES = [//dirty fix
    {
        name: "enviromental", rarity: 140
    },
    {
        name: "enemies", rarity: 100
    },
    {
        name: "bad_effects", rarity: 100
    },
    {
        name: "good_effects", rarity: 90
    },
    {
        name: "worms", rarity: 90
    },
    {
        name: "traps", rarity: 50
    },
    {
        name: "curses", rarity: 70
    },
    {
        name: "helpful", rarity: 90
    },
    {
        name: "detrimental", rarity: 90
    },
    {
        name: "perks", rarity: 80
    },
    {
        name: "unknown", rarity: 80
    },
    {
        name: "lame", rarity: 20
    }
]
class WebUI {
    constructor(parent) {
        this.port = 8989
        this.parent = parent
        this.dir = path.join(__dirname, "../webui")
        this.app = express()
        this.app.use(express.static(this.dir))
        // CSRF protection for API
        this.app.use((req, res, next) => {
            if (req.headers["sec-fetch-site"] === "same-origin") {
                next()
            } else {
                res.status(403).send({ error: "request must be from same origin" })
            }
        })
        this.app.use(express.urlencoded({ extended: true }));
        this.app.use(express.json());
        this.init()
    }

    init() {
        this.app.get("/reset/:key", (req, res) => {
            let { key } = req.params

            if (key == "outcomes") {
                this.parent.settings.set("outcomes", {})
                this.parent.noita.outcomes.loadOutcomes()
                res.json(this.parent.settings.get("outcomes"))
                res.end()
            }
            else {//key == option_types
                this.parent.settings.setKey("noita", "option_types", DEFAULT_TYPES)
                res.json(this.parent.settings.get("noita"))
                res.end()
            }
        })

        this.app.get("/outcomes", (req, res) => {
            res.json(this.parent.settings.get("outcomes"))
            res.end()
        })

        this.app.get("/noita", (req, res) => {
            res.json(this.parent.settings.get("noita"))
            res.end()
        })

        this.app.get("/twitch", (req, res) => {
            res.json(this.parent.settings.get("twitch"))
            res.end()
        })

        this.app.post("/outcomes/:key", (req, res) => {
            let { key } = req.params
            let val = req.body
            this.parent.settings.setKey("outcomes", key, val)
            res.end()
        })

        this.app.post("/noita", (req, res) => {
            let val = req.body
            this.parent.settings.set("noita", val)
            res.end()
        })

        this.app.post("/twitch", (req, res) => {
            let val = req.body
            let old = JSON.parse(JSON.stringify(this.parent.settings.get("twitch")))
            this.parent.settings.set("twitch", val)

            if (old.channel_name != this.parent.settings.get("twitch").channel_name) {
                this.parent.twitch.rejoin()
            }
            res.end()
        })

        this.app.post("/togame/:option", (req, res) => {
            let { option } = req.params
            option = `twitch_${option}()`
            if (this.parent.noita) {
                if (this.parent.noita.noitaClient) {
                    this.parent.noita.noitaClient.send(option)
                }
            }
            res.end()
        })

        this.app.post("/misc/:name", (req, res) => {
            let { name } = req.params
            let body = req.body
            if (name == "reload_outcomes") {
                if (this.parent.noita) {
                    this.parent.noita.outcomes.loadOutcomes()
                }
            }
            else if (name == "timeleft") {
                let { val } = body
                if (isNaN(val)) { return }
                if (this.parent.noita) {
                    this.parent.noita.affectTimer(val)
                }
            }
            res.end()
        })

        this.app.listen(this.port, "127.42.0.69")
        open(`http://127.42.0.69:${this.port}/`)
    }
}

module.exports = WebUI