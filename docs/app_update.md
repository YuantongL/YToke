## In-app Update

The app uses [Sparkle](https://sparkle-project.org/) for automatic in-app update check and perform updates.

Currently we are using Sparkle 1.x version, the doc can be found here. [Sparkle doc](https://sparkle-project.org/documentation/)

## Prepare a new app update

- Change `Version` and `Build` under Xcode's project setting to a higher version number.
- Archive the app and send to Apple notary service and wait for it finish.
- When Apple finishes notarize the app, export the `.app` file to a folder. Make a `.dmg` (I use this custom version of [create-dmg](https://github.com/sindresorhus/create-dmg)).
- Sign the dmg with EdDSA otherwise Sparkle won't process the update. Run `./bin/generate_keys` tool (from the Sparkle distribution root) generates a public key (it should have saved to the KeyChain if you did this before). Then use the `./bin/sign_update` tool on the `.dmg` file, remember its output (edSignature and length).
- Merge code to master and upload `.dmg` to Github Release.

## Publish a new app update

- Tweak the `/Sparkle/appcast.xml`. ADD a NEW "item" with title, description, most importantly the edSignature and length should match the one you got from last step.
- Make the URL in your new item point to the Github release raw download link (with latest version).
- Merge the updated appcast.xml to `/Sparkle/appcast.xml`. Older version apps should able to see this new version information (thanks to Sparkle).

### Note
- Sparkle perform checks on Apple Code signature and edSignature every app update, the old version should match every new version published.
- Needs to turn off App Sandbox for Sparkle 1.x version, otherwise it will say "Unable to mound DMG" during updating.
- Prefer separation of normal code push and release code push (basically just `appcast.xml`). Release commit should be marked Release.
