"""
ЛАБОРАТОРНАЯ РАБОТА 6. ЧАСТЬ 6 - СРАВНИТЕЛЬНЫЙ АНАЛИЗ ФП
Реализация на PYTHON (ИСПРАВЛЕННАЯ ВЕРСИЯ)
"""

from dataclasses import dataclass
from typing import List, Optional
from functools import reduce


@dataclass
class User:
    """Пользователь системы"""

    id: int
    name: str
    email: str


@dataclass
class Product:
    """Товар в магазине"""

    id: int
    name: str
    price: float
    category: str


@dataclass
class OrderItem:
    """Позиция в заказе"""

    product: Product
    quantity: int


@dataclass
class Order:
    """Заказ пользователя"""

    id: int
    user: User
    items: List[OrderItem]
    status: str


# ==============================================================================
# ИНИЦИАЛИЗАЦИЯ ДАННЫХ
# ==============================================================================

users = [
    User(1, "John Doe", "john@example.com"),
    User(2, "Jane Smith", "jane@example.com"),
    User(3, "Bob Johnson", "bob@example.com"),
]

products = [
    Product(1, "iPhone", 999.99, "electronics"),
    Product(2, "MacBook", 1999.99, "electronics"),
    Product(3, "T-shirt", 29.99, "clothing"),
    Product(4, "Jeans", 79.99, "clothing"),
    Product(5, "Book", 15.99, "books"),
]

orders = [
    Order(
        1,
        users[0],
        [
            OrderItem(products[0], 1),
            OrderItem(products[2], 2),
        ],
        "completed",
    ),
    Order(
        2,
        users[1],
        [
            OrderItem(products[1], 1),
        ],
        "pending",
    ),
    Order(
        3,
        users[0],
        [
            OrderItem(products[3], 3),
        ],
        "completed",
    ),
    Order(
        4,
        users[2],
        [
            OrderItem(products[4], 5),
            OrderItem(products[2], 1),
        ],
        "pending",
    ),
]


# ==============================================================================
# ФУНКЦИОНАЛЬНЫЕ ОПЕРАЦИИ
# ==============================================================================


def calculate_order_total(order: Order) -> float:
    """Расчет общей стоимости заказа"""
    return sum(item.product.price * item.quantity for item in order.items)


def filter_orders_by_status(orders: List[Order], status: str) -> List[Order]:
    """Фильтрация заказов по статусу"""
    return list(filter(lambda order: order.status == status, orders))


def get_top_expensive_orders(orders: List[Order], n: int) -> List[Order]:
    """Получение топ N самых дорогих заказов"""
    return sorted(orders, key=calculate_order_total, reverse=True)[:n]


def apply_discount(order: Order, discount: float) -> Order:
    """Применить скидку к заказу"""
    discounted_items = [
        OrderItem(
            Product(
                item.product.id,
                item.product.name,
                item.product.price * (1 - discount),
                item.product.category,
            ),
            item.quantity,
        )
        for item in order.items
    ]
    return Order(order.id, order.user, discounted_items, order.status)


def group_orders_by_user(orders: List[Order]) -> dict:
    """Группировка заказов по пользователям"""
    grouped = {}
    for order in orders:
        user_id = order.user.id
        if user_id not in grouped:
            grouped[user_id] = []
        grouped[user_id].append(order)
    return grouped


def calculate_user_spending(orders: List[Order]) -> List[tuple]:
    """Расчет общих расходов по пользователям"""
    spending = {}
    for order in orders:
        user_name = order.user.name
        if user_name not in spending:
            spending[user_name] = 0
        spending[user_name] += calculate_order_total(order)

    return sorted(spending.items(), key=lambda x: x[1], reverse=True)


def find_orders_by_category(orders: List[Order], category: str) -> List[Order]:
    """Поиск заказов содержащих товары определенной категории"""
    result = []
    for order in orders:
        for item in order.items:
            if item.product.category == category:
                result.append(order)
                break
    return result


def calculate_statistics(orders: List[Order]) -> dict:
    """Статистика по заказам"""
    if not orders:
        return {}

    totals = [calculate_order_total(order) for order in orders]

    return {
        "total_orders": len(orders),
        "completed_orders": len(filter_orders_by_status(orders, "completed")),
        "pending_orders": len(filter_orders_by_status(orders, "pending")),
        "total_revenue": sum(totals),
        "average_order": sum(totals) / len(totals),
        "max_order": max(totals),
        "min_order": min(totals),
    }


# ==============================================================================
# ДЕМОНСТРАЦИЯ
# ==============================================================================


def main():
    """Основная функция демонстрации"""

    print("\n" + "█" * 70)
    print("ЛАБОРАТОРНАЯ РАБОТА 6. ЧАСТЬ 6 - СРАВНИТЕЛЬНЫЙ АНАЛИЗ ФП")
    print("Реализация на PYTHON\n" + "█" * 70)

    # 1. Фильтрация по статусу
    print("\n" + "=" * 70)
    print("✅ АНАЛИЗ ЗАКАЗОВ (PYTHON)")
    print("=" * 70)

    print("\n✓ Завершенные заказы:")
    completed = filter_orders_by_status(orders, "completed")
    for order in completed:
        print(
            f"  Заказ {order.id}: {order.user.name} - ${calculate_order_total(order):.2f}"
        )

    # 2. Общая выручка
    total_revenue = sum(calculate_order_total(order) for order in completed)
    print(f"\n✓ Общая выручка (завершенные): ${total_revenue:.2f}")

    # 3. Топ дорогие заказы
    print("\n✓ Топ-2 самых дорогих заказа:")
    top_orders = get_top_expensive_orders(orders, 2)
    for order in top_orders:
        print(f"  Заказ {order.id}: ${calculate_order_total(order):.2f}")

    # 4. Применение скидки
    print("\n✓ Первый заказ со скидкой 10%:")
    print(f"  Было: ${calculate_order_total(orders[0]):.2f}")
    discounted = apply_discount(orders[0], 0.1)
    print(f"  После скидки: ${calculate_order_total(discounted):.2f}")

    # 5. Группировка по пользователям
    print("\n✓ Заказы по пользователям:")
    grouped = group_orders_by_user(orders)
    for user_id, user_orders in grouped.items():
        user_name = next((u.name for u in users if u.id == user_id), "Unknown")
        print(f"  {user_name}: {len(user_orders)} заказов")

    # 6. Расходы пользователей
    print("\n✓ Общие расходы по пользователям:")
    spending = calculate_user_spending(orders)
    for name, total in spending:
        print(f"  {name}: ${total:.2f}")

    # 7. Поиск по категориям
    print("\n✓ Заказы с электроникой:")
    electronics_orders = find_orders_by_category(orders, "electronics")
    print(f"  Найдено заказов: {len(electronics_orders)}")
    for order in electronics_orders:
        print(f"    Заказ {order.id}: ${calculate_order_total(order):.2f}")

    # 8. Статистика
    print("\n" + "=" * 70)
    print("📊 СТАТИСТИКА")
    print("=" * 70)

    stats = calculate_statistics(orders)
    print(f"✓ Всего заказов: {stats['total_orders']}")
    print(f"✓ Завершенных: {stats['completed_orders']}")
    print(f"✓ В ожидании: {stats['pending_orders']}")
    print(f"✓ Общая выручка: ${stats['total_revenue']:.2f}")
    print(f"✓ Средний заказ: ${stats['average_order']:.2f}")
    print(f"✓ Максимальный заказ: ${stats['max_order']:.2f}")
    print(f"✓ Минимальный заказ: ${stats['min_order']:.2f}")

    # 9. Функциональная композиция (БЕЗ |>)
    print("\n✓ Цепочка операций (функциональное программирование):")

    # Этап 1: Фильтруем завершенные заказы стоимостью > 50
    expensive_orders = [
        order
        for order in orders
        if order.status == "completed" and calculate_order_total(order) > 50
    ]

    # Этап 2: Применяем скидку 5%
    discounted_orders = [apply_discount(order, 0.05) for order in expensive_orders]

    # Этап 3: Сортируем по цене (убывающий порядок)
    top_result = sorted(discounted_orders, key=calculate_order_total, reverse=True)[:1]

    if top_result:
        order = top_result[0]
        print(f"  Заказ {order.id}: ${calculate_order_total(order):.2f} (после скидки)")

    # Или альтернативно, через промежуточные переменные
    print("\n✓ Альтернативная композиция (через промежуточные шаги):")

    # Функциональное программирование через map/filter/reduce
    step1 = filter(lambda o: o.status == "completed", orders)
    step2 = filter(lambda o: calculate_order_total(o) > 50, step1)
    step3 = map(lambda o: apply_discount(o, 0.05), step2)
    step4 = sorted(step3, key=calculate_order_total, reverse=True)
    step5 = step4[:1] if step4 else []

    if step5:
        order = step5[0]
        print(f"  Результат: Заказ {order.id} - ${calculate_order_total(order):.2f}")

    print("\n" + "=" * 70)
    print("✅ ВСЕ ОПЕРАЦИИ ЗАВЕРШЕНЫ!")
    print("=" * 70 + "\n")


# ==============================================================================
# ФУНКЦИОНАЛЬНЫЕ ПРИМЕРЫ (ФП СТИЛЬ)
# ==============================================================================


def functional_style_demo():
    """Демонстрация функционального стиля программирования в Python"""

    print("\n" + "=" * 70)
    print("🎯 ФУНКЦИОНАЛЬНОЕ ПРОГРАММИРОВАНИЕ В PYTHON")
    print("=" * 70)

    # 1. Map
    print("\n✓ Map - преобразование всех заказов в их стоимости:")
    totals = list(map(calculate_order_total, orders))
    print(f"  {totals}")

    # 2. Filter
    print("\n✓ Filter - только завершенные заказы:")
    completed = list(filter(lambda o: o.status == "completed", orders))
    print(f"  Найдено: {len(completed)} заказов")

    # 3. Reduce
    print("\n✓ Reduce - сумма всех заказов:")
    total_sum = reduce(lambda acc, order: acc + calculate_order_total(order), orders, 0)
    print(f"  Сумма: ${total_sum:.2f}")

    # 4. List comprehensions (Python way)
    print("\n✓ List comprehensions (Pythonic ФП):")
    expensive = [o for o in orders if calculate_order_total(o) > 100]
    print(f"  Дорогие заказы (>$100): {len(expensive)} штук")

    # 5. Комбинирование
    print("\n✓ Комбинирование операций:")
    result = [
        (o.id, calculate_order_total(o)) for o in orders if o.status == "completed"
    ]
    print(f"  Завершенные: {result}")

    print("\n" + "=" * 70 + "\n")


if __name__ == "__main__":
    main()
    functional_style_demo()
