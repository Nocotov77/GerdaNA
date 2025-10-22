# Конструктор класса Копилка
piggy_bank <- function(capacity = 1000, current_amount = 0, material = "керамика", broken = FALSE) {
  # Проверка корректности параметров
  if (!is.numeric(capacity) || capacity <= 0) {
    stop("Вместимость должна быть положительным числом")
  }
  
  if (!is.numeric(current_amount) || current_amount < 0) {
    stop("Текущая сумма должна быть неотрицательным числом")
  }
  
  if (current_amount > capacity) {
    stop("Текущая сумма не может превышать вместимость копилки")
  }
  
  if (!is.logical(broken)) {
    stop("Статус 'broken' должен быть логическим значением")
  }
  
  structure(
    list(
      capacity = capacity,
      current_amount = current_amount,
      material = material,
      broken = broken,
      creation_date = Sys.Date()
    ),
    class = "piggy_bank"
  )
}

# Метод для добавления денег
add_money <- function(x, amount) {
  UseMethod("add_money")
}

add_money.piggy_bank <- function(x, amount) {
  if (x$broken) {
    message("Копилка сломана! Нельзя добавить деньги.")
    return(x)
  }
  
  if (!is.numeric(amount) || amount <= 0) {
    message("Сумма для добавления должна быть положительным числом")
    return(x)
  }
  
  if (x$current_amount + amount > x$capacity) {
    message("Нельзя добавить деньги: копилка переполнится!")
    return(x)
  }
  
  x$current_amount <- x$current_amount + amount
  message(paste("Добавлено", amount, "денег. Текущая сумма:", x$current_amount))
  
  # Проверка на заполненность
  if (x$current_amount == x$capacity) {
    message("Копилка полностью заполнена!")
  }
  
  return(x)
}

# Метод для разбития копилки
break_bank <- function(x) {
  UseMethod("break_bank")
}

break_bank.piggy_bank <- function(x) {
  if (x$broken) {
    message("Копилка уже сломана!")
    return(x)
  }
  
  message(paste("Разбиваем копилку... Достаем", x$current_amount, "денег!"))
  x$broken <- TRUE
  x$current_amount <- 0
  message("Копилка сломана. Больше нельзя добавлять деньги.")
  
  return(x)
}

# Метод для проверки баланса
check_balance <- function(x) {
  UseMethod("check_balance")
}

check_balance.piggy_bank <- function(x) {
  message(paste("Текущий баланс:", x$current_amount, "/", x$capacity))
  message(paste("Свободное место:", x$capacity - x$current_amount))
  invisible(x$current_amount)
}

# Метод для тряски копилки (проверка наполненности)
shake_bank <- function(x) {
  UseMethod("shake_bank")
}

shake_bank.piggy_bank <- function(x) {
  if (x$current_amount == 0) {
    message("Копилка пустая и почти не гремит")
  } else if (x$current_amount < x$capacity / 2) {
    message("Слышен небольшой звон монет")
  } else if (x$current_amount < x$capacity) {
    message("Копилка гремит довольно громко")
  } else {
    message("Копилка не гремит - она полностью заполнена!")
  }
  
  return(x)
}

# Метод для отображения информации о копилке
print.piggy_bank <- function(x, ...) {
  cat("Копилка\n")
  cat("Материал:", x$material, "\n")
  cat("Вместимость:", x$capacity, "\n")
  cat("Текущая сумма:", x$current_amount, "\n")
  cat("Статус:", ifelse(x$broken, "сломана", "целая"), "\n")
  cat("Дата создания:", as.character(x$creation_date), "\n")
  cat("Заполненность:", round((x$current_amount / x$capacity) * 100, 1), "%\n")
  invisible(x)
}

# Демонстрация работы
cat("=== Демонстрация работы класса Копилка ===\n\n")

# Создание копилок
cat("1. Создание копилки со значениями по умолчанию:\n")
bank1 <- piggy_bank()
print(bank1)

cat("\n2. Создание копилки с заданными параметрами:\n")
bank2 <- piggy_bank(capacity = 5000, current_amount = 1000, material = "стекло")
print(bank2)

cat("\n3. Работа с первой копилкой:\n")
bank1 <- add_money(bank1, 100)
bank1 <- add_money(bank1, 50)
check_balance(bank1)
bank1 <- shake_bank(bank1)

cat("\n4. Попытка добавить слишком много денег:\n")
bank1 <- add_money(bank1, 1000)

cat("\n5. Заполнение копилки до конца:\n")
bank1 <- add_money(bank1, bank1$capacity - bank1$current_amount)
check_balance(bank1)
bank1 <- shake_bank(bank1)

cat("\n6. Разбитие копилки:\n")
bank1 <- break_bank(bank1)
print(bank1)

cat("\n7. Попытка добавить деньги в сломанную копилку:\n")
bank1 <- add_money(bank1, 100)

cat("\n8. Создание и использование металлической копилки:\n")
metal_bank <- piggy_bank(capacity = 2000, material = "металл")
metal_bank <- add_money(metal_bank, 500)
metal_bank <- add_money(metal_bank, 300)
check_balance(metal_bank)
metal_bank <- shake_bank(metal_bank)

cat("\n9. Информация о всех копилках:\n")
print(bank1)
print(bank2)
print(metal_bank)