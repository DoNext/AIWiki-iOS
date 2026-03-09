# New app release template

This document extracts the reusable release flow from AIWiki so new iOS apps do not need to rediscover the same Xcode Cloud and App Store Connect setup issues.

## Reusable files

Copy these files into a new app repo with the same relative paths:

- `Gemfile`
- `fastlane/Appfile`
- `fastlane/Fastfile`
- `scripts/release_to_app_store.sh`
- `ci_scripts/ci_post_clone.sh`
- `ci_scripts/ci_post_xcodebuild.sh`
- `ci_scripts/exportOptions-appstore.plist`

Keep these directory conventions:

- `fastlane/metadata/<locale>`
- `screenshots/AppStore/<locale>`

## App-specific values

Replace these per app:

- `APP_BUNDLE_ID`
- app name / subtitle / description / keywords / release notes
- support URL
- privacy policy URL
- review contact information
- screenshot files
- `MARKETING_VERSION_OVERRIDE`

## Required metadata files per locale

Each locale folder under `fastlane/metadata` should include at least:

- `name.txt`
- `subtitle.txt`
- `description.txt`
- `keywords.txt`
- `promotional_text.txt`
- `release_notes.txt`
- `support_url.txt`

If App Store Connect still says `whatsNew` is missing, make sure the localized `release_notes.txt` was either uploaded successfully or manually filled once in App Store Connect for that version.

## Xcode Cloud workflow template

Create one archive workflow named `Release`.

Recommended settings:

- Trigger: manual only
- Scheme: app scheme
- Action: archive for App Store distribution
- Custom scripts enabled

Disable:

- branch-change auto trigger
- automatic submission unless explicitly needed

## Recommended Xcode Cloud environment variables

Required:

- `XCODE_CLOUD_AUTO_SUBMIT=1`
- `XCODE_CLOUD_RELEASE_WORKFLOW=Release`
- `APP_BUNDLE_ID=<your bundle id>`
- `APP_STORE_CONNECT_KEY_ID=<api key id>`
- `APP_STORE_CONNECT_ISSUER_ID=<issuer id>`
- `APP_STORE_CONNECT_KEY_CONTENT=<p8 raw text or base64>`
- `APP_REVIEW_FIRST_NAME=<first name>`
- `APP_REVIEW_LAST_NAME=<last name>`
- `APP_REVIEW_PHONE=<phone>`
- `APP_REVIEW_EMAIL=<email>`
- `APP_REVIEW_NOTES=<review notes>`
- `MARKETING_VERSION_OVERRIDE=<for example 1.1.0>`

Optional:

- `APP_STORE_LOCALES=en-US,zh-Hans`
- `APP_STORE_AUTO_SUBMIT=0`
- `APP_STORE_SKIP_BINARY_UPLOAD=1`
- `APP_STORE_EXISTING_BUILD_NUMBER=<existing processed build>`

Use these operationally:

- Set `APP_STORE_AUTO_SUBMIT=0` if you want to upload and stop before review.
- Set `APP_STORE_SKIP_BINARY_UPLOAD=1` when reusing an already processed App Store Connect build.
- Set `APP_STORE_EXISTING_BUILD_NUMBER` when metadata-only resubmission should point to an older processed build instead of the current CI build number.

## First-release checklist

Do these once in App Store Connect:

- Create the app record
- Accept agreements / tax / banking setup
- Fill app privacy
- Fill support URL
- Fill privacy policy URL
- Set pricing / availability
- Set age rating

## Versioning rules

- `CURRENT_PROJECT_VERSION` is the build number and can track CI build number.
- `MARKETING_VERSION` / `CFBundleShortVersionString` must be increased for every new App Store version train.
- Do not keep relying on `1.0.0` as a default after first approval.

## Screenshot rule

Do not keep multiple screenshot sets that App Store Connect maps into the same device slot.

For AIWiki, both `iPad_12_9_*` and `iPad_13_*` were treated as the same App Store slot, which caused duplicate uploads. For each App Store slot, keep only one canonical set in the repo.

## Typical recovery cases

If upload fails with `Invalid Pre-Release Train`:

- bump `MARKETING_VERSION_OVERRIDE`
- ensure the archive and submission both use the new marketing version

If upload fails with `Build number does not exist`:

- use `APP_STORE_SKIP_BINARY_UPLOAD=1`
- set `APP_STORE_EXISTING_BUILD_NUMBER=<processed build>`

If screenshot upload fails with duplicate device images:

- remove the extra screenshot family from `screenshots/AppStore`
- clear the duplicated screenshots in App Store Connect once

If metadata submission fails with missing fields:

- verify `support_url.txt`
- verify `release_notes.txt`
- manually fill the missing field once in App Store Connect if the version record is already in a bad partial state

## Minimal repeatable release flow

For a new app, the repeatable path should be:

1. Prepare screenshots and metadata in repo.
2. Manually run the `Release` workflow.
3. Let Xcode Cloud archive and upload.
4. If needed, rerun with `APP_STORE_SKIP_BINARY_UPLOAD=1` and `APP_STORE_EXISTING_BUILD_NUMBER=<processed build>` for metadata-only fixes.
5. Submit for review manually unless auto-submit is intentionally enabled.
