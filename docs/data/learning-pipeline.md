# Learning Data Pipeline

This pipeline collects official website content and turns it into app-ready learning materials.

## Flow

1. `collect`: fetch pages listed in `data/sources/source_catalog.json`
2. `normalize`: convert raw pages to structured learning material
3. `review`: mark records as approved or rejected
4. `merge`: export approved records and sync to iOS seed resources

Collector behavior:

- Uses browser-like headers and TLS 1.2+ context.
- Supports HTTP `308` redirects.
- Retries transient errors (`429` / `5xx` / timeout).
- For blocked pages (`403` etc.), uses text-only fallback via `r.jina.ai` and marks `fetched_via: "reader_fallback"` in raw output.

## Files

- Source catalog: `data/sources/source_catalog.json`
- Review decisions: `data/sources/review_decisions.json`
- Raw pages: `data/raw/sources/*.json`
- Normalized output: `data/processed/learning/learning_materials.json`
- Approved output: `data/processed/learning/learning_materials.approved.json`
- iOS seed sync target: `ios/AIWiki/Resources/Seed/learning_materials.json`

## Commands

Run full update:

```bash
scripts/collect/update_learning_data.sh
```

Run collect only (with explicit knobs):

```bash
python3 scripts/collect/collect_sources.py --timeout 15 --retries 3
```

Disable fallback mirror:

```bash
python3 scripts/collect/collect_sources.py --disable-reader-fallback
```

Review status:

```bash
python3 scripts/collect/review_learning.py --materials data/processed/learning/learning_materials.json list
```

Approve records:

```bash
python3 scripts/collect/review_learning.py approve chatgpt --note "content verified"
```

Reject records:

```bash
python3 scripts/collect/review_learning.py reject chatgpt --note "needs manual rewrite"
```

Rebuild normalized + approved output after review changes:

```bash
python3 scripts/collect/normalize_sources.py
python3 scripts/collect/merge_learning.py
```

## Compliance notes

- Keep only structured summaries and reference links.
- Do not copy long official text blocks.
- Keep `source_url` and verification dates for every record.
