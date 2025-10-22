# Конструктор класса Микроволновая печь
microwave_oven <- function(power = 800, door_open = FALSE) {
  # Проверка корректности мощности
  if (!is.numeric(power) || power <= 0) {
    stop("Мощность должна быть положительным числом")
  }
  
  # Проверка корректности состояния дверцы
  if (!is.logical(door_open)) {
    stop("Состояние дверцы должно быть логическим значением (TRUE/FALSE)")
  }
  
  structure(
    list(
      power = power,
      door_open = door_open
    ),
    class = "microwave_oven"
  )
}

# Метод для открытия дверцы
open_door <- function(x) {
  UseMethod("open_door")
}

open_door.microwave_oven <- function(x) {
  if (!x$door_open) {
    x$door_open <- TRUE
    message("Дверца микроволновки открыта")
  } else {
    message("Дверца уже открыта")
  }
  return(x)
}

# Метод для закрытия дверцы
close_door <- function(x) {
  UseMethod("close_door")
}

close_door.microwave_oven <- function(x) {
  if (x$door_open) {
    x$door_open <- FALSE
    message("Дверца микроволновки закрыта")
  } else {
    message("Дверца уже закрыта")
  }
  return(x)
}

# Метод для приготовления пищи
cook <- function(x, food_name = "еда", time_seconds = NULL) {
  UseMethod("cook")
}

cook.microwave_oven <- function(x, food_name = "еда", time_seconds = NULL) {
  # Проверка состояния дверцы
  if (x$door_open) {
    stop("Невозможно начать приготовление: дверца открыта!")
  }
  
  # Если время не указано, вычисляем его на основе мощности
  if (is.null(time_seconds)) {
    # Базовое время для мощности 800 Вт - 60 секунд
    base_time <- 60
    base_power <- 800
    time_seconds <- base_time * (base_power / x$power)
    message(paste("Автоматическое время приготовления:", round(time_seconds, 1), "секунд"))
  }
  
  # Проверка корректности времени
  if (!is.numeric(time_seconds) || time_seconds <= 0) {
    stop("Время приготовления должно быть положительным числом")
  }
  
  message(paste("Приготовление", food_name, "началось..."))
  message(paste("Мощность:", x$power, "Вт"))
  message(paste("Время:", time_seconds, "секунд"))
  
  # Имитация приготовления (бездействие системы)
  Sys.sleep(min(time_seconds, 5))  # Ограничим максимальное время для демонстрации
  
  message(paste(food_name, "готова(о)!"))
  return(x)
}

# Вспомогательная функция для печати информации о микроволновке
print.microwave_oven <- function(x, ...) {
  cat("Микроволновая печь\n")
  cat("Мощность:", x$power, "Вт\n")
  cat("Состояние дверцы:", ifelse(x$door_open, "открыта", "закрыта"), "\n")
  invisible(x)
}

# Демонстрация работы
cat("=== Демонстрация работы класса Микроволновая печь ===\n\n")

# Создание объектов
cat("1. Создание микроволновки со значениями по умолчанию:\n")
oven1 <- microwave_oven()
print(oven1)

cat("\n2. Создание микроволновки с заданными параметрами:\n")
oven2 <- microwave_oven(power = 1200, door_open = TRUE)
print(oven2)

cat("\n3. Работа с первой микроволновкой:\n")
oven1 <- close_door(oven1)
oven1 <- cook(oven1, "суп", 3)

cat("\n4. Работа со второй микроволновкой:\n")
oven2 <- close_door(oven2)
oven2 <- cook(oven2, "картофель")  # Автоматическое время

cat("\n5. Попытка готовки с открытой дверцей:\n")
oven1 <- open_door(oven1)
tryCatch(
  {
    cook(oven1, "еда")
  },
  error = function(e) {
    message("Ошибка: ", e$message)
  }
)

cat("\n6. Приготовление с автоматическим расчетом времени для разной мощности:\n")
oven_low <- microwave_oven(power = 600)
oven_low <- cook(oven_low, "каша")

oven_high <- microwave_oven(power = 1000)
oven_high <- cook(oven_high, "горячий бутерброд")

