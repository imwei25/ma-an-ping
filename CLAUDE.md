# 科研写作 Skill 套件 — 项目说明

本项目是一组**独立的科研 / 医学写作技能（skills）**，没有主控 / 路由 / 调度机制。
每个技能靠自己 `SKILL.md` 里的 `description` 自行触发——你（agent）读用户请求，命中哪个技能就直接用哪个，不需要先经过任何"总控"。

## 技能清单（按用途）
- **顶刊论文写作 / 审稿**：`nature-writing`（撰写）、`nature-polishing`（润色）、`nature-statistics`（统计报告审查）、`nature-reviewer`（模拟审稿意见）、`nature-figure`（投稿级配图：森林图 / KM / 火山图，300dpi+ 矢量）
- **论文撰写**：`paper-writer`（IMRaD 全流程、期刊选择、投稿前检查）
- **论文拆解 / 精读**：`paper-spine`（拆解范文骨架、结构与逻辑迁移）
- **深度研究**：`academic-research-suite`（多源检索 + 对抗式核查 + 成文报告）
- **文献综述**：`survey-builder`（叙述性综述 / 调研报告；占位·通用流程兜底）
- **基金申请（中文标书）**：`fund-background-writer`、`fund-literature-review-writer`、`fund-research-content-writer`、`fund-technical-route-writer`
- **文稿核查**：`reference-check`（查假引用 / 核 DOI-PMID）、`humanize-academic`（去 AI 味润色）
- **排版出件**：`render-pdf-doc`（Markdown→出版级 PDF，pandoc+xelatex，含中文排版）、`render-docx`（Markdown→投稿版 `.docx`）
- **基础设施**：`env-setup`（建项目根 `.venv`、装依赖）

各技能是否需要串联（例如写完论文再核查引用、综述后再去 AI 味），由你按当下任务临时决定，不存在固定流水线。

## 几条硬规矩（所有技能通用）
- **不虚构**数据 / 结果 / 统计量 / 参考文献 / 伦理批号 / 注册号；缺的标"待补充"向用户要。
- 写完综述 / 论文，**建议接着跑 `reference-check`** 查假引用。
- Python 统一走**项目根 `.venv`**（缺则先跑 `env-setup`）：Windows `.venv/Scripts/python.exe`、Linux/macOS `.venv/bin/python`。
- 产出写 `outputs/`；**Web 网关注入了会话专属目录（`outputs/<会话id>/`）时以它为准，临时脚本也别写仓库根**（多用户共享，会串数据）。

## 技能位置
技能装在 `.opencode/skills/`（OpenCode 源镜像）与 `deploy/skills/`（部署 / 容器镜像），两套内容一致。Claude Code 可用 `install.ps1 -LinkClaude` / `install.sh --link-claude` 把技能复制到 `~/.claude/skills/`。`_shared/` 是 Nature 系技能共用的片段资源，不是独立技能。
