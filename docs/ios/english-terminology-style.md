# English terminology style guide

This guide standardizes high-frequency English wording used in AIWiki seed content.

Scope:

- `tool.*.intro`
- `learning.*.summary`
- `tool.*.best_practice.*`
- `tool.*.strength.*`
- `tool.*.limitation.*`
- `tool.*.prompt.*`

## Writing rules

Use these sentence shapes consistently:

- `intro`: one short product description sentence
- `summary`: one short descriptive sentence, usually mirroring the intro style
- `best_practice`: imperative action sentence
- `strength`: capability phrase or concise descriptive phrase
- `limitation`: concise constraint or risk phrase
- `prompt title`: short noun phrase ending with `template` when applicable
- `prompt body`: direct instruction block with compact structure

Keep wording:

- short
- concrete
- product-facing
- neutral in tone

Avoid:

- marketing claims such as `best`, `top-tier`, `extraordinarily productive`
- filler such as `make good use of`, `experience the power of`
- mixed sentence styles inside the same list
- placeholder company wording such as `global tech company`
- awkward literal translations

## Preferred terms

| Concept | Preferred term | Avoid |
| --- | --- | --- |
| AI assistant | `AI assistant` | `AI helper`, `AI bot` for general assistant copy |
| Platform | `platform` | `tool` when the product is clearly multi-surface |
| Workflow | `workflow` | `flow` unless the product uses that term directly |
| Productivity | `productivity` | `efficiency` when the meaning is general work enablement |
| Multimodal | `multimodal` | `multi-modal`, `multi mode` |
| Long-context | `long-context` | `long text`, `long window` |
| Knowledge base | `knowledge base` | `knowledge库`, `KB` in user-facing copy |
| Voice cloning | `voice cloning` | `voice copy` |
| Text to speech | `text-to-speech` | `TTS` in user-facing copy |
| Image generation | `image generation` | `image creation` unless style needs variety |
| Image understanding | `image understanding` | `vision Q&A` as a primary label |
| Coding assistant | `coding assistant` | `code helper` |
| Code editor | `code editor` | `IDE tool` when editor is more accurate |
| Presentation tool | `presentation tool` | `PPT tool` in product descriptions |
| Deck | `deck` | `slides` when referring to a generated presentation artifact |
| Real-time topics | `real-time topics` | `hot topics`, `trending events` by default |
| Productivity workflows | `productivity workflows` | `office workflows` unless enterprise-office context is explicit |
| Open-source model | `open-source model` or `open-weight model` | malformed phrases such as `model from` fragments |
| Cross-device | `cross-device` | `multi-device` unless required by source wording |
| Brand kit | `Brand Kit` when product-specific, otherwise `brand kit` | mixed casing |

## Product-category wording

Use these defaults for product descriptions:

- assistant products: `AI assistant for ...`
- platform products: `Platform for ...`
- editor products: `Code editor with ...`
- generation products: `Tool for ...`
- learning products: `Learning app for ...`
- presentation products: `Presentation tool for ...`
- voice products: `Voice platform for ...`

Examples:

- `General-purpose AI assistant for writing, analysis, and reasoning.`
- `Platform for building AI bots, workflows, and lightweight apps.`
- `Code editor with built-in AI support for navigation, edits, and generation.`
- `Presentation tool for generating decks, outlines, and formatted slides.`

## List-style rules

### Best practices

Use imperative verbs:

- `Use`
- `Ask`
- `Provide`
- `Start`
- `Choose`
- `Run`
- `Keep`
- `Define`

Examples:

- `Use a knowledge base to improve answer quality`
- `Ask it to mark uncertainties and assumptions explicitly`
- `Start from a template instead of building from scratch`

Avoid:

- `Works best when ...`
- `The more specific ..., the better ...`
- descriptive statements that are not actionable

### Strengths

Use noun phrases or stable capability phrases.

Examples:

- `Strong reasoning capabilities`
- `Fast deck and outline generation`
- `Rich plugin ecosystem`
- `Convenient AI chat mode`

Avoid:

- full action sentences such as `Write and run instantly`
- vague praise such as `Very powerful`

### Limitations

Use concise constraint or risk phrases.

Examples:

- `Limited precision and control`
- `Commercial-use copyright and compliance risk`
- `Locked to the Notion ecosystem`
- `Availability may vary by region and platform`

Avoid:

- instructions such as `Check copyright...`
- review commands such as `Review terms carefully`

## Prompt style

Prompt titles:

- use short noun phrases
- end with `template` when the title describes a reusable structure

Prompt bodies:

- start with a direct verb: `Summarize`, `Rewrite`, `Compare`, `Write`, `Review`
- prefer `Return:` or `Output:` for structured results
- keep enumerations compact

Examples:

- `Long-form summary template`
- `Repo review template`
- `Image analysis template`

- `Summarize this repository's architecture, core modules, and dependencies. Then identify the most likely performance bottlenecks and maintainability risks.`
- `Review this production bug and return: root cause, fix plan, changed files, and a regression checklist.`

## Brand and naming rules

- Prefer official product names in English when they are widely recognized.
- Prefer official company names over placeholders.
- Do not invent translated English aliases for brands if a stable product name already exists.

Examples:

- `Claude`, not `Logical Reasoning Engine`
- `Gemini`, not `Multimodal Brain`
- `Kimi`, not `High-Efficiency Assistant`
- `Anthropic`, not `AI research company`
- `Google`, not `global tech company`

## Update checklist

Before adding or revising seed copy:

1. Check whether the product is best described as an assistant, platform, editor, tool, or app.
2. Reuse preferred terms from this guide before introducing a new variant.
3. Keep `intro` and `summary` under one sentence each.
4. Keep `best_practice`, `strength`, and `limitation` in their fixed sentence shapes.
5. Use official English brand and company names.
6. Re-scan `en.lproj/Localizable.strings` for drift after bulk edits.

## Validation command

Run the style checker after bulk copy edits:

```bash
scripts/check_en_localizable_style.py
```

To enforce the same rule locally before each commit:

```bash
bash scripts/install_git_hooks.sh
```

Shared entrypoints:

```bash
make lint-copy
bash scripts/check_all.sh
```
