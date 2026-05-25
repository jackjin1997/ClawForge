---
name: eisenhower-matrix
description: Use when user reports overwhelm from too many tasks, asks for week/sprint/OKR planning help, or describes spending 'all day firefighting' while long-term projects stall. Triggers on Chinese phrases 太多事 / 不知道先做哪个 / 排不过来 / 周计划 / sprint planning / 救火 / 优先级 / overwhelm / 焦虑 / 做不完 / todo 列表炸了, and explicit task triage requests. Especially valuable when waiting list has 15+ pending items, or when user says "重要的事一直推不动 / 都在做紧急的事". Do NOT use for small lists (<5 items just sort by deadline), team-level responsibility assignment (use RAPID/DACI from backlog), or when importance needs quantitative weighting (use weighted decision matrix).
license: MIT
metadata:
  author: JackJin
  version: "1.0"
  category: 矩阵派
  framework_author: Dwight D. Eisenhower (引用); Stephen Covey 推广
  source: 1954 Northwestern speech; 《The 7 Habits》(1989)
  related: pareto, moscow
---

# Eisenhower Matrix · 紧急-重要 二维矩阵

> **一句话定位：** 大多数人被「紧急」拖死、「重要」饿死。先把每项任务标上紧急 × 重要的象限，再分别处理 — Do / Schedule / Delegate / Delete。

## 何时使用 (TRIGGER)
- 用户说「太多事情了不知道先做哪个」
- 周计划 / sprint 计划 / OKR 拆解时
- 一天 8 小时全在救火，长期项目一直推不动
- 待办列表 > 15 项

## 何时不要用 (ANTI-PATTERN)
- 任务很少（< 5 项），直接按 deadline 排
- 团队任务且涉及责任分配（用 RAPID/DACI）
- 任务质量不均（有些 1 小时有些 1 周），先用 Pareto 抓 20%
- 重要性需要量化打分（用 weighted decision matrix）

## 4 象限定义 (STEPS)

```
                 紧急                  不紧急
            ┌─────────────────┬─────────────────┐
            │  Q1: DO         │  Q2: SCHEDULE   │
   重要     │  立即做         │  规划进日程     │
            │  危机/deadline  │  战略/成长/预防 │
            ├─────────────────┼─────────────────┤
            │  Q3: DELEGATE   │  Q4: DELETE     │
  不重要    │  交付/协商      │  砍掉           │
            │  打断/某些会议  │  消遣/无效内卷  │
            └─────────────────┴─────────────────┘
```

### 操作步骤
1. **倒出来**：把脑子里所有任务/承诺/感觉「该做」的事，一行一项写下，至少 10 项
2. **逐项判断「重要」**：这件事推进我未来 6 个月的核心目标吗？(是 = 重要)
3. **逐项判断「紧急」**：错过本周是否产生不可挽回的成本？(是 = 紧急)
4. **填入象限**
5. **按象限策略处理**：
   - **Q1** 立即做，但要警惕 — Q1 不能成为生活的主旋律（说明 Q2 做得不够）
   - **Q2** 必须**进日历**（不只是 todo 列表）— 这是高产人和平庸人的最大区别
   - **Q3** 找人接手；找不到就讨论「为什么是我」
   - **Q4** 删掉 — 真正的勇气

## 决策 Checklist
- [ ] 我的 Q2 占总任务 ≥ 40%（如果不到，说明在用紧急代替重要）
- [ ] Q1 任务有具体 deadline 和明确完成标准
- [ ] Q2 任务**已经在日历上有时间块**（不只是列表）
- [ ] Q3 任务有具体的「交给谁 / 何时交」
- [ ] Q4 我至少敢删 1 项 — 删不掉就承认它其实在 Q2/Q3

## 真实案例

### 案例 1: Eisenhower 自己（1954 演讲）
> "I have two kinds of problems: the urgent and the important. The urgent are not important, and the important are never urgent."

作为美国总统 + 二战盟军最高指挥，他的工作哲学是 — 警惕「重要的事永远不紧急」这个陷阱，强制把重要的事**预先安排**进日程，否则它们永远输给突发邮件和电话。

### 案例 2: 工程师周计划
- Q1 (紧急+重要)：今晚要发版的 P0 bug 修复 / 周五客户演示前的功能联调
- Q2 (不紧急+重要)：写测试覆盖率提升 / 学 LangGraph / 重构那块技术债 / 健身
- Q3 (紧急+不重要)：HR 催的合规培训 / 跨部门同步会 / 临时 review 别组的 RFC
- Q4 (都不)：刷推、刷知乎、参加自己根本不关心的 launch 庆功

最容易出错的是：把 Q2 的「写测试」推到「下周再说」（永远在下周），然后 Q1 的 bug 越来越多。**bug 增量 = Q2 欠债的复利**。

### 案例 3: Covey 的「大石头比喻」
玻璃罐里要装大石头、小石头、沙、水。如果先放沙和水，大石头放不进；先放大石头，再倒沙和水，全装得下。**Q2 是大石头**，必须先占日历位置。

## 与其他框架的关系
- **MoSCoW 是 Eisenhower 的离散化版本**（Must / Should / Could / Won't 对应 Q1/Q2/Q3/Q4 的精神）
- **Pareto 帮你识别 Q2 里哪 20% 是杠杆点**
- **Hell Yeah or No 是 Q4 删除步骤的辅助** — 不是「Hell Yeah」的就是 Q4
- **与 ten-ten-ten 互补**：Eisenhower 解决「现在做什么」，10/10/10 解决「这值不值得做」

## 常见陷阱
1. **把所有事都标成 Q1**：心理上「都很急」，但物理上不可能 — 应对：强制每天 Q1 不超过 3 项
2. **Q2 没有上日历，只在 todo**：todo 容易被推迟，日历有强制力 — 应对：周日晚先排 Q2 时间块，再让 Q1/Q3 填空隙
3. **Q4 删不掉**：怕错过 / 怕得罪人 — 应对：先标记，2 周观察后真没事就删；委婉拒绝模板
4. **混淆"紧急"和"焦虑"**：你焦虑不代表它紧急 — 应对：问「错过今天会有什么具体后果？」

## 参考
- Eisenhower, 1954 Northwestern University Convocation speech
- Stephen R. Covey, 《The 7 Habits of Highly Effective People》Habit 3 "Put First Things First"
- 衍生：Covey 《First Things First》(1994)
