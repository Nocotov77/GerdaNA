# Создаем исходный вектор
my_vector <- c(21, 18, 21, 19, 25, 20, 17, 17, 18, 22, 17, 18, 18, 19, 19, 27, 21, 20,
               24, 17, 15, 24, 24, 29, 19, 14, 21, 17, 19, 18, 18, 20, 21, 21, 19, 17, 
               21, 13, 17, 13, 23, 15, 23, 24, 16, 17, 25, 24, 22)

# Вычисляем среднее значение и стандартное отклонение
mean_value <- mean(my_vector)
sd_value <- sd(my_vector)

# Выводим вычисленные значения для проверки
cat("Среднее значение:", mean_value, "\n")
cat("Стандартное отклонение:", sd_value, "\n")

# Отбираем наблюдения, которые отклоняются от среднего меньше чем на одно стандартное отклонение
my_vector2 <- my_vector[abs(my_vector - mean_value) < sd_value]

# Проверяем результат
cat("\nИсходный вектор my_vector:\n")
print(my_vector)
cat("Длина исходного вектора:", length(my_vector), "\n")

cat("\nНовый вектор my_vector2:\n")
print(my_vector2)
cat("Длина нового вектора:", length(my_vector2), "\n")

# Дополнительная проверка - покажем какие элементы были отобраны
cat("\nПроверка отбора:\n")
cat("Границы отбора: от", mean_value - sd_value, "до", mean_value + sd_value, "\n")
cat("Количество элементов в исходном векторе:", length(my_vector), "\n")
cat("Количество элементов в новом векторе:", length(my_vector2), "\n")
cat("Отобрано", length(my_vector2), "из", length(my_vector), "элементов\n")

# Визуализируем результат для наглядности
cat("\nВизуализация отбора:\n")
for (i in 1:length(my_vector)) {
  deviation <- abs(my_vector[i] - mean_value)
  if (deviation < sd_value) {
    cat(sprintf("Элемент %2d: %2d (отклонение: %.2f) - ВКЛЮЧЕН\n", i, my_vector[i], deviation))
  } else {
    cat(sprintf("Элемент %2d: %2d (отклонение: %.2f) - исключен\n", i, my_vector[i], deviation))
  }
}