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
        )
    ]
}
