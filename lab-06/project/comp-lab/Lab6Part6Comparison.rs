// ЛАБОРАТОРНАЯ РАБОТА 6. ЧАСТЬ 6 - СРАВНИТЕЛЬНЫЙ АНАЛИЗ ФП
// Реализация на RUST (для сравнения с другими языками)

#[derive(Debug, Clone)]
struct User {
    id: u32,
    name: String,
    email: String,
}

#[derive(Debug, Clone)]
struct Product {
    id: u32,
    name: String,
    price: f64,
    category: String,
}

#[derive(Debug, Clone)]
struct OrderItem {
    product: Product,
    quantity: u32,
}

#[derive(Debug, Clone)]
struct Order {
    id: u32,
    user: User,
    items: Vec<OrderItem>,
    status: String,
}

impl User {
    fn new(id: u32, name: &str, email: &str) -> Self {
        User {
            id,
            name: name.to_string(),
            email: email.to_string(),
        }
    }
}

impl Product {
    fn new(id: u32, name: &str, price: f64, category: &str) -> Self {
        Product {
            id,
            name: name.to_string(),
            price,
            category: category.to_string(),
        }
    }
}

impl OrderItem {
    fn new(product: Product, quantity: u32) -> Self {
        OrderItem { product, quantity }
    }
}

impl Order {
    fn new(id: u32, user: User, items: Vec<OrderItem>, status: &str) -> Self {
        Order {
            id,
            user,
            items,
            status: status.to_string(),
        }
    }
}

// ============================================================================
// Функции обработки заказов
// ============================================================================

fn calculate_order_total(order: &Order) -> f64 {
    order.items.iter()
        .map(|item| item.product.price * item.quantity as f64)
        .sum()
}

fn filter_orders_by_status(orders: &[Order], status: &str) -> Vec<Order> {
    orders.iter()
        .filter(|order| order.status == status)
        .cloned()
        .collect()
}

fn get_top_expensive_orders(orders: &[Order], n: usize) -> Vec<Order> {
    let mut sorted_orders = orders.to_vec();
    sorted_orders.sort_by(|a, b| {
        calculate_order_total(b)
            .partial_cmp(&calculate_order_total(a))
            .unwrap_or(std::cmp::Ordering::Equal)
    });
    sorted_orders.into_iter().take(n).collect()
}

fn apply_discount(order: &Order, discount: f64) -> Order {
    let discounted_items: Vec<OrderItem> = order.items.iter()
        .map(|item| {
            let discounted_product = Product {
                price: item.product.price * (1.0 - discount),
                ..item.product.clone()
            };
            OrderItem {
                product: discounted_product,
                ..item.clone()
            }
        })
        .collect();

    Order {
        items: discounted_items,
        ..order.clone()
    }
}

fn group_orders_by_user(orders: &[Order]) -> std::collections::HashMap<u32, Vec<Order>> {
    let mut grouped = std::collections::HashMap::new();
    for order in orders {
        grouped
            .entry(order.user.id)
            .or_insert_with(Vec::new)
            .push(order.clone());
    }
    grouped
}

fn calculate_user_spending(orders: &[Order]) -> Vec<(String, f64)> {
    let mut spending: std::collections::HashMap<String, f64> = std::collections::HashMap::new();
    for order in orders {
        *spending.entry(order.user.name.clone()).or_insert(0.0) += calculate_order_total(order);
    }
    let mut result: Vec<_> = spending.into_iter().collect();
    result.sort_by(|a, b| b.1.partial_cmp(&a.1).unwrap_or(std::cmp::Ordering::Equal));
    result
}

fn main() {
    println!("\n{}", "█".repeat(70));
    println!("ЛАБОРАТОРНАЯ РАБОТА 6. ЧАСТЬ 6 - СРАВНИТЕЛЬНЫЙ АНАЛИЗ ФП");
    println!("Реализация на RUST\n{}", "█".repeat(70));

    // Инициализация данных
    let users = vec![
        User::new(1, "John Doe", "john@example.com"),
        User::new(2, "Jane Smith", "jane@example.com"),
        User::new(3, "Bob Johnson", "bob@example.com"),
    ];

    let products = vec![
        Product::new(1, "iPhone", 999.99, "electronics"),
        Product::new(2, "MacBook", 1999.99, "electronics"),
        Product::new(3, "T-shirt", 29.99, "clothing"),
        Product::new(4, "Jeans", 79.99, "clothing"),
        Product::new(5, "Book", 15.99, "books"),
    ];

    let orders = vec![
        Order::new(
            1,
            users[0].clone(),
            vec![
                OrderItem::new(products[0].clone(), 1),
                OrderItem::new(products[2].clone(), 2),
            ],
            "completed",
        ),
        Order::new(
            2,
            users[1].clone(),
            vec![OrderItem::new(products[1].clone(), 1)],
            "pending",
        ),
        Order::new(
            3,
            users[0].clone(),
            vec![OrderItem::new(products[3].clone(), 3)],
            "completed",
        ),
        Order::new(
            4,
            users[2].clone(),
            vec![
                OrderItem::new(products[4].clone(), 5),
                OrderItem::new(products[2].clone(), 1),
            ],
            "pending",
        ),
    ];

    // ========================================================================
    // Демонстрация функций
    // ========================================================================

    println!("\n{}", "=".repeat(70));
    println!("✅ АНАЛИЗ ЗАКАЗОВ (RUST)");
    println!("{}", "=".repeat(70));

    // 1. Фильтрация по статусу
    println!("\n✓ Завершенные заказы:");
    let completed = filter_orders_by_status(&orders, "completed");
    for order in &completed {
        println!("  Заказ {}: {} - ${:.2}", order.id, order.user.name, calculate_order_total(order));
    }

    // 2. Общая выручка
    let total_revenue: f64 = completed.iter().map(calculate_order_total).sum();
    println!("\n✓ Общая выручка (завершенные): ${:.2}", total_revenue);

    // 3. Топ дорогие заказы
    println!("\n✓ Топ-2 самых дорогих заказа:");
    let top_orders = get_top_expensive_orders(&orders, 2);
    for order in &top_orders {
        println!("  Заказ {}: ${:.2}", order.id, calculate_order_total(order));
    }

    // 4. Скидка
    println!("\n✓ Первый заказ со скидкой 10%:");
    let discounted = apply_discount(&orders[0], 0.1);
    println!("  Было: ${:.2}", calculate_order_total(&orders[0]));
    println!("  После скидки: ${:.2}", calculate_order_total(&discounted));

    // 5. Группировка по пользователям
    println!("\n✓ Заказы по пользователям:");
    let grouped = group_orders_by_user(&orders);
    for (user_id, user_orders) in &grouped {
        let user_name = users.iter()
            .find(|u| u.id == *user_id)
            .map(|u| u.name.as_str())
            .unwrap_or("Unknown");
        println!("  {}: {} заказов", user_name, user_orders.len());
    }

    // 6. Расходы пользователей
    println!("\n✓ Общие расходы по пользователям:");
    let spending = calculate_user_spending(&orders);
    for (name, total) in &spending {
        println!("  {}: ${:.2}", name, total);
    }

    // 7. Статистика
    println!("\n{}", "=".repeat(70));
    println!("📊 СТАТИСТИКА");
    println!("{}", "=".repeat(70));
    println!("✓ Всего заказов: {}", orders.len());
    println!("✓ Завершенных: {}", completed.len());
    println!("✓ В ожидании: {}", filter_orders_by_status(&orders, "pending").len());
    println!("✓ Средняя стоимость заказа: ${:.2}", total_revenue / completed.len() as f64);
    println!("✓ Максимальная стоимость: ${:.2}",
        orders.iter().map(calculate_order_total).fold(0.0, f64::max));

    println!("\n{}", "=".repeat(70));
    println!("✅ ВСЕ ОПЕРАЦИИ ЗАВЕРШЕНЫ!");
    println!("{}", "=".repeat(70) + "\n");
}
