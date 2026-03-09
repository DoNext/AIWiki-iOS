# iOS Release Template

Portable Xcode Cloud + App Store Connect release automation template for iOS apps.

This template is intended to be copied into app repositories, not used as a runtime dependency.

## What it includes

- `Gemfile`
- `ci_scripts/`
- `fastlane/`
- `scripts/release_to_app_store.sh`
- `tools/install_into_app.sh`
- `tools/diff_template_against_app.sh`
- `docs/`

## Recommended usage

Install into an app repository:

```bash
sh release-template/tools/install_into_app.sh /path/to/your-app-repo
```

Compare template files against an app repository:

```bash
sh release-template/tools/diff_template_against_app.sh /path/to/your-app-repo
```

## Required replacements after install

Replace these values before using the workflow:

- `APP_BUNDLE_ID`
- `APP_PRODUCT_NAME`
- app name
- subtitle
- description
- keywords
- promotional text
- release notes / What's New
- support URL
- review contact information

## Placeholder conventions

Template files are intentionally generic.

Expected app-specific replacements include:

- `com.example.app`
- `ExampleApp`
- `https://example.com/support`
- generic metadata text in `fastlane/metadata`

## Workflow expectations

- Xcode Cloud workflow name: `Release`
- Archive workflow for App Store distribution
- Manual trigger only
- Auto-submit disabled by default

## Documentation

- Chinese quick start: `README.zh-CN.md`
- English reuse checklist: `docs/new-app-release-template.md`
- Chinese reuse checklist: `docs/new-app-release-template.zh-CN.md`
- Release flow notes: `docs/app-store-release.md`
