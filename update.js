// Imports
const fetch = require('node-fetch');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const EventEmitter = require('events');

// Constants
const AutoUpdateServers = ['https://raw.githubusercontent.com/Miczu/noita-twitch-integration/'];

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
    constructor(branch = 'master') {
        super();
        this.setMaxListeners(0);

        this.branch = branch;
    }

    buildPath(relpath) { return path.join(__dirname, relpath); }
    buildURL(serverIndex, relpath) { return `${AutoUpdateServers[serverIndex]}${this.branch}/${relpath}`; }
    async downloadRaw(serverIndex, relpath) { return await (await fetch(this.buildURL(serverIndex, relpath))).buffer(); }
    async downloadJSON(serverIndex, relpath) { return await (await fetch(this.buildURL(serverIndex, relpath))).json(); }

    async check(serverIndex = 0) {
        this.emit('check_start', serverIndex);

        try {
            const manifest = await this.downloadJSON(serverIndex, 'manifest.json');

            let operations = [];
            Object.keys(manifest.files).forEach(relpath => {
                const filedata = manifest.files[relpath];
                const filepath = this.buildPath(relpath);

                let expectedHash = null;
                let needsUpdate = false;
                if (typeof filedata === 'object') {
                    expectedHash = filedata.hash.toUpperCase();

                    if (filedata.overwrite === 'only')
                        needsUpdate = fs.existsSync(filepath) && hash(fs.readFileSync(filepath)) !== expectedHash;
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
                        abspath: filepath
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

            if (serverIndex + 1 < AutoUpdateServers.length) {
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
                        this.emit('download_start', checkResult.serverIndex, operation.relpath);
                        operation.data = await this.downloadRaw(checkResult.serverIndex, operation.relpath);
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
                                    fs.writeFileSync(operation.abspath, operation.data);
                                    this.emit('install_finish', operation.relpath);
                                } catch (e) {
                                    success = false;
                                    this.emit('install_error', operation.relpath, e);
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


// if you run `node update.js` this will run
if (require.main === module) {
  const manifest = JSON.parse(fs.readFileSync("manifest.json"));
  const pairs = [];
  for (const [key, value] of Object.entries(manifest.files)) {
    let data;

    try {
      data = fs.readFileSync(key);
    } catch (e) {
      if (e.code != "ENOENT") {
        throw e;
      }
      console.log(`File \x1b[31m${key}\x1b[0m was deleted? Removing from manifest...`);
      continue;
    }

    // pre-normalize crlf, excluding binary and .bat files
    if ([".dll", ".png", ".xcf", ".bat"].every(end => !key.endsWith(end))) {
      data = data.toString('utf8').replaceAll(/\r\n/g, '\n');
    }

    const hashed = hash(data).toLowerCase(); // lol
    if (hashed == value.toLowerCase()) {
      pairs.push([key, value]);
      continue;
    }
    console.log(`File \x1b[32m${key}\x1b[0m has hash \x1b[2m${hashed}\x1b[0m, expected \x1b[2m${value}\x1b[0m, updating...`);
    pairs.push([key, hashed]);
  }

  pairs.sort(([a], [b]) => a.localeCompare(b));

  // hoping that node will never stop preserving object insertion order
  fs.writeFileSync("manifest.json", JSON.stringify({
    files: Object.fromEntries(pairs),
  }, undefined, 4));
}
