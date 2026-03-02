# Data workflow quickstart

## 1) Edit seed data

- Raw collection file: `data/raw/tools_seed.csv`
- Processed JSON file (app-ready draft): `data/processed/tools.seed.json`

## 2) Validate processed JSON

```bash
python3 scripts/validate_tools_json.py data/processed/tools.seed.json
```

Expected output:

```text
validation passed: <N> records
```

## 3) Batch checklist (every update)

- Every entry has `source_url`
- `last_verified_at` updated to verification date
- Category in whitelist
- No duplicate `id` or `url`
- JSON validation passed
