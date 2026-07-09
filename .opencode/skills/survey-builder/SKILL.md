---
name: survey-builder
description: 文献综述 / 调研报告构建。围绕一个主题，系统地检索、归类、对比多篇文献，产出结构化的**叙述性综述 / 调研报告**（背景→现状→分歧→空白→展望，含证据表）。当用户说"写篇综述""某方向研究进展""调研报告""survey""综述报告""把这批文献综述一下"时使用（若用户明确要 PRISMA/双人筛选/RoB/Meta，那是系统综述，另走系统综述流程）。⚠️ 本技能为占位/待补全：上游 survey-report-builder 来自 mcpmarket，尚未取得其脚本，暂用通用综述流程兜底。
---

> **本仓库运行环境（先读）**：Python 用 `.venv/Scripts/python.exe`（Windows）/ `.venv/bin/python`（Linux/macOS）（项目根 `.venv`；没有先跑 `env-setup` 技能）；本技能资源在 `skills/survey-builder/` 下；产出写 `outputs/`。

# 文献综述 / 调研报告构建（Survey Builder）—— 占位·待补全

目标是把一个主题下的多篇文献，做成一份可读、可引用、有逻辑主线的**叙述性综述**。

> **状态：占位。** 原始 skill（[mcpmarket · survey-report-builder](https://mcpmarket.com/zh/tools/skills/survey-report-builder)）当前抓取被限流、脚本未取得。在补全上游前，本技能用下面这套**通用综述流程**兜底，同样能交付综述初稿。

## 兜底流程（未取得上游脚本时照此做）

1. **界定范围**：与用户确认主题、时间窗、纳入方向（给编号候选让用户选）。
2. **检索**：用可用的检索能力（Europe PMC / Crossref 等国内可达源；PubMed 需境外网络）拉相关文献，按主题聚类。
3. **建证据表**：每篇一行——研究对象 / 方法 / 主要发现 / 局限 / 与主线的关系。写到 `outputs/`。
4. **成文**：按 背景 → 研究现状（分主题）→ 争议与分歧 → 研究空白 → 展望 组织，边写边落引用（作者, 年）。
5. **核查**：成文后交 `reference-check` 查假引用 / 核 DOI，全绿再交付。
6. **去 AI 味**（可选）：交 `humanize-academic` 润色。

## 待办（补全上游）
- 换用其它抓取方式或镜像取得 mcpmarket 的 `survey-report-builder` 打包内容，替换/增强本兜底流程。

## 边界
- 只做**叙述性综述**；一旦用户要求 PRISMA 流程图 / 双人筛选 / 偏倚风险(RoB) / Meta 合并 / 森林图，这是**系统综述**，超出本技能范围，应改走系统综述方法学（本项目当前未内置该技能，需另配）。
- 不虚构文献与数据，缺的标"待补充"向用户要。
