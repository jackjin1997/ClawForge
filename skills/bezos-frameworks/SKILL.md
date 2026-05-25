---
name: bezos-frameworks
description: Two complementary Bezos heuristics in one skill. (A) Two-Way Door — classify decisions by reversibility; reversible = decide fast with 70% info, irreversible = decide slow with 90% info. (B) Regret Minimization — for life-defining choices, project to age 80 and pick what minimizes regret. Use Two-Way Door triggers on Chinese 决策瘫痪 / 反复纠结小事 / 开了三次会还没定 / 大事小事一样慢; Regret Min triggers on 离职 / 创业 / 移民 / 结婚 / 生育 / 转行 / 重大决定 / 这辈子. Especially when team applies identical heavy process to all decisions (need Two-Way), or when user faces once-in-a-decade pivot where rational analysis ties (need Regret Min). Do NOT misclassify One-Way as Two-Way (most expensive mistake), use Regret Min for daily decisions (age-80 view on "what to eat" is meaningless), or run Regret Min in heated emotion (cool 24-48h first to avoid romanticizing risk).
license: MIT
metadata:
  author: JackJin
  version: "1.0"
  category: 类型派
  framework_author: Jeff Bezos
  source: Amazon 1997 / 2015 / 2016 Shareholder Letters
  related: cynefin, wrap, ten-ten-ten
---

# Bezos 双框架 · Two-Way Door + Regret Minimization

> **一句话定位：** 决策速度不该一刀切 — 可逆决策**快做**（输得起），不可逆决策**慢做**（输不起）。人生级决策再加一层：**80 岁视角**最小化遗憾。

---

## 框架 A: Two-Way Door · 决策可逆性分类

### 何时使用 (TRIGGER)
- 团队卡在「决策瘫痪」(decision paralysis) — 小事开 3 次会还没定
- 大型组织里所有决策都跑同一套审批流程，导致大事和小事一样慢
- 你自己对每件事都过度谨慎
- 创业 / 新项目初期速度比完美重要

### 何时不要用 (ANTI-PATTERN)
- 误把 One-Way Door 判定成 Two-Way（这是最贵的错）— 必须警惕

### 步骤
1. **问一个问题**：如果这个决策错了，**多快、多便宜地**能反悔？
   - 一周内 + 低成本 → **Two-Way Door**
   - 几个月 + 高成本 → **One-Way Door**
   - 不可逆（融了资、卖了公司、辞了职、说出口的话）→ **One-Way Door**

2. **Two-Way Door 决策**：
   - 由**最低能做决定的人**决定，**快决定**
   - 不需要全部信息（Bezos 建议 70% 信息就够）
   - 错了就改 — 反悔成本本身就是「实验费」
   - 例子：尝试新工具、调整 daily standup 时间、A/B 测试新文案、试用某 SDK

3. **One-Way Door 决策**：
   - 走完整流程：WRAP / Pre-Mortem / 多视角评审
   - 等到 90% 信息才决定也不晚
   - 必要时使用 Regret Minimization
   - 例子：收购公司、辞退 senior、关停核心产品线、签 5 年长期合同

### Checklist
- [ ] 我明确说出了这是 Two-Way 还是 One-Way
- [ ] 我能描述「反悔的具体方式 + 成本」
- [ ] Two-Way 决策没花 > 1 小时
- [ ] One-Way 决策走了至少 2 个独立框架（如 WRAP + Pre-Mortem）

---

## 框架 B: Regret Minimization · 遗憾最小化

### 何时使用 (TRIGGER)
- 人生级、十年级、转折点级决策（创业、移民、辞职、换行、结婚、生育）
- 选项之间**理性分析无法分胜负**（两边都讲得通）
- 决策有强烈"现在不做就来不及"信号
- One-Way Door 类决策

### 何时不要用 (ANTI-PATTERN)
- 日常决策（不要为决定「今晚加班」启用 80 岁视角）
- 决策是 Two-Way Door（反悔成本低，无需遗憾框架）
- 你处于强烈情绪中（先冷静 24-48 小时再做 Regret Min，否则会美化「冒险」）

### 步骤
1. **设定时间机器**：闭上眼睛，想象自己 80 岁。坐在摇椅上回顾人生。

2. **想象两个版本的人生**：
   - 版本 A：我**做了** X
   - 版本 B：我**没做** X

3. **问唯一一个问题**：
   > "**80 岁的我，更后悔哪个版本？**"

   - 不是问「哪个更成功」
   - 不是问「哪个更幸福」
   - 是问「哪个版本我会真正**后悔**没活过」

4. **更后悔不做 → 去做**。更后悔做了 → 不做。**模糊 → 通常意味着不是真正的人生决策，降级用 WRAP**

5. **不被结果绑架**：
   - Regret Min 不保证你「做了」一定成功
   - 它保证的是 — 哪怕失败，你也不后悔「没试」
   - 这是它和 Expected Value 计算的本质区别

### Checklist
- [ ] 我真的想象了 80 岁的我（不是 5 年后的我）
- [ ] 我问的是「后悔」而非「成功概率」
- [ ] 我承认了即使做了也可能失败，但失败本身不让我后悔
- [ ] 我冷静了至少 24 小时再做出最终决定
- [ ] 这是 One-Way Door 决策（如果是 Two-Way，别启用这么重的工具）

## 真实案例

### 案例 1: Bezos 离开 D.E. Shaw 创办 Amazon (1994)
30 岁的 Bezos 在 D.E. Shaw 已是 SVP，年薪百万。要不要辞职去做"在网上卖书"这种当时听起来很蠢的事。
- 直接老板劝他「再考虑 48 小时」
- 他启用 Regret Min：「80 岁的我会后悔什么？」
  - 后悔尝试了互联网创业失败？— 不会
  - 后悔从没尝试，留在金融圈拿钱？— **会**
- 走出门时已经决定。
> "I knew that when I was 80, I was not going to regret having tried this. ... But I knew the one thing I might regret is not ever having tried."

### 案例 2: Amazon 内部 — Prime / AWS 决策
- **Prime（2005）**：会员制免运费。当时财务部门反对（数学算不通）。Bezos 把它视为 **One-Way Door**（一旦给了承诺难以撤回），走严格分析；但启动后允许小范围 Two-Way Door 调整（运费阈值、品类）。
- **AWS（2003-06）**：从内部基础设施切分出来卖。**One-Way Door**（一旦对外卖就不能停），走数年深度论证。

### 案例 3: 工程师场景
- **Two-Way Door 示例**：选用某 npm 包（不喜欢就换）/ 调整 sprint 长度 / 试 Linear vs Jira (一周后能切回) — **不要开会 1 小时讨论，直接试**
- **One-Way Door 示例**：迁移整个数据库 schema（迁移完旧表删了）/ 公开发布破坏性 API 变更 / 招聘第 1 个 staff engineer — **必须深度论证**

## 与其他框架的关系
- **Cynefin + Bezos 组合最强**：先 Cynefin 分类问题域，再 Bezos 分类决策可逆性
- **One-Way Door 决策必须配 WRAP 全流程**
- **Regret Min 是 10/10/10 的极端版**（80 年 vs 10 年时窗）
- **Two-Way Door 实践 = OODA Loop 思维**（行动产生信号，错了快改）

## 常见陷阱
1. **One-Way 误判为 Two-Way**：以为可以反悔，实际损失已发生（比如「先 layoff 10 人，不行再招回来」— 错，士气和声誉损失不可逆）
2. **Two-Way 误判为 One-Way**：把每个小决定都当大事，组织变成蜗牛
3. **Regret Min 被用于日常决策**：80 岁视角看「今天点啥外卖」毫无意义
4. **Regret Min 后立刻做**：未冷静就行动，事后发现是逃避现在而非追求长远
5. **滥用「不后悔尝试」合理化鲁莽**：真正的 Regret Min 是「失败我也不后悔」，不是「肯定能成」— 必须诚实面对失败可能

## 参考
- Jeff Bezos, Amazon 1997 Shareholder Letter (Regret Minimization Framework 原始出处)
- Jeff Bezos, Amazon 2015 & 2016 Shareholder Letters (Two-Way / One-Way Door 概念)
- Bezos in conversation with Mathias Döpfner, Axel Springer Award (2018)
