---
name: inversion
description: Use when user pursues an abstract goal where the path to success is unclear but the path to failure is concrete — '想做出好产品' / '想长寿' / '想升 staff' / '战略方向' / '怎么变得更好'. Triggers Munger's "invert, always invert" mental model: ask 'how do I GUARANTEE failure?' then avoid those. Also use when user is stuck brainstorming positive actions ('should I do X or Y'), facing analysis paralysis on abstract criteria, or when industry advice gives contradictory positive recommendations. Especially powerful for investment decisions, hiring criteria, product PRDs, strategic direction. Do NOT use for concrete quantifiable goals (use OKR), low-cost trial decisions (just try), or in teams already in self-blame mode (will be heard as criticism).
license: MIT
metadata:
  author: JackJin
  version: "1.0"
  category: 视角派
  framework_author: Charlie Munger (citing Carl Jacobi)
  source: 《Poor Charlie's Almanack》(2005); USC Law School speech (1986)
  related: pre-mortem, wrap, first-principles
---

# Inversion · 逆向思维

> **一句话定位：** 别问「怎么成功」，问「怎么保证失败」— 然后避免那些。失败路径往往比成功路径**更具体、更可枚举、更少争议**。

## 何时使用 (TRIGGER)
- 目标抽象（「想变得更好」「想做出好产品」「想长寿」）
- 通往成功的路径众说纷纭，每个人推荐都不一样
- 想清楚「该做什么」但脑子空白；想清楚「不该做什么」却很容易
- 在选择投资 / 战略方向 / 招人 / 写产品 PRD 时

## 何时不要用 (ANTI-PATTERN)
- 目标已经非常具体可量化（用 OKR / 目标拆解即可）
- 失败成本极低（直接试，比想象失败便宜）
- 时间紧（inversion 是探索工具，不是急救工具）— 用 OODA Loop
- 团队已经在自责，inversion 会被解读为「找问题挑刺」— 先做心理安全

## 操作步骤 (STEPS)

### 1. 先正向写出目标
明确你想达成的状态。例：
- "我想做一个用户喜爱的 AI 产品"
- "我想 5 年内攒到 100 万存款"
- "我想成为 staff engineer"

### 2. 反过来问：怎么保证彻底失败？
**强制脑暴所有把它做砸的方法**，不评判，越具体越好。例（AI 产品）：
- 没问任何真实用户就开始写代码
- 只用一种 LLM，供应商一挂全部宕机
- prompt 写死在代码里，每次改要发版
- 不留任何日志，用户报 bug 完全无法重现
- 复制竞品所有功能，没有任何差异化
- 推广靠 SEO 一条腿，不做社区
- 文档只在内部 wiki，外部用户搜不到

### 3. 把每条「失败方法」翻译成「该避免的具体行为」
通常长得像「不要 X」的禁令，但比正向 to-do 更可执行。

### 4. 在每条避免项里，挑出**前 20%**优先级
不是所有失败路径都同等致命。问：哪些一旦发生就**不可逆**（信任崩塌 / 资金链断 / 核心团队走光）。

### 5. 把禁令变成系统/流程
单凭意志力守禁令会失败。最好把禁令转成 process / monitoring / 物理约束：
- "不要 prompt 写死" → 用 prompt management 平台 + lint rule 禁止字符串字面量
- "不要单一 LLM" → 架构里强制 model abstraction + 多 provider fallback

## 决策 Checklist
- [ ] 我至少列出了 10 条「保证失败」的方法
- [ ] 每条都具体到可观察的行为或事件（不是「态度不好」这种）
- [ ] 我识别了 top 3 不可逆失败路径
- [ ] 我把至少一条禁令转化为流程/系统约束（不只是「记住别这么干」）
- [ ] 我和团队同步了这份「不要做」清单

## 真实案例

### 案例 1: Munger 谈幸福人生
> "如果想知道怎么过得悲惨，我可以告诉你 — 不可靠、嫉妒、怨恨、酗酒、不学习、看不起别人。这些保证你过得糟糕。"

Munger 拒绝回答「怎么幸福」（太多说法），但能给出怎么不幸的具体清单。他和巴菲特一辈子的投资哲学是：**别亏钱第一，赚钱第二**。Berkshire 持有的「禁令清单」（不投不懂的、不加杠杆、不卷入舆论漩涡）远比「策略清单」长。

### 案例 2: Google 早期搜索质量原则
"Don't be evil" — 一条禁令式公司价值观。比起「To be good」这种正向价值，禁令具体到可以做决定：广告标识不清楚 → evil；搜索结果被金钱影响 → evil。这让运营层有明确边界，而非依赖管理层每事审判。

### 案例 3: 工程师职业发展
正向问：「怎么晋升 staff？」 → 答案五花八门，且公司间不一致
逆向问：「怎么保证我永远卡在 senior？」 → 清单很统一：
- 只做被分配的 ticket，从不主动找 ambiguous 项目
- 从不写技术文档/分享/RFC
- 影响范围永远限于自己小组
- 不培养新人
- 拒绝跨组协作和 oncall

→ **避免这些**比追求虚构的「staff 标准」具体得多。

## 与其他框架的关系
- **Pre-Mortem 是 inversion 在项目层面的特化** — 失败的具体形态
- **Inversion + Second-Order Thinking 组合**：不只问失败方法，还问每个失败方法引发的连锁反应
- **First Principles 是「重建正向」**，**Inversion 是「枚举负向」** — 两者互补
- **WRAP 的 R 步骤** (Reality-test) 鼓励找反证，本质是 inversion 应用

## 常见陷阱
1. **变成抱怨**：「保证失败的方法 = 老板不靠谱、市场不行」— 应对：只列**自己能控制**的失败路径
2. **过度悲观**：天天想失败导致不行动 — 应对：inversion 后立刻转回正向：「避开这些后，最简单的下一步是什么」
3. **失败方法太抽象**：「执行不力」「沟通不畅」等 — 应对：必须能用录像/日志验证「发生了 / 没发生」
4. **只 inversion 一次**：项目演进过程中失败模式会变 — 应对：每个里程碑前 re-invert

## 参考
- Charlie Munger, 《Poor Charlie's Almanack》(2005)
- Carl Gustav Jacob Jacobi: "Man muss immer umkehren" (Always invert)
- Shane Parrish, Farnam Street: "Inversion and The Power of Avoiding Stupidity"
- Munger, 1986 USC Law School Commencement Speech ("How to Guarantee a Life of Misery")
