# 第三方（vendored）技能来源与许可

本仓库的科研写作技能大多从上游开源仓库**原样引入**（仅在每个 `SKILL.md` 顶部加了一段「本仓库运行环境」说明，方法论与脚本保持原样；个别技能剥离了测试夹具 / 超大示例资源）。

| 本仓库技能目录 | 上游仓库 | 上游子技能 / 路径 | 许可 |
|---|---|---|---|
| `nature-figure` | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) | `skills/nature-figure` | Apache-2.0 |
| `nature-writing` | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) | `skills/nature-writing` | Apache-2.0 |
| `nature-polishing` | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) | `skills/nature-polishing` | Apache-2.0 |
| `nature-statistics` | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) | `skills/nature-statistics` | Apache-2.0 |
| `nature-reviewer` | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) | `skills/nature-reviewer` | Apache-2.0 |
| `_shared` | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) | `skills/_shared`（Nature 系共用片段，非独立技能） | Apache-2.0 |
| `academic-research-suite` | [Imbad0202/academic-research-skills-codex](https://github.com/Imbad0202/academic-research-skills-codex) | `plugins/academic-research-skills/skills/academic-research-suite` | 见上游 LICENSE |
| `paper-spine` | [WUBING2023/PaperSpine](https://github.com/WUBING2023/PaperSpine) | `dist/claude/skills/paper-spine`（Claude 发行版） | 见上游 LICENSE |
| `paper-writer` | [kgraph57/paper-writer-skill](https://github.com/kgraph57/paper-writer-skill) | 仓库根（单技能） | 见上游 LICENSE |
| `fund-background-writer` | [HuiyuLi-2000/Chinese-Grant-Writer-Skills](https://github.com/HuiyuLi-2000/Chinese-Grant-Writer-Skills) | `skills/fund-background-writer` | 见上游 LICENSE |
| `fund-literature-review-writer` | [HuiyuLi-2000/Chinese-Grant-Writer-Skills](https://github.com/HuiyuLi-2000/Chinese-Grant-Writer-Skills) | `skills/fund-literature-review-writer` | 见上游 LICENSE |
| `fund-research-content-writer` | [HuiyuLi-2000/Chinese-Grant-Writer-Skills](https://github.com/HuiyuLi-2000/Chinese-Grant-Writer-Skills) | `skills/fund-research-content-writer` | 见上游 LICENSE |
| `fund-technical-route-writer` | [HuiyuLi-2000/Chinese-Grant-Writer-Skills](https://github.com/HuiyuLi-2000/Chinese-Grant-Writer-Skills) | `skills/fund-technical-route-writer` | 见上游 LICENSE |

## 本仓库自建 / 保留的技能（非 vendored）
- `reference-check`（查假引用 / 核 DOI-PMID）、`humanize-academic`（去 AI 味）、`env-setup`（环境自举）：来自本套件母项目，随本项目保留。
- `paper-qa`（私有知识库 RAG，占位）：封装 [Future-House/paper-qa](https://github.com/Future-House/paper-qa)（Apache-2.0，pip 包，非现成 skill）；本仓库仅提供一层调用说明 skill，真正运行需 `pip install "paper-qa>=5"` 并自备 LLM/embedding 的 API key。见 `skills/paper-qa/SKILL.md`。
- `survey-builder`（文献综述，占位）：目标上游为 [mcpmarket · survey-report-builder](https://mcpmarket.com/zh/tools/skills/survey-report-builder)，抓取受限暂未取得，当前以通用综述流程兜底，待换源补全。

## 我们做的改动（须按许可声明）
1. 每个 vendored 技能的 `SKILL.md` **顶部新增一段引用块**：说明本仓库 Python 解释器（项目根 `.venv`）、脚本目录 `skills/<name>/`、产出目录 `outputs/`。正文其余部分未改。
2. `paper-writer`：删除了 `tests/` 与 `.github/`。
3. `nature-figure`：沿用母项目引入版（已删除 ~30MB 示例图库 `assets/`，保留 SKILL.md / manifest / static / references / scripts / evals）。
4. `academic-research-suite`：删除了内部 `.github/` 等无关目录。

## 未采用
- **LaTeX Writer**（[EvolvingLMMs-Lab/lmms-lab-writer](https://github.com/EvolvingLMMs-Lab/lmms-lab-writer)）：上游是一个完整的前端应用（apps/desktop·web·video 单仓库），**不是 skill 包**，无法按本套件的 `SKILL.md` 约定装入，故未采用。

## 依赖
见 `scripts/requirements-skills.txt`（本地 `.venv`）与 `deploy/requirements.txt`（容器）。要点：
- `paper-writer`：`pypdf` / `pdfplumber` + 通用科学计算（numpy/pandas/scipy/statsmodels/lifelines/matplotlib，已装）。
- `nature-figure`：matplotlib / seaborn（已装）。
- `paper-spine`：脚本全走 Python 标准库，无额外 pip 依赖。
- `fund-literature-review-writer`：`scholarly`（Google Scholar，易被限流）/ `exa-py`（需 `EXA_API_KEY`），均可选。
- `academic-research-suite` / nature 文字类技能：无 pip 依赖。
- `paper-qa`：默认不装，用时再 `pip install "paper-qa>=5"`（需 API key）。

## 保留声明
各上游仓库的版权与许可声明随技能目录保留；本文件即为对本仓库改动的说明。使用前请核对各上游仓库的 LICENSE 原文。
