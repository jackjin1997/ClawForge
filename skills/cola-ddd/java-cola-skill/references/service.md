# Service 和执行器模板

## Service 接口

```java
// client/api/UserServiceI.java
public interface UserServiceI {
    Response addUser(UserAddCmd cmd);
    SingleResponse<UserCO> getUser(UserGetQry qry);
    MultiResponse<UserCO> listUsers(UserListQry qry);
    PageResponse<UserCO> pageUsers(UserPageQry qry);
}
```

## Command 执行器

```java
// app/command/UserAddCmdExe.java
@Component
public class UserAddCmdExe {
    
    @Autowired
    private UserGateway userGateway;
    
    public Response execute(UserAddCmd cmd) {
        // 1. 参数校验
        if (StringUtils.isEmpty(cmd.getUserCO().getEmail())) {
            return Response.buildFailure("PARAM_ERROR", "邮箱不能为空");
        }
        
        // 2. 业务逻辑检查
        if (userGateway.existsByEmail(cmd.getUserCO().getEmail())) {
            return Response.buildFailure("EMAIL_EXISTS", "邮箱已存在");
        }
        
        // 3. 创建领域实体
        User user = new User();
        BeanUtils.copyProperties(cmd.getUserCO(), user);
        
        // 4. 调用 Gateway 持久化
        userGateway.save(user);
        
        return Response.buildSuccess();
    }
}
```

## Query 执行器

```java
// app/command/query/UserListQryExe.java
@Component
public class UserListQryExe {
    
    @Autowired
    private UserGateway userGateway;
    
    @Autowired
    private UserConvertor userConvertor;
    
    public MultiResponse<UserCO> execute(UserListQry qry) {
        List<User> users = userGateway.listByCondition(
            qry.getKeyword(), qry.getPageIndex(), qry.getPageSize()
        );
        
        List<UserCO> userCOs = users.stream()
            .map(userConvertor::toClientObject)
            .collect(Collectors.toList());
        
        return MultiResponse.of(userCOs);
    }
}
```

## Service 实现

```java
// app/service/UserServiceImpl.java
@Service
@CatchAndLog  // COLA 异常处理注解
public class UserServiceImpl implements UserServiceI {
    
    @Resource
    private UserAddCmdExe userAddCmdExe;
    
    @Resource
    private UserListQryExe userListQryExe;
    
    @Override
    public Response addUser(UserAddCmd cmd) {
        return userAddCmdExe.execute(cmd);
    }
    
    @Override
    public MultiResponse<UserCO> listUsers(UserListQry qry) {
        return userListQryExe.execute(qry);
    }
}
```

## Maven 依赖

```xml
<dependency>
    <groupId>com.alibaba.cola</groupId>
    <artifactId>cola-component-catchlog-starter</artifactId>
</dependency>
```
