# DDD 架构模式参考

## 目录

1. [六边形架构](#六边形架构)
2. [洋葱架构](#洋葱架构)
3. [CQRS模式](#cqrs模式)
4. [事件溯源](#事件溯源)
5. [Saga模式](#saga模式)

---

## 六边形架构

六边形架构（又称端口与适配器架构）将应用程序分为内部（领域）和外部（基础设施）两部分。

### 架构图

```
                          ┌────────────────────────────────┐
                          │         驱动适配器              │
                          │   (Driving Adapters)           │
                          │                                │
           ┌──────────┐   │   ┌──────────┐  ┌──────────┐   │
           │  REST    │───┼──►│          │  │          │   │
           │  API     │   │   │  驱动    │  │  消息    │   │
           └──────────┘   │   │  端口    │  │  监听    │◄──┼───┐
                          │   │          │  │          │   │   │
           ┌──────────┐   │   └────┬─────┘  └──────────┘   │   │
           │  Web UI  │───┼───────┘                        │   │
           └──────────┘   │        ▼                       │   │
                          │   ┌────────────────────┐       │   │
                          │   │                    │       │   │
                          │   │   应用服务层        │       │   │
                          │   │   (Application)    │       │   │
                          │   │                    │       │   │
                          │   └────────┬───────────┘       │   │
                          │            ▼                   │   │
                          │   ┌────────────────────┐       │   │
                          │   │                    │       │   │
                          │   │   领域层            │       │   │  消息
                          │   │   (Domain)         │       │   │  队列
                          │   │                    │       │   │
                          │   └────────┬───────────┘       │   │
                          │            ▼                   │   │
                          │   ┌────────────────────┐       │   │
                          │   │   被驱动端口        │       │   │
                          │   │   (Driven Ports)   │       │   │
                          │   └────┬─────┬─────────┘       │   │
                          │        │     │                 │   │
                          └────────┼─────┼─────────────────┘   │
                                   │     │                     │
                          ┌────────▼─────▼─────────────────────┘
                          │       被驱动适配器
                          │   (Driven Adapters)
                          │
           ┌──────────┐   │   ┌──────────┐  ┌──────────┐
           │  MySQL   │◄──┼───│          │  │          │
           │          │   │   │  数据库  │  │  消息    │
           └──────────┘   │   │  适配器  │  │  发布    │
                          │   │          │  │          │
           ┌──────────┐   │   └──────────┘  └──────────┘
           │  Redis   │◄──┼───┘
           └──────────┘   │
                          └────────────────────────────────┘
```

### 代码结构

```
src/
├── application/           # 应用层
│   ├── ports/            # 端口定义
│   │   ├── input/        # 驱动端口（用例接口）
│   │   │   └── OrderService.py
│   │   └── output/       # 被驱动端口
│   │       ├── OrderRepository.py
│   │       └── PaymentGateway.py
│   └── services/         # 应用服务实现
│       └── OrderApplicationService.py
│
├── domain/               # 领域层
│   ├── model/           # 领域模型
│   │   ├── Order.py
│   │   └── OrderItem.py
│   ├── events/          # 领域事件
│   └── services/        # 领域服务
│
└── infrastructure/       # 基础设施层
    ├── adapters/        # 适配器
    │   ├── input/       # 驱动适配器
    │   │   ├── rest/
    │   │   │   └── OrderController.py
    │   │   └── grpc/
    │   └── output/      # 被驱动适配器
    │       ├── persistence/
    │       │   └── SqlOrderRepository.py
    │       └── external/
    │           └── StripePaymentGateway.py
    └── config/          # 配置
```

### 实现示例

```python
# 驱动端口（输入端口）
from abc import ABC, abstractmethod

class OrderService(ABC):
    """订单服务端口 - 定义用例"""
    
    @abstractmethod
    def place_order(self, cmd: PlaceOrderCommand) -> OrderId:
        pass
    
    @abstractmethod
    def cancel_order(self, cmd: CancelOrderCommand) -> None:
        pass


# 被驱动端口（输出端口）
class OrderRepository(ABC):
    """订单仓储端口"""
    
    @abstractmethod
    def find_by_id(self, order_id: OrderId) -> Optional[Order]:
        pass
    
    @abstractmethod
    def save(self, order: Order) -> None:
        pass


class PaymentGateway(ABC):
    """支付网关端口"""
    
    @abstractmethod
    def process_payment(self, amount: Money, card: CardInfo) -> PaymentResult:
        pass


# 应用服务（端口实现）
class OrderApplicationService(OrderService):
    """订单应用服务"""
    
    def __init__(
        self, 
        order_repo: OrderRepository,
        payment_gateway: PaymentGateway
    ):
        self._order_repo = order_repo
        self._payment_gateway = payment_gateway
    
    def place_order(self, cmd: PlaceOrderCommand) -> OrderId:
        order = Order.create(cmd.customer_id, cmd.items)
        
        # 处理支付
        payment_result = self._payment_gateway.process_payment(
            order.total, cmd.payment_info
        )
        
        if not payment_result.success:
            raise PaymentFailedException(payment_result.error)
        
        order.confirm_payment(payment_result.transaction_id)
        self._order_repo.save(order)
        
        return order.id


# 驱动适配器（REST API）
class OrderController:
    """REST API 适配器"""
    
    def __init__(self, order_service: OrderService):
        self._order_service = order_service
    
    def post_order(self, request: HttpRequest) -> HttpResponse:
        cmd = PlaceOrderCommand(
            customer_id=request.json['customer_id'],
            items=request.json['items'],
            payment_info=CardInfo(**request.json['payment'])
        )
        
        order_id = self._order_service.place_order(cmd)
        
        return HttpResponse(
            status=201,
            body={'order_id': order_id.value}
        )


# 被驱动适配器（数据库）
class SqlOrderRepository(OrderRepository):
    """SQL 数据库适配器"""
    
    def __init__(self, session: Session):
        self._session = session
    
    def find_by_id(self, order_id: OrderId) -> Optional[Order]:
        model = self._session.query(OrderModel).get(order_id.value)
        return self._to_domain(model) if model else None
    
    def save(self, order: Order) -> None:
        model = self._to_model(order)
        self._session.merge(model)
        self._session.commit()
```

---

## 洋葱架构

洋葱架构强调依赖指向中心，外层依赖内层。

### 架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                        基础设施层                                │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                     应用服务层                            │   │
│  │  ┌─────────────────────────────────────────────────┐    │   │
│  │  │                  领域服务层                       │    │   │
│  │  │  ┌─────────────────────────────────────────┐   │    │   │
│  │  │  │               领域模型层                  │   │    │   │
│  │  │  │         (核心：实体、值对象)              │   │    │   │
│  │  │  └─────────────────────────────────────────┘   │    │   │
│  │  └─────────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘

依赖方向: 外 → 内
```

### 层次职责

| 层次 | 职责 | 示例 |
|------|------|------|
| 领域模型 | 业务实体和规则 | `Order`, `Money` |
| 领域服务 | 跨实体业务逻辑 | `PricingService` |
| 应用服务 | 用例编排 | `PlaceOrderUseCase` |
| 基础设施 | 技术实现 | `MySqlRepository` |

---

## CQRS模式

命令查询职责分离（CQRS）将读写操作分开处理。

### 架构图

```
              客户端
                │
        ┌───────┴───────┐
        │               │
        ▼               ▼
┌───────────────┐  ┌───────────────┐
│  Command API  │  │   Query API   │
└───────┬───────┘  └───────┬───────┘
        │                   │
        ▼                   ▼
┌───────────────┐  ┌───────────────┐
│ Command Bus   │  │  Query Bus    │
└───────┬───────┘  └───────┬───────┘
        │                   │
        ▼                   ▼
┌───────────────┐  ┌───────────────┐
│   Handler     │  │   Handler     │
│ (修改聚合)    │  │ (读取视图)    │
└───────┬───────┘  └───────┬───────┘
        │                   │
        ▼                   ▼
┌───────────────┐  ┌───────────────┐
│  Write Model  │  │  Read Model   │
│  (聚合存储)   │  │  (查询视图)   │
└───────┬───────┘  └───────────────┘
        │                   ▲
        │   领域事件        │
        └───────────────────┘
```

### 实现示例

```python
# 命令定义
@dataclass(frozen=True)
class PlaceOrderCommand:
    customer_id: str
    items: List[OrderItemDto]
    
@dataclass(frozen=True)
class CancelOrderCommand:
    order_id: str
    reason: str


# 查询定义
@dataclass(frozen=True)
class GetOrderQuery:
    order_id: str

@dataclass(frozen=True)
class ListCustomerOrdersQuery:
    customer_id: str
    page: int = 1
    page_size: int = 20


# 命令处理器
class PlaceOrderHandler:
    def __init__(self, order_repo: OrderRepository):
        self._order_repo = order_repo
    
    def handle(self, cmd: PlaceOrderCommand) -> OrderId:
        order = Order.create(cmd.customer_id, cmd.items)
        self._order_repo.save(order)
        return order.id


# 查询处理器（直接读取优化的视图）
class GetOrderHandler:
    def __init__(self, read_db: ReadDatabase):
        self._read_db = read_db
    
    def handle(self, query: GetOrderQuery) -> OrderView:
        return self._read_db.query(
            "SELECT * FROM order_view WHERE id = ?",
            query.order_id
        )


# 读模型投影器（同步读写模型）
class OrderProjector:
    def __init__(self, read_db: ReadDatabase):
        self._read_db = read_db
    
    def on_order_created(self, event: OrderCreated):
        self._read_db.execute("""
            INSERT INTO order_view (id, customer_id, status, total, created_at)
            VALUES (?, ?, ?, ?, ?)
        """, event.order_id, event.customer_id, 'pending', 
            event.total, event.occurred_at)
    
    def on_order_shipped(self, event: OrderShipped):
        self._read_db.execute("""
            UPDATE order_view SET status = 'shipped', shipped_at = ?
            WHERE id = ?
        """, event.shipped_at, event.order_id)
```

---

## 事件溯源

事件溯源将聚合状态存储为事件序列，而非当前快照。

### 原理图

```
传统方式：存储当前状态
┌─────────────────────────────────────┐
│  Order                              │
│  ├── id: "ORD-001"                  │
│  ├── status: "shipped"              │
│  ├── total: 299.00                  │
│  └── items: [...]                   │
└─────────────────────────────────────┘

事件溯源：存储事件历史
┌─────────────────────────────────────┐
│  Event Stream: ORD-001              │
│  ├── [v1] OrderCreated              │
│  ├── [v2] ItemAdded                 │
│  ├── [v3] ItemAdded                 │
│  ├── [v4] OrderSubmitted            │
│  ├── [v5] PaymentReceived           │
│  └── [v6] OrderShipped              │
└─────────────────────────────────────┘

重建状态：
replay([v1,v2,v3,v4,v5,v6]) → Order(status="shipped")
```

### 实现示例

```python
# 事件溯源聚合基类
class EventSourcedAggregate:
    def __init__(self):
        self._changes: List[DomainEvent] = []
        self._version = 0
    
    def load_from_history(self, events: List[DomainEvent]):
        """从事件历史重建状态"""
        for event in events:
            self._apply(event)
            self._version += 1
    
    def _apply_change(self, event: DomainEvent):
        """应用新事件"""
        self._apply(event)
        self._changes.append(event)
    
    def _apply(self, event: DomainEvent):
        """分发到具体处理方法"""
        handler = getattr(self, f'_on_{type(event).__name__}', None)
        if handler:
            handler(event)
    
    def get_uncommitted_changes(self) -> List[DomainEvent]:
        return self._changes.copy()
    
    def mark_changes_committed(self):
        self._changes.clear()


# 事件溯源订单
class Order(EventSourcedAggregate):
    def __init__(self, order_id: OrderId = None):
        super().__init__()
        self._id = order_id
        self._items = []
        self._status = None
        self._total = Money(Decimal("0"))
    
    @classmethod
    def create(cls, order_id: OrderId, customer_id: str) -> 'Order':
        order = cls(order_id)
        order._apply_change(OrderCreated(order_id.value, customer_id))
        return order
    
    def add_item(self, product_id: str, quantity: int, price: Money):
        if self._status != OrderStatus.DRAFT:
            raise DomainException("Cannot modify non-draft order")
        self._apply_change(ItemAdded(self._id.value, product_id, quantity, price))
    
    def submit(self):
        if not self._items:
            raise DomainException("Cannot submit empty order")
        self._apply_change(OrderSubmitted(self._id.value, self._total))
    
    # 事件处理方法
    def _on_OrderCreated(self, event: OrderCreated):
        self._id = OrderId(event.order_id)
        self._status = OrderStatus.DRAFT
    
    def _on_ItemAdded(self, event: ItemAdded):
        self._items.append(OrderItem(event.product_id, event.quantity, event.price))
        self._total = self._total.add(event.price.multiply(Decimal(event.quantity)))
    
    def _on_OrderSubmitted(self, event: OrderSubmitted):
        self._status = OrderStatus.SUBMITTED


# 事件存储
class EventStore:
    def __init__(self, db: Database):
        self._db = db
    
    def save(self, aggregate_id: str, events: List[DomainEvent], expected_version: int):
        """保存事件（乐观并发控制）"""
        with self._db.transaction():
            current_version = self._get_version(aggregate_id)
            if current_version != expected_version:
                raise ConcurrencyException("Aggregate has been modified")
            
            for i, event in enumerate(events):
                self._db.execute("""
                    INSERT INTO events (aggregate_id, version, event_type, data, timestamp)
                    VALUES (?, ?, ?, ?, ?)
                """, aggregate_id, expected_version + i + 1, 
                    type(event).__name__, json.dumps(asdict(event)), datetime.utcnow())
    
    def load(self, aggregate_id: str) -> List[DomainEvent]:
        """加载事件流"""
        rows = self._db.query("""
            SELECT event_type, data FROM events 
            WHERE aggregate_id = ? ORDER BY version
        """, aggregate_id)
        return [self._deserialize(row) for row in rows]


# 事件溯源仓储
class EventSourcedOrderRepository:
    def __init__(self, event_store: EventStore):
        self._event_store = event_store
    
    def find_by_id(self, order_id: OrderId) -> Optional[Order]:
        events = self._event_store.load(order_id.value)
        if not events:
            return None
        order = Order()
        order.load_from_history(events)
        return order
    
    def save(self, order: Order):
        events = order.get_uncommitted_changes()
        self._event_store.save(order.id.value, events, order._version)
        order.mark_changes_committed()
```

---

## Saga模式

Saga模式用于管理跨多个聚合或服务的长事务。

### 编排式Saga

```
┌─────────────────────────────────────────────────────────────────┐
│                        Saga 协调器                               │
└────────┬────────────────┬────────────────┬────────────────┬─────┘
         │                │                │                │
         ▼                ▼                ▼                ▼
┌─────────────┐   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│ 订单服务    │   │ 库存服务    │   │ 支付服务    │   │ 物流服务    │
│             │   │             │   │             │   │             │
│ 1.创建订单  │   │ 2.预留库存  │   │ 3.扣款      │   │ 4.安排发货  │
│ ↓          │   │ ↓          │   │ ↓          │   │             │
│ 补偿:取消   │   │ 补偿:释放   │   │ 补偿:退款   │   │             │
└─────────────┘   └─────────────┘   └─────────────┘   └─────────────┘
```

### 实现示例

```python
# Saga 定义
class CreateOrderSaga:
    """创建订单Saga - 编排式"""
    
    def __init__(
        self,
        order_service: OrderService,
        inventory_service: InventoryService,
        payment_service: PaymentService,
        shipping_service: ShippingService
    ):
        self._order_service = order_service
        self._inventory_service = inventory_service
        self._payment_service = payment_service
        self._shipping_service = shipping_service
    
    def execute(self, cmd: CreateOrderCommand) -> SagaResult:
        """执行Saga"""
        compensation_actions = []
        
        try:
            # 步骤1：创建订单
            order_id = self._order_service.create_order(cmd)
            compensation_actions.append(
                lambda: self._order_service.cancel_order(order_id)
            )
            
            # 步骤2：预留库存
            reservation_id = self._inventory_service.reserve_items(
                order_id, cmd.items
            )
            compensation_actions.append(
                lambda: self._inventory_service.release_reservation(reservation_id)
            )
            
            # 步骤3：处理支付
            payment_id = self._payment_service.process_payment(
                order_id, cmd.payment_info
            )
            compensation_actions.append(
                lambda: self._payment_service.refund(payment_id)
            )
            
            # 步骤4：安排发货
            self._shipping_service.schedule_shipment(order_id)
            
            # 步骤5：确认订单
            self._order_service.confirm_order(order_id)
            
            return SagaResult.success(order_id)
            
        except Exception as e:
            # 执行补偿
            self._compensate(compensation_actions)
            return SagaResult.failure(str(e))
    
    def _compensate(self, actions: List[Callable]):
        """逆序执行补偿操作"""
        for action in reversed(actions):
            try:
                action()
            except Exception as e:
                # 记录补偿失败，可能需要人工介入
                logger.error(f"Compensation failed: {e}")


# 事件驱动式Saga（基于状态机）
class OrderSagaState(Enum):
    STARTED = "started"
    INVENTORY_RESERVED = "inventory_reserved"
    PAYMENT_PROCESSED = "payment_processed"
    SHIPPING_SCHEDULED = "shipping_scheduled"
    COMPLETED = "completed"
    COMPENSATING = "compensating"
    FAILED = "failed"


class OrderSaga:
    """基于状态机的Saga"""
    
    def __init__(self, saga_id: str):
        self.saga_id = saga_id
        self.state = OrderSagaState.STARTED
        self.order_id = None
        self.reservation_id = None
        self.payment_id = None
    
    def handle_event(self, event: DomainEvent) -> List[Command]:
        """处理事件，返回要执行的命令"""
        handler = {
            OrderSagaState.STARTED: self._on_started,
            OrderSagaState.INVENTORY_RESERVED: self._on_inventory_reserved,
            OrderSagaState.PAYMENT_PROCESSED: self._on_payment_processed,
            OrderSagaState.COMPENSATING: self._on_compensating,
        }.get(self.state)
        
        if handler:
            return handler(event)
        return []
    
    def _on_started(self, event: DomainEvent) -> List[Command]:
        if isinstance(event, OrderCreated):
            self.order_id = event.order_id
            self.state = OrderSagaState.STARTED
            return [ReserveInventoryCommand(event.order_id, event.items)]
        return []
    
    def _on_inventory_reserved(self, event: DomainEvent) -> List[Command]:
        if isinstance(event, InventoryReserved):
            self.reservation_id = event.reservation_id
            self.state = OrderSagaState.INVENTORY_RESERVED
            return [ProcessPaymentCommand(self.order_id)]
        elif isinstance(event, InventoryReservationFailed):
            self.state = OrderSagaState.COMPENSATING
            return [CancelOrderCommand(self.order_id)]
        return []
```

### Saga 设计考虑

| 考虑点 | 建议 |
|--------|------|
| 幂等性 | 每个步骤必须幂等，支持重试 |
| 超时 | 设置合理超时，触发补偿 |
| 补偿顺序 | 严格按逆序执行补偿 |
| 并发 | 使用乐观锁或分布式锁 |
| 可观测性 | 记录Saga状态和步骤 |
