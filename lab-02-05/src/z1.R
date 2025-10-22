# Устанавливаем и загружаем необходимые пакеты
if (!require(repurrrsive)) install.packages("repurrrsive")
if (!require(purrr)) install.packages("purrr")
if (!require(tidyverse)) install.packages("tidyverse")

library(repurrrsive)
library(purrr)
library(tidyverse)

# Смотрим на структуру исходного списка sw_films
str(sw_films[1:2], max.level = 1)

# Создаем именованный список с названиями фильмов в качестве имен
named_sw_films <- sw_films %>% 
  set_names(map_chr(sw_films, "title"))

# Проверяем результат
str(named_sw_films[1:2], max.level = 1)
names(named_sw_films)

# Альтернативный вариант с использованием map
named_sw_films_alt <- map(sw_films, ~.x) %>% 
  set_names(map_chr(sw_films, "title"))

# Проверяем, что структура сохранилась идентичной
identical(sw_films[[1]], named_sw_films[[1]])
identical(sw_films[[1]], named_sw_films[["A New Hope"]])

# Демонстрация доступа к элементам по разным способам
cat("Доступ по индексу (первый элемент):\n")
print(names(named_sw_films[[1]]))

cat("\nДоступ по имени ('A New Hope'):\n")
print(names(named_sw_films[["A New Hope"]]))

cat("\nДоступ с использованием $:\n")
print(names(named_sw_films$`A New Hope`))

# Показываем все названия фильмов
cat("\nНазвания всех фильмов:\n")
walk(names(named_sw_films), ~cat(.x, "\n"))

# Функциональный подход с явным использованием pipe и map
named_sw_films_func <- sw_films %>%
  map(identity) %>%  # Проходим по всем элементам без изменений
  set_names(sw_films %>% map_chr("title"))  # Устанавливаем имена из поля title

# Проверяем эквивалентность
identical(named_sw_films, named_sw_films_func)

# Дополнительная проверка - извлекаем некоторые данные
cat("\nРежиссеры фильмов:\n")
imap(named_sw_films, ~{
  cat(.y, ": ", .x$director, "\n")
})

cat("\nДаты выхода:\n")
map2_chr(named_sw_films, names(named_sw_films), ~{
  paste(.y, "вышел", .x$release_date)
}) %>% walk(cat, sep = "\n")