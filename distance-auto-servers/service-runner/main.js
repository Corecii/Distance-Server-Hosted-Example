
const fs = require('fs');
const path = require('path');
const respawn = require('respawn');
const exitHook = require('async-exit-hook');

const serversPath = process.argv[3];
const exePath = process.argv[2];

function promiseCallback(resolve, reject) {
	return (err, result) => {
		if (err) {
			reject(err);
		} else {
			resolve(result);
		}
	}
}

async function main() {
	const monitors = [];

	const serverDirs = await new Promise((resolve, reject) => fs.readdir(serversPath, promiseCallback(resolve, reject)));
	console.log(serverDirs);
	for (const serverDirName of serverDirs) {
		const serverDir = path.join(serversPath, serverDirName);
		const name = `distance-${path.basename(serverDir)}`;
		const monitor = respawn(
			[
				exePath,
				"-logFile", path.join(serverDir, "Server.log"),
				"-nodefaultplugins", 
				"-serverDir", path.join(serverDir, "config"),
				"-masterserverworkaround",
				"-batchmode", "-nographics",
			], {
				name: name,
				maxRestarts: -1,
				sleep: 30 * 1000,
				kill: 10 * 1000,
			}
		);
		monitor.on("start", () => {
			console.log(`${name}: Monitor starting...`);
		})
		monitor.on("exit", (code, signal) => {
			console.log(`${name}: Exited with ${code} because ${signal}; restarting in 30 seconds...`);
		})
		monitor.on("spawn", (process) => {
			console.log(`${name}: Spawned ${process.pid}`);
		})
		monitor.on("crash", () => {
			console.error(`${name}: Monitor crashed!`);
		})
		monitor.on("stop", () => {
			console.log(`${name}: Monitor stopping...`);
		})
		monitors.push(monitor);
	}

	for (let monitor of monitors) {
		monitor.start();
	}

	exitHook((exit) => {
		let promises = [];
		for (let monitor of monitors) {
			promises.push(new Promise((resolve) => {
				monitor.stop(resolve);
			}));
		}
		Promise.all(promises).then(exit);
	});
}

main();