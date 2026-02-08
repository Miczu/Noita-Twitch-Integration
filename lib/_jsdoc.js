/**
 * @typedef {Object} RandomVotingTime
 * @property {boolean} enabled
 * @property {number} min
 * @property {number} max
 * @property {boolean} randomize
 */

/**
 * @typedef {Object} RandomTimeBetween
 * @property {boolean} enabled
 * @property {number} min
 * @property {number} max
 */

/**
 * @typedef {Object} OptionType
 * @property {string} name
 * @property {number} rarity
 */

/**
 * @typedef {Object} NoitaSettings
 * @property {boolean} enabled
 * @property {boolean} game_ui
 * @property {boolean} obs_overlay
 * @property {boolean} display_votes
 * @property {boolean} random_on_no_votes
 * @property {boolean} named_enemies
 * @property {boolean} scuffed_mode
 * @property {boolean} multiple_winners
 * @property {number} time_between_votes
 * @property {number} voting_time
 * @property {number} options_per_vote
 * @property {RandomVotingTime} random_voting_time
 * @property {RandomTimeBetween} random_time_between
 * @property {OptionType[]} option_types
 * @property {boolean} permanent_gamba_option
 */

/**
 * @typedef {Object} Outcome
 * @property {string} id
 * @property {string} name
 * @property {boolean} enabled
 * @property {string} comment
 * @property {string} description
 * @property {string} type
 * @property {number} rarity
 */

/**
 * @typedef {Object} OutcomeGroup
 * @property {number} rarity
 * @property {Outcome[]} outcomes
 */
