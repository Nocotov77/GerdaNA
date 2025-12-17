// ЛАБОРАТОРНАЯ РАБОТА 6. ЧАСТЬ 4 - SCALA И ФУНКЦИОНАЛЬНОЕ ПРОГРАММИРОВАНИЕ
// ПОЛНОСТЬЮ ИСПРАВЛЕННАЯ ВЕРСИЯ (Scala 3.x совместимая)

import scala.collection.immutable.List

// ============================================================================
// УТИЛИТЫ РАСШИРЕНИЯ (для поддержки старых методов)
// ============================================================================

extension (s: String) {
  def repeat(n: Int): String = s * n
  def takeLast(n: Int): String = if (s.length >= n) s.substring(s.length - n) else s
}

// ============================================================================
// 1. БАЗОВЫЙ СИНТАКСИС И ФУНКЦИИ
// ============================================================================

object BasicScala {

  // Функции первого класса
  val square: Int => Int = (x: Int) => x * x
  val add: (Int, Int) => Int = (a, b) => a + b

  // Функции высшего порядка
  def applyFunction(f: Int => Int, x: Int): Int = f(x)

  // Каррирование
  def multiply(a: Int)(b: Int): Int = a * b
  val double = multiply(2)

  // Рекурсия
  def factorial(n: Int): Int = {
    if (n <= 1) 1
    else n * factorial(n - 1)
  }

  // Хвостовая рекурсия
  def factorialTailrec(n: Int): Int = {
    @scala.annotation.tailrec
    def loop(acc: Int, n: Int): Int = {
      if (n <= 1) acc
      else loop(acc * n, n - 1)
    }
    loop(1, n)
  }

  def main(args: Array[String]): Unit = {
    println("\n" + "=".repeat(70))
    println("1. БАЗОВЫЙ СИНТАКСИС И ФУНКЦИИ SCALA")
    println("=".repeat(70))

    println(s"✓ Квадрат 5: ${square(5)}")
    println(s"✓ Сложение 3 и 4: ${add(3, 4)}")
    println(s"✓ Применение функции: ${applyFunction(square, 3)}")
    println(s"✓ Удвоение 7: ${double(7)}")
    println(s"✓ Факториал 5: ${factorial(5)}")
    println(s"✓ Факториал хвостовой 5: ${factorialTailrec(5)}")
  }
}

// ============================================================================
// 2. КОЛЛЕКЦИИ И ФУНКЦИИ ВЫСШЕГО ПОРЯДКА
// ============================================================================

object Collections {

  case class Product(id: Int, name: String, price: Double, category: String, inStock: Boolean)

  val products = List(
    Product(1, "iPhone", 999.99, "electronics", true),
    Product(2, "MacBook", 1999.99, "electronics", false),
    Product(3, "T-shirt", 29.99, "clothing", true),
    Product(4, "Jeans", 79.99, "clothing", true),
    Product(5, "Book", 15.99, "education", false)
  )

  val numbers = List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

  def demonstrateCollections(): Unit = {
    println("\n" + "=".repeat(70))
    println("2. КОЛЛЕКЦИИ И ФУНКЦИИ ВЫСШЕГО ПОРЯДКА")
    println("=".repeat(70))

    // Map
    val productNames = products.map(_.name)
    println(s"✓ Названия продуктов: ${productNames.mkString(", ")}")

    // Map с преобразованием
    val discountedPrices = products.map(p => p.copy(price = p.price * 0.9))
    println(s"✓ Первый продукт со скидкой: ${discountedPrices.head}")

    // Filter
    val availableProducts = products.filter(_.inStock)
    println(s"✓ Доступные продукты: ${availableProducts.map(_.name).mkString(", ")}")

    // Reduce
    val totalPrice = products.map(_.price).reduce(_ + _)
    val priceFormatted = String.format("%.2f", totalPrice)
    println(s"✓ Общая стоимость (reduce): $$priceFormatted")

    // Fold
    val totalFold = products.foldLeft(0.0)((acc, p) => acc + p.price)
    val foldFormatted = String.format("%.2f", totalFold)
    println(s"✓ Общая стоимость (fold): $$foldFormatted")

    // GroupBy
    val productsByCategory = products.groupBy(_.category)
    println(s"✓ Категории: ${productsByCategory.keys.mkString(", ")}")

    // For-comprehension
    val result = for {
      product <- products
      if product.inStock && product.price > 50
    } yield product.name.toUpperCase()

    println(s"✓ For-comprehension (доступные товары >50): ${result.mkString(", ")}")

    // Цепочка преобразований
    val chainResult = products
      .filter(_.inStock)
      .map(p => (p.name, p.price * 0.8))
      .sortBy(-_._2)
      .take(3)

    println(s"✓ Топ-3 товара со скидкой: ${chainResult.map(_._1).mkString(", ")}")
  }

  def main(args: Array[String]): Unit = {
    demonstrateCollections()
  }
}

// ============================================================================
// 3. OPTION И EITHER ДЛЯ ОБРАБОТКИ ОШИБОК
// ============================================================================

object ErrorHandling {

  case class User(id: Int, name: String, email: String)
  case class Order(userId: Int, amount: Double, status: String)

  val users = Map(
    1 -> User(1, "John Doe", "john@example.com"),
    2 -> User(2, "Jane Smith", "jane@example.com")
  )

  val orders = List(
    Order(1, 99.99, "completed"),
    Order(2, 149.99, "pending"),
    Order(3, 199.99, "shipped")
  )

  def findUser(id: Int): Option[User] = users.get(id)

  def validateUser(user: User): Either[String, User] = {
    if (user.email.contains("@")) Right(user)
    else Left(s"Invalid email for user ${user.name}")
  }

  def processOrder(order: Order): Either[String, (User, Order)] = {
    for {
      user <- findUser(order.userId).toRight(s"User ${order.userId} not found")
      validatedUser <- validateUser(user)
    } yield (validatedUser, order)
  }

  def demonstrateErrorHandling(): Unit = {
    println("\n" + "=".repeat(70))
    println("3. OPTION И EITHER ДЛЯ ОБРАБОТКИ ОШИБОК")
    println("=".repeat(70))

    val user1 = findUser(1)
    val user3 = findUser(3)

    println(s"✓ Пользователь 1: ${user1.map(_.name).getOrElse("Not found")}")
    println(s"✓ Пользователь 3: ${user3.map(_.name).getOrElse("Not found")}")

    val userEmail = findUser(1).map(_.email)
    println(s"✓ Email пользователя 1: ${userEmail.getOrElse("N/A")}")

    val validUser = validateUser(User(1, "John", "john@example.com"))
    val invalidUser = validateUser(User(2, "Jane", "invalid-email"))

    println(s"✓ Валидный пользователь: $validUser")
    println(s"✓ Невалидный пользователь: $invalidUser")

    println("✓ Обработка заказов:")
    orders.foreach { order =>
      processOrder(order) match {
        case Right((user, o)) =>
          println(s"  ✓ Успешно: заказ для ${user.name}: $$${o.amount}")
        case Left(error) =>
          println(s"  ✗ Ошибка: $error")
      }
    }

    val combinedResult = for {
      user1 <- findUser(1).toRight("User 1 not found")
      user2 <- findUser(2).toRight("User 2 not found")
    } yield s"${user1.name} и ${user2.name}"

    println(s"✓ Оба пользователя найдены: ${combinedResult.getOrElse("Error")}")
  }

  def main(args: Array[String]): Unit = {
    demonstrateErrorHandling()
  }
}

// ============================================================================
// 4. PATTERN MATCHING И CASE CLASSES
// ============================================================================

object PatternMatching {

  sealed trait PaymentMethod
  case class CreditCard(number: String, expiry: String) extends PaymentMethod
  case class PayPal(email: String) extends PaymentMethod
  case class Crypto(wallet: String) extends PaymentMethod

  sealed trait OrderStatus
  case object Pending extends OrderStatus
  case object Processing extends OrderStatus
  case class Shipped(trackingNumber: String) extends OrderStatus
  case class Delivered(deliveryDate: String) extends OrderStatus
  case class Cancelled(reason: String) extends OrderStatus

  case class Order(id: Int, amount: Double, payment: PaymentMethod, status: OrderStatus)

  def processPayment(payment: PaymentMethod): String = payment match {
    case CreditCard(number, expiry) =>
      s"Кредитная карта: ${number.takeLast(4)} (до $expiry)"
    case PayPal(email) =>
      s"PayPal: $email"
    case Crypto(wallet) =>
      s"Криптовалюта: ${wallet.take(10)}..."
  }

  def canCancelOrder(status: OrderStatus): Boolean = status match {
    case Pending | Processing => true
    case Shipped(_) | Delivered(_) | Cancelled(_) => false
  }

  def demonstratePatternMatching(): Unit = {
    println("\n" + "=".repeat(70))
    println("4. PATTERN MATCHING И CASE CLASSES")
    println("=".repeat(70))

    val orders = List(
      Order(1, 99.99, CreditCard("1234567812345678", "12/25"), Pending),
      Order(2, 149.99, PayPal("user@example.com"), Processing),
      Order(3, 199.99, Crypto("1A2b3C4d5E6f7G8h9I0j"), Shipped("TRACK123")),
      Order(4, 79.99, CreditCard("8765432187654321", "06/24"), Delivered("2024-01-15"))
    )

    println("✓ Обработка платежей:")
    orders.foreach { order =>
      val paymentInfo = processPayment(order.payment)
      val cancelable = if (canCancelOrder(order.status)) "можно отменить" else "нельзя отменить"
      println(s"  Заказ ${order.id}: $paymentInfo - $cancelable")
    }

    val statusDescriptions = orders.map {
      case Order(id, amount, _, Shipped(tracking)) =>
        s"Заказ $id отправлен ($tracking)"
      case Order(id, amount, _, Delivered(date)) =>
        s"Заказ $id доставлен ($date)"
      case Order(id, amount, _, Pending) =>
        s"Заказ $id в ожидании"
      case Order(id, amount, _, _) =>
        s"Заказ $id в обработке"
    }

    println("✓ Описания статусов:")
    statusDescriptions.foreach(desc => println(s"  $desc"))
  }

  def main(args: Array[String]): Unit = {
    demonstratePatternMatching()
  }
}

// ============================================================================
// 5. ПРАКТИЧЕСКИЕ ЗАДАНИЯ
// ============================================================================

object Solutions {

  case class SalesRecord(product: String, category: String, amount: Double)
  case class Employee(name: String, salary: Double, department: String)

  def analyzeSales(sales: List[SalesRecord]): Map[String, (Double, Int)] = {
    sales
      .groupBy(_.category)
      .map { case (category, records) =>
        val totalAmount = records.map(_.amount).sum
        val count = records.length
        (category, (totalAmount, count))
      }
  }

  def validateOrder(amount: Double): Either[String, Double] = {
    if (amount > 0) Right(amount)
    else Left("Amount must be positive")
  }

  def applyDiscount(amount: Double): Either[String, Double] = {
    if (amount > 100) Right(amount * 0.9)
    else Right(amount)
  }

  def processOrderPipeline(amount: Double): Either[String, Double] = {
    for {
      validated <- validateOrder(amount)
      discounted <- applyDiscount(validated)
    } yield discounted
  }

  def analyzeEmployees(employees: List[Employee]): Map[String, Double] = {
    employees
      .groupBy(_.department)
      .map { case (dept, emps) =>
        val avgSalary = emps.map(_.salary).sum / emps.length
        (dept, avgSalary)
      }
  }

  def demonstrateSolutions(): Unit = {
    println("\n" + "=".repeat(70))
    println("5. ПРАКТИЧЕСКИЕ ЗАДАНИЯ")
    println("=".repeat(70))

    val sales = List(
      SalesRecord("iPhone", "electronics", 999.99),
      SalesRecord("Shirt", "clothing", 29.99),
      SalesRecord("MacBook", "electronics", 1999.99),
      SalesRecord("Jeans", "clothing", 79.99)
    )

    val analysis = analyzeSales(sales)
    println("✓ Анализ продаж по категориям:")
    analysis.foreach { case (cat, (total, count)) =>
      val totalFormatted = String.format("%.2f", total)
      println(s"  $cat: $$totalFormatted ($count товаров)")
    }

    println("✓ Обработка заказов с ошибками:")
    List(150.0, 75.0, 0.0, -50.0).foreach { amount =>
      val result = processOrderPipeline(amount)
      result match {
        case Right(finalAmount) =>
          val amountStr = String.format("%.1f", amount)
          val formatted = String.format("%.2f", finalAmount)
          println(s"  $$amountStr: OK -> $$formatted")
        case Left(error) =>
          val amountStr = String.format("%.1f", amount)
          println(s"  $$amountStr: ERROR - $error")
      }
    }

    val employees = List(
      Employee("John", 5000.0, "IT"),
      Employee("Jane", 6000.0, "IT"),
      Employee("Bob", 4000.0, "HR"),
      Employee("Alice", 4500.0, "HR")
    )

    val avgSalaries = analyzeEmployees(employees)
    println("✓ Средние зарплаты по отделам:")
    avgSalaries.foreach { case (dept, avg) =>
      val formatted = String.format("%.2f", avg)
      println(s"  $dept: $$formatted")
    }
  }

  def main(args: Array[String]): Unit = {
    demonstrateSolutions()
  }
}

// ============================================================================
// ГЛАВНАЯ ПРОГРАММА
// ============================================================================

@main def main(): Unit = {
  println("\n" + "█".repeat(70))
  println("ЛАБОРАТОРНАЯ РАБОТА 6. ЧАСТЬ 4 - SCALA И ФУНКЦИОНАЛЬНОЕ ПРОГРАММИРОВАНИЕ")
  println("█".repeat(70))

  try {
    BasicScala.main(Array())
    Collections.main(Array())
    ErrorHandling.main(Array())
    PatternMatching.main(Array())
    Solutions.main(Array())

    println("\n" + "=".repeat(70))
    println("✅ ВСЕ ПРИМЕРЫ ВЫПОЛНЕНЫ УСПЕШНО!")
    println("=".repeat(70) + "\n")
  } catch {
    case e: Exception =>
      println(s"\n❌ Ошибка выполнения: ${e.getMessage}")
      e.printStackTrace()
  }
}
