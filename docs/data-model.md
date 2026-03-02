# AI Wiki data model (V1)

## Canonical JSON shape

```json
{
  "id": "chatgpt",
  "name": "ChatGPT",
  "intro": "对话式人工智能助手",
  "features": [
    "自然语言问答",
    "多轮对话"
  ],
  "company": "OpenAI",
  "url": "https://chatgpt.com/",
  "icon": "chatgpt.png",
  "category": "聊天机器人",
  "source_url": "https://openai.com/chatgpt/overview/",
  "last_verified_at": "2026-03-02",
  "use_cases": ["学习总结", "写作润色"],
  "best_practices": ["先给目标和输出格式", "复杂任务分步提问"],
  "strengths": ["通用任务覆盖广"],
  "limitations": ["关键事实需二次核对"],
  "prompt_templates": [
    {
      "title": "结构化写作",
      "prompt": "你是资深编辑，请按结论先行+要点列表输出..."
    }
  ],
  "access": {
    "pricing": "免费版 + 订阅版",
    "account_required": true,
    "platforms": ["Web", "iOS", "Android", "API"],
    "api_available": true
  }
}
```

## Field rules

- `id`: lowercase slug, `[a-z0-9-]+`, unique
- `name`: 1-60 chars
- `intro`: 10-140 chars
- `features`: array with 1-8 items; each item 2-30 chars
- `company`: 1-60 chars
- `url`: official public page, `https://`
- `icon`: local asset file name
- `category`: one of:
  - 聊天机器人
  - 编程助手
  - 图像生成
  - 数据分析
  - 多模态模型
- `source_url`: source used for verification
- `last_verified_at`: `YYYY-MM-DD`
- Optional depth fields:
  - `use_cases`: array of practical scenarios
  - `best_practices`: array of usage tips
  - `strengths`: array of key strengths
  - `limitations`: array of limitations/caveats
  - `prompt_templates`: array of `{title, prompt}`
  - `access`: object with `pricing`, `account_required`, `platforms`, `api_available`

## CSV header for manual collection

`id,name,intro,features,company,url,icon,category,source_url,last_verified_at`

`features` in CSV uses `|` as separator.
