# Задание 2: Распараллеливание кода

# Подгружаем функцию
mean_of_rnorm <- function(n) {
  random_numbers <- rnorm(n)
  mean(random_numbers)
}

# Способ 1: Использование пакета parallel (базовый)
library(parallel)

# Создаем вычислительный кластер
cl <- makeCluster(detectCores() - 1) # Оставляем одно ядро свободным

# Экспортируем функцию в кластер
clusterExport(cl, "mean_of_rnorm")

# Распараллеленная версия
result_parallel <- parSapply(cl, seq_len(50), function(iter) {
  mean_of_rnorm(10000)
})

# Останавливаем кластер
stopCluster(cl)

# Выводим результаты
cat("Параллельные вычисления завершены\n")
cat("Среднее значение результатов:", mean(result_parallel), "\n")
cat("Стандартное отклонение результатов:", sd(result_parallel), "\n")

# Способ 2: Использование пакета foreach с бэкендом parallel
library(foreach)
library(doParallel)

# Регистрируем параллельный бэкенд
cl <- makeCluster(detectCores() - 1)
registerDoParallel(cl)

# Распараллеленный цикл foreach
result_foreach <- foreach(iter = 1:50, .combine = c) %dopar% {
  mean_of_rnorm(10000)
}

# Останавливаем кластер
stopCluster(cl)

# Выводим результаты
cat("\nПараллельные вычисления с foreach завершены\n")
cat("Среднее значение результатов:", mean(result_foreach), "\n")
cat("Стандартное отклонение результатов:", sd(result_foreach), "\n")

# Сравнение с последовательной версией
cat("\n=== Сравнение с последовательной версией ===\n")

# Последовательная версия (оригинальный код)
result_sequential <- numeric(50)
start_time_seq <- Sys.time()
for(iter in seq_len(50)) {
  result_sequential[iter] <- mean_of_rnorm(10000)
}
end_time_seq <- Sys.time()

# Параллельная версия для сравнения времени
cl <- makeCluster(detectCores() - 1)
clusterExport(cl, "mean_of_rnorm")
start_time_par <- Sys.time()
result_parallel_compare <- parSapply(cl, seq_len(50), function(iter) {
  mean_of_rnorm(10000)
})
end_time_par <- Sys.time()
stopCluster(cl)

# Вывод сравнения
time_seq <- end_time_seq - start_time_seq
time_par <- end_time_par - start_time_par

cat("Время последовательного выполнения:", round(time_seq, 3), "секунд\n")
cat("Время параллельного выполнения:", round(time_par, 3), "секунд\n")
cat("Ускорение:", round(as.numeric(time_seq)/as.numeric(time_par), 2), "раз\n")

# Проверка эквивалентности результатов
cat("Результаты эквивалентны:", all.equal(sort(result_sequential), sort(result_parallel_compare)), "\n")

# Визуализация результатов
par(mfrow = c(1, 2))
hist(result_sequential, main = "Последовательные вычисления", 
     xlab = "Среднее значение", col = "lightblue", border = "black")
abline(v = mean(result_sequential), col = "red", lwd = 2)

hist(result_parallel_compare, main = "Параллельные вычисления", 
     xlab = "Среднее значение", col = "lightgreen", border = "black")
abline(v = mean(result_parallel_compare), col = "red", lwd = 2)

# Возвращаем к обычному отображению графиков
par(mfrow = c(1, 1))

# Финальный результат
cat("\n=== Итоговый результат ===\n")
final_result <- result_parallel_compare
cat("Итоговый вектор результатов (первые 10 элементов):\n")
print(head(final_result, 10))
cat("Сводная статистика:\n")
print(summary(final_result))