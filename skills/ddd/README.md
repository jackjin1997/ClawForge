# DDD Skill - 领域驱动设计建模技能

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 概述

DDD Skill 是一个专门为 AI Agent 设计的领域驱动设计（Domain-Driven Design）建模技能。该技能提供完整的 DDD 方法论指导，帮助开发者和架构师进行领域建模、限界上下文划分和战术模式实现。

## 功能特性

### 战略设计（Strategic Design）
- 子域识别与分类（核心域、支撑域、通用域）
- 限界上下文划分
- 上下文映射模式
- 通用语言建立

### 战术设计（Tactical Design）
- 实体（Entity）设计
- 值对象（Value Object）设计
- 聚合（Aggregate）边界划分
- 领域服务（Domain Service）
- 领域事件（Domain Event）
- 仓储（Repository）模式
- 工厂（Factory）模式

### 架构模式
- 六边形架构（Hexagonal Architecture）
- 洋葱架构（Onion Architecture）
- CQRS（命令查询职责分离）
- 事件溯源（Event Sourcing）
- Saga 模式

## 安装

### 通过 OpenSkills 安装

```bash
npx openskills install kuangmi-bit/ddd-skill
```

### 通过 Git URL 安装

```bash
npx openskills install https://github.com/kuangmi-bit/ddd-skill.git
```

## 使用场景

当您需要：
- 分析复杂业务领域并进行领域建模
- 划分限界上下文和子域
- 设计聚合根、实体、值对象
- 实现领域服务和领域事件
- 进行微服务边界划分
- 应用 CQRS/事件溯源模式
- 设计六边形架构/洋葱架构

## 文件结构

```
ddd/
├── SKILL.md                    # 主技能文档
├── references/
│   ├── strategic-design.md     # 战略设计详解
│   ├── tactical-design.md      # 战术设计模式
│   └── patterns.md             # DDD架构模式
├── package.json
├── LICENSE
└── README.md
```

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 相关资源

- [Eric Evans - Domain-Driven Design](https://domainlanguage.com/)
- [Vaughn Vernon - Implementing Domain-Driven Design](https://vaughnvernon.co/)
- [事件风暴工作坊](https://www.eventstorming.com/)
- [Martin Fowler - DDD](https://martinfowler.com/tags/domain%20driven%20design.html)

## 贡献

欢迎提交 Issue 和 Pull Request！

## 作者

DeepArchi Team
