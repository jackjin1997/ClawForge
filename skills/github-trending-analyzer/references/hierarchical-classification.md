# 分层分类方法论：显式映射 vs 关键词 heuristic

## 何时用 2 级分层

| 项目数 | 推荐方式 |
|--------|---------|
| < 30 | 单级（5-9 个桶） |
| 30-200 | **2 级（5-8 macro × 3-7 sub）** |
| > 200 | 3 级或自动 clustering |

GitHub Trending 单日合并 5 个数据源后通常 100-200 个独特项目，**默认走 2 级**。

## 为什么显式映射优于关键词 heuristic

### 关键词 heuristic 的失败模式

```python
# 看似优雅，实际不行
if 'skill' in desc and 'code' in desc:
    return 'cli_coding'
if 'skill' in name:
    return 'skills'
```

问题：
1. **命中率永远 ~75%**：剩下 25% 项目（多语言 / 缩写 / 描述为空）掉进 "其它"
2. **维护成本指数上升**：每加一个流派要改 3 处规则，规则之间相互冲突
3. **边界争议反复出现**：`anthropics/defending-code-reference-harness` 是 skill 还是 security？同时是
4. **空描述项无能为力**：`Tong89/smartNode` 没描述也没仓库结构线索，纯关键词死路

### 显式映射方式

```python
# hierarchy.py
M = {
    'helloianneo/ian-xiaohei-illustrations': ('ai_native', 'skills_media'),
    'op7418/guizang-social-card-skill': ('ai_native', 'skills_media'),
    'anthropics/defending-code-reference-harness': ('security', 'sec_defense'),  # cross-domain → 选最具体的
    'tong89/smartnode': ('ai_native', 'skills_general'),  # 空描述项也能基于命名习惯归类
    # ...
}
```

优点：
1. **100% 覆盖**：每个项目都有归属，无 "其它" 万能桶
2. **决策可审计**：边界争议项的归属选择是显式的、可被 review 的
3. **维护成本与项目数线性**：加一行就行
4. **可与关键词回退混合**：未知项目走 heuristic 兜底，主流项目显式定义

### 时间成本对比

| 任务 | 关键词规则 | 显式映射 |
|------|-----------|---------|
| 首次写 130 项的规则 | ~30 分钟（反复调试） | ~15 分钟（一次性）|
| 命中率 | 75% | 100% |
| 加新流派 | 改 3 处规则 + 测试 | 加 1 行 |
| 边界争议处理 | 改规则可能误伤其他项 | 改一行 |

> **核心 trade-off**：当数据量 ≤ 200 且语义边界模糊时，**人工标注一次 << 维护无穷规则**。这就是 ML 圈"few-shot manual labeling beats elaborate rules"的本地化版本。

## 推荐 schema（GitHub Trending 场景）

```python
MACROS = {
    'ai_native': '🤖 AI Native 开发栈',
    'models': '🎨 模型 & 创意生成',
    'security': '🛡️ 安全 & 防御',
    'engineering': '🛠️ 工程 & 生产力',
    'research': '🔬 研究 & 学习资源',
    'platform': '🌳 平台 & 经典基础设施',
    'misc': '🌎 其它',
}

# Sub-buckets: (macro, sub_key): label
SUBS = {
    # AI Native（最热区域，细分最深）
    ('ai_native','skills_media'):    '🎨 创意 / 媒体 Skills',
    ('ai_native','skills_writing'):  '✍️ 写作 / 语言 Skills',
    ('ai_native','skills_workflow'): '🔁 工作流 / 方法论 Skills',
    ('ai_native','skills_research'): '🔬 研究 / 学术 Skills',
    ('ai_native','skills_general'):  '🧩 通用 Skill 集合 / Meta',
    ('ai_native','cli_bigtech'):     '🏢 大厂 / 模型 lab 出品 CLI',
    ('ai_native','cli_indie'):       '👤 独立开发者 CLI',
    ('ai_native','cli_vibecoding'):  '🚀 Vibecoding 驾驶舱 & ship',
    ('ai_native','cli_ui'):          '🎛️ Claude Code UI 增强',
    ('ai_native','infra_harness'):   '⚙️ Agent harness / framework',
    ('ai_native','infra_platform'):  '🏗️ LLM 应用平台',
    ('ai_native','infra_workspace'): '🖥️ 自托管 AI workspace',
    ('ai_native','infra_observability'): '📊 评估 / 可观测',
    ('ai_native','infra_mcp'):       '🔌 MCP / SDK',
    # ... 其它 macros 类推
}

M = {
    'full_name_lowercase': ('macro_key', 'sub_key'),
    # ...
}
```

## Sub-buckets 应从数据中浮现

**不要预先决定每个 macro 下有几个 sub-buckets**。先把所有项目铺开，再根据自然聚类切分。

例子（2026-06-16 run）：
- Skills macro 有 19 个项目时，自然分成 5 个 subs（创意/媒体 6 · 写作 3 · 工作流 6 · 研究 4 · 通用 7）
- 如果只有 5 个 Skills，那就 1-2 个 sub 即可
- 强行预设 "Skills 一定要有 7 个 sub" 会得到空桶或硬拆

## 检查清单

写完映射后，跑这段验证：

```python
import json
inv = json.load(open('merged.json'))
mapped, missing = [], []
for r in inv:
    key = r['full_name'].lower()
    (mapped if key in M else missing).append(r['full_name'])
print(f'Mapped: {len(mapped)}/{len(inv)}')
print(f'Missing: {missing}')
```

任何 `missing > 0` 都意味着分类未完成。

## 跨域项目的归属选择

某些项目同时属于多个 macro（如 `anthropics/defending-code-reference-harness` 既是 Skill 又是 Security 工具）。规则：

1. **选最具体的 macro**：Security 比 Skills 通用类更具体
2. **在 sub_label 里隐含归属**：`'🛡️ 防御 / 威胁建模'` 已经暗示这是 skill 形态的防御工具
3. **绝不重复归类**：一个 record 一个家，避免 UI 计数与 schema 冲突
