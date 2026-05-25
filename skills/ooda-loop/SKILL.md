---
name: ooda-loop
description: Use when decisions must happen under time pressure or in adversarial/changing conditions — production incidents (P0, on-call, live debugging, rollback choices), competitive moves, real-time negotiations, anything where the situation reacts to your action. Triggers on Chinese phrases 事故 / P0 / 故障 / 排障 / oncall / 救火 / 谈判 / 实时 / 紧急 / 来不及, and English signals "incident", "outage", "live", "real-time", "the other side just". Especially when information is arriving while you must respond, when 5-minute decision cycles beat 1-hour ones, or when you catch yourself wanting to "analyze more" while the situation degrades. Do NOT use for slow life decisions (use wrap), for problems where information is already complete (use eisenhower-matrix or weighted decision matrix), or for Cynefin Clear-domain SOPs.
license: MIT
metadata:
  author: JackJin
  version: "1.0"
  category: 流程派
  framework_author: John Boyd (USAF Colonel)
  source: 《Patterns of Conflict》讲座 (1976-95)
  related: cynefin, first-principles
---

# OODA Loop · 观察-定位-决断-行动循环

> **一句话定位：** 在对抗或动态环境中，**循环速度** 和 **Orient 质量** 决定胜负 — 不是谁更聪明，而是谁的循环更快、心智模型更准。

## 何时使用 (TRIGGER)
- 时间压力强（秒-分钟级），不允许慢决策
- 对手/市场/系统在主动反馈，你的决策会改变下一轮输入
- 生产事故/线上 P0 排障
- 竞品突袭、谈判桌反价、运动比赛
- 任何「信息一边到达，一边要响应」的场景

## 何时不要用 (ANTI-PATTERN)
- 高赌注、慢决策（婚姻、辞职、千万级投资）— 用 WRAP
- 信息已经齐全，只是在选 — 用 Eisenhower Matrix 或 weighted decision matrix
- Cynefin Clear 象限有 SOP — 直接执行 SOP，不要 OODA

## 4 步骤 (STEPS)

### O — Observe（观察）
收集原始信号 — 不解读，先看清。
- 当前事实是什么？指标、报错、对手动作、环境变化
- **关键**：不要只看你想看的（确认偏见在战场上致命）
- 工具：监控大盘、日志 tail、对手历史动作模式

### O — Orient（定位）⭐ 最重要的一步
把观察到的信号融入你的心智模型，理解「这意味着什么」。Boyd 认为这是整个循环的**胜负手**。包含 5 个滤镜：
1. **文化遗产** — 你所在团队/公司/行业的默认假设
2. **遗传** — 你的本能反应（恐惧/兴奋）
3. **既往经验** — 你以前见过类似模式吗？
4. **新信息** — 当前观察补充的内容
5. **分析与综合** — 拆解模型，重新组合

> Boyd 原话："Orientation isn't just a state you're in; it's a process. It's how you destroy and re-create reality."

如果 Orient 错了，OODA 越快越死得快。

### D — Decide（决断）
基于当前 Orient 做出选择 — 通常是个 **假设** 而非定论（"我猜回滚是对的"）。
- 不追求最优解，追求**足够好且可执行**
- 明确这是个假设，准备下一轮验证

### A — Act（行动）
最小可行动作 — 执行后立刻生成新的 Observe 信号，进入下一循环。
- 关键：行动是测试假设的工具，不是最终答案
- 把大动作拆成 5 分钟一动 vs 1 小时一动 — 前者循环 12 倍快

## 决策 Checklist
- [ ] 我能描述对手/系统的当前状态（不是我的假设）
- [ ] 我识别了至少 2 个心智模型滤镜（如「我可能在用旧经验套新情况」）
- [ ] 我的决定明确标记为「假设」而非「定论」
- [ ] 我下一步行动是「会立刻产生新信息」的动作，不是「等结果」
- [ ] 我下次 Observe 的时间窗口已定（X 分钟后我再看一次）

## 真实案例

### 案例 1: 朝鲜战争空战中的 F-86 vs MiG-15
F-86 在性能指标上略逊 MiG-15（爬升、加速、机动），但 10:1 击落比胜出。Boyd 分析原因：F-86 座舱视野好（O 快）+ 全液压操控 (A 快)，飞行员能在更短时间内完成一次「看-判-决-动」循环，把对手"卡"在上一个 Orient 里。**循环速度 > 单点性能**。

### 案例 2: 线上 P0 事故排障
错误做法：拿到告警 → 直接改配置回滚（跳过 Orient）→ 30 分钟后发现错的服务
- **O**：error rate 突增到 15%，集中在 us-east-1，user-service /login 接口
- **Orient**：刚才 10 分钟前 deploy 过 auth-service v2.3.1，有 user-service 依赖；但 us-east-1 同时也有 RDS failover 告警 — **两个嫌疑**
- **D**：假设是 deploy 引起的（先验概率更高 + 可回滚成本最低）
- **A**：5 分钟内只回滚 auth-service，**不动 RDS**，看 error 是否消失 → 立即拿到下一轮 O

### 案例 3: 商业竞争 — Slack vs HipChat 早期
Slack 每周发版，HipChat 每季度发版。同样的功能 Slack 4 周内迭代 4 次（用户反馈→改→再问），HipChat 一次过。**OODA 速度差** 直接转化为产品契合度差。

## 与其他框架的关系
- **WRAP 是慢循环（小时-天单元），OODA 是快循环（秒-分钟单元）** — 大脑里同时持有两种节奏
- **Orient 步骤的质量靠 first-principles 和 second-order-thinking 增强**
- **Cynefin 用来判断当前场景配不配 OODA**：Chaotic 象限必须 OODA，Clear 象限不用

## 常见陷阱
1. **跳过 Orient**：直接从 Observe → Decide，本质是用旧模型对新情况 — 应对：哪怕只用 30 秒，也说出「这意味着什么」
2. **追求循环速度而忽视质量**：快但持续做错决定 — 应对：每 3 个循环复盘一次模型对不对
3. **把 OODA 当口号不当工具**：仅在事故复盘时引用，平时不练 — 应对：日常 5 分钟 debug 也用一次

## 参考
- John Boyd, 《Patterns of Conflict》讲座笔记 (1976-95)
- Chet Richards, 《Certain to Win》(2004) — 商业语境的 OODA 应用
- Robert Coram, 《Boyd: The Fighter Pilot Who Changed the Art of War》(2002)
