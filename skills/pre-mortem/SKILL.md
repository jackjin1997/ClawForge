---
name: pre-mortem
description: Use BEFORE committing to a plan, project, hire, launch, funding round, or any irreversible decision. Triggers on Chinese phrases 即将启动 / 上线前 / 发布前 / kick off / 拍板 / 决定要做 / 万事俱备 / 一切都准备好了, and English "before we launch", "ready to ship", "let's commit to". Especially when the team is in a "this is definitely going to work" high-confidence mode (the most dangerous moment), or when user has vague unease they can't articulate. Pre-mortem assumes the plan has already failed 12 months from now, then asks 'why?' — releases concerns silenced by group enthusiasm. Do NOT use after the decision is already irreversible (do post-mortem prep instead), on low-stakes reversible trials, or in teams with low psychological safety (will become political attack).
license: MIT
metadata:
  author: JackJin
  version: "1.0"
  category: 视角派
  framework_author: Gary Klein (cognitive psychologist)
  source: HBR "Performing a Project Premortem" (2007)
  related: wrap, inversion, second-order-thinking
---

# Pre-Mortem · 预先尸检

> **一句话定位：** 比起 post-mortem 事后复盘，pre-mortem 事前假装失败 — 用「这事已经失败了」的心理框架，**释放团队里被沉默压制的怀疑**。Klein 的研究显示能识别出原本 30% 漏掉的风险。

## 何时使用 (TRIGGER)
- 即将启动新项目 / 即将做不可逆决策（融资、招聘 senior、产品发布）
- 团队进入「这事肯定能成」的高士气期（最危险的时刻）
- 计划已经在领导面前过审，但你心里有疙瘩
- 重要 milestone 前夜（不是过早，应在「计划已成形但还没全押」时）

## 何时不要用 (ANTI-PATTERN)
- 决策低赌注、易回滚（直接试，不要走流程）
- 决策已经做出且不可逆（这时该 post-mortem 准备而非 pre-mortem）
- 团队信任度低（pre-mortem 在低信任团队会变成借机互相攻击）
- 时间窗口极紧（< 1 小时），改用 OODA Loop 做快速 risk check

## 操作步骤 (STEPS)

### 1. 设定时间机器场景（5 分钟）
召集团队，开场白固定为：
> "**假设现在是 12 个月后。我们启动的 X 项目已经彻底失败 — 不是部分失败，是灾难级失败。每个人花 3 分钟在纸上写下：失败的具体原因是什么。**"

关键设定：
- **过去时叙述**：用「失败了」而不是「可能会失败」
- **独立写**：先不讨论，避免群体思维
- **失败要具体**：不是「执行不力」，要是「Q2 流失率 35%，主要因为 onboarding 第 3 步用户看不懂」

### 2. 轮流朗读 + 分类（15 分钟）
- 每人轮流朗读自己的失败原因，**不允许打断辩论**
- 主持人在白板分类：**外部因素 / 团队执行 / 产品本身 / 市场假设 / 资源**

### 3. 评估每个原因（20 分钟）
对每条失败原因评估：
- **可能性** (1-5)
- **影响** (1-5)
- **可缓解性** (Y/N) — 我们能不能现在就做点什么减少风险？

### 4. 转化为行动项（15 分钟）
对「高可能性 × 高影响 × 可缓解」的原因，定义具体的：
- **预防措施**：现在就做什么减少发生概率
- **早期信号** (tripwire)：什么指标说明这个风险正在变现
- **应对预案**：发生时怎么办，谁负责

### 5. 写入决策档案
不要让 pre-mortem 产出消失。把识别的 top 5 风险 + 应对预案写进项目 README 或 ADR，定期回顾。

## 决策 Checklist
- [ ] 用了过去时（"失败了"）而非未来时（"可能失败"）的开场
- [ ] 每人**独立**写完才开始讨论（避免锚定）
- [ ] 每条失败原因都具体到「指标 + 原因」
- [ ] Top 5 风险有明确的 tripwire 指标
- [ ] 输出有人负责把它放进项目档案（不是会议结束就消失）

## 真实案例

### 案例 1: NASA 项目里的应用
NASA 早期不做 pre-mortem，挑战者号航天飞机失事后系统性引入「devil's advocate 制度」(本质 pre-mortem 的变种)。在后续任务前强制由一名工程师**专门负责扮演"这次会失败"的角色**，列出所有失败路径，团队必须逐条响应。

### 案例 2: Klein 自己的研究数据
Klein 在多个企业 R&D 项目里对比 pre-mortem 组 vs 无 pre-mortem 组：
- 项目启动后 30 天内识别风险数：pre-mortem 组多 **30%**
- 这些多识别的风险中，约 **60%** 是 pre-mortem 之前完全没想到的盲区
- 团队成员对项目的「自信偏差」显著下降，但**士气没有降低**（因为是「找问题以确保成功」的心理框架）

### 案例 3: 工程团队上线新支付系统
某团队 pre-mortem 输出的 top 风险：
- "12 个月后失败的原因：和银行 API 的对账文件格式我们假设固定，但银行换了系统改了格式，我们 3 周没发现"
- → 预防：每天对账 + 格式 hash 监控
- → tripwire：对账失败率 > 0.1% 立即告警
- 上线 4 个月后，银行果然改了格式 — tripwire 触发，2 小时内发现，避免成数百万异常交易

## 与其他框架的关系
- **WRAP 的 P 步骤本质就是 pre-mortem**
- **Inversion 是 pre-mortem 的更广义版本** — pre-mortem 是「假设失败」，inversion 是「反过来想任何问题」
- **post-mortem 是事后**，pre-mortem 是事前；两者都需要无指责文化
- **配合 second-order-thinking** 评估每个风险的连锁后果

## 常见陷阱
1. **变成形式主义**：开会 1 小时填表格然后归档遗忘 — 应对：风险必须落地为 tripwire + owner
2. **政治化**：用 pre-mortem 攻击别人的项目 — 应对：必须由项目 owner 自己主持
3. **太早做**：项目还没成形就 pre-mortem，全是无效抽象担忧 — 应对：在「方案已经具体到能画出关键路径」之后做
4. **太晚做**：已经签合同/招完人才做 — 应对：在不可逆点之前做

## 参考
- Gary Klein, "Performing a Project Premortem", *Harvard Business Review*, Sep 2007
- Daniel Kahneman, 《Thinking, Fast and Slow》(2011) 引用并背书
- Gary Klein, 《The Power of Intuition》(2003)
