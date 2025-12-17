module Lib where

-- ============== BASICS ==============

-- Простые функции
square :: Int -> Int
square x = x * x

-- Функция с двумя параметрами
add :: Int -> Int -> Int
add x y = x + y

-- Условные выражения
absolute :: Int -> Int
absolute x = if x >= 0 then x else -x

-- Охрана (guard)
grade :: Int -> String
grade score
    | score >= 90 = "Excellent"
    | score >= 75 = "Good"
    | score >= 60 = "Satisfactory"
    | otherwise   = "Fail"

-- ============== RECURSION ==============

-- Рекурсивный факториал
factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- Рекурсивная сумма списка
sumList :: [Int] -> Int
sumList [] = 0
sumList (x:xs) = x + sumList xs

-- Длина списка через рекурсию
length' :: [a] -> Int
length' [] = 0
length' (_:xs) = 1 + length' xs

-- Фибоначчи
fibonacci :: Int -> Int
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n-1) + fibonacci (n-2)

-- ============== PATTERNS ==============

-- Pattern matching для кортежей
addVectors :: (Double, Double) -> (Double, Double) -> (Double, Double)
addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- Работа с троичными кортежами
first :: (a, b, c) -> a
first (x, _, _) = x

second :: (a, b, c) -> b
second (_, y, _) = y

third :: (a, b, c) -> c
third (_, _, z) = z

-- Pattern matching в case выражениях
describeList :: [a] -> String
describeList xs = case xs of
    [] -> "Empty list"
    [x] -> "Singleton list"
    _ -> "Long list"

-- ============== HIGHER ORDER ==============

-- Применение функции к каждому элементу
map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map' f xs

-- Фильтрация списка
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' p (x:xs)
    | p x       = x : filter' p xs
    | otherwise = filter' p xs

-- Свертка (fold) — переименована, чтобы избежать конфликта с Prelude.foldl'
myFoldl :: (b -> a -> b) -> b -> [a] -> b
myFoldl _ acc [] = acc
myFoldl f acc (x:xs) = myFoldl f (f acc x) xs

-- Композиция функций
compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

-- ============== TYPES ==============

-- Перечисление
data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
    deriving (Show, Eq)

isWeekend :: Day -> Bool
isWeekend Saturday = True
isWeekend Sunday = True
isWeekend _ = False

-- Продуктовый тип
data Point = Point Double Double
    deriving (Show)

distance :: Point -> Point -> Double
distance (Point x1 y1) (Point x2 y2) = sqrt ((x2 - x1)^2 + (y2 - y1)^2)

-- Рекурсивный тип данных (список)
data List a = Empty | Cons a (List a)
    deriving (Show)

-- Функция для преобразования нашего списка в стандартный
toStandardList :: List a -> [a]
toStandardList Empty = []
toStandardList (Cons x xs) = x : toStandardList xs

-- ============== SOLUTIONS ==============

-- Задание 1: Количество четных чисел в списке
countEven :: [Int] -> Int
countEven [] = 0
countEven (x:xs)
    | even x    = 1 + countEven xs
    | otherwise = countEven xs

-- Альтернативный вариант через фильтр
countEven' :: [Int] -> Int
countEven' xs = length (filter even xs)

-- Задание 2: Список квадратов только положительных чисел
positiveSquares :: [Int] -> [Int]
positiveSquares [] = []
positiveSquares (x:xs)
    | x > 0     = x * x : positiveSquares xs
    | otherwise = positiveSquares xs

-- Альтернативный вариант через map и filter
positiveSquares' :: [Int] -> [Int]
positiveSquares' xs = map (^2) (filter (>0) xs)

-- Задание 3: Пузырьковая сортировка
-- Один проход пузырька
bubblePass :: [Int] -> [Int]
bubblePass []       = []
bubblePass [x]      = [x]
bubblePass (x:y:xs)
    | x > y     = y : bubblePass (x:xs)
    | otherwise = x : bubblePass (y:xs)

-- Полная пузырьковая сортировка
bubbleSort :: [Int] -> [Int]
bubbleSort []  = []
bubbleSort xs  =
    let xs' = bubblePass xs
    in if xs' == xs
       then xs'
       else bubbleSort xs'
