const path = require("path")
const fs = require("fs")
const baseDir = path.join(__dirname, "../settings/")
const DEFAULTS = {
    "twitch": {
        "channel_name": "channel_name_here",
        "ingame-subs": false,
        "highlighted-message": {
            "enabled": false,
            "comment": "Shows user message on sream",
            "func": "GamePrintImportant(\"${name}:\",\"${message}\")"
        },
        "show_user_msg": true,
        "custom-rewards": {
            "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx": {
                "enabled": false,
                "name": "Example",
                "comment": "Does nothing?, jk it spawns eEEeeeEeeeeEE's\nmaybe delet later",
                "msg_head": "${name}:",
                "msg_body": "${message}",
                "func": "spawn_twitch_stuff(\"e\", 15)"
            }
        }
    },
    "noita": {
        "enabled": true,
        "game_ui": true,
        "obs_overlay": false,
        "display_votes": true,
        "random_on_no_votes": true,
        "named_enemies": true,
        "scuffed_mode": false,
        "multiple_winners": false,
        "time_between_votes": 90,
        "voting_time": 60,
        "options_per_vote": 4,
        "permanent_gamba_option": false,
        "random_voting_time": {
            "enabled": false,
            "min": 30,
            "max": 120
        },
        "random_time_between": {
            "enabled": false,
            "min": 30,
            "max": 60
        },
        "option_types": [
            {
                "name": "enviromental",
                "rarity": 140
            },
            {
                "name": "enemies",
                "rarity": 100
            },
            {
                "name": "bad_effects",
                "rarity": 100
            },
            {
                "name": "good_effects",
                "rarity": 90
            },
            {
                "name": "worms",
                "rarity": 90
            },
            {
                "name": "traps",
                "rarity": 50
            },
            {
                "name": "curses",
                "rarity": 70
            },
            {
                "name": "helpful",
                "rarity": 90
            },
            {
                "name": "detrimental",
                "rarity": 90
            },
            {
                "name": "perks",
                "rarity": 80
            },
            {
                "name": "unknown",
                "rarity": 80
            },
            {
                "name": "lame",
                "rarity": 20
            }
        ]
    }
}
class Settings {
    constructor() {
        this.props = new Map()
        this.loadProps()
    }

    get(key) {
        const exists = this.props.has(key)
        if (!exists) {
            const defaultValue = DEFAULTS[key]
            this.props.set(key, defaultValue || {})
            this.save(key)
        }
        return this.props.get(key)
    }

    set(prop, val) {
        this.props.set(prop, val)

        this.save(prop)
    }

    setKey(prop, key, val) {
        this.props.get(prop)[key] = val
        this.save(prop)
    }

    setSubkey(prop, key, subKey, val) {
        if (typeof this.props[key] == "undefined") {
            this.props[key] = {}
        }
        this.props[key][subKey] = val
        this.save(prop)
    }

    loadProps() {
        const files = fs.readdirSync(baseDir)
        for (const file of files) {
            const key = file.split(".")[0]
            const data = JSON.parse(fs.readFileSync(path.join(baseDir + file)))
            const defaultValue = DEFAULTS[key] ? JSON.parse(JSON.stringify(DEFAULTS[key])) : {}
            let needSave = []
            for (const property in defaultValue) {
                if (data[property] === null || data[property] === undefined) {
                    data[property] = defaultValue[property]
                    if (needSave.indexOf(key) === -1) {
                        needSave.push(key)
                    }
                }
            }
            this.props.set(key, data)
            if (needSave.length > 0) {
                for (const prop of needSave) {
                    this.save(prop)
                }
            }
        }
    }

    save(key) {
        try {
            const filepath = path.join(baseDir, key + ".json")
            fs.writeFileSync(filepath, JSON.stringify(this.props.get(key), null, 2))
        } catch (error) {
            console.log(error)
        }
    }
}

module.exports = Settings