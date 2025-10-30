get_negative_values <- function(df) {
  # Создаем пустой список для хранения результатов
  result_list <- list()
  
  # Перебираем все столбцы dataframe
  for (col_name in names(df)) {
    # Получаем столбец
    column <- df[[col_name]]
    
    # Отбираем только отрицательные значения (исключая NA)
    negative_values <- column[!is.na(column) & column < 0]
    
    # Если в столбце есть отрицательные значения, добавляем их в результат
    if (length(negative_values) > 0) {
      result_list[[col_name]] <- negative_values
    }
  }
  
  # Проверяем, можно ли преобразовать в матрицу
  # Для этого все векторы в списке должны быть одинаковой длины
  if (length(result_list) > 0) {
    lengths <- sapply(result_list, length)
    
    # Если все векторы одинаковой длины, преобразуем в матрицу
    if (length(unique(lengths)) == 1 && all(lengths > 0)) {
      # Создаем матрицу, где каждый столбец - это вектор отрицательных значений
      result_matrix <- matrix(unlist(result_list), 
                              nrow = lengths[1], 
                              ncol = length(result_list),
                              byrow = FALSE)
      
      # Устанавливаем имена столбцов
      colnames(result_matrix) <- names(result_list)
      
      return(result_matrix)
    }
  }
  
  # Если матрицу создать нельзя или список пуст, возвращаем список
  return(result_list)
}

# Тестирование функции на предоставленных примерах
cat("=== Тест 1 ===\n")
test_data1 <- as.data.frame(list(
  V1 = c(-9.7, -10, -10.5, -7.8, -8.9), 
  V2 = c(NA, -10.2, -10.1, -9.3, -12.2), 
  V3 = c(NA, NA, -9.3, -10.9, -9.8)
))
result1 <- get_negative_values(test_data1)
print(result1)

cat("\n=== Тест 2 ===\n")
test_data2 <- as.data.frame(list(
  V1 = c(NA, 0.5, 0.7, 8), 
  V2 = c(-0.3, NA, 2, 1.2), 
  V3 = c(2, -1, -5, -1.2)
))
result2 <- get_negative_values(test_data2)
print(result2)

cat("\n=== Тест 3 ===\n")
test_data3 <- as.data.frame(list(
  V1 = c(NA, -0.5, -0.7, -8), 
  V2 = c(-0.3, NA, -2, -1.2), 
  V3 = c(1, 2, 3, NA)
))
result3 <- get_negative_values(test_data3)
print(result3)

# Дополнительные тесты
cat("\n=== Тест 4 (нет отрицательных значений) ===\n")
test_data4 <- as.data.frame(list(
  V1 = c(1, 2, 3), 
  V2 = c(4, 5, 6), 
  V3 = c(7, 8, 9)
))
result4 <- get_negative_values(test_data4)
print(result4)
cat("\n=== Тест 5 (разное количество отрицательных значений в столбцах) ===\n")
test_data5 <- as.data.frame(list(
  V1 = c(-1, 2, -3, 4, -5), 
  V2 = c(-4, -5, 6, 7, 8), 
  V3 = c(9, 10, 11, 12, 13)
))
result5 <- get_negative_values(test_data5)
print(result5)