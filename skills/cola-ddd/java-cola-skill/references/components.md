# COLA 组件详解

## 组件总览

| 组件 | Maven ArtifactId | 功能 |
|------|------------------|------|
| DTO 组件 | `cola-component-dto` | Response、Command、Query、PageResponse |
| Exception 组件 | `cola-component-exception` | BizException、SysException、ErrorCode |
| CatchLog 组件 | `cola-component-catchlog-starter` | @CatchAndLog 异常捕获和日志 |
| Extension 组件 | `cola-component-extension-starter` | 扩展点机制 |
| StateMachine 组件 | `cola-component-statemachine` | 状态机 |
| Domain 组件 | `cola-component-domain-starter` | Spring 托管领域实体 |
| RuleEngine 组件 | `cola-component-ruleengine` | 规则引擎 |
| Test 组件 | `cola-component-test-container` | 测试容器 |

---

## 1. DTO 组件

```xml
<dependency>
    <groupId>com.alibaba.cola</groupId>
    <artifactId>cola-component-dto</artifactId>
</dependency>
```

### Response 类型

```java
// 基础响应
Response.buildSuccess();
Response.buildFailure("ERROR_CODE", "错误信息");

// 单对象响应
SingleResponse<UserCO> response = SingleResponse.of(userCO);

// 多对象响应
MultiResponse<UserCO> response = MultiResponse.of(userList);

// 分页响应
PageResponse<UserCO> response = PageResponse.of(userList, totalCount, pageSize, pageIndex);
```

### Command 和 Query

```java
// 写操作 - 继承 Command
public class UserAddCmd extends Command {
    private UserCO userCO;
}

// 读操作 - 继承 Query
public class UserListQry extends Query {
    private String keyword;
}

// 分页查询 - 继承 PageQuery
public class UserPageQry extends PageQuery {
    private String status;
}
```

---

## 2. Exception 组件

```xml
<dependency>
    <groupId>com.alibaba.cola</groupId>
    <artifactId>cola-component-exception</artifactId>
</dependency>
```

### 异常类型

```java
// 业务异常 - 用户可理解的错误
throw new BizException("USER_NOT_FOUND", "用户不存在");

// 系统异常 - 技术错误
throw new SysException("DB_ERROR", "数据库连接失败");
```

### 错误码接口

```java
public enum ErrorCode implements ErrorCodeI {
    USER_NOT_FOUND("USER_NOT_FOUND", "用户不存在"),
    EMAIL_EXISTS("EMAIL_EXISTS", "邮箱已存在"),
    PARAM_ERROR("PARAM_ERROR", "参数错误");
    
    private String errCode;
    private String errDesc;
    
    @Override
    public String getErrCode() { return errCode; }
    
    @Override
    public String getErrDesc() { return errDesc; }
}

// 使用
throw new BizException(ErrorCode.USER_NOT_FOUND);
```

---

## 3. CatchLog 组件

```xml
<dependency>
    <groupId>com.alibaba.cola</groupId>
    <artifactId>cola-component-catchlog-starter</artifactId>
</dependency>
```

### @CatchAndLog 注解

```java
@Service
@CatchAndLog  // 自动捕获异常并记录日志
public class UserServiceImpl implements UserServiceI {
    
    @Override
    public Response addUser(UserAddCmd cmd) {
        // BizException → Response.buildFailure()
        // 其他异常 → 记录日志 + 系统错误响应
        return userAddCmdExe.execute(cmd);
    }
}
```

---

## 4. Extension 扩展点组件

```xml
<dependency>
    <groupId>com.alibaba.cola</groupId>
    <artifactId>cola-component-extension-starter</artifactId>
</dependency>
```

### 定义扩展点

```java
// 扩展点接口
public interface OrderExtPt extends ExtensionPointI {
    void beforeCreate(Order order);
    void afterCreate(Order order);
    BigDecimal calculateDiscount(Order order);
}
```

### 实现扩展点

```java
// 普通订单扩展
@Extension(bizId = "normalOrder")
public class NormalOrderExt implements OrderExtPt {
    @Override
    public void beforeCreate(Order order) {
        // 普通订单逻辑
    }
    
    @Override
    public BigDecimal calculateDiscount(Order order) {
        return BigDecimal.ZERO;
    }
}

// VIP 订单扩展
@Extension(bizId = "vipOrder")
public class VipOrderExt implements OrderExtPt {
    @Override
    public void beforeCreate(Order order) {
        // VIP 订单逻辑
    }
    
    @Override
    public BigDecimal calculateDiscount(Order order) {
        return order.getAmount().multiply(new BigDecimal("0.1")); // 9折
    }
}
```

### 使用扩展点

```java
@Service
public class OrderServiceImpl {
    
    @Autowired
    private ExtensionExecutor extensionExecutor;
    
    public void createOrder(Order order, String bizId) {
        // 执行扩展点（无返回值）
        extensionExecutor.executeVoid(
            OrderExtPt.class, 
            BizScenario.valueOf(bizId),
            ext -> ext.beforeCreate(order)
        );
        
        // 执行扩展点（有返回值）
        BigDecimal discount = extensionExecutor.execute(
            OrderExtPt.class,
            BizScenario.valueOf(bizId),
            ext -> ext.calculateDiscount(order)
        );
        
        order.setDiscount(discount);
        orderRepository.save(order);
    }
}
```

### BizScenario 业务场景

```java
// 单维度
BizScenario.valueOf("vipOrder");

// 多维度：bizId + useCase
BizScenario.valueOf("vipOrder", "create");

// 三维度：bizId + useCase + scenario
BizScenario.valueOf("vipOrder", "create", "promotion");
```

---

## 5. StateMachine 状态机组件

```xml
<dependency>
    <groupId>com.alibaba.cola</groupId>
    <artifactId>cola-component-statemachine</artifactId>
</dependency>
```

### 定义状态和事件

```java
// 状态枚举
public enum OrderState {
    INIT, PAID, SHIPPED, RECEIVED, CANCELLED
}

// 事件枚举
public enum OrderEvent {
    PAY, SHIP, RECEIVE, CANCEL
}
```

### 构建状态机

```java
@Configuration
public class OrderStateMachineConfig {
    
    @Bean
    public StateMachine<OrderState, OrderEvent, Order> orderStateMachine() {
        StateMachineBuilder<OrderState, OrderEvent, Order> builder = 
            StateMachineBuilderFactory.create();
        
        // INIT -> PAID (on PAY)
        builder.externalTransition()
            .from(OrderState.INIT)
            .to(OrderState.PAID)
            .on(OrderEvent.PAY)
            .when(this::checkPayCondition)
            .perform(this::doPayAction);
        
        // PAID -> SHIPPED (on SHIP)
        builder.externalTransition()
            .from(OrderState.PAID)
            .to(OrderState.SHIPPED)
            .on(OrderEvent.SHIP)
            .perform(this::doShipAction);
        
        // SHIPPED -> RECEIVED (on RECEIVE)
        builder.externalTransition()
            .from(OrderState.SHIPPED)
            .to(OrderState.RECEIVED)
            .on(OrderEvent.RECEIVE)
            .perform(this::doReceiveAction);
        
        // 任意状态 -> CANCELLED (on CANCEL)
        builder.externalTransitions()
            .fromAmong(OrderState.INIT, OrderState.PAID)
            .to(OrderState.CANCELLED)
            .on(OrderEvent.CANCEL)
            .perform(this::doCancelAction);
        
        return builder.build("orderStateMachine");
    }
    
    private boolean checkPayCondition(Order order) {
        return order.getAmount().compareTo(BigDecimal.ZERO) > 0;
    }
    
    private void doPayAction(OrderState from, OrderState to, OrderEvent event, Order order) {
        order.setPaidTime(LocalDateTime.now());
        log.info("Order {} paid", order.getId());
    }
}
```

### 使用状态机

```java
@Service
public class OrderServiceImpl {
    
    @Autowired
    private StateMachine<OrderState, OrderEvent, Order> orderStateMachine;
    
    public void payOrder(Order order) {
        // 触发状态转换
        OrderState newState = orderStateMachine.fireEvent(
            order.getState(),  // 当前状态
            OrderEvent.PAY,    // 事件
            order              // 上下文
        );
        
        order.setState(newState);
        orderRepository.save(order);
    }
}
```

### 内部转换（状态不变）

```java
// 内部转换：状态不变，但执行动作
builder.internalTransition()
    .within(OrderState.PAID)
    .on(OrderEvent.UPDATE_ADDRESS)
    .perform(this::doUpdateAddress);
```

---

## 6. Domain 组件

```xml
<dependency>
    <groupId>com.alibaba.cola</groupId>
    <artifactId>cola-component-domain-starter</artifactId>
</dependency>
```

### Spring 托管领域实体

```java
@Configuration
@EnableDomainEntity
public class DomainConfig {
}

// 领域实体可以注入 Spring Bean
@Entity
public class Order {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private EventPublisher eventPublisher;
    
    public void save() {
        orderRepository.save(this);
        eventPublisher.publish(new OrderCreatedEvent(this));
    }
}
```

---

## 7. Maven BOM

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.alibaba.cola</groupId>
            <artifactId>cola-components-bom</artifactId>
            <version>5.0.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

---

## 组件选择建议

| 场景 | 推荐组件 |
|------|----------|
| 基础项目 | dto + exception + catchlog |
| 多业务线 | + extension |
| 复杂状态流转 | + statemachine |
| 领域驱动设计 | + domain |
