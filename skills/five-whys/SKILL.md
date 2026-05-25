---
name: five-whys
description: Use for incident/bug root-cause analysis, postmortem, recurring-problem diagnosis, or process improvement. Triggers on Chinese phrases 复盘 / 根因 / postmortem / 又坏了 / 老是 / 重复出现 / 这不是第一次 / 为啥总是 / RCA, and English signals "this keeps happening", "RCA", "post-mortem", "incident review". Ask "why?" 3-7 times (5 is average not rule) until hit a process/system/design root that can be changed — not the symptom. Do NOT use for one-off random events (could be noise — observe first), Cynefin Complex-domain problems (5 Whys assumes linear causality, complex systems have multi-cause emergence), teams in blame-mode (Why will become 因为 X 不靠谱 chain), or truly unknowable causes (ML model outputs — use statistics not 5 Whys).
license: MIT
metadata:
  author: JackJin
  version: "1.0"
  category: 反思/复盘类
  framework_author: Sakichi Toyoda / 大野耐一
  source: 《丰田生产方式》(1978)
  related: pre-mortem, ooda-loop, second-order-thinking
---

# 5 Whys · 五个为什么

> **一句话定位：** 对一个问题连问「为什么」3-7 次（不是严格 5 次），从症状挖到可改的流程/系统/设计 — 不要在症状层面修补。

## 何时使用 (TRIGGER)
- 事故 / bug 复盘（postmortem）
- 同类问题重复出现（不是首次偶发）
- 表层修复显然不够（每次都「下不为例」但又复发）
- 流程问题诊断
- 用户报告「为什么我们老是 X？」— 信号需要根因分析

## 何时不要用 (ANTI-PATTERN)
- 单次偶发、无规律可循 — 可能是噪声，先观察
- 复杂系统问题（Cynefin Complex 域）— 5 Whys 假设线性因果，复杂系统是多因 + 涌现
- 团队氛围是「找罪人」— 5 Whys 容易变成「Why X 没做好 → 因为 Y 不靠谱」的责备链
- 真正的 unknowable（如 ML 模型某次输出为啥这样）— 用统计方法不是 5 Whys

## 操作步骤 (STEPS)

### 1. 准确陈述问题
必须含：**指标 + 时间 + 范围**。不要笼统说「登录有问题」，要说「2026-05-25 14:00-15:00 us-east-1 登录失败率 32%」

### 2. 问 Why #1，得到答案 A1
**A1 必须是事实而非评价**。错：「因为团队不仔细」对：「auth-service 14:05 deploy 引入了 null 检查 bug」

### 3. 把 A1 当作问题，问 Why #2
对 A1 再问「为什么 A1 发生？」得到 A2

### 4. 重复直到到达「可改流程 / 可改系统 / 可改设计」的根因
通常 3-7 层。**5 是平均值不是规则**。判断终止：根因属于「下次能从流程层面预防」而非「这次具体哪个人疏忽」

### 5. 验证因果链
从根因正向推演能不能解释最初问题。不能 → 链条断了，需要重做

### 6. 提出针对根因的行动
不是针对症状的临时补丁。「加 lint rule」「改 oncall 流程」「重设计权限模型」— 都是流程/系统级行动

## 决策 Checklist
- [ ] 问题陈述含指标 + 时间 + 范围
- [ ] 每个 Why 的答案是事实而非评价
- [ ] 答案里没有人名（Why 后面跟机制，不跟人）
- [ ] 根因属于「下次能从流程层面预防」的层级（不是「下次注意点」）
- [ ] 从根因能正向推演回最初问题（双向验证）
- [ ] 行动针对根因，不是症状

## 真实案例

### 案例 1: 丰田经典（大野耐一原始示例）
- **问题**：机器停了
- Why #1：保险丝烧了 → Why?
- Why #2：轴承没润滑 → Why?
- Why #3：油泵不工作 → Why?
- Why #4：泵轴磨损 → Why?
- Why #5：没装过滤器（金属屑进入轴）→ **根因**
- **行动**：加过滤器 + 定期检查（流程级）
- 如果只问 1 层（保险丝烧了）→ 解决方案是「换保险丝」→ 一周后还会再坏

### 案例 2: 工程师 — 登录失败 5 Whys
- **问题**：14:00-15:00 us-east-1 登录失败率 32%
- Why #1：服务器 500 → 因为 DB 连接池满
- Why #2：连接池为什么满？→ 因为某 batch job 持有长事务 12 分钟
- Why #3：为什么 batch job 没释放？→ 因为没设 timeout
- Why #4：为什么没 timeout？→ 因为 code review 漏了
- Why #5：为什么 review 会漏？→ 因为没有 lint rule 强制 SQL transaction timeout
- **根因**：缺少 lint rule（流程级）
- **行动**：加 lint rule 强制所有 transaction 必须有 timeout（系统级预防）

### 案例 3: 产品 — 新功能 DAU 只有 1%
- **问题**：上线一周新功能 DAU 仅 1%
- Why #1：用户找不到入口
- Why #2：为什么找不到？→ 入口埋在三级菜单
- Why #3：为什么三级菜单？→ PRD 没要求一级露出
- Why #4：为什么 PM 不要求？→ 担心一级菜单太拥挤
- Why #5：为什么没空间预算？→ 没有「一级菜单空间分配」的 RFC 流程
- **根因**：缺一级菜单空间分配的决策流程
- **行动**：制定一级菜单 RFC 流程（流程级）+ 本次功能补救上浮一级

## 与其他框架的关系
- **Pre-Mortem 是事前 5 Whys**：「如果失败了，可能因为为什么的为什么...」
- **配合 OODA Loop 的 Orient 步骤**：5 Whys 是 Orient 质量的工具
- **Second-Order Thinking 是「向未来追」，5 Whys 是「向过去追」** — 时间方向互补

## 常见陷阱
1. **数到 5 就停**（5 是平均值不是终点）— 应对：判断标准是「到了流程/系统/设计层」而非「问了 5 次」
2. **找罪人**（Why 后面跟人名）— 应对：硬性规定 Why 后面必须是事件/机制
3. **没验证因果链**（root cause 推不回原 symptom）— 应对：必须双向因果链能解释
4. **一棵树主义**（只走一条 why 链，忽视并行多因）— 应对：必要时画鱼骨图（Ishikawa），有多个分支
5. **过早跳到方案**（问 1-2 次就动手）— 应对：强制走完 3-5 层再讨论行动

## 参考
- 大野耐一, 《丰田生产方式》(1978)
- Eric Ries, 《The Lean Startup》(2011) — 推广到软件创业
- Toyota Production System: "ask 'why?' five times about every matter"
- 衍生：鱼骨图（Ishikawa Diagram）= 多分支 5 Whys
