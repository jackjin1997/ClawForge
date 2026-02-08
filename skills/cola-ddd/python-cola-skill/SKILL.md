---
name: python-cola-skill
description: Python COLA 架构指南 - 将阿里巴巴 COLA 整洁分层架构适配到 Python/Flask/FastAPI 项目。用于 Python 后端的 DDD 分层架构设计、代码结构规范、应用架构重构。触发条件：Python DDD、Flask 架构、FastAPI 架构、Python 分层架构、整洁架构、六边形架构、洋葱圈架构、COLA、代码分层、模块划分、Gateway 模式、Repository 模式、CQRS、架构重构、职责分离。创建 Python 文件时自动应用 COLA 目录结构和命名规范。
---

# Python COLA 架构

COLA = Clean Object-Oriented and Layered Architecture（整洁面向对象分层架构）

## 分层架构

```
Adapter → Application → Domain ← Infrastructure
                    ↘      ↙
                     Client
```

| 层 | 职责 | Python 实现 |
|---|------|------------|
| **Adapter** | 接收外部请求 | Flask Blueprint / FastAPI Router |
| **Application** | 用例编排 | Service, CmdExe, QryExe |
| **Domain** | 核心业务逻辑 | Entity, ValueObject, Gateway 接口 |
| **Infrastructure** | 技术实现 | Gateway 实现, SQLAlchemy |
| **Client** | DTO 定义 | Command, Query, CO |

## 目录结构

```
project/
├── adapter/routes/           # Flask Blueprint
├── application/
│   ├── command/              # *_cmd_exe.py
│   ├── query/                # *_qry_exe.py
│   └── service/              # *_service.py
├── client/
│   ├── api/                  # *_service_i.py (Protocol)
│   └── dto/
│       ├── command/          # *_cmd.py
│       ├── query/            # *_qry.py
│       └── co/               # *_co.py
├── domain/
│   ├── {aggregate}/          # entity.py, value_object.py
│   └── gateway/              # *_gateway.py (ABC)
├── infrastructure/
│   ├── gateway_impl/         # *_gateway_impl.py
│   ├── convertor/            # *_convertor.py
│   └── repository/           # models.py
└── app.py
```

## 命名规范

| 类型 | 后缀 | 位置 |
|------|------|------|
| 命令 | `_cmd` | client/dto/command |
| 查询 | `_qry` | client/dto/query |
| 命令执行器 | `_cmd_exe` | application/command |
| 查询执行器 | `_qry_exe` | application/query |
| 客户端对象 | `_co` | client/dto/co |
| 服务接口 | `_service_i` | client/api |
| 服务实现 | `_service` | application/service |
| 网关接口 | `_gateway` | domain/gateway |
| 网关实现 | `_gateway_impl` | infrastructure/gateway_impl |
| 转换器 | `_convertor` | infrastructure/convertor |

## 核心原则

1. **Domain 层不依赖任何层**（纯 Python，无框架依赖）
2. **Infrastructure 实现 Domain 定义的 Gateway 接口**
3. **Client 层被所有层依赖（DTO 定义）**

## 代码模板

详细代码示例请参考：
- **Response 和 DTO**: [references/dto.md](references/dto.md)
- **Service 和执行器**: [references/service.md](references/service.md)
- **Gateway 模式**: [references/gateway.md](references/gateway.md)
- **完整示例**: [references/example.md](references/example.md)

## 重构检查清单

1. 创建 adapter/application/client/domain/infrastructure 包
2. 定义 Response、Command、Query、CO 类
3. 创建 CmdExe/QryExe 执行器和 Service
4. 定义 Gateway 接口（ABC）和实现
5. 创建 Convertor 转换器
6. 迁移路由到 adapter/routes

## Python vs Java 对照

| Java | Python |
|------|--------|
| `interface` | `Protocol` 或 `ABC` |
| `@Autowired` | 构造函数注入 |
| `@CatchAndLog` | `@catch_and_log` 装饰器 |
| `@Data` | `@dataclass` |
| `@RestController` | Flask Blueprint |
