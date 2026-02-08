# DDD 战术设计参考

## 目录

1. [实体](#实体entity)
2. [值对象](#值对象value-object)
3. [聚合](#聚合aggregate)
4. [领域服务](#领域服务domain-service)
5. [领域事件](#领域事件domain-event)
6. [仓储](#仓储repository)
7. [工厂](#工厂factory)

---

## 实体（Entity）

实体是具有唯一标识和生命周期的领域对象。

### 核心特征

1. **唯一标识** - 通过ID区分，而非属性值
2. **可变性** - 状态可以改变，但标识不变
3. **生命周期** - 有创建、修改、销毁的生命周期

### 实现模式

```python
from dataclasses import dataclass, field
from typing import Optional
from datetime import datetime

@dataclass
class UserId:
    """强类型ID - 避免原始类型偏执"""
    value: str
    
    def __post_init__(self):
        if not self.value or len(self.value) < 5:
            raise ValueError("UserId must be at least 5 characters")

class User:
    """用户实体"""
    
    def __init__(self, user_id: UserId, email: str, name: str):
        self._id = user_id
        self._email = email
        self._name = name
        self._status = "active"
        self._created_at = datetime.utcnow()
        self._events: list = []
    
    @property
    def id(self) -> UserId:
        return self._id
    
    @property
    def email(self) -> str:
        return self._email
    
    def change_email(self, new_email: str) -> None:
        """业务逻辑封装在实体内"""
        if not self._is_valid_email(new_email):
            raise ValueError("Invalid email format")
        old_email = self._email
        self._email = new_email
        self._events.append(UserEmailChanged(self._id, old_email, new_email))
    
    def deactivate(self) -> None:
        if self._status != "active":
            raise DomainException("Only active users can be deactivated")
        self._status = "inactive"
        self._events.append(UserDeactivated(self._id))
    
    def _is_valid_email(self, email: str) -> bool:
        return "@" in email and "." in email
    
    def __eq__(self, other: object) -> bool:
        """实体通过ID判等"""
        if not isinstance(other, User):
            return False
        return self._id == other._id
    
    def __hash__(self) -> int:
        return hash(self._id)
```

---

## 值对象（Value Object）

值对象是没有标识的不可变对象，通过属性值来判断相等性。

### 核心特征

1. **无标识** - 通过属性值判等
2. **不可变** - 创建后不可修改
3. **可替换** - 整体替换而非部分修改

### 实现模式

```python
from dataclasses import dataclass
from decimal import Decimal
from typing import NamedTuple

@dataclass(frozen=True)
class Money:
    """金额值对象"""
    amount: Decimal
    currency: str = "CNY"
    
    def __post_init__(self):
        if self.amount < 0:
            raise ValueError("Amount cannot be negative")
    
    def add(self, other: 'Money') -> 'Money':
        """返回新对象而非修改自身"""
        self._ensure_same_currency(other)
        return Money(self.amount + other.amount, self.currency)
    
    def subtract(self, other: 'Money') -> 'Money':
        self._ensure_same_currency(other)
        return Money(self.amount - other.amount, self.currency)
    
    def multiply(self, factor: Decimal) -> 'Money':
        return Money(self.amount * factor, self.currency)
    
    def _ensure_same_currency(self, other: 'Money') -> None:
        if self.currency != other.currency:
            raise ValueError(f"Cannot operate on different currencies: {self.currency} vs {other.currency}")


@dataclass(frozen=True)
class Address:
    """地址值对象"""
    country: str
    province: str
    city: str
    street: str
    postal_code: str
    
    def format_full(self) -> str:
        return f"{self.country} {self.province} {self.city} {self.street}, {self.postal_code}"


class DateRange(NamedTuple):
    """日期范围值对象 - 使用NamedTuple"""
    start: datetime
    end: datetime
    
    def contains(self, date: datetime) -> bool:
        return self.start <= date <= self.end
    
    def overlaps(self, other: 'DateRange') -> bool:
        return self.start <= other.end and other.start <= self.end
    
    def duration_days(self) -> int:
        return (self.end - self.start).days
```

### 值对象 vs 实体 决策

| 考虑因素 | 选择实体 | 选择值对象 |
|---------|---------|-----------|
| 需要跨时间跟踪 | ✓ | |
| 需要唯一标识 | ✓ | |
| 属性值完全定义对象 | | ✓ |
| 需要不可变性 | | ✓ |
| 可以整体替换 | | ✓ |

---

## 聚合（Aggregate）

聚合是一组相关对象的集合，作为数据修改的单元。

### 设计规则

1. **保护不变式** - 聚合确保业务规则始终满足
2. **原子性** - 聚合作为整体进行持久化
3. **通过根访问** - 外部只能通过聚合根访问内部对象
4. **ID引用** - 聚合间通过ID引用，不直接持有对象

### 聚合根示例

```python
from dataclasses import dataclass, field
from typing import List, Optional
from decimal import Decimal

class OrderId:
    def __init__(self, value: str):
        self.value = value

class Order:
    """订单聚合根"""
    
    def __init__(self, order_id: OrderId, customer_id: str):
        self._id = order_id
        self._customer_id = customer_id
        self._items: List[OrderItem] = []
        self._status = OrderStatus.DRAFT
        self._total: Money = Money(Decimal("0"))
        self._events: List[DomainEvent] = []
    
    @property
    def id(self) -> OrderId:
        return self._id
    
    @property
    def items(self) -> List['OrderItem']:
        """返回只读副本，防止外部修改"""
        return list(self._items)
    
    @property
    def total(self) -> Money:
        return self._total
    
    def add_item(self, product_id: str, quantity: int, unit_price: Money) -> None:
        """添加订单项 - 包含业务验证"""
        self._ensure_draft_status()
        self._validate_quantity(quantity)
        
        # 检查是否已存在相同商品
        existing = self._find_item(product_id)
        if existing:
            existing.increase_quantity(quantity)
        else:
            item = OrderItem(product_id, quantity, unit_price)
            self._items.append(item)
        
        self._recalculate_total()
        self._events.append(OrderItemAdded(self._id, product_id, quantity))
    
    def remove_item(self, product_id: str) -> None:
        """移除订单项"""
        self._ensure_draft_status()
        
        item = self._find_item(product_id)
        if not item:
            raise DomainException(f"Item {product_id} not found")
        
        self._items.remove(item)
        self._recalculate_total()
        self._events.append(OrderItemRemoved(self._id, product_id))
    
    def submit(self) -> None:
        """提交订单 - 状态转换"""
        self._ensure_draft_status()
        if not self._items:
            raise DomainException("Cannot submit empty order")
        
        self._status = OrderStatus.SUBMITTED
        self._events.append(OrderSubmitted(self._id, self._total))
    
    def cancel(self, reason: str) -> None:
        """取消订单"""
        if self._status not in [OrderStatus.DRAFT, OrderStatus.SUBMITTED]:
            raise DomainException(f"Cannot cancel order in {self._status} status")
        
        self._status = OrderStatus.CANCELLED
        self._events.append(OrderCancelled(self._id, reason))
    
    def _ensure_draft_status(self) -> None:
        if self._status != OrderStatus.DRAFT:
            raise DomainException("Only draft orders can be modified")
    
    def _validate_quantity(self, quantity: int) -> None:
        if quantity <= 0:
            raise DomainException("Quantity must be positive")
    
    def _find_item(self, product_id: str) -> Optional['OrderItem']:
        return next((i for i in self._items if i.product_id == product_id), None)
    
    def _recalculate_total(self) -> None:
        total = Decimal("0")
        for item in self._items:
            total += item.subtotal.amount
        self._total = Money(total)
    
    def pop_events(self) -> List[DomainEvent]:
        """获取并清空领域事件"""
        events = self._events.copy()
        self._events.clear()
        return events


class OrderItem:
    """订单项 - 聚合内的实体"""
    
    def __init__(self, product_id: str, quantity: int, unit_price: Money):
        self._product_id = product_id
        self._quantity = quantity
        self._unit_price = unit_price
    
    @property
    def product_id(self) -> str:
        return self._product_id
    
    @property
    def quantity(self) -> int:
        return self._quantity
    
    @property
    def subtotal(self) -> Money:
        return self._unit_price.multiply(Decimal(self._quantity))
    
    def increase_quantity(self, amount: int) -> None:
        """只能通过聚合根调用"""
        self._quantity += amount
```

### 聚合边界判断

```
问题清单：
□ 这些对象是否必须一起保持一致？
□ 是否有跨对象的业务规则？
□ 能否接受最终一致性？
□ 并发修改的粒度是什么？

如果需要强一致性 → 放入同一聚合
如果可以最终一致 → 分成不同聚合，用领域事件同步
```

---

## 领域服务（Domain Service）

领域服务处理不属于任何实体或值对象的业务逻辑。

### 使用场景

1. 跨多个聚合的操作
2. 涉及外部服务的业务逻辑
3. 无状态的业务规则

### 实现示例

```python
from abc import ABC, abstractmethod

class TransferService:
    """转账领域服务 - 跨聚合操作"""
    
    def __init__(self, account_repo: AccountRepository):
        self._account_repo = account_repo
    
    def transfer(self, from_id: AccountId, to_id: AccountId, amount: Money) -> None:
        """执行转账"""
        from_account = self._account_repo.find_by_id(from_id)
        to_account = self._account_repo.find_by_id(to_id)
        
        if from_account is None or to_account is None:
            raise DomainException("Account not found")
        
        # 业务逻辑
        from_account.withdraw(amount)
        to_account.deposit(amount)
        
        # 分别保存（最终一致性）
        self._account_repo.save(from_account)
        self._account_repo.save(to_account)


class PricingService:
    """定价领域服务 - 复杂定价规则"""
    
    def __init__(self, discount_repo: DiscountRepository):
        self._discount_repo = discount_repo
    
    def calculate_price(self, product: Product, customer: Customer, quantity: int) -> Money:
        """计算最终价格"""
        base_price = product.unit_price.multiply(Decimal(quantity))
        
        # 应用折扣规则
        discount = self._find_best_discount(product, customer, quantity)
        if discount:
            return discount.apply(base_price)
        
        return base_price
    
    def _find_best_discount(self, product: Product, customer: Customer, quantity: int):
        # 复杂的折扣逻辑
        pass
```

---

## 领域事件（Domain Event）

领域事件记录领域中发生的重要业务变化。

### 设计原则

1. **不可变** - 事件一旦发生不可修改
2. **过去式命名** - 表示已发生的事实
3. **携带必要数据** - 包含处理事件所需的信息

### 实现模式

```python
from dataclasses import dataclass, field
from datetime import datetime
from uuid import uuid4

@dataclass(frozen=True)
class DomainEvent:
    """领域事件基类"""
    event_id: str = field(default_factory=lambda: str(uuid4()))
    occurred_at: datetime = field(default_factory=datetime.utcnow)


@dataclass(frozen=True)
class OrderSubmitted(DomainEvent):
    """订单提交事件"""
    order_id: str
    customer_id: str
    total_amount: Money
    items: tuple  # 不可变

@dataclass(frozen=True)
class PaymentCompleted(DomainEvent):
    """支付完成事件"""
    payment_id: str
    order_id: str
    amount: Money
    payment_method: str


# 事件发布器
class DomainEventPublisher:
    _handlers: dict = {}
    
    @classmethod
    def subscribe(cls, event_type: type, handler: callable):
        if event_type not in cls._handlers:
            cls._handlers[event_type] = []
        cls._handlers[event_type].append(handler)
    
    @classmethod
    def publish(cls, event: DomainEvent):
        handlers = cls._handlers.get(type(event), [])
        for handler in handlers:
            handler(event)


# 事件处理器
class OrderSubmittedHandler:
    def __init__(self, inventory_service: InventoryService):
        self._inventory_service = inventory_service
    
    def handle(self, event: OrderSubmitted):
        """响应订单提交：预留库存"""
        for item in event.items:
            self._inventory_service.reserve(item.product_id, item.quantity)
```

---

## 仓储（Repository）

仓储提供聚合的持久化抽象，隐藏存储细节。

### 设计原则

1. **每个聚合一个仓储** - 只为聚合根创建仓储
2. **集合语义** - 像操作内存集合一样操作
3. **接口在领域层** - 实现在基础设施层

### 实现模式

```python
from abc import ABC, abstractmethod
from typing import Optional, List

# 领域层 - 仓储接口
class OrderRepository(ABC):
    """订单仓储接口"""
    
    @abstractmethod
    def find_by_id(self, order_id: OrderId) -> Optional[Order]:
        pass
    
    @abstractmethod
    def find_by_customer(self, customer_id: str) -> List[Order]:
        pass
    
    @abstractmethod
    def save(self, order: Order) -> None:
        pass
    
    @abstractmethod
    def delete(self, order: Order) -> None:
        pass
    
    @abstractmethod
    def next_id(self) -> OrderId:
        """生成下一个ID"""
        pass


# 基础设施层 - 仓储实现
class SqlOrderRepository(OrderRepository):
    """SQL实现的订单仓储"""
    
    def __init__(self, session: Session, event_publisher: DomainEventPublisher):
        self._session = session
        self._event_publisher = event_publisher
    
    def find_by_id(self, order_id: OrderId) -> Optional[Order]:
        row = self._session.query(OrderModel).filter_by(id=order_id.value).first()
        return self._to_domain(row) if row else None
    
    def save(self, order: Order) -> None:
        model = self._to_model(order)
        self._session.merge(model)
        self._session.commit()
        
        # 发布领域事件
        for event in order.pop_events():
            self._event_publisher.publish(event)
    
    def _to_domain(self, model: OrderModel) -> Order:
        """数据模型转领域模型"""
        order = Order(OrderId(model.id), model.customer_id)
        # ... 重建聚合状态
        return order
    
    def _to_model(self, order: Order) -> OrderModel:
        """领域模型转数据模型"""
        return OrderModel(
            id=order.id.value,
            customer_id=order._customer_id,
            # ...
        )
```

---

## 工厂（Factory）

工厂封装复杂对象的创建逻辑。

### 使用场景

1. 创建逻辑复杂
2. 需要组装多个部件
3. 创建时需要验证不变式

### 实现模式

```python
class OrderFactory:
    """订单工厂"""
    
    def __init__(self, id_generator: IdGenerator, pricing_service: PricingService):
        self._id_generator = id_generator
        self._pricing_service = pricing_service
    
    def create_order(self, customer_id: str, items: List[dict]) -> Order:
        """创建订单"""
        order_id = OrderId(self._id_generator.next())
        order = Order(order_id, customer_id)
        
        for item in items:
            price = self._pricing_service.get_price(item['product_id'])
            order.add_item(item['product_id'], item['quantity'], price)
        
        return order
    
    def create_from_quote(self, quote: Quote) -> Order:
        """从报价单创建订单"""
        order_id = OrderId(self._id_generator.next())
        order = Order(order_id, quote.customer_id)
        
        for line in quote.lines:
            order.add_item(line.product_id, line.quantity, line.quoted_price)
        
        return order


class UserFactory:
    """用户工厂 - 包含创建验证"""
    
    def __init__(self, user_repo: UserRepository):
        self._user_repo = user_repo
    
    def create_user(self, email: str, name: str) -> User:
        """创建用户 - 验证邮箱唯一性"""
        existing = self._user_repo.find_by_email(email)
        if existing:
            raise DomainException(f"User with email {email} already exists")
        
        user_id = UserId(self._generate_id())
        return User(user_id, email, name)
```
