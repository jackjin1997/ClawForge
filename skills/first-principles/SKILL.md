---
name: first-principles
description: Use when user is stuck by industry conventions ("大家都这么做"), faces a new problem with no precedent, or finds current solutions arbitrarily expensive (intuition says "it shouldn't cost this much"). Triggers on Chinese phrases 行业惯例 / 大家都这么做 / 为什么不能 / 这么贵不合理 / 颠覆性 / 从零开始, and English signals "everyone does it this way", "why is it so expensive", "let's think from scratch". Decompose to irreducible physical/logical truths then rebuild — bypasses analogy thinking. Musk's secret. Do NOT use for problems with proven best practice (Cynefin Clear domain — use SOP), time-critical decisions (first principles takes hours-days), high-emotion contexts (cool down first), or in low-psychological-safety teams (will create conflict with authority).
license: MIT
metadata:
  author: JackJin
  version: "1.0"
  category: 视角派
  framework_author: Aristotle (origin); Elon Musk (modern)
  source: Aristotle Posterior Analytics; Musk 2013 TED
  related: inversion, second-order-thinking, cynefin
---

# First Principles · 第一性原理

> **一句话定位：** 把问题拆到无法再拆的物理/逻辑事实，从那里重新推导 — 跳出「类比思维」的束缚。Musk 用它把火箭成本降了 90%。

## 何时使用 (TRIGGER)
- 被「行业惯例」「大家都这么做」束缚
- 新行业 / 新问题，没有可类比的先例
- 现有方案成本高得不合理（直觉「不应该这么贵」）
- 想做颠覆性创新而非渐进式优化
- 用户说「为什么不能 X？」— 信号他在挑战默认假设

## 何时不要用 (ANTI-PATTERN)
- 问题已有完美 best practice（Cynefin Clear 域）— 用 SOP 不要重新推
- 时间紧 — 第一性原理需要深度推导（小时-天级别）
- 高情感卷入 — 先冷静再用，否则会用「物理」合理化偏好
- 团队不愿挑战权威 — 第一性原理会引发文化冲突，需先建心理安全

## 操作步骤 (STEPS)

### 1. 写下当前结论 / 当前做法
明确陈述「现状是什么」。例：「火箭一枚 6500 万美元」

### 2. 列每个支撑结论的隐含假设
强迫显式化。例：「火箭贵是因为：a) 材料贵 b) 工艺贵 c) 一次性使用 d) 供应链有限」

### 3. 对每个假设问：这是「物理/逻辑事实」还是「行业类比」？
- **物理事实**：化学反应、物理定律、人体生理、数学不等式
- **行业类比**：因为大家都这么做、因为传统、因为合规历史
- 黄金问题：「这个假设在 100 年前 / 在另一个文明里 / 在外星智慧眼里 还成立吗？」

### 4. 把所有非物理事实剥离，只剩物理基本面
得到「物理上可能的方案空间」— 通常比当前现状大得多

### 5. 从基本面重新构建解决方案
不要回头看现状，从零设计

### 6. 对比物理基本面方案 vs 类比方案
- 差距 = 类比惯性带来的成本 = 第一性原理的回报

## 决策 Checklist
- [ ] 我列出了至少 5 个隐含假设
- [ ] 我对每个假设标注了「物理 / 类比」
- [ ] 我承认了至少 2 个假设是「类比而非物理」
- [ ] 我从物理基本面重新设计了方案（不是优化现状）
- [ ] 我能解释「物理允许但行业没做」的具体原因（监管/资本/认知/路径依赖）

## 真实案例

### 案例 1: SpaceX 火箭成本拆解（2002）
- **现状**：俄罗斯火箭一枚 6500 万美元
- **隐含假设**：a) 钛铝铜铁等材料贵 b) 制造工艺贵 c) 一次性使用是物理决定的
- **物理事实**：拆到原料 — 铝、钢、铜、铂金、燃料。原料成本 < 200 万美元（火箭总成本 < 2%）
- **结论**：6300 万的差异是「行业利润链 + 一次性使用」造成的，不是物理决定
- **重建**：自造 + 可重复使用。Falcon 9 单次发射 6200 万 → 复用后边际成本 < 1000 万

### 案例 2: Tesla 电池组成本（2008-2018）
- **现状**：业内 600 美元/kWh
- **物理拆解**：锂 + 钴 + 镍 + 铝 + 加工 = 80 美元/kWh（实际原料 + 加工成本）
- **差距来源**：规模不足 + 行业利润 + 上下游零散
- **重建**：Gigafactory 集中超大规模 + 垂直整合。2024 年降到 100 美元/kWh 量级

### 案例 3: 工程师的本地化测试
- **现状**：「不能本地跑这个集成测试，公司流程要 CI」
- **隐含假设拆解**：CI 提供了什么？— a) 数据库 b) 网络 c) 凭证 d) 报告 e) 评审
- **物理事实**：a-d 都可以在本地复现（docker 数据库 / 本地 mock 网络 / .env 凭证文件 / 本地 HTML 报告）；只有 e 评审需要 CI
- **重建**：本地一键脚本搭起 a-d，5 分钟跑完测试；最后推 PR 给 CI 跑 e
- **效果**：开发-测试循环从 30 分钟降到 5 分钟

## 与其他框架的关系
- **Inversion 是「枚举负向」，First Principles 是「重建正向」** — 思维互补
- **Cynefin Complex/Chaotic 域里第一性原理特别重要**（因为没有现成模式可套）
- **Second-Order Thinking 评估第一性原理方案的长期可行性**

## 常见陷阱
1. **把「我不熟」误当「物理不可能」**：你不懂的事不代表不可能 — 应对：先问领域专家「这是物理限制吗？」
2. **拆到分子原子层级**（过度）— 应对：拆到「能采购 / 能合成 / 能验证」这一层就够
3. **重建时偷偷又用类比**（自我欺骗）— 应对：让一个外人 review 你的「物理基本面」
4. **忽略社会基本面**：法律、合规、信任、网络效应也是「基本面」，不只物理 — 应对：把社会基本面也作为「不可拆约束」

## 参考
- Aristotle, *Posterior Analytics* (古希腊原典)
- Elon Musk, 2013 TED interview ("First Principles Thinking")
- Tim Urban, Wait But Why: "The Cook and the Chef: Musk's Secret Sauce" (2015)
- Ozan Varol, 《Think Like a Rocket Scientist》(2020)
