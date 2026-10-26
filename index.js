const fs = require("fs")
const path = require("path")
//check if workaround exists
const workaroundPath = path.join(__dirname, "../twitch-helper")
if (!fs.existsSync(workaroundPath)) {
    fs.mkdirSync(workaroundPath)
    const XML = `
    <Mod
        name="Twitch-helper"
        description="Temporal workaround for twitch integration, preferably always leave enabled."
        request_no_api_restrictions="1" 
        > 
    </Mod>`
    fs.writeFileSync(path.join(workaroundPath, "mod.xml"), XML)
    fs.writeFileSync(path.join(workaroundPath, "init.lua"), "function OnModPreInit() end")
}
// Update
async function updateSelf() {
    delete require.cache[require.resolve('./update')];
    const Updater = require('./update');

    let error = false;

    const updater = new Updater(branch, autoUpdateServers);
    updater.on('run_start', () => { console.log(`[update] Self-update started (Branch: ${updater.branch})`); });
    updater.on('check_start', (serverIndex) => { if (updatelog) console.log(`[update] Update check started (Server: ${serverIndex})`); });
    updater.on('check_success', (serverIndex, operations) => { if (updatelog) console.log(`[update] Update check finished (Server: ${serverIndex}), ${operations.length} operations required`); });
    updater.on('check_fail', (serverIndex, error) => { console.log(`[update] Update check failed (Server: ${serverIndex}): ${error}`); });
    updater.on('check_fail_all', () => { error = true; console.log(`[update] Update check failed`); });
    updater.on('prepare_start', () => { if (updatelog) console.log(`[update] Update download and preparation started`); });
    updater.on('download_start', (serverIndex, relpath) => { if (updatelog) console.log(`[update] - Download: ${relpath} (Server: ${serverIndex})`); });
    updater.on('download_external_start', (url, relpath) => { if (updatelog) console.log(`[update] - Download: ${relpath} (URL: ${url})`); });
    updater.on('download_error', (relpath, expected_hash, downloaded_hash) => {
        error = true;
        console.log(`[update] - Error downloading ${relpath}: file hash mismatch (expected: ${expected_hash}, found: ${downloaded_hash})!`);
    });
    //updater.on('download_finish', (serverIndex, relpath) => { if (updatelog) console.log(`[update] - Download done: ${relpath} (Server: ${serverIndex})`); });
    updater.on('prepare_finish', () => { if (updatelog) console.log(`[update] Update download and preparation finished`); });
    updater.on('execute_start', () => { if (updatelog) console.log(`[update] Update installation started`); });
    updater.on('install_start', (relpath) => { if (updatelog) console.log(`[update] - Install: ${relpath}`); });
    //updater.on('install_finish', (relpath) => { if (updatelog) console.log(`[update] - Install done: ${relpath}`); });
    updater.on('install_error', (relpath, e) => {
        error = true;
        console.log(`[update] - Error installing ${relpath}: ${e}`);
        if (relpath.startsWith('node_modules/tera-client-interface/scanner/')) {
            console.log('[update] - Your anti-virus software most likely falsely detected it to be a virus.');
            console.log('[update] - Please whitelist TERA Toolbox in your anti-virus!');
            console.log(`[update] - For further information, check the #toolbox-faq channel in ${DiscordURL}!`);
        } else if (relpath === 'node_modules/tera-client-interface/tera-client-interface.dll') {
            console.log('[update] - This is most likely caused by an instance of the game that is still running.');
            console.log('[update] - Close all game clients or restart your computer, then try again!');
        }
    });
    updater.on('delete', (relpath) => { if (updatelog) console.log(`[update] - Delete: ${relpath}`); });
    updater.on('delete_error', (relpath, e) => {
        error = true;
        console.log(`[update] - Error deleting ${relpath}: ${e}`);
    });
    updater.on('execute_finish', () => { if (updatelog) console.log(`[update] Update installation finished`); });
    updater.on('run_finish', (success) => { console.log(`[update] Self-update ${success ? 'finished' : 'failed'}`); });

    const filesChanged = await updater.run();
    if (error)
        return false;
    if (filesChanged)
        return await updateSelf();
    return true;
}

function run() {
    const Settings = require("./lib/settings")
    const Twitch = require("./lib/twitch")
    const Noita = require("./lib/noita")
    const WebUI = require("./lib/webui")
    class Main {
        constructor() {
            this.initSubmodules()
        }

        initSubmodules() {
            this.settings = new Settings()
            this.twitch = new Twitch(this)
            this.noita = new Noita(this)
            this.webui = new WebUI(this)
        }
    }

    const bot = new Main()
}

function main() {
    if (noselfupdate) {
        console.warn("Auto update disabled.");
        run();
    } else {
        updateSelf().then(success => {
            if (success) {
                run();
            } else {
                console.error('[update] ERROR: Unable to perform self-update!');
            }
        }).catch(e => {
            console.error('[update] ERROR: Unable to perform self-update!');
            console.error('[update] ERROR: The full error message is:');
            console.error('-----------------------------------------------');
            console.error(e);
            console.error('-----------------------------------------------');
        });
    }
}

// -------------------------------------------------------------------
// Prevent CLI from immediately closing in case of an error
process.stdin.resume();
process.on('uncaughtException', (e) => {
    console.log(e);
});

// Safely load configuration
let branch;
let autoUpdateServers;
let updatelog = true;
let noselfupdate = false;
try {
    const config = require('./config.json');
    if (config) {
        if (config.branch)
            branch = config.branch;
        if (config.autoUpdateServers)
            autoUpdateServers = config.autoUpdateServers;
        updatelog = !!config.updatelog;
        noselfupdate = !!config.noselfupdate;
    }
} catch (_) {
    console.warn('[update] WARNING: An error occurred while trying to read the config file! Falling back to default values.');
}

//Boot
main();
