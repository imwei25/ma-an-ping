# scientific-writer

自托管**科研 / 医学写作 Agent** 技能套件。基于 **OpenCode**（`opencode serve`）+ **DeepSeek**（OpenAI 格式），
配一个流式对话 + 文件上传/下载的 Web 网关（`web/`），也可打包成桌面端 / Docker 部署。

本项目由母项目 scientific-discover 复制而来，**换了一套技能集、并去掉了顶层主控 / 路由机制**：
不再有"总控"判意图分派——**每个技能靠自己 `SKILL.md` 的 `description` 自行触发**，agent 命中哪个用哪个，是否串联由当下任务临时决定。

- 技能目录：`.opencode/skills/`（本地，Python 走项目根 `.venv`）与 `deploy/skills/`（服务器 / 容器，用 `python3`），两套内容一致。
- 启动后端：`opencode serve --port 4098`；网关见 `web/server.mjs`。
- 上传目录 `uploads/`，产出目录 `outputs/`。
- 项目根 `AGENTS.md`（OpenCode）/ `CLAUDE.md`（Claude Code）只是**项目说明 + 几条通用硬规矩**，不是调度器。

## 技能套件（18 个）

| 方向 | 技能 | 说明 | 来源 |
|---|---|---|---|
| 顶刊撰写 | `nature-writing` | Nature 级论文撰写工作流 | vendored ᵛ |
| 顶刊润色 | `nature-polishing` | 语言 / 逻辑打磨，投稿级润色 | vendored ᵛ |
| 顶刊统计审查 | `nature-statistics` | 统计报告审查（p 值 / 样本量 / 多重比较 / 图注） | vendored ᵛ |
| 模拟审稿 | `nature-reviewer` | Nature 风格 3 份审稿报告 + 交叉综述 | vendored ᵛ |
| 投稿级配图 | `nature-figure` | matplotlib/seaborn 出森林图/KM/火山图，SVG/PDF/TIFF | vendored ᵛ |
| 论文撰写 | `paper-writer` | IMRaD 全流程、期刊选择、投稿前检查 | vendored ᵛ |
| 论文拆解 | `paper-spine` | 拆解范文骨架，结构 / 逻辑迁移到自己的稿子 | vendored ᵛ |
| 深度研究 | `academic-research-suite` | 多源检索 + 对抗式核查 + 成文报告 | vendored ᵛ |
| 文献综述 | `survey-builder` | 叙述性综述 / 调研报告（**占位**·通用流程兜底） | 待补全 |
| 基金·立项依据 | `fund-background-writer` | 国自然标书立项依据撰写 | vendored ᵛ |
| 基金·研究现状 | `fund-literature-review-writer` | 标书文献综述 / 研究现状 | vendored ᵛ |
| 基金·研究内容 | `fund-research-content-writer` | 研究内容 / 目标 / 方案 | vendored ᵛ |
| 基金·技术路线 | `fund-technical-route-writer` | 技术路线 / 可行性 | vendored ᵛ |
| 文献真实性核查 | `reference-check` | 对 Crossref/Europe PMC 查假引用（不存在/张冠李戴/虚构） | 本项目保留 |
| 去 AI 味 | `humanize-academic` | 去机器腔（中英双语清单），保术语与引用 + 不变量校验 | 本项目保留 |
| 排版(PDF) | `render-pdf-doc` | Markdown→出版级 PDF（pandoc+xelatex，含中文排版） | vendored ᵛ |
| 排版(Word) | `render-docx` | Markdown→投稿版 `.docx`（多数医学期刊要 Word） | 本项目保留 |
| 环境自举 | `env-setup` | 查 Python → 建项目根 `.venv` → 装依赖 | 本项目保留 |

> ᵛ = 直接引入的现成开源技能（vendored），来源与许可见 [THIRD_PARTY_SKILLS.md](THIRD_PARTY_SKILLS.md)。
> `_shared/` 是 Nature 系技能共用的片段资源，不是独立技能。
> **占位**技能（`survey-builder`）已装好说明与兜底流程，但要完全可用还需补一步（换源），详见其 `SKILL.md`。
> 排版技能 `render-pdf-doc` / `render-docx` 依赖 **pandoc**（+ `render-pdf-doc` 还要 **xelatex** 与 CJK 字体）——用 `install.ps1 -WithPdf` / `install.sh --with-pdf` 一并装好。

## 一键安装（Python 统一走**项目根 `.venv`**）

```powershell
# Windows 本地
powershell -ExecutionPolicy Bypass -File install.ps1           # 或 scripts\setup.ps1
powershell -ExecutionPolicy Bypass -File install.ps1 -WithPdf -LinkClaude
```
```bash
# Linux 服务器（非 Docker）
bash install.sh                # 或 scripts/setup.sh；之后 source .venv/bin/activate 再起服务
bash install.sh --with-pdf --link-claude
```

脚本会：在项目根建/复用 `.venv` → 装 `scripts/requirements-skills.txt` 全部依赖 → （`-WithPdf` 时）装 pandoc + xelatex → 逐包冒烟测试 → 运行 `scripts/validate_skills.py` 校验所有 SKILL.md（无 BOM、frontmatter 合法、两套镜像技能集合一致、正文无漂移）。**不再写任何路由文件**。`-LinkClaude` / `--link-claude` 会把技能复制到 `~/.claude/skills/` 供 Claude Code 使用。

Docker 部署走 `deploy/requirements.txt` + `deploy/Dockerfile`（容器内技能落 `/app/.opencode/skills/`，`deploy/AGENTS.md` 作为 OpenCode 的项目说明）。

### 启动 Web 网关

装好后用根目录一键启动脚本（会刷新 PATH 找到 pandoc/xelatex/node/opencode、激活项目 `.venv` 让技能的 `python3` 指向它、缺 `web/node_modules` 自动 `npm install`，再起网关；网关自身会拉起本机 opencode 重扫技能目录）：

```powershell
# Windows：网关 3100 + opencode 4198（默认，避开母项目 3000/4098）
powershell -ExecutionPolicy Bypass -File start.ps1
powershell -ExecutionPolicy Bypass -File start.ps1 -Port 3100 -OcPort 4198
powershell -ExecutionPolicy Bypass -File start.ps1 -NoAuth      # 关掉局域网登录（localhost 始终免登录）
```
```bash
# Linux / macOS
bash start.sh
PORT=3100 OC_PORT=4198 bash start.sh
NO_AUTH=1 bash start.sh
```

启动后浏览器打开 `http://localhost:<Port>`（本机免登录）。停网关按 `Ctrl+C`；opencode 是 detached 进程，另用 `scripts\serve-opencode.ps1 -Force` 或杀对应端口。模型走 opencode 的全局登录（默认 `deepseek/deepseek-v4-pro`），未登录时可用 `opencode auth login` 配置。

> **换机器 / 换框架时**：技能不写死任何机器路径——解释器统一指向**项目根 `.venv`**（Windows `.venv\Scripts\python.exe`，Linux/mac `.venv/bin/python`）。把 `skills/` 拷到目标框架的技能根、跑一次 `env-setup`（或 `scripts/setup.*`）建好 `.venv` 即可，无需改任何 SKILL.md。

## 依赖与数据源要点

- **pip 依赖**：见 `scripts/requirements-skills.txt`（本地）与 `deploy/requirements.txt`（容器）。核心是科学计算（pandas/numpy/scipy/statsmodels/lifelines/matplotlib/seaborn）＋ `paper-writer` 的 `pypdf`/`pdfplumber` ＋ `reference-check` 的 `requests`/`bibtexparser`/`rispy`。`paper-spine` 脚本全走标准库；nature 文字类技能与 `academic-research-suite` 无 pip 依赖。
- **系统依赖（排版用）**：`render-pdf-doc` 需 pandoc + xelatex（Windows: MiKTeX；Linux/Docker: `texlive-xetex`）+ CJK 字体；`render-docx` 需 pandoc。由 `install.ps1 -WithPdf` / `install.sh --with-pdf` 与 `deploy/Dockerfile` 安装。
- **可选依赖（需 key / 易被墙）**：`fund-literature-review-writer` 的 `scholarly`（Google Scholar，限流）/ `exa-py`（需 `EXA_API_KEY`）。
- **免费数据源（无需 key，国内可达）**：[Europe PMC](https://europepmc.org/RestfulWebService) / [Crossref](https://api.crossref.org)（`reference-check` 用）。NCBI/PubMed 在中国大陆常被阻断，本套件核查默认走 Europe PMC/Crossref。

## 未采用

- **LaTeX Writer**（[EvolvingLMMs-Lab/lmms-lab-writer](https://github.com/EvolvingLMMs-Lab/lmms-lab-writer)）：上游是完整前端应用、不是 skill 包，无法按本套件约定装入，故未采用。见 [THIRD_PARTY_SKILLS.md](THIRD_PARTY_SKILLS.md)。
