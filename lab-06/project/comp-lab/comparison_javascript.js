// ЛАБОРАТОРНАЯ РАБОТА 6. ЧАСТЬ 6 - СРАВНИТЕЛЬНЫЙ АНАЛИЗ ФП
// Реализация на JAVASCRIPT

// ============================================================================
// Модель данных
// ============================================================================

class User {
    constructor(id, name, email) {
        this.id = id;
        this.name = name;
        this.email = email;
    }

    static new(id, name, email) {
        return new User(id, name, email);
    }
}

class Product {
    constructor(id, name, price, category) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.category = category;
    }

    static new(id, name, price, category) {
        return new Product(id, name, price, category);
    }
}

class OrderItem {
    constructor(product, quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    static new(product, quantity) {
        return new OrderItem(product, quantity);
    }
}

class Order {
    constructor(id, user, items, status) {
        this.id = id;
        this.user = user;
        this.items = items;
        this.status = status;
    }

    static new(id, user, items, status) {
        return new Order(id, user, items, status);
    }
}

// ============================================================================
// Инициализация данных
// ============================================================================

const users = [
    User.new(1, "John Doe", "john@example.com"),
    User.new(2, "Jane Smith", "jane@example.com"),
    User.new(3, "Bob Johnson", "bob@example.com"),
];

const products = [
    Product.new(1, "iPhone", 999.99, "electronics"),
    Product.new(2, "MacBook", 1999.99, "electronics"),
    Product.new(3, "T-shirt", 29.99, "clothing"),
    Product.new(4, "Jeans", 79.99, "clothing"),
    Product.new(5, "Book", 15.99, "books"),
];

const orders = [
    Order.new(1, users[0], [
        OrderItem.new(products[0], 1),
        OrderItem.new(products[2], 2),
    ], "completed"),
    Order.new(2, users[1], [
        OrderItem.new(products[1], 1),
    ], "pending"),
    Order.new(3, users[0], [
        OrderItem.new(products[3], 3),
    ], "completed"),
    Order.new(4, users[2], [
        OrderItem.new(products[4], 5),
        OrderItem.new(products[2], 1),
    ], "pending"),
];

// ============================================================================
// Функции обработки (функциональный стиль)
// ============================================================================

// Расчет стоимости заказа
const calculateOrderTotal = (order) =>
    order.items.reduce((total, item) => total + (item.product.price * item.quantity), 0);

// Фильтрация по статусу
const filterOrdersByStatus = (orders, status) =>
    orders.filter(order => order.status === status);

// Получить топ N дорогих заказов
const getTopExpensiveOrders = (orders, n) =>
    [...orders]
        .sort((a, b) => calculateOrderTotal(b) - calculateOrderTotal(a))
        .slice(0, n);

// Применить скидку
const applyDiscount = (order, discount) => ({
    ...order,
    items: order.items.map(item => ({
        ...item,
        product: {
            ...item.product,
            price: item.product.price * (1 - discount)
        }
    }))
});

// Группировка по пользователям
const groupOrdersByUser = (orders) =>
    orders.reduce((acc, order) => {
        if (!acc[order.user.id]) {
            acc[order.user.id] = [];
        }
        acc[order.user.id].push(order);
        return acc;
    }, {});

// Расходы пользователей
const calculateUserSpending = (orders) => {
    const spending = orders.reduce((acc, order) => {
        const name = order.user.name;
        acc[name] = (acc[name] || 0) + calculateOrderTotal(order);
        return acc;
    }, {});

    return Object.entries(spending)
        .sort(([, a], [, b]) => b - a);
};

// Поиск по категориям
const findOrdersByCategory = (orders, category) =>
    orders.filter(order =>
        order.items.some(item => item.product.category === category)
    );

// Статистика
const calculateStatistics = (orders) => {
    if (orders.length === 0) return {};

    const totals = orders.map(calculateOrderTotal);

    return {
        total_orders: orders.length,
        completed_orders: filterOrdersByStatus(orders, "completed").length,
        pending_orders: filterOrdersByStatus(orders, "pending").length,
        total_revenue: totals.reduce((a, b) => a + b, 0),
        average_order: totals.reduce((a, b) => a + b, 0) / totals.length,
        max_order: Math.max(...totals),
        min_order: Math.min(...totals),
    };
};

// ============================================================================
// Демонстрация
// ============================================================================

function main() {
    console.log("\n" + "█".repeat(70));
    console.log("ЛАБОРАТОРНАЯ РАБОТА 6. ЧАСТЬ 6 - СРАВНИТЕЛЬНЫЙ АНАЛИЗ ФП");
    console.log("Реализация на JAVASCRIPT\n" + "█".repeat(70));

    console.log("\n" + "=".repeat(70));
    console.log("✅ АНАЛИЗ ЗАКАЗОВ (JAVASCRIPT)");
    console.log("=".repeat(70));

    // 1. Завершенные заказы
    console.log("\n✓ Завершенные заказы:");
    const completed = filterOrdersByStatus(orders, "completed");
    completed.forEach(order => {
        console.log(`  Заказ ${order.id}: ${order.user.name} - $${calculateOrderTotal(order).toFixed(2)}`);
    });

    // 2. Общая выручка
    const totalRevenue = completed.reduce((sum, order) => sum + calculateOrderTotal(order), 0);
    console.log(`\n✓ Общая выручка (завершенные): $${totalRevenue.toFixed(2)}`);

    // 3. Топ дорогие заказы
    console.log("\n✓ Топ-2 самых дорогих заказа:");
    const topOrders = getTopExpensiveOrders(orders, 2);
    topOrders.forEach(order => {
        console.log(`  Заказ ${order.id}: $${calculateOrderTotal(order).toFixed(2)}`);
    });

    // 4. Скидка
    console.log("\n✓ Первый заказ со скидкой 10%:");
    console.log(`  Было: $${calculateOrderTotal(orders[0]).toFixed(2)}`);
    const discounted = applyDiscount(orders[0], 0.1);
    console.log(`  После скидки: $${calculateOrderTotal(discounted).toFixed(2)}`);

    // 5. Группировка
    console.log("\n✓ Заказы по пользователям:");
    const grouped = groupOrdersByUser(orders);
    Object.entries(grouped).forEach(([userId, userOrders]) => {
        const userName = users.find(u => u.id == userId)?.name || "Unknown";
        console.log(`  ${userName}: ${userOrders.length} заказов`);
    });

    // 6. Расходы
    console.log("\n✓ Общие расходы по пользователям:");
    const spending = calculateUserSpending(orders);
    spending.forEach(([name, total]) => {
        console.log(`  ${name}: $${total.toFixed(2)}`);
    });

    // 7. По категориям
    console.log("\n✓ Заказы с электроникой:");
    const electronics = findOrdersByCategory(orders, "electronics");
    console.log(`  Найдено заказов: ${electronics.length}`);
    electronics.forEach(order => {
        console.log(`    Заказ ${order.id}: $${calculateOrderTotal(order).toFixed(2)}`);
    });

    // 8. Статистика
    console.log("\n" + "=".repeat(70));
    console.log("📊 СТАТИСТИКА");
    console.log("=".repeat(70));

    const stats = calculateStatistics(orders);
    console.log(`✓ Всего заказов: ${stats.total_orders}`);
    console.log(`✓ Завершенных: ${stats.completed_orders}`);
    console.log(`✓ В ожидании: ${stats.pending_orders}`);
    console.log(`✓ Общая выручка: $${stats.total_revenue.toFixed(2)}`);
    console.log(`✓ Средний заказ: $${stats.average_order.toFixed(2)}`);
    console.log(`✓ Максимальный заказ: $${stats.max_order.toFixed(2)}`);
    console.log(`✓ Минимальный заказ: $${stats.min_order.toFixed(2)}`);

    // 9. Функциональная композиция
    console.log("\n✓ Цепочка операций (функциональное программирование):");
    const expensive = filterOrdersByStatus(orders, "completed")
        .filter(order => calculateOrderTotal(order) > 50);
    const discountedExpensive = expensive.map(o => applyDiscount(o, 0.05));
    const topResult = getTopExpensiveOrders(discountedExpensive, 1);

    if (topResult.length > 0) {
        const order = topResult[0];
        console.log(`  Заказ ${order.id}: $${calculateOrderTotal(order).toFixed(2)} (после скидки)`);
    }

    console.log("\n" + "=".repeat(70));
    console.log("✅ ВСЕ ОПЕРАЦИИ ЗАВЕРШЕНЫ!");
    console.log("=".repeat(70) + "\n");
}

// ============================================================================
// Запуск
// ============================================================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        User, Product, OrderItem, Order,
        calculateOrderTotal, filterOrdersByStatus, getTopExpensiveOrders,
        applyDiscount, groupOrdersByUser, calculateUserSpending,
        findOrdersByCategory, calculateStatistics
    };
}

main();
