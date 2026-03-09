# App Store release automation

This project now includes a local App Store submission tool built on `fastlane`.

It covers the repeatable parts of release delivery:

- Upload localized metadata from `fastlane/metadata`
- Upload localized screenshots from `screenshots/AppStore`
- Attach a specific build number
- Submit the selected build for App Store review
- Optionally auto-release after approval
- Optionally regenerate screenshots before upload

## What still needs one-time manual setup

Apple still keeps some account-level or app-level settings in App Store Connect that are not realistic to bootstrap entirely from a local script:

- Paid Applications agreement, banking, and tax setup
- App privacy answers
- Pricing and availability defaults
- Age rating if not already configured
- Public support / marketing / privacy policy URLs
- First-time app record setup if the app has never been created in App Store Connect

After those are in place, normal metadata and screenshot updates can be driven locally.

## Files

- `fastlane/Fastfile`: release lanes
- `fastlane/Appfile`: App Store Connect app identifiers
- `fastlane/metadata/en-US`: English localized metadata
- `fastlane/metadata/zh-Hans`: Simplified Chinese localized metadata
- `scripts/release_to_app_store.sh`: one-command wrapper
- `ci_scripts/ci_post_xcodebuild.sh`: Xcode Cloud auto-submit hook
- `ci_scripts/exportOptions-appstore.plist`: export options used by Xcode Cloud
- `docs/new-app-release-template.md`: checklist for reusing this flow in a new app

## Prerequisites

1. Install Ruby dependencies:

```bash
bundle install
```

2. Create an App Store Connect API key and export these environment variables:

```bash
export APP_STORE_CONNECT_KEY_ID=YOUR_KEY_ID
export APP_STORE_CONNECT_ISSUER_ID=YOUR_ISSUER_ID
export APP_STORE_CONNECT_KEY_FILE=/absolute/path/to/AuthKey_ABC123XYZ.p8
```

If your Xcode Cloud UI does not expose file secrets, store the raw `.p8` text in a masked environment variable instead:

```bash
export APP_STORE_CONNECT_KEY_CONTENT='-----BEGIN PRIVATE KEY-----
YOUR_KEY_CONTENT
-----END PRIVATE KEY-----'
```

If the Xcode Cloud text field strips line breaks, you can also store a Base64-encoded version of the `.p8` file in `APP_STORE_CONNECT_KEY_CONTENT`.

3. Add review contact details so submission does not block:

```bash
export APP_REVIEW_FIRST_NAME=YourName
export APP_REVIEW_LAST_NAME=YourLastName
export APP_REVIEW_PHONE=+8613800000000
export APP_REVIEW_EMAIL=you@example.com
export APP_REVIEW_NOTES="Offline app. No login required."
```

Optional:

```bash
export APP_BUNDLE_ID=com.next.wiki
export APP_STORE_CONNECT_APPLE_ID=your-apple-id@example.com
export APP_STORE_LOCALES=en-US,zh-Hans
```

## Xcode Cloud setup

Use an archive workflow in Xcode Cloud and enable custom build scripts for this repository.

Recommended workflow shape:

1. Archive the `AIWiki` scheme for App Store distribution.
2. Do not rely on a separate manual local upload step.
3. Let `ci_post_xcodebuild.sh` export the archive and call `fastlane`.

Set these Xcode Cloud environment variables:

```bash
XCODE_CLOUD_AUTO_SUBMIT=1
XCODE_CLOUD_RELEASE_WORKFLOW=Release
APP_STORE_CONNECT_KEY_ID=YOUR_KEY_ID
APP_STORE_CONNECT_ISSUER_ID=YOUR_ISSUER_ID
APP_STORE_CONNECT_KEY_CONTENT=-----BEGIN PRIVATE KEY-----...
APP_REVIEW_FIRST_NAME=YourName
APP_REVIEW_LAST_NAME=YourLastName
APP_REVIEW_PHONE=+8613800000000
APP_REVIEW_EMAIL=you@example.com
APP_REVIEW_NOTES=Offline app. No login required.
```

Notes:

- `XCODE_CLOUD_RELEASE_WORKFLOW` should match the exact workflow name you want to permit for automatic submission.
- `ci_post_clone.sh` installs the Ruby gems required by `fastlane`.
- `ci_post_xcodebuild.sh` reads the archived app version/build from the generated `.xcarchive`, exports an IPA, then calls `scripts/release_to_app_store.sh`.
- In this model, Xcode Cloud is the machine that builds and uploads. No local archive/upload step is involved.
- Prefer `APP_STORE_CONNECT_KEY_FILE` when file secrets are available. Use `APP_STORE_CONNECT_KEY_CONTENT` only when the UI exposes text secrets only.

## Release commands

Upload metadata and screenshots, select an existing build, and submit for review:

```bash
bash scripts/release_to_app_store.sh --version 1.0.0 --build-number 12
```

Regenerate screenshots first, then submit:

```bash
bash scripts/release_to_app_store.sh --with-screenshots --version 1.0.0 --build-number 12
```

Upload binary together with metadata and screenshots:

```bash
bash scripts/release_to_app_store.sh --upload-binary --version 1.0.0
```

Upload assets only without submitting:

```bash
bash scripts/release_to_app_store.sh --no-submit
```

## Notes

- The script defaults to `skip_binary_upload=true`, which is safer when the build has already been uploaded by Xcode or CI.
- Screenshot folders must already exist under `screenshots/AppStore/<locale>`.
- Metadata is stored in git, so app copy changes can be reviewed like normal code.
- For Xcode Cloud, keep the API key in a secure environment variable or secret file path provided by the workflow.
