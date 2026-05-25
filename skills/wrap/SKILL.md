---
name: wrap
description: Use when user faces a binary or two-way decision they've been agonizing over — career changes, hiring, tech stack choices, product bets, life pivots, or any high-stakes call where short-term emotion likely clouds judgment. Triggers on Chinese phrases 要不要 / 该选 X 还是 Y / 纠结 / 拿不准 / 想了好几天 / 在 X 和 Y 之间. Also trigger proactively when user describes a decision accompanied by strong feelings (excitement, dread, urgency, FOMO), confirmation-bias signals ("我心里其实有答案了"), or when they've explicitly compared only 2 options. Do NOT use for time-critical decisions (use ooda-loop), reversible low-cost trial decisions (just try), or Cynefin Clear-domain SOPs.
license: MIT
metadata:
  author: JackJin
  version: "1.0"
  category: 流程派
  framework_author: Chip & Dan Heath
  source: 《Decisive》(2013)
  related: pre-mortem, inversion, ten-ten-ten, cynefin
---

# WRAP 决策流程 · Widen · Reality-test · Attain distance · Prepare to be wrong

> **一句话定位：** 用 4 步骤系统性绕过人类决策的 4 个先天 bug — 框架太窄、确认偏见、短期情绪、过度自信。

## 何时使用 (TRIGGER)
- 用户在两个选项里反复纠结（"要不要离职"、"用 React 还是 Vue"）
- 决策带有强烈情绪（兴奋、焦虑、急迫）
- 用户已经"心里有答案"但还在找理由说服自己（确认偏见信号）
- 时间还允许（至少几小时到几天），不是消防式急救

## 何时不要用 (ANTI-PATTERN)
- 决策可逆且成本极低（直接试，不要走流程）
- 真正的时间临界（电梯门关之前必须按），用 OODA Loop
- 决策属于 Cynefin 的 Clear/Obvious 象限（有最佳实践就用）
- 选项已经被外部约束锁死（合规/资源没得选）

## 4 步骤 (STEPS)

### W — Widen Your Options（拓宽选项）
人类倾向于把选择简化为「Yes/No」或「A/B」。先强制扩展：
1. 问自己「**消失选项测试**」：如果当前所有选项都消失，我会怎么办？
2. 找一个「**机会成本**」选项：用同样的时间/钱/精力能做什么别的？
3. 找一个「**AND 而非 OR**」的方案：能不能同时做？分阶段做？
4. 找做过类似决策的人，看他们的选项菜单（**外部视角**）

### R — Reality-Test Your Assumptions（验证假设）
直觉给的答案往往基于未验证的假设。用证据攻击假设：
1. **故意找反驳证据**（与确认偏见对抗）：列出 3 个会推翻当前倾向的事实
2. **缩小实验**：能不能用 1 周/1 个月的小规模试探代替全押？(Heath: "ooch" 试探性小步)
3. **从远处看**：相同行业/相同处境的人怎么做的？基础率（base rate）是多少？

### A — Attain Distance Before Deciding（拉开距离）
短期情绪会高估眼前压力、低估长期影响。用工具拉距离：
1. 应用 10/10/10 Rule：10 分钟后 / 10 个月后 / 10 年后我会怎么看这个决策？
2. 问「**如果是我最好的朋友面临同样情况，我会建议他怎么做？**」
3. 识别「**核心优先级**」：未来 5 年我最看重的 3 件事是什么，这个决策服务于它们吗？

### P — Prepare to Be Wrong（准备犯错）
未来比你想的更不确定。预案不是悲观，是负责：
1. 做 Pre-Mortem：假设 6 个月后这个决策失败了，最可能的原因是什么？
2. 设定「**触发警报**」(tripwire)：什么指标/事件出现时，我应该重新评估？
3. 想好「**逃生路径**」：如果错了，最快的退出方式和损失上限是什么？

## 决策 Checklist
- [ ] 我列出了至少 3 个选项（不是 2 个）
- [ ] 我主动找到了 ≥ 2 条与当前倾向相反的证据
- [ ] 我应用了至少一种拉开距离的方法
- [ ] 我设定了具体的 tripwire 触发警报
- [ ] 我能在 1 分钟内说出失败时的最大损失

## 真实案例

### 案例 1: 是否接受新工作 offer
- **W**：除了「接 / 不接」，还有「谈薪资」「申请延迟 2 周入职先 trial」「同时和现公司谈反 offer」「先做 1 个月顾问试合作」 — 突然从 2 选项变成 5 选项
- **R**：和该公司 3 年内离职的 2 个前员工聊
- **A**：10 年后回看，我希望成为什么样的人，这份工作把我推向那里还是推开？
- **P**：tripwire = 入职 90 天内若 manager 换人或核心产品方向变更，立即重新评估

### 案例 2: Intel 1985 放弃存储芯片业务
Grove & Moore 在巨亏中纠结要不要砍掉 DRAM 业务。Grove 用了拉开距离技巧 — 问 Moore："如果董事会换掉我们俩，新 CEO 上任第一件事会做什么？" Moore 答："砍掉 DRAM。" Grove："那我们为什么不自己砍？" — 一个经典 **A (Attain Distance)** 应用，结果造就 Intel 转型 CPU。

## 与其他框架的关系
- **WRAP 包含 pre-mortem** 作为 P 步骤的子技术
- **WRAP 包含 ten-ten-ten** 作为 A 步骤的子技术
- **WRAP 与 ooda-loop 互补**：WRAP 适合慢决策（小时-天），OODA 适合快决策（秒-分钟）
- **决策前用 cynefin 分类**：Complex/Complicated 象限才值得跑 WRAP

## 常见陷阱
1. **走过场**：4 步骤变成自我安慰的形式，实际还是按直觉决定 — 应对：把每一步的产出写下来，不允许「想了一下」
2. **只做 W 不做 P**：拓宽完选项就以为做完了，没有为犯错准备 — 应对：tripwire 是硬要求
3. **拉开距离时找的「朋友」是回音壁**：建议被偏好筛选 — 应对：找一个会反对你的人，不是支持你的人

## 参考
- Chip Heath & Dan Heath, 《Decisive》Crown Business 2013
- HBR 摘要："The Process of Better Decision Making" 2013-03
