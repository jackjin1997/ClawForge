---
name: cynefin
description: Use BEFORE selecting any other decision framework — Cynefin (kuh-NEV-in) classifies WHICH framework fits the current situation across 5 domains (Clear / Complicated / Complex / Chaotic / Confused). Triggers when user is about to apply a method and the fit feels off, asks meta-questions like "should we follow SOP or explore?", or when same approach that worked last time seems wrong now. Also use after failure when "the method was right but the situation didn't match", or when team argues over deterministic-plan-vs-experimentation. Especially valuable at the start of major decisions to avoid using the wrong hammer for the nail. Do NOT use for trivial classified decisions (don't run Cynefin for "what to eat for lunch"), true Chaotic situations needing immediate stabilizing action (act first, classify later), or teams unfamiliar with the model (use simpler known/unknown binary).
license: MIT
metadata:
  author: JackJin
  version: "1.0"
  category: 类型派
  framework_author: Dave Snowden
  source: IBM Research (1999); HBR "A Leader's Framework" (Snowden & Boone, 2007)
  related: ooda-loop, wrap, first-principles
---

# Cynefin Framework · 情境感知框架

> **一句话定位：** 在挑「用哪个决策框架」之前，先问「我在哪个情境」。同一个工具在不同情境里要么救命要么致命。

## 何时使用 (TRIGGER)
- 你已经准备用某个决策方法，但隐约觉得不对
- 团队里争论「该按 SOP 还是该探索」
- 复盘失败时发现「方法没错，用错地方了」
- 任何重大决策的**第一步**（meta-level，先分类再处理）

## 何时不要用 (ANTI-PATTERN)
- 决策极小且已分类（不要为决定「中午吃啥」启用 Cynefin）
- 处于真正的 Chaotic 象限，必须立刻行动 — 跳过分类，先稳住
- 团队对 Cynefin 不熟，用了反而沟通成本高 — 用简化版「已知 / 未知」二分

## 5 个域 (DOMAINS)

```
        ┌──────────────────────┬──────────────────────┐
        │     COMPLEX          │     COMPLICATED      │
        │ Probe → Sense → Resp │ Sense → Analyze → R  │
        │ 涌现的实践            │ 好的实践（专家）       │
        │ 因果只能事后看         │ 因果可分析            │
        │                      │                      │
        ├──────────────────────┼──────────────────────┤
        │     CHAOTIC          │     CLEAR (Obvious)  │
        │  Act → Sense → Resp  │ Sense → Categorize → │
        │ 新颖的实践            │   Best practice      │
        │ 无因果可分析          │ 标准 SOP              │
        └──────────────────────┴──────────────────────┘
                  ↑ CONFUSED (中心点) — 还没分类清楚的状态
```

### 1. Clear (Obvious) — 简单/明显域
- **特征**：因果关系明显，每个人都能看到
- **方法**：Sense → Categorize → Respond — 识别模式、归类、套用 best practice
- **例子**：用户报「无法登录」→ 查密码错误 → 重置密码
- **陷阱**：把所有事都当 Clear（其实是 Complex 但你没看出来），导致用 SOP 处理新型问题

### 2. Complicated — 繁杂域
- **特征**：因果关系存在但需要专业知识才能分析；可能有多个正确答案
- **方法**：Sense → Analyze → Respond — **请专家**做分析
- **例子**：数据库性能调优 / 设计一个高可用架构 / 法律合规
- **陷阱**：用了 Clear 的快速决策（拍脑袋），或越级到 Complex（无谓探索）

### 3. Complex — 复杂域
- **特征**：因果**只能事后**看清；系统对你的行动有反应；同样输入未必同样输出
- **方法**：Probe → Sense → Respond — **做小实验**，观察涌现的模式，放大有效的
- **例子**：产品市场契合 / 团队文化建设 / 新市场进入 / agent 行为调优
- **陷阱**：试图「设计完美方案再执行」（这是 Complicated 的方法，用错了），或频繁切换方向（没给涌现时间）

### 4. Chaotic — 混乱域
- **特征**：因果完全不存在或失效；当务之急是**稳住**
- **方法**：Act → Sense → Respond — **先行动**任何能减少混乱的事，再观察
- **例子**：生产事故 P0 / 公司财务崩盘 / 灾难现场
- **陷阱**：试图分析（来不及），或过早转入 Complex 探索

### 5. Confused (Disorder) — 失序域
- **特征**：你不知道自己在哪个象限
- **方法**：先**分解**问题，每个子问题各自归类，否则会用熟悉的框架硬套不熟悉的问题
- **陷阱**：默认归到自己最擅长的象限（工程师默认 Complicated，PM 默认 Complex，老板默认 Clear）

## 决策 Checklist
- [ ] 我说出了当前问题属于哪个域，并给出理由
- [ ] 我选择的工具/方法**匹配**那个域（不是「我最熟的方法」）
- [ ] 如果域是 Complex，我设计了实验而不是方案
- [ ] 如果域是 Chaotic，我已经在执行稳定性动作（不在开会讨论）
- [ ] 我承认了域**可能在我处理过程中变化**（Complex 解决一半可能变 Complicated）

## 真实案例

### 案例 1: 2008 金融危机 — 不同象限的混乱
- 当时大部分 CEO 用 Complicated 工具（请专家分析）处理 Chaotic 局面（市场失序），结果错过稳定窗口
- Snowden 在 HBR 文章里直接点名：领导者用 Best Practice 套 Complex 问题是当代决策最大失败模式

### 案例 2: 工程团队
- **登录失败 bug** → Clear（查日志套 SOP）
- **设计支付网关重构** → Complicated（请 senior + 多方案对比）
- **新产品 AI agent 是否被用户接受** → Complex（不能 paper design，必须灰度小规模试 + 看用户实际行为）
- **生产数据库被删库** → Chaotic（先停写入 + 启动备份恢复，不要先开会）

错配的代价：把 Complex 当 Complicated → 6 个月规划完美方案上线，用户不买账 — 因为系统对你「设计」有反应，规划阶段的假设已被现实证伪。

### 案例 3: COVID 早期应对
- 2020 年 1 月：症状不明 → Confused → 分解
- 2 月：医疗资源短缺、传播路径不清 → Chaotic → 强制隔离稳住（行动先于分析）
- 之后：疫苗研发 → Complicated（流程明确，需要专家）
- 之后：社会复苏 → Complex（无人知道结果，必须实验）

## 与其他框架的关系
- **Cynefin 是 meta-framework，决定其他框架的应用场景**：
  - Clear → SOP / checklist
  - Complicated → WRAP + 专家分析
  - Complex → OODA Loop + Pre-Mortem + 灰度实验
  - Chaotic → 直接 OODA Loop 快循环
- **First Principles 在 Complex/Chaotic 域里特别重要**（因为没有现成模式可套）
- **Pre-Mortem 在 Complicated 域里 ROI 最高**（因为可分析）

## 常见陷阱
1. **域分类只做一次**：决策途中域已变 — 应对：每个里程碑重新分类
2. **默认归 Clear**：用最熟悉的 SOP 应对所有新问题 — 应对：质疑「这是新型问题吗？」
3. **不敢说 Confused**：硬选一个域显得专业 — 应对：Confused 是有效状态，比错误归类更安全
4. **Complex 当 Complicated 处理**：花 3 个月做完美 PRD 才开发 — 应对：能否用 1 周原型测试核心假设

## 参考
- David J. Snowden & Mary E. Boone, "A Leader's Framework for Decision Making", *Harvard Business Review*, Nov 2007
- Cognitive Edge 官方资源: cynefin.io
- Snowden 的 Cynefin 在 2014/2021 多次更新，本文档基于 2021 版（Clear 替代原来的 Simple/Obvious）
