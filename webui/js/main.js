const TwitchView = Vue.component("ti-twitch", {
    data() {
        return {
            tempId: "",
            snackbar: { right: true, bottom: true },
            models: { twitch: {} },
            temp: { twitch: {} }
        }
    },
    computed: {
        unsavedChanges: function () {
            return JSON.stringify(this.models) !== JSON.stringify(this.temp)
        },
        enabledHighlights: function () {
            return this.temp.twitch.show_user_msg || false
        },
        rewards: function () {
            if (!this.temp.twitch["custom-rewards"]) { return [] }
            return Object.keys(this.temp.twitch["custom-rewards"])
        }
    },
    methods: {
        reset: function () {
            this.temp = JSON.parse(JSON.stringify(this.models))
        },
        apply: function (id) {
            axios.post(`/twitch`, this.temp.twitch)
            this.models = JSON.parse(JSON.stringify(this.temp))
        },
        addReward: function (id) {
            this.$set(this.temp.twitch["custom-rewards"], id, {
                enabled: false,
                name: "Unnamed",
                comment: "What does it do?",
                msg_head: "",
                msg_body: "",
                func: ""
            })
        },
        rmReward: function (id) {
            this.$set(this.temp.twitch["custom-rewards"], id, undefined)
        }
    },
    beforeCreate: async function () {
        let twitch = await axios.get("/twitch")
        const data = JSON.stringify(twitch.data)
        this.$set(this.models, "twitch", JSON.parse(data))
        this.$set(this.temp, "twitch", JSON.parse(data))
    },
    template: `<v-container fluid> <v-snackbar :timeout="0" :right="snackbar.right" :bottom="snackbar.bottom" :value="unsavedChanges">Unsaved Changes</v-snackbar>
        <v-card>
            <v-toolbar color="deep-purple" flat>
                <v-toolbar-title>Twitch Settings</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
                <v-row dense>
                    <v-col cols="12">
                        <v-card flat>

                            <v-card-text>
                                <v-row justify="space-around">
                                    <v-col cols="12" xs="12" sm="12" md="6">
                                        <v-text-field label="Channel Name" v-model="temp.twitch.channel_name" outlined>
                                        </v-text-field>
                                    </v-col>
                                    
                                        <v-checkbox label="Ingame Subs" v-model="temp.twitch['ingame-subs']">
                                        </v-checkbox>
                                        <v-checkbox label="Ingame Highlights" v-model="temp.twitch.show_user_msg">
                                        </v-checkbox>
                                    
                                </v-row>
                            </v-card-text>
                        </v-card>
                    </v-col>

                    <v-col v-if="enabledHighlights">
                        <v-card flat>
                            <v-toolbar color="deep-purple" flat>
                                <v-toolbar-title>Highlighted Messages</v-toolbar-title>
                            </v-toolbar>
                            <v-card-text>
                                <v-row>
                                    <v-col cols="6" md="6" >
                                        <v-textarea label="Comment" v-model="temp.twitch['highlighted-message'].comment" outlined>
                                        </v-textarea>
                                    </v-col>
                                    <v-col cols="6" md="6" >
                                        <v-textarea label="Function" v-model="temp.twitch['highlighted-message'].func" outlined>
                                        </v-textarea>
                                    </v-col>
                                </v-row>
                            </v-card-text>
                        </v-card>
                    </v-col>

                    <v-col cols="12">
                        <v-card flat>
                            <v-toolbar color="deep-purple" flat>
                                <v-toolbar-title>Custom Rewards</v-toolbar-title>
                            </v-toolbar>
                            <v-row v-for="id in rewards" :key="id">
                                <template v-if="typeof temp.twitch['custom-rewards'][id] != 'undefined'">
                                <v-col cols="12" md="12">
                                    <span class="subtitle-2">
                                        <v-btn @click="rmReward(id)" icon large class="ma-0"><v-icon>mdi-delete</v-icon></v-btn>
                                        id: {{id}}
                                    </span>
                                </v-col>
                                <v-col cols="8" md="8">
                                    <v-text-field label="Reward Name" v-model="temp.twitch['custom-rewards'][id].name" outlined>
                                    </v-text-field>
                                </v-col>
                                <v-col cols="4" md="4">
                                    <v-checkbox label="Enabled" v-model="temp.twitch['custom-rewards'][id].enabled">
                                    </v-checkbox>
                                </v-col>
                                <v-col cols="6" md="6">
                                    <v-text-field label="Message Header" v-model="temp.twitch['custom-rewards'][id].msg_head" outlined>
                                    </v-text-field>
                                </v-col>
                                <v-col cols="6" md="6">
                                    <v-text-field label="Message Body" v-model="temp.twitch['custom-rewards'][id].msg_body" outlined>
                                    </v-text-field>
                                </v-col>
                                <v-col cols="6" md="6" >
                                    <v-textarea label="Comment" v-model="temp.twitch['custom-rewards'][id].comment" outlined>
                                    </v-textarea>
                                </v-col>
                                <v-col cols="6" md="6">
                                    <v-textarea label="Function" v-model="temp.twitch['custom-rewards'][id].func" outlined>
                                    </v-textarea>
                                </v-col>
                                <v-col cols="12" md="12">
                                <v-divider></v-divider>
                                </v-col>
                                </template>
                            </v-row>
                        </v-card>
                    </v-col>
                </v-row>

                <v-col cols="12" md="12">
                    <v-text-field label="Add Reward" hint="Reward id from the console: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
                    v-model="tempId" @keypress.enter="addReward(tempId)">
                        <template v-slot:append>
                            <v-btn depressed tile class="ma-0" @click="addReward(tempId)">Add</v-btn>
                        </template>
                    </v-text-field>
                </v-col>

                <v-divider></v-divider>
                <v-card-actions>
                    <v-row align="center" justify="center">
                        <v-btn tile @click="apply()">Apply</v-btn>
                        <v-divider vertical></v-divider>
                        <v-btn tile @click="reset()">Cancel</v-btn>
                    </v-row>
                </v-card-actions>
            </v-card-text>
        </v-card>
    </v-container>`
})

const NoitaView = Vue.component("ti-noita", {
    data() {
        return {
            snackbar: { right: true, bottom: true },
            models: { noita: {} },
            temp: { noita: {} }
        }
    },
    computed: {
        randomizedTime: function () {
            const timers = {
                voting: false,
                between: false
            }
            if (Object.keys(this.temp.noita).length > 0) {
                timers.voting = this.temp.noita.random_voting_time.enabled
                timers.between = this.temp.noita.random_time_between.enabled
            }
            return timers
        },
        getCols: function () {
            const cols = {
                voting: 6,
                between: 6
            }
            if (Object.keys(this.temp.noita).length > 0) {
                cols.between = this.temp.noita.random_voting_time.enabled ? 12 : 6
                cols.voting = this.temp.noita.random_time_between.enabled ? 12 : 6
                cols.varying = cols.voting == cols.between ? 6 : 12
            }
            return cols
        },
        unsavedChanges: function () {
            if (!this.temp.noita) { return }
            let temp = JSON.parse(JSON.stringify(this.temp.noita))
            if (temp.option_types && temp.option_types.length > 0) {
                for (let option in temp.option_types) {
                    delete temp.option_types[option].uid
                }
            }
            return JSON.stringify(this.models.noita) !== JSON.stringify(temp)
        },
        totalWeight: function () {
            if (!this.temp.noita) { return }
            if (Object.keys(this.temp.noita.option_types || {}) == 0) { return }
            if (this.temp.noita.option_types) {
                return this.temp.noita.option_types.reduce((accumulator, val) => accumulator + val.rarity, 0)
            }
            else {
                return 0
            }
        }
    },
    methods: {
        reset: function () {
            this.temp = JSON.parse(JSON.stringify(this.models))
            if (this.temp.noita.option_types.length > 0) {
                for (let option in this.temp.noita.option_types) {
                    this.temp.noita.option_types[option].uid = (Math.random() * 100000000) + 1000
                }
            }
        },
        apply: function (id) {
            let toSend = JSON.parse(JSON.stringify(this.temp.noita))
            if (toSend.option_types.length > 0) {
                for (let option in toSend.option_types) {
                    delete toSend.option_types[option].uid
                }
            }
            axios.post(`/noita`, toSend)
            this.$set(this.models, "noita", toSend)
        },
        getDefaults: async function () {
            let defaults = await axios.get("/reset/option_types")
            let data = JSON.stringify(defaults.data)
            this.$set(this.models, "noita", JSON.parse(data))
            this.$set(this.temp, "noita", JSON.parse(data))
            if (this.temp.noita.option_types.length > 0) {
                for (let option in this.temp.noita.option_types) {
                    this.temp.noita.option_types[option].uid = (Math.random() * 100000000) + 1000
                }
            }
        },
        isNumber(val) {
            if (typeof val == "number") {
                return true
            }
            else {
                return "Not a number"
            }
        },
        calculateOdds: function (index) {
            let weight = this.temp.noita.option_types[index].rarity
            let odds = (weight / this.totalWeight) * 100
            return `${odds.toFixed(2)}%`
        },
        votingMinRule(val) {
            if (val > this.temp.noita.random_voting_time.max) {
                return "Must be lower than max"
            }
            else return true
        },
        betweenMinRule(val) {
            if (val > this.temp.noita.random_time_between.max) {
                return "Must be lower than max"
            }
            else return true
        },
        votingMaxRule(val) {
            if (val < this.temp.noita.random_voting_time.min) {
                return "Must be higher than min"
            }
            else return true
        },
        betweenMaxRule(val) {
            if (val < this.temp.noita.random_time_between.min) {
                return "Must be higher than min"
            }
            else return true
        },
        voteOptionsRule(val) {
            if (val < 1) {
                return "Must be at least 1"
            } else if (val % 1 != 0) {
                return "Must be an integer"
            }
            else return true
        }
    },
    beforeCreate: async function () {
        let noita = await axios.get("/noita")
        const data = JSON.stringify(noita.data)
        this.$set(this.models, "noita", JSON.parse(data))
        this.$set(this.temp, "noita", JSON.parse(data))

        if (this.temp.noita.option_types.length > 0) {
            for (let option in this.temp.noita.option_types) {
                this.temp.noita.option_types[option].uid = (Math.random() * 100000000) + 1000
            }
        }
    },
    template: `<v-container fluid> <v-snackbar :timeout="0" :right="snackbar.right" :bottom="snackbar.bottom" :value="unsavedChanges">Unsaved Changes</v-snackbar>
    <v-card>
        <v-toolbar color="deep-purple" flat>
            <v-toolbar-title>Noita Settings</v-toolbar-title>
        </v-toolbar>
        <v-card-text>
            <v-row dense>
                <v-col cols="12">
                    <v-card flat>
                        <v-card-text>
                            <v-row justify="space-around">
                                <v-checkbox label="Enable Voting" v-model="temp.noita.enabled">
                                </v-checkbox>
                                <v-checkbox label="Ingame UI" v-model="temp.noita.game_ui">
                                </v-checkbox>
                                <v-checkbox label="OBS Overlay" v-model="temp.noita.obs_overlay">
                                </v-checkbox>
                                <v-checkbox label="Show Votes" v-model="temp.noita.display_votes">
                                </v-checkbox>
                                <v-checkbox label="Named Enemies" v-model="temp.noita.named_enemies">
                                </v-checkbox>
                                <v-checkbox label="Random Winner" v-model="temp.noita.random_on_no_votes">
                                </v-checkbox>

                                <v-checkbox label="Scuffed Mode" v-model="temp.noita.scuffed_mode">
                                </v-checkbox>
                                <v-checkbox label="Multiple Winners" v-model="temp.noita.multiple_winners">
                                </v-checkbox>

                                <template v-if="typeof temp.noita.random_voting_time !== 'undefined'">
                                    <v-checkbox label="Varying Voting Time" v-model="temp.noita.random_voting_time.enabled">
                                    </v-checkbox>
                                    <v-checkbox label="Varying Time Between" v-model="temp.noita.random_time_between.enabled">
                                    </v-checkbox>
                                </template>
                                <v-col cols="12">
                                    <v-divider></v-divider>
                                </v-col>

                                <v-col cols="12">
                                    <v-card color="grey darken-3" flat>
                                        <v-toolbar color="deep-purple darken-1" flat>
                                            <v-toolbar-title>Vote Choices</v-toolbar-title>
                                        </v-toolbar>
                                        <v-card-text>
                                            <v-row>
                                                <v-col cols="12">
                                                    <v-text-field label="Number Of Options" v-model.number="temp.noita.options_per_vote" type="number" :rules="[isNumber, voteOptionsRule]" outlined>
                                                    </v-text-field>
                                                    <v-checkbox label="Permanent Gamba Option" v-model="temp.noita.permanent_gamba_option">
                                                    </v-checkbox>
                                                </v-col>
                                            </v-row>
                                        </v-card-text>
                                    </v-card>
                                </v-col>

                                <v-col cols="12"  :sm="getCols.voting" :md="getCols.voting" :xl="getCols.voting" v-if="!randomizedTime['voting']">
                                    <v-text-field label="Voting Time" v-model.number="temp.noita.voting_time" type="number" :rules="[isNumber]" outlined>
                                    </v-text-field>
                                </v-col>
                                <v-col cols="12"  :sm="getCols.between" :md="getCols.between" :xl="getCols.between" v-if="!randomizedTime['between']">
                                    <v-text-field label="Time Between Votes" v-model.number="temp.noita.time_between_votes" type="number" :rules="[isNumber]" outlined>
                                    </v-text-field>
                                </v-col>

                                <v-col cols="12"  :sm="getCols.varying" :md="getCols.varying" :xl="getCols.varying" v-if="randomizedTime['voting']">    
                                    <v-card color="grey darken-3" flat>
                                        <v-toolbar color="deep-purple darken-1" flat>
                                            <v-toolbar-title>Voting Time</v-toolbar-title>
                                        </v-toolbar>
                                        <v-card-text>
                                            <v-row>
                                                <v-col cols="12">
                                                    <v-checkbox label="Randomize After Each Vote" v-model="temp.noita.random_voting_time.randomize">
                                                    </v-checkbox>
                                                </v-col>
                                                <v-col cols="12" sm="6" md="6">
                                                    <v-text-field label="Min" v-model.number="temp.noita.random_voting_time.min" type="number" :rules="[isNumber, votingMinRule]" outlined>
                                                    </v-text-field>
                                                </v-col>
                                                <v-col cols="12" sm="6" md="6">
                                                    <v-text-field label="Max" v-model.number="temp.noita.random_voting_time.max" type="number" :rules="[isNumber, votingMaxRule]" outlined>
                                                    </v-text-field>
                                                </v-col>
                                            </v-row>
                                        </v-card-text>
                                    </v-card>
                                </v-col>
                                <v-col cols="12"  :sm="getCols.varying" :md="getCols.varying" :xl="getCols.varying" v-if="randomizedTime['between']">
                                    <v-card color="grey darken-3" flat>
                                        <v-toolbar color="deep-purple darken-1" flat>
                                            <v-toolbar-title>Time Between</v-toolbar-title>
                                        </v-toolbar>
                                        <v-card-text>
                                            <v-row>
                                                <v-col cols="12">
                                                    <v-checkbox label="Randomize After Each Vote" v-model="temp.noita.random_time_between.randomize">
                                                    </v-checkbox>
                                                </v-col>
                                                <v-col cols="12" sm="6" md="6">
                                                    <v-text-field label="Min" v-model.number="temp.noita.random_time_between.min" type="number" :rules="[isNumber, betweenMinRule]" outlined>
                                                    </v-text-field>
                                                </v-col>
                                                <v-col cols="12" sm="6" md="6">
                                                    <v-text-field label="Max" v-model.number="temp.noita.random_time_between.max" type="number" :rules="[isNumber, betweenMaxRule]" outlined>
                                                    </v-text-field>
                                                </v-col>
                                            </v-row>
                                        </v-card-text>
                                    </v-card>
                                </v-col>
                            </v-row>
                        </v-card-text>
                        <v-card-actions>
                        <v-row align="center" justify="center">
                            <v-btn tile @click="apply()">Apply</v-btn>
                            <v-divider vertical></v-divider>
                            <v-btn tile @click="reset()">Cancel</v-btn>
                        </v-row>
                        </v-card-actions>
                    </v-card>
                </v-col>
                
                <v-col>
                    <v-card flat>
                        <v-toolbar color="deep-purple" flat>
                            <v-toolbar-title>Outcome Categories {{totalWeight}}/1000</v-toolbar-title>
                            <v-spacer></v-spacer>
                            <v-btn @click="getDefaults()">Reset</v-btn>
                        </v-toolbar>
                        <v-card-text>
                            <v-row no-gutters>
                                <v-col class="d-flex justify-center" cols="12" v-for="(item, index) in temp.noita.option_types" :key=item.uid>
                                    <v-text-field label="Name" v-model="temp.noita.option_types[index].name" hide-details="auto">
                                        <v-btn slot="prepend" icon text>
                                            <v-icon>mdi-delete</v-icon>
                                        </v-btn>
                                    </v-text-field>
                                    <v-text-field class="d-flex justify-start" :label="'Rarity ' + calculateOdds(index)" v-model.number="temp.noita.option_types[index].rarity" :rules="[isNumber]" hide-details="auto">
                                    </v-text-field>
                                </v-col>
                            </v-row>
                        </v-card-text>
                    </v-card>
                </v-col>
            </v-row>

            <v-divider></v-divider>
            <v-card-actions>
                <v-row align="center" justify="center">
                    <v-btn tile @click="apply()">Apply</v-btn>
                    <v-divider vertical></v-divider>
                    <v-btn tile @click="reset()">Cancel</v-btn>
                </v-row>
            </v-card-actions>
        </v-card-text>
    </v-card>
</v-container>`
})

const OutcomesView = Vue.component("ti-outcomes", {
    data() {
        return {
            snackbar: { right: true, bottom: true },
            models: {},
            temp: {},
            activeKey: "",
            filterKey: ""
        }
    },
    computed: {
        unsavedChanges: function () {
            return JSON.stringify(this.models) !== JSON.stringify(this.temp)
        },
        totalWeight: function () {
            if (Object.keys(this.temp) == 0) { return }
            let weights = {}
            Object.values(this.temp).forEach(outcome => {
                if (!outcome.enabled) { return }
                weights[outcome.type] = (weights[outcome.type] || 0) + outcome.rarity
            })
            return weights
        },
        list: function () {
            let key = this.filterKey.toLowerCase()
            let filtered = Object.values(this.models).filter(val => {
                return val.name.toLowerCase().includes(key) || val.type.toLowerCase().includes(key)
            })
            let sorted = filtered.sort((a, b) => {
                let nameA = a.name.toUpperCase()
                let nameB = b.name.toUpperCase()
                if (nameA < nameB) {
                    return -1
                }
                if (nameA > nameB) {
                    return 1
                }

                return 0
            }).sort((a, b) => {
                let typeA = a.type.toUpperCase()
                let typeB = b.type.toUpperCase()
                if (typeA < typeB) {
                    return -1
                }
                if (typeA > typeB) {
                    return 1
                }

                return 0
            })
            if (this.activeKey === "" && sorted.length > 0) {
                this.activeKey = sorted[0].id
            }
            return sorted
        }
    },
    methods: {
        reset: function () {
            this.temp = JSON.parse(JSON.stringify(this.models))
        },
        getDefaults: async function () {
            let defaults = await axios.get("/reset/outcomes")
            let data = JSON.stringify(defaults.data)
            this.$set(this, "models", JSON.parse(data))
            this.$set(this, "temp", JSON.parse(data))
        },
        calculateOdds: function (type, weight) {
            let odds = (weight / this.totalWeight[type]) * 100
            return `${odds.toFixed(2)}%`
        },
        apply: function (id) {
            axios.post(`/outcomes/${id}`, this.temp[id])
            this.models[id] = JSON.parse(JSON.stringify(this.temp[id]))
        },
        toGame: function (id) {
            axios.post(`/togame/${id}`)
        },
        isNumber(val) {
            if (typeof val == "number") {
                return true
            }
            else {
                return "Not a number"
            }
        }
    },
    beforeCreate: async function () {
        let outcomes = await axios.get("/outcomes")
        let outcomesData = JSON.stringify(outcomes.data)
        this.$set(this, "models", JSON.parse(outcomesData))
        this.$set(this, "temp", JSON.parse(outcomesData))
    },
    template: `<v-container fluid> <v-snackbar :timeout="0" :right="snackbar.right" :bottom="snackbar.bottom" :value="unsavedChanges">Unsaved Changes</v-snackbar>
    <v-navigation-drawer app clipped permanent >
        <v-toolbar color="deep-purple" extended>
            <v-toolbar-title>Outcomes</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-btn @click="getDefaults()">Reset</v-btn>
            <template v-slot:extension>
                <v-text-field label="Search..." v-model="filterKey"></v-text-field>
            </template>
        </v-toolbar>
        

        <v-list dense nav>
            <v-list-item v-for="item in list" :key="item.id" link>

                <v-list-item-content @click="activeKey = item.id">
                    <v-list-item-title>{{ temp[item.id].name }}</v-list-item-title>
                    <v-list-item-subtitle v-text="temp[item.id].type + ' - ' +
                        temp[item.id].rarity + '/' + totalWeight[item.type] +
                        ' [' + calculateOdds(temp[item.id].type, temp[item.id].rarity) + ']'"></v-list-item-subtitle>
                </v-list-item-content>

            </v-list-item>
        </v-list>
    </v-navigation-drawer>

    <v-card v-if="activeKey !== ''">
        <v-toolbar color="deep-purple" flat>
            <v-toolbar-title class="title">{{temp[activeKey].name}}</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-btn @click="toGame(activeKey)">To Game</v-btn>
        </v-toolbar>

        <v-card-text>
            <v-row justify="space-between" no-gutters>
                <v-checkbox label="Enabled" v-model="temp[activeKey].enabled">
                </v-checkbox>
                <v-col cols="12" md="5">
                    <v-text-field label="Type" v-model="temp[activeKey].type" outlined>
                    </v-text-field>
                </v-col>
                <v-col cols="12" md="5">
                    <v-text-field :label="'Rarity '+ calculateOdds(temp[activeKey].type, temp[activeKey].rarity)" v-model.number="temp[activeKey].rarity" type="number" :rules="[isNumber]" outlined>
                    </v-text-field>
                </v-col>
            </v-row>

            <v-text-field label="Name" v-model="temp[activeKey].name" outlined>
                </v-text-field>

                <v-text-field label="Description" v-model="temp[activeKey].description" outlined>
                </v-text-field>

                <v-textarea label="Comment" v-model="temp[activeKey].comment" outlined>
                </v-textarea>
            <v-divider></v-divider>
            <v-card-actions>
                <v-row align="center" justify="center">
                    <v-btn tile @click="apply(activeKey)">Apply</v-btn>
                    <v-divider vertical></v-divider>
                    <v-btn tile @click="reset()">Cancel</v-btn>
                </v-row>
            </v-card-actions>
        </v-card-text>
    </v-card>

    </v-container>`
})

const MiscView = Vue.component("ti-misc", {
    data() {
        return {
            snackbar: { right: true, bottom: true },
            models: { config: {} },
            temp: { config: {} }
        }
    },
    computed: {
        unsavedChanges: function () {
            return JSON.stringify(this.models) !== JSON.stringify(this.temp)
        }
    },
    beforeCreate: async function () {
        /*
        let config = await axios.get("/outcomes")
        this.$set(this.models, "outcomes", config.data)
        */
    },
    template: `<v-container fluid> <v-snackbar :timeout="0" :right="snackbar.right" :bottom="snackbar.bottom" :value="unsavedChanges">Unsaved Changes</v-snackbar>
        <v-card>
            <v-toolbar color="deep-purple" flat>
                <v-toolbar-title class="title">W.I.P</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
                <v-spacer></v-spacer>
            </v-card-text>
        </v-card>
    </v-container>`
})

const CreditsView = Vue.component("ti-credits", {
    data() {
        return {
            credits: [
                { name: "Soler91", description: "Creator of the twitch integration you are using now.", github: "https://github.com/soler91/Noita-Twitch-Integration", twitch: "https://www.twitch.tv/soler91" },
                { name: "Pyry", description: "Creator of the first twitch integration this is based off.", github: "https://github.com/probable-basilisk/noita-ws-api", twitch: "https://www.twitch.tv/fakepyry" },
                { name: "MiczuPL", description: "Created some outcomes.", github: "https://github.com/miczupl", twitch: "https://www.twitch.tv/MiczuPL" },
                { name: "Goki", description: "Created some outcomes.", github: "https://github.com/gokiburikin", twitch: "https://www.twitch.tv/goki_dev" },
                { name: "Conga Lyne", description: "Created some outcomes.", github: "https://github.com/Conga0", twitch: "https://www.twitch.tv/conga_lyne" },
                { name: "AsterCastell", description: "Created some pixel art for the temporal \"perks\".", twitch: "https://www.twitch.tv/astercastell/" },
                { name: "AndyTheIllusion", description: "Created the pixel art for the thunderballs.", twitch: "https://www.twitch.tv/andy_the_illusion/" },
                { name: "TheSm1rk", description: "Created some pixel art for the temporal \"perks\".", twitch: "https://www.twitch.tv/theSm1rk/" },
                { name: "Sleepylemonbug", description: "Streamer, user and tester.", twitch: "https://www.twitch.tv/sleepylemonbug/" },
                { name: "Dunkorslam", description: "Streamer, user and tester.", twitch: "https://www.twitch.tv/dunkorslam/" }
            ]
        }
    },
    template: `<v-container fluid>
        <v-card>
            <v-toolbar color="deep-purple" flat>
                <v-toolbar-title class="title">Credits</v-toolbar-title>
            </v-toolbar>

            <v-list two-line >
                <v-list-item v-for="entry in credits" :key="entry.name">
                    <v-list-item-content>
                        <v-list-item-title>{{entry.name}}
                            <v-btn icon x-small v-if="entry.twitch" target="blank" :href="entry.twitch"><v-icon>mdi-twitch</v-icon></v-btn>
                            <v-btn icon x-small v-if="entry.github" target="blank" :href="entry.github"><v-icon>mdi-github</v-icon></v-btn>
                        </v-list-item-title>
                        <v-list-item-subtitle>{{entry.description}}</v-list-item-subtitle>
                    </v-list-item-content>
                </v-list-item>
            </v-list>
                
        </v-card>
    </v-container>`
})

Vue.use(VueRouter)
const routes = [
    { path: '/', redirect: "/twitch" },
    { path: '/twitch', component: TwitchView },
    { path: '/noita', component: NoitaView },
    { path: '/outcomes', component: OutcomesView },
    { path: '/misc', component: MiscView },
    { path: '/credits', component: CreditsView },
]
const router = new VueRouter({ routes })
/*
Vue.component("comp-misc", {
    data: function () {
        return {
            plusTime: 0,
            minusTime: 0
        }
    },
    methods: {
        addTime(val) {
            if (isNaN(val)) {
                return
            }
            axios.post("/misc/timeleft", { val: Math.floor(val) })
        },
        rmTime(val) {
            if (isNaN(val)) {
                return
            }
            axios.post("/misc/timeleft", { val: Math.floor(val - val * 2) })
        },
        reloadOutcomes(val) {
            axios.post("/misc/reload_outcomes", {})
        },
        isNumber(val) {
            if (typeof val == "number") {
                return true
            }
            else {
                return "Not a number"
            }
        }
    },
    template: `<div>
    <v-container fluid>
        <v-card>
            <v-card-title>Misc Things</v-card-title>
            <v-divider></v-divider>
            <v-card-text>
                <v-row>
                    <v-col cols="6" md="6">
                        <v-text-field label="Increase time" v-model.number="plusTime"
                        :rules="[isNumber]" @keypress.enter="addTime(plusTime)">
                            <template v-slot:append>
                                <v-btn depressed tile @click="addTime(plusTime)">Send</v-btn>
                            </template>
                        </v-text-field>
                    </v-col>
                    <v-col cols="6" md="6">
                        <v-text-field label="Decrease timer" v-model.number="minusTime"
                        :rules="[isNumber]" @keypress.enter="rmTime(minusTime)">
                            <template v-slot:append>
                                <v-btn depressed tile @click="rmTime(minusTime)">Send</v-btn>
                            </template>
                        </v-text-field>
                    </v-col>
                    <v-divider></v-divider>
                    <v-col cols="4" md="4">
                        <v-btn @click="reloadOutcomes()">Reload Outcomes</v-btn>
                    </v-col>
                </v-row>
            </v-card-text>
        </v-card>
    </v-container>
    </div>`
})
*/
let vm = new Vue({
    el: '#app',
    router,
    vuetify: new Vuetify(),
    data: {
        models: {
            outcomes: {},
            twitch: {},
            noita: {},
            obs_template: {},
            misc: {}
        }
    },
    beforeCreate: async function () {
        this.$vuetify.theme.dark = true

        let outcomes = await axios.get("/outcomes")
        this.$set(this.models, "outcomes", outcomes.data)

        let twitch = await axios.get("/twitch")
        this.$set(this.models, "twitch", twitch.data)

        let noita = await axios.get("/noita")
        this.$set(this.models, "noita", noita.data)
    }
})