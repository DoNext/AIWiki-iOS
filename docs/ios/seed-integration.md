# iOS seed integration (JSON)

## Included files

- Model: `ios/AIWiki/Core/Models/AITool.swift`
- Repository: `ios/AIWiki/Data/ToolSeedStore.swift`
- ViewModel sample: `ios/AIWiki/Features/Home/HomeViewModel.swift`
- Search ViewModel: `ios/AIWiki/Features/Search/SearchViewModel.swift`
- Search View sample: `ios/AIWiki/Features/Search/SearchView.swift`
- Seed file: `ios/AIWiki/Resources/Seed/tools.seed.json`
- English copy guide: `docs/ios/english-terminology-style.md`

## Xcode setup

1. Add the `ios/AIWiki` folder to your iOS project target.
2. Ensure `tools.seed.json` is in **Copy Bundle Resources**.
3. Use `ToolSeedStore()` as your default repository.

## Usage example

```swift
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        List(viewModel.tools, id: \.id) { tool in
            VStack(alignment: .leading) {
                Text(tool.name)
                Text(tool.intro)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            viewModel.loadSeedData()
        }
    }
}
```

## Seed update command

```bash
scripts/sync_seed_to_ios.sh
```

Then rebuild app to load latest local data.

## Search behavior (V1)

- Search scope: `name`, `intro`, `features`
- Matching: case-insensitive `contains`
- Ranking weight:
  - name: 5
  - intro: 3
  - features: 2
- Empty query returns full list
