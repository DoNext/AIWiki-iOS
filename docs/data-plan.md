# AI Wiki data execution plan (V1)

## Goal

Build a high-quality offline dataset for the first app release with stable schema, repeatable validation, and small-batch expansion.

## Scope for V1

- Target size: 50-100 tools
- Categories (fixed for V1):
  - 聊天机器人
  - 编程助手
  - 图像生成
  - 数据分析
  - 多模态模型
- Data source priority:
  - Official website/documentation/blog (required for final verification)
  - Directory sites only as discovery channel

## Batch workflow

1. Collect candidate tools into `data/raw/tools_seed.csv`
2. Convert and clean into `data/processed/tools.seed.json`
3. Run validation:
   - required fields
   - unique id/url
   - category whitelist
   - reasonable intro/features length
4. Manually review each record against official source
5. Move approved records to app seed data file

## Quality gates (must pass)

- `id` is stable and unique
- `name` is non-empty and clear
- `intro` is concise (10-140 chars)
- `features` has 1-8 items
- `company` is non-empty
- `url` starts with `https://`
- `icon` is local asset filename (for example `chatgpt.png`)
- `category` is one of V1 categories
- `source_url` and `last_verified_at` are present

## Expansion strategy

- Start with 20-30 records for product validation
- Expand by batch of 20 after QA sign-off
- Keep changelog for every batch update
