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
| `render-pdf-doc` | [Aperivue/medsci-skills](https://github.com/Aperivue/medsci-skills) | `skills/render-pdf-doc`（Markdown→PDF，pandoc+xelatex） | MIT |
| `paperconan` | [zixixr/paperconan](https://github.com/zixixr/paperconan) | `skills/paperconan`（论文源数据完整性核查，包 `paperconan` CLI） | 见上游 LICENSE |
| `ppt-master` | [hugohe3/ppt-master](https://github.com/hugohe3/ppt-master) | `skills/ppt-master`（文档→原生可编辑 PPTX） | MIT |

## 本仓库自建 / 保留的技能（非 vendored）
- `reference-check`（查假引用 / 核 DOI-PMID）、`humanize-academic`（去 AI 味）、`render-docx`（Markdown→投稿版 `.docx`，走 pandoc）、`env-setup`（环境自举）：来自本套件母项目，随本项目保留。
- `survey-builder`（文献综述，占位）：目标上游为 [mcpmarket · survey-report-builder](https://mcpmarket.com/zh/tools/skills/survey-report-builder)，抓取受限暂未取得，当前以通用综述流程兜底，待换源补全。

## 我们做的改动（须按许可声明）
1. 每个 vendored 技能的 `SKILL.md` **顶部新增一段引用块**：说明本仓库 Python 解释器（项目根 `.venv`）、脚本目录 `skills/<name>/`、产出目录 `outputs/`。正文其余部分未改。
2. `paper-writer`：删除了 `tests/` 与 `.github/`。
3. `nature-figure`：沿用母项目引入版（已删除 ~30MB 示例图库 `assets/`，保留 SKILL.md / manifest / static / references / scripts / evals）。
4. `academic-research-suite`：删除了内部 `.github/` 等无关目录。
5. `render-pdf-doc`：删除了 `tests/` 测试夹具，保留 SKILL.md / scripts / references / templates。
6. `paperconan`：仅取上游的 `skills/paperconan/`（SKILL.md + references，未带 `src/` 源码）；顶部加「本仓库运行环境」块，说明 `paperconan` CLI 已装进 `.venv`、跳过原文第 0 步的安装/询问。CLI 由 `pip install "paperconan[all]"` 提供（见 requirements）。
7. `ppt-master`：取上游的 `skills/ppt-master/`（SKILL.md + scripts + templates + references + workflows），**删除了 44M 的图片风格对比库 `references/ai-image-comparison/`**（人看的风格预览图，无界面文本 Agent 用不上；`strategist.md` 内相关链接失效，无碍）。保留了 `templates/icons/`（11k+ SVG 图标，供流水线按名检索）。顶部加「本仓库运行环境」块（说明核心依赖已装进 `.venv`、AI 配图/旁白/编辑器为可选）。

## 未采用
- **LaTeX Writer**（[EvolvingLMMs-Lab/lmms-lab-writer](https://github.com/EvolvingLMMs-Lab/lmms-lab-writer)）：上游是一个完整的前端应用（apps/desktop·web·video 单仓库），**不是 skill 包**，无法按本套件的 `SKILL.md` 约定装入，故未采用。

## 依赖
见 `scripts/requirements-skills.txt`（本地 `.venv`）与 `deploy/requirements.txt`（容器）。要点：
- `paper-writer`：`pypdf` / `pdfplumber` + 通用科学计算（numpy/pandas/scipy/statsmodels/lifelines/matplotlib，已装）。
- `nature-figure`：matplotlib / seaborn（已装）。
- `paper-spine`：脚本全走 Python 标准库，无额外 pip 依赖。
- `fund-literature-review-writer`：`scholarly`（Google Scholar，易被限流）/ `exa-py`（需 `EXA_API_KEY`），均可选。
- `academic-research-suite` / nature 文字类技能：无 pip 依赖。
- `render-pdf-doc` / `render-docx`：脚本走标准库，靠**系统 pandoc**（`render-pdf-doc` 另需 **xelatex** + CJK 字体）出件，由 `-WithPdf` / `--with-pdf` 安装。
- `paperconan`：`paperconan[all]`（含 `python-calamine` 读 .xls/.xlsx、`pdfplumber`/`python-docx` 解析 PDF/Word 表格），提供 `paperconan` 命令行；已并入 `requirements-skills.txt`。
- `ppt-master`：核心 `python-pptx` / `XlsxWriter` / `svglib` / `reportlab` / `mammoth` / `markdownify` / `ebooklib` / `nbconvert` / `curl_cffi` / `flask` / `edge-tts`（已并入 requirements）。可选：`cairosvg`（比 svglib 好，但需系统 cairo，未装）、`google-genai`（AI 配图，需 Gemini key，未装）。

## 保留声明
各上游仓库的版权与许可声明随技能目录保留；本文件即为对本仓库改动的说明。使用前请核对各上游仓库的 LICENSE 原文。
