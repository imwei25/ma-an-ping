---
name: paper-qa
description: 私有文献知识库问答（RAG）。把一批本地 PDF / 全文建成可检索的知识库，然后带**逐句引用**回答关于这些文献的问题——"我这堆论文里关于 X 的证据有哪些""综述这几篇的方法差异""帮我从知识库里找支持某结论的原文"。基于 Future-House/paper-qa（pip 包）。当用户说"私有知识库""本地文献问答""把我的 PDF 建库""RAG 问文献""paper-qa""带引用地回答我的文献库"时使用。⚠️ 本技能为占位/待配置：真正运行前需先 `pip install paper-qa` 并配好 LLM / embedding 的 API key（见下）。
---

> **本仓库运行环境（先读）**：Python 用 `.venv/Scripts/python.exe`（Windows）/ `.venv/bin/python`（Linux/macOS）（项目根 `.venv`；没有先跑 `env-setup` 技能）；本技能资源在 `skills/paper-qa/` 下；产出写 `outputs/`（有会话专属目录时以它为准）。

# 私有文献知识库问答（paper-qa / RAG）—— 占位·待配置

本技能封装开源 **[Future-House/paper-qa](https://github.com/Future-House/paper-qa)**（Apache-2.0）：对一批科学文献做检索增强生成（RAG），回答**必带来源引用**，专治"AI 编文献"。

> **状态：占位。** 上游是 Python 库、不是现成 skill，且**必须自备 API key**才能真跑。按下面几步启用后即可用；未配置前请先告诉用户"需要先配 API key"，不要假装已建库或编造答案。

## 启用步骤（一次性）

1. **装包**（在项目根 `.venv` 里）：
   - Windows：`.venv/Scripts/python.exe -m pip install "paper-qa>=5"`
   - Linux/macOS：`.venv/bin/python -m pip install "paper-qa>=5"`
2. **配 API key**（二选一）：
   - **OpenAI（默认 LLM + embedding）**：设环境变量 `OPENAI_API_KEY=sk-...`
   - **换用 Claude / DeepSeek / 本地模型**：paper-qa 走 LiteLLM，可用 `pqa --settings` 或配置文件指定 `llm` / `embedding`（如 Claude 走 `ANTHROPIC_API_KEY`）。embedding 仍常用 OpenAI 或本地句向量。
   - 建议再配 `CROSSREF_API_KEY` / `SEMANTIC_SCHOLAR_API_KEY` 以免建大库时被限流（可选）。
3. **验证**：`.venv/Scripts/python.exe -m paperqa --help`（或装好后的 `pqa --help`）。

## 用法（配好后）

```bash
# 把某目录下的 PDF/全文建库并提问（paper-qa 会自动索引该目录）
cd <放论文 PDF 的目录>
pqa ask "这些文献里关于 DNA 甲基化与 HNSCC 预后的证据有哪些？"

# 或指定命名索引，先加文档再问
pqa -i mylib add ./papers
pqa -i mylib ask "对比这几篇的检测方法与样本量"
```

回答会带 `(Author, Year)` 式引用并列出所用片段来源。把最终答复与引用清单写到 `outputs/`。

## 与本套其它技能的衔接
- 建库前若要先把 PDF 转 Markdown / 下 OA 全文，可先手动获取；paper-qa 也能直接吃 PDF。
- 得到的引用可再交 `reference-check` 核 DOI/PMID 真实性兜底。

## 边界
- **绝不**在未真正建库/检索的情况下臆造文献或答案——这正是本技能要消灭的失败模式。
- 未配 API key → 明确告知用户"paper-qa 未配置，需先按上面步骤配 key"，停在这里等用户。
