# Repository Guidelines

## Project Structure & Module Organization
This repository is currently documentation-first. Keep product and architecture docs at the root until a `docs/` folder is introduced.

- `prd.md`: product requirements and scope.
- `tech-stack.md`: platform and architecture decisions.

When implementation starts, organize by platform and feature to match the planned MVVM architecture:

- `ios/` for SwiftUI code.
- `android/` for Kotlin/Compose code.
- `assets/` for offline data files and icons.
- `tests/` for shared test plans and fixtures.

Use domain-based names such as `search`, `categories`, and `favorites`.

## Build, Test, and Development Commands
There is no build pipeline committed yet. For now, contributors should run lightweight checks for docs quality:

- `rg --files` to verify expected files are present.
- `npx markdownlint-cli "**/*.md"` to lint Markdown formatting.
- `npx markdown-link-check prd.md` (and other docs) to validate links.

Add project-specific commands here once iOS/Android modules are created (for example, `xcodebuild test` or `./gradlew test`).

## Coding Style & Naming Conventions
For Markdown: use concise sections, sentence-case text, and clear bullet lists. Wrap long lines for readability.

For future app code:

- Swift: 4-space indentation, `UpperCamelCase` for types, `lowerCamelCase` for members.
- Kotlin: 4-space indentation, `UpperCamelCase` for classes, `lowerCamelCase` for functions/properties.
- Name files by primary type or screen (for example, `SearchViewModel.swift`, `FavoritesScreen.kt`).

No formatter/linter config is committed yet; add tooling config files with the first code module.

## Testing Guidelines
Automated tests are not configured yet. When adding code, include tests in the same PR:

- Unit tests for search, favorites, and repository logic.
- ViewModel state-transition tests.
- UI tests for core navigation paths.

Use names like `SearchViewModelTests.swift` and `FavoritesRepositoryTest.kt`.

## Commit & Pull Request Guidelines
Git history is not available in this workspace, so use Conventional Commit style going forward:

- `docs: update offline data schema section`
- `feat(android): add favorites persistence`
- `fix(ios): correct dark mode contrast`

PRs should include: a short summary, changed files/modules, test evidence, and screenshots for UI changes.
