// Imports
const fetch = require('node-fetch');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const EventEmitter = require('events');

// Constants
const DefaultAutoUpdateServers = ['https://raw.githubusercontent.com/Miczu/noita-twitch-integration/'];


// Implementation
function forcedirSync(dir) {
    const sep = path.sep;
    const initDir = path.isAbsolute(dir) ? sep : '';
    dir.split(sep).reduce((parentDir, childDir) => {
        const curDir = path.resolve(parentDir, childDir);
        try {
            fs.mkdirSync(curDir);
        } catch (_) {
            // Ignore
        }

        return curDir;
    }, initDir);
}

function hash(data) {
    return crypto.createHash('sha256').update(data).digest().toString('hex').toUpperCase();
}

class Updater extends EventEmitter {
    constructor(branch = 'master', autoUpdateServers = DefaultAutoUpdateServers) {
        super();
        this.setMaxListeners(0);

        this.branch = branch;
        this.autoUpdateServers = autoUpdateServers;
    }

    buildPath(relpath) { return path.join(__dirname, relpath); }
    buildURL(serverIndex, relpath) { return `${this.autoUpdateServers[serverIndex]}${this.branch}/${relpath}`; }
    async downloadRaw(serverIndex, relpath) { return await (await fetch(this.buildURL(serverIndex, relpath))).buffer(); }
    async downloadJSON(serverIndex, relpath) { return await (await fetch(this.buildURL(serverIndex, relpath))).json(); }
    async downloadExternal(url) { return await (await fetch(url)).buffer(); }

    async check(serverIndex = 0) {
        this.emit('check_start', serverIndex);

        try {
            const manifest = await this.downloadJSON(serverIndex, 'manifest.json');

            let operations = [];
            // externalFiles is separate for compatibility
            Object.entries(Object.assign(manifest.files, manifest.externalFiles ?? {})).forEach(([relpath, filedata]) => {
                const filepath = this.buildPath(relpath);

                let expectedHash = null;
                let needsUpdate = false;
                if (typeof filedata === 'object') {
                    expectedHash = filedata.hash.toUpperCase();

                    if (filedata.overwrite === 'only')
                        needsUpdate = fs.existsSync(filepath) && hash(fs.readFileSync(filepath)) !== expectedHash;
                    else if (filedata.overwrite === 'rename' && fs.existsSync(`${filepath}.deleted.tmp`))
                        // Clean up files that couldn't be deleted during the last update
                        operations.push({
                            type: 'delete',
                            relpath: `${relpath}.deleted.tmp`,
                            abspath: `${filepath}.deleted.tmp`
                        });
                    else
                        needsUpdate = !fs.existsSync(filepath) || (filedata.overwrite && hash(fs.readFileSync(filepath)) !== expectedHash);
                } else {
                    expectedHash = filedata.toUpperCase();
                    needsUpdate = !fs.existsSync(filepath) || hash(fs.readFileSync(filepath)) !== expectedHash;
                }

                if (needsUpdate)
                    operations.push({
                        type: 'update',
                        hash: expectedHash,
                        relpath,
                        abspath: filepath,
                        url: filedata.url,
                        overwrite: filedata.overwrite ?? 'always'
                    });
            });
			fs.writeFileSync('manifest.json', JSON.stringify(manifest, undefined, 4));

            this.emit('check_success', serverIndex, operations);
            return {
                serverIndex,
                operations
            };
        } catch (e) {
            this.emit('check_fail', serverIndex, e);

            if (serverIndex + 1 < this.autoUpdateServers.length) {
                return await this.check(serverIndex + 1);
            } else {
                this.emit('check_fail_all');
                return null;
            }
        }
    }

    async run(checkResult = null) {
        this.emit('run_start');
        if (!checkResult)
            checkResult = await this.check();

        let success;
        if (checkResult) {
            success = true;

            if (checkResult.operations.length > 0) {
                this.emit('prepare_start');

                // Prepare and validate operations
                for (let operation of checkResult.operations) {
                    if (operation.type === 'update') {
                        if (operation.url) {
                            // TODO: Replace download_start with download_external_start at some point in the future
                            // If download_external_start is used when the running index.js doesn't support it, the download won't be logged
                            //this.emit('download_external_start', operation.url, operation.relpath);
                            this.emit('download_start', operation.url, operation.relpath);
                            operation.data = await this.downloadExternal(operation.url);
                        } else {
                            this.emit('download_start', checkResult.serverIndex, operation.relpath);
                            operation.data = await this.downloadRaw(checkResult.serverIndex, operation.relpath);
                        }

                        if (operation.hash === hash(operation.data)) {
                            this.emit('download_finish', checkResult.serverIndex, operation.relpath);
                        } else {
                            this.emit('download_error', operation.relpath, operation.hash, hash(operation.data));
                            success = false;
                            break;
                        }
                    }
                }

                this.emit('prepare_finish');

                if (success) {
                    this.emit('execute_start');

                    // All operations have been prepared and validated, so execute them now
                    for (let operation of checkResult.operations) {
                        switch (operation.type) {
                            case 'update': {
                                this.emit('install_start', operation.relpath);
                                try {
                                    forcedirSync(path.dirname(operation.abspath));
                                    // Can't overwrite/delete running processes
                                    if (operation.overwrite === 'rename') {
                                        if (fs.existsSync(operation.abspath))
                                            fs.renameSync(operation.abspath, `${operation.abspath}.deleted.tmp`);
                                        fs.writeFileSync(operation.abspath, operation.data);
                                        // Can't rely on new error handling in index.js because it doesn't relaunch itself
                                        throw 'Relaunch to complete update';
                                    } else {
                                        fs.writeFileSync(operation.abspath, operation.data);
                                    }
                                    this.emit('install_finish', operation.relpath);
                                } catch (e) {
                                    success = false;
                                    this.emit('install_error', operation.relpath, e);
                                }
                                break;
                            }
                            case 'delete': {
                                try {
                                    this.emit('delete', operation.relpath);
                                    // Old versions of Node.js don't support fs.rmSync
                                    fs.unlinkSync(operation.abspath);
                                } catch (e) {
                                    success = false;
                                    this.emit('delete_error', operation.relpath, e);
                                }
                                break;
                            }
                        }
                    }

                    this.emit('execute_finish');
                }
            }
        } else {
            success = false;
        }

        this.emit('run_finish', success);
        return checkResult && checkResult.operations && checkResult.operations.length !== 0;
    }
}

module.exports = Updater;
