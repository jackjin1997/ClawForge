# 完整示例：用户管理模块

## Controller (Adapter 层)

```java
// adapter/web/UserController.java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @Autowired
    private UserServiceI userService;
    
    @PostMapping
    public Response addUser(@RequestBody UserAddCmd cmd) {
        return userService.addUser(cmd);
    }
    
    @GetMapping
    public MultiResponse<UserCO> listUsers(UserListQry qry) {
        return userService.listUsers(qry);
    }
    
    @GetMapping("/{id}")
    public SingleResponse<UserCO> getUser(@PathVariable Long id) {
        UserGetQry qry = new UserGetQry();
        qry.setUserId(id);
        return userService.getUser(qry);
    }
}
```

## Maven 模块依赖

```xml
<!-- 父 POM -->
<modules>
    <module>project-adapter</module>
    <module>project-app</module>
    <module>project-client</module>
    <module>project-domain</module>
    <module>project-infrastructure</module>
    <module>start</module>
</modules>

<!-- project-adapter -->
<dependencies>
    <dependency>
        <groupId>com.company</groupId>
        <artifactId>project-app</artifactId>
    </dependency>
</dependencies>

<!-- project-app -->
<dependencies>
    <dependency>
        <groupId>com.company</groupId>
        <artifactId>project-domain</artifactId>
    </dependency>
    <dependency>
        <groupId>com.company</groupId>
        <artifactId>project-client</artifactId>
    </dependency>
    <dependency>
        <groupId>com.alibaba.cola</groupId>
        <artifactId>cola-component-catchlog-starter</artifactId>
    </dependency>
</dependencies>

<!-- project-domain -->
<dependencies>
    <dependency>
        <groupId>com.company</groupId>
        <artifactId>project-client</artifactId>
    </dependency>
</dependencies>

<!-- project-infrastructure -->
<dependencies>
    <dependency>
        <groupId>com.company</groupId>
        <artifactId>project-domain</artifactId>
    </dependency>
</dependencies>

<!-- start -->
<dependencies>
    <dependency>
        <groupId>com.company</groupId>
        <artifactId>project-adapter</artifactId>
    </dependency>
    <dependency>
        <groupId>com.company</groupId>
        <artifactId>project-infrastructure</artifactId>
    </dependency>
</dependencies>
```

## COLA BOM

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

## 异常处理

```java
// 业务异常
throw new BizException("USER_NOT_FOUND", "用户不存在");

// 系统异常
throw new SysException("DATABASE_ERROR", "数据库连接失败");

// 使用错误码枚举
public enum ErrorCode implements ErrorCodeI {
    USER_NOT_FOUND("USER_NOT_FOUND", "用户不存在"),
    EMAIL_EXISTS("EMAIL_EXISTS", "邮箱已存在");
    
    private String errCode;
    private String errDesc;
}
```

## 状态机

```java
StateMachineBuilder<OrderState, OrderEvent, Order> builder = 
    StateMachineBuilderFactory.create();

builder.externalTransition()
    .from(OrderState.CREATED)
    .to(OrderState.PAID)
    .on(OrderEvent.PAY)
    .when(checkCondition())
    .perform(doAction());

StateMachine<OrderState, OrderEvent, Order> stateMachine = 
    builder.build("orderStateMachine");

// 触发状态转换
stateMachine.fireEvent(OrderState.CREATED, OrderEvent.PAY, order);
```

## 扩展点

```java
// 定义扩展点接口
public interface OrderExtPt extends ExtensionPointI {
    void beforeCreate(Order order);
}

// 实现扩展点
@Extension(bizId = "vip", useCase = "order")
public class VipOrderExt implements OrderExtPt {
    @Override
    public void beforeCreate(Order order) {
        order.applyVipDiscount();
    }
}

// 使用扩展点
@Autowired
private ExtensionExecutor extensionExecutor;

extensionExecutor.executeVoid(OrderExtPt.class, 
    BizScenario.valueOf("vip", "order"), 
    ext -> ext.beforeCreate(order));
```
