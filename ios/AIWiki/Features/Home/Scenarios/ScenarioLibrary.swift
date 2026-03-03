import Foundation

enum ScenarioLibrary {
    static let all: [TaskScenario] = [
        TaskScenario(
            id: "weekly-report",
            title: "写周报",
            subtitle: "把本周工作快速整理成可发送版本",
            outcome: "15 分钟产出结构完整、可直接发送的周报。",
            quickStartSteps: [
                "粘贴本周事项（最多 10 条）",
                "复制模板生成初稿",
                "核对数据后发送"
            ],
            steps: [
                .init(title: "收集原始信息", detail: "列出本周完成事项、数据结果、阻塞问题。"),
                .init(title: "生成初稿", detail: "使用模板让 AI 按固定结构输出周报初稿。"),
                .init(title: "校正事实", detail: "把数字、日期、负责人逐条校对后再发布。")
            ],
            promptCards: [
                .init(
                    title: "周报生成模板",
                    prompt: "你是团队负责人助理。请基于以下输入生成周报，结构固定为：1) 本周完成；2) 关键数据；3) 问题与风险；4) 下周计划；5) 需要协同事项。语气简洁专业，控制在 500 字内。输入：<粘贴本周事项>"
                )
            ],
            pitfalls: ["只给笼统描述会导致结果空泛", "数据未校对容易造成管理误判"],
            exampleOutput: "本周完成：完成支付链路重构并上线灰度；关键数据：结算失败率从 1.8% 降到 0.6%；风险：账单导出接口高峰期延迟仍偏高；下周计划：完成导出任务异步化并补齐监控。",
            reviewQuestions: ["这份周报是否突出关键结果而不是过程？", "是否明确了风险和下一步责任人？"],
            relatedToolIDs: ["chatgpt", "claude", "gemini"]
        ),
        TaskScenario(
            id: "competitor-brief",
            title: "做竞品分析",
            subtitle: "快速拿到可讨论的竞品对比稿",
            outcome: "30 分钟输出一份用于内部讨论的竞品简报。",
            quickStartSteps: [
                "确定对比对象和时间窗口",
                "复制模板让 AI 生成对比草稿",
                "确认关键结论的来源链接"
            ],
            steps: [
                .init(title: "设定对比维度", detail: "先固定功能、定价、目标用户、增长策略四个维度。"),
                .init(title: "收集并归纳", detail: "用检索型工具收集资料，再让 AI 统一结构。"),
                .init(title: "形成结论", detail: "输出差异化机会、短期动作和风险项。")
            ],
            promptCards: [
                .init(
                    title: "竞品对比模板",
                    prompt: "请对比 <产品A> 与 <产品B>，输出：1) 功能差异表；2) 定价策略；3) 目标用户；4) 各自优势与短板；5) 我方可执行机会。每条结论附来源链接。"
                )
            ],
            pitfalls: ["没有限定时间窗口会混入过期信息", "只看功能不看商业模式会失真"],
            exampleOutput: "结论：产品A在企业协作和权限体系上更强，产品B在上手速度和价格门槛更低；建议：短期优先补齐模板市场与团队协作能力。",
            reviewQuestions: ["结论是否有来源支撑？", "建议是否是团队两周内可执行动作？"],
            relatedToolIDs: ["perplexity", "notebooklm", "chatgpt"]
        ),
        TaskScenario(
            id: "code-debug",
            title: "代码排错",
            subtitle: "从报错到修复方案的标准化流程",
            outcome: "10-20 分钟定位根因并拿到最小修复方案。",
            quickStartSteps: [
                "粘贴报错 + 相关代码",
                "要求输出根因和最小修复",
                "按回归清单跑测试"
            ],
            steps: [
                .init(title: "提供完整上下文", detail: "包含报错日志、关键代码、预期行为。"),
                .init(title: "要求结构化输出", detail: "让 AI 按根因/修复/验证步骤回答。"),
                .init(title: "回归验证", detail: "执行测试并检查关联模块是否受影响。")
            ],
            promptCards: [
                .init(
                    title: "Bug 修复模板",
                    prompt: "请定位以下问题并按格式输出：A) 根因；B) 最小修复方案；C) 修复后代码；D) 回归测试清单。代码与日志：<粘贴内容>"
                )
            ],
            pitfalls: ["只贴一小段代码会误判根因", "不做回归测试会引入新问题"],
            exampleOutput: "根因：空数组输入时索引越界；最小修复：在访问 first 前增加 isEmpty 判断；回归测试：空输入、单元素、多元素三种场景。",
            reviewQuestions: ["修复是否保持最小改动原则？", "回归测试是否覆盖边界场景？"],
            relatedToolIDs: ["github-copilot", "cursor", "chatgpt"]
        ),
        TaskScenario(
            id: "study-plan",
            title: "做学习计划",
            subtitle: "把模糊目标变成可执行日程",
            outcome: "5 分钟生成按周拆解的学习计划与复盘清单。",
            quickStartSteps: [
                "填写目标、周期、每日可投入时间",
                "复制模板生成 4 周计划",
                "每周末按复盘问题调整"
            ],
            steps: [
                .init(title: "定义目标", detail: "明确期限、当前水平和可投入时间。"),
                .init(title: "生成计划", detail: "按周目标和每天任务拆解，并附阶段检查点。"),
                .init(title: "每周复盘", detail: "根据完成率和难点调整下一周安排。")
            ],
            promptCards: [
                .init(
                    title: "4 周学习计划模板",
                    prompt: "你是学习教练。请为我制定 4 周学习计划，输出：每周目标、每天任务、复盘问题、风险提醒。学习主题：<填写>；当前水平：<填写>；每日可投入时间：<填写>。"
                )
            ],
            pitfalls: ["目标过大但时间不足", "只列任务不做复盘会难以持续"],
            exampleOutput: "第1周目标：掌握基础概念与最小实践；每日任务：40分钟学习 + 20分钟练习；周复盘：完成率、难点、下周调整动作。",
            reviewQuestions: ["本周计划是否与可投入时间匹配？", "复盘后是否给出下周具体调整动作？"],
            relatedToolIDs: ["gemini", "notebooklm", "claude"]
        ),
        TaskScenario(
            id: "content-creation",
            title: "写公众号文章",
            subtitle: "从选题到成稿的高效创作流程",
            outcome: "30 分钟产出一篇结构清晰、可发布的公众号文章。",
            quickStartSteps: [
                "确定选题和目标读者",
                "用 AI 生成大纲和初稿",
                "人工润色后配图发布"
            ],
            steps: [
                .init(title: "选题调研", detail: "用搜索工具找热门话题，确定切入角度。"),
                .init(title: "生成大纲与初稿", detail: "让 AI 按大纲展开，每段 100-200 字。"),
                .init(title: "润色与配图", detail: "调整语气，用 AI 生成配图或封面。")
            ],
            promptCards: [
                .init(
                    title: "公众号文章模板",
                    prompt: "请为我写一篇公众号文章，主题：<填写>，目标读者：<填写>。要求：标题吸引眼球、开头有故事感、分 3-5 个小节、每节有小标题、结尾引导互动。字数 1500 左右。"
                )
            ],
            pitfalls: ["AI 生成的文字容易千篇一律", "不加个人观点会缺乏温度"],
            exampleOutput: "标题：AI 时代，普通人如何用 3 个工具提升 10 倍效率？...",
            reviewQuestions: ["是否有独特观点而不只是常识？", "读者看完是否有行动指引？"],
            relatedToolIDs: ["chatgpt", "jasper", "notion-ai"]
        ),
        TaskScenario(
            id: "meeting-summary",
            title: "整理会议纪要",
            subtitle: "会后 5 分钟输出可执行纪要",
            outcome: "会后 5 分钟自动生成结构化会议纪要与 TODO 列表。",
            quickStartSteps: [
                "录制或粘贴会议内容",
                "用模板提取决议和待办",
                "发送给参会人确认"
            ],
            steps: [
                .init(title: "录音转文字", detail: "使用语音识别工具将会议录音转为文字稿。"),
                .init(title: "提取要点", detail: "让 AI 按决议、待办、问题三栏整理。"),
                .init(title: "分发确认", detail: "发给参会人核实后归档。")
            ],
            promptCards: [
                .init(
                    title: "会议纪要模板",
                    prompt: "请将以下会议内容整理为纪要，格式：1) 会议主题；2) 关键讨论点（列表）；3) 决议事项（含负责人和截止日期）；4) 遗留问题。会议内容：<粘贴>"
                )
            ],
            pitfalls: ["录音质量差会影响识别准确率", "AI 可能遗漏非正式口头决定"],
            exampleOutput: "决议：Q3 预算上调 15%（负责人：张三，截止 3/15）；遗留问题：供应商合同条款待法务确认。",
            reviewQuestions: ["每条决议是否有负责人和截止时间？", "是否遗漏了重要讨论？"],
            relatedToolIDs: ["whisper", "otter-ai", "chatgpt"]
        ),
        TaskScenario(
            id: "data-report",
            title: "分析数据出报告",
            subtitle: "从 Excel 到可汇报的数据洞察",
            outcome: "20 分钟将原始数据转化为带图表的分析报告。",
            quickStartSteps: [
                "上传数据文件或粘贴表格",
                "让 AI 生成统计摘要和可视化",
                "提炼 3 条关键洞察"
            ],
            steps: [
                .init(title: "数据清洗", detail: "上传数据，让 AI 检查缺失值和异常值。"),
                .init(title: "统计分析", detail: "生成关键指标的统计摘要和趋势图表。"),
                .init(title: "洞察提炼", detail: "让 AI 总结 3-5 条关键发现并给出建议。")
            ],
            promptCards: [
                .init(
                    title: "数据分析模板",
                    prompt: "请分析以下数据并输出：1) 数据概览（行列数、类型分布）；2) 关键指标统计（均值、中位数、增长率）；3) 趋势分析；4) 3 条关键洞察；5) 行动建议。数据：<粘贴>"
                )
            ],
            pitfalls: ["不检查数据质量直接分析会得到错误结论", "忽略业务背景只看数字会误导"],
            exampleOutput: "洞察 1：用户留存率在第 7 天有明显断崖，建议优化首周引导流程；洞察 2：付费转化集中在晚 8-10 点...",
            reviewQuestions: ["结论是否有数据支撑？", "建议是否可落地执行？"],
            relatedToolIDs: ["julius-ai", "chatgpt-data", "notebooklm"]
        ),
        TaskScenario(
            id: "email-writing",
            title: "写商务邮件",
            subtitle: "3 分钟写出得体的英文商务邮件",
            outcome: "快速产出语法正确、语气得当的商务邮件。",
            quickStartSteps: [
                "说明邮件目的和收件人关系",
                "用模板生成邮件初稿",
                "检查语气和关键信息后发送"
            ],
            steps: [
                .init(title: "明确目标", detail: "确定邮件目的、收件人、紧急程度和期望行动。"),
                .init(title: "生成初稿", detail: "让 AI 按商务邮件格式生成，注意称呼和结尾。"),
                .init(title: "语法检查", detail: "用语法工具做最后检查，确保无拼写错误。")
            ],
            promptCards: [
                .init(
                    title: "商务邮件模板",
                    prompt: "请帮我写一封商务邮件。目的：<填写>；收件人：<填写关系>；语气：<正式/友好>；关键信息：<填写>。要求简洁、专业，不超过 200 词。"
                )
            ],
            pitfalls: ["直接翻译中文思维会导致语气生硬", "忘记明确期望行动（call to action）"],
            exampleOutput: "Subject: Follow-up on Q3 Partnership Proposal\nDear Mr. Chen,\nThank you for taking the time to discuss... I'd appreciate your feedback by March 15th.",
            reviewQuestions: ["是否有明确的 call to action？", "语气是否匹配与收件人的关系？"],
            relatedToolIDs: ["grammarly", "chatgpt", "claude"]
        )
    ]
}
