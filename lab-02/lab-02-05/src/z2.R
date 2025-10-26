# Загружаем необходимые пакеты
library(purrr)
library(datasets)

# Просматриваем доступные datasets
# library(help = "datasets")

cat("=== Функции семейства map_* в purrr ===\n\n")

# Создаем тестовые данные
test_list <- list(a = 1:5, b = 6:10, c = 11:15)
test_df <- data.frame(x = 1:5, y = 6:10, z = letters[1:5])
test_numeric <- c(1.5, 2.7, 3.2, 4.8, 5.1)
test_character <- c("apple", "banana", "cherry")
test_logical <- c(TRUE, FALSE, TRUE, TRUE, FALSE)

cat("1. map() - возвращает список:\n")
cat("   Применяет функцию к каждому элементу, возвращает список того же размера\n\n")

result_map <- map(test_list, ~ .x * 2)
print(result_map)

cat("\n2. map_lgl() - возвращает логический вектор:\n")
cat("   Функция должна возвращать логические значения\n\n")

result_lgl <- map_lgl(test_list, ~ mean(.x) > 5)
print(result_lgl)

# Пример с данными iris
cat("\n3. map_int() - возвращает целочисленный вектор:\n")
cat("   Функция должна возвращать целые числа\n\n")

result_int <- map_int(iris, ~ length(unique(.x)))
print(result_int)

cat("\n4. map_dbl() - возвращает числовой вектор (double):\n")
cat("   Функция должна возвращать числа с плавающей точкой\n\n")

result_dbl <- map_dbl(iris[, 1:4], mean)
print(result_dbl)

cat("\n5. map_chr() - возвращает символьный вектор:\n")
cat("   Функция должна возвращать строки\n\n")

result_chr <- map_chr(iris, ~ paste(class(.x), collapse = ", "))
print(result_chr)

cat("\n6. map_dfr() - возвращает data.frame, объединяя по строкам:\n")
cat("   Каждый элемент должен возвращать data.frame или именованный вектор\n\n")

# Разделяем iris по видам
iris_split <- split(iris, iris$Species)
result_dfr <- map_dfr(iris_split, ~ {
  data.frame(
    Species = unique(.x$Species),
    Mean_Sepal.Length = mean(.x$Sepal.Length),
    Mean_Petal.Length = mean(.x$Petal.Length)
  )
})
print(result_dfr)

cat("\n7. map_dfc() - возвращает data.frame, объединяя по столбцам:\n")
cat("   Каждый элемент должен возвращать вектор одинаковой длины\n\n")

result_dfc <- map_dfc(1:3, ~ rnorm(5, mean = .x))
names(result_dfc) <- paste0("col", 1:3)
print(result_dfc)

cat("\n8. walk() - выполняет функцию для побочных эффектов:\n")
cat("   Не возвращает значение, используется для вывода или сохранения\n\n")

walk(test_character, ~ cat("Фрукт:", .x, "\n"))

cat("\n9. map2() - работает с двумя наборами входных данных:\n")
cat("   Итерируется одновременно по двум векторам/спискам\n\n")

x <- 1:3
y <- 4:6
result_map2 <- map2(x, y, ~ .x + .y)
print(result_map2)

cat("\n10. pmap() - работает с произвольным количеством аргументов:\n")
cat("    Принимает список списков для более сложных итераций\n\n")

params <- list(
  list(mean = 0, sd = 1, n = 3),
  list(mean = 5, sd = 2, n = 4),
  list(mean = 10, sd = 3, n = 5)
)

result_pmap <- pmap(params, ~ rnorm(..3, mean = ..1, sd = ..2))
print(result_pmap)

cat("\n11. map_if() - применяет функцию только к элементам, удовлетворяющим условию:\n")
cat("    Полезно для условного применения функций\n\n")

mixed_list <- list(a = 1:3, b = "hello", c = 4:6, d = "world")
result_map_if <- map_if(mixed_list, is.numeric, ~ .x * 2)
print(result_map_if)

cat("\n12. map_at() - применяет функцию только к указанным элементам:\n")
cat("    Указываем конкретные имена или индексы\n\n")

result_map_at <- map_at(test_list, c("a", "c"), ~ .x * 10)
print(result_map_at)

cat("\n13. safely(), possibly(), quietly() - обработка ошибок:\n")
cat("    Полезно при работе с ненадежными операциями\n\n")

# Функция, которая может вызвать ошибку
safe_sqrt <- safely(~ sqrt(.x), otherwise = NA_real_)
result_safe <- map(c(4, 9, -1, 16), safe_sqrt)
print(result_safe)

# possibly - более простой вариант
possible_sqrt <- possibly(~ sqrt(.x), otherwise = NA_real_)
result_possible <- map_dbl(c(4, 9, -1, 16), possible_sqrt)
print(result_possible)

cat("\n14. keep() и discard() - фильтрация элементов:\n")
cat("    keep сохраняет элементы, удовлетворяющие условию, discard - удаляет\n\n")

numbers <- 1:10
kept <- keep(numbers, ~ .x %% 2 == 0)  # четные
discarded <- discard(numbers, ~ .x %% 2 == 0)  # нечетные
cat("Четные:", kept, "\n")
cat("Нечетные:", discarded, "\n")

cat("\n15. reduce() и accumulate() - последовательное применение:\n")
cat("    reduce возвращает конечный результат, accumulate - все промежуточные\n\n")

result_reduce <- reduce(1:5, `*`)
result_accumulate <- accumulate(1:5, `*`)
cat("Факториал 5 (reduce):", result_reduce, "\n")
cat("Факториалы 1-5 (accumulate):", result_accumulate, "\n")

cat("\n=== Сводка отличий ===\n")
cat("• map_* функции различаются типом возвращаемого значения:\n")
cat("  - map: список\n")
cat("  - map_lgl: логический вектор\n")
cat("  - map_int: целочисленный вектор\n")
cat("  - map_dbl: числовой вектор\n")
cat("  - map_chr: символьный вектор\n")
cat("  - map_dfr: data.frame (по строкам)\n")
cat("  - map_dfc: data.frame (по столбцам)\n")
cat("• walk: для побочных эффектов, не возвращает значение\n")
cat("• map2/pmap: для работы с несколькими входными данными\n")
cat("• map_if/map_at: для условного применения\n")
cat("• safely/possibly: для обработки ошибок\n")
cat("• keep/discard: для фильтрации\n")
cat("• reduce/accumulate: для последовательного применения\n")