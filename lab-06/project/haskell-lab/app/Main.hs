module Main where

import Lib

main :: IO ()
main = do
    putStrLn "=== Демонстрация работы функций ==="
    putStrLn ""

    -- Базовые функции
    putStrLn "--- Базовые функции ---"
    putStrLn $ "square 5 = " ++ show (square 5)
    putStrLn $ "add 3 4 = " ++ show (add 3 4)
    putStrLn $ "grade 85 = " ++ grade 85
    putStrLn $ "absolute (-10) = " ++ show (absolute (-10))
    putStrLn ""

    -- Рекурсия
    putStrLn "--- Рекурсия ---"
    putStrLn $ "factorial 5 = " ++ show (factorial 5)
    putStrLn $ "sumList [1..5] = " ++ show (sumList [1,2,3,4,5])
    putStrLn $ "length' [1..5] = " ++ show (length' [1,2,3,4,5])
    putStrLn $ "fibonacci 7 = " ++ show (fibonacci 7)
    putStrLn ""

    -- Pattern matching
    putStrLn "--- Pattern matching ---"
    putStrLn $ "addVectors (1,2) (3,4) = " ++ show (addVectors (1,2) (3,4))
    putStrLn $ "first (1,2,3) = " ++ show (first ((1,2,3) :: (Int, Int, Int)))
    putStrLn $ "describeList [] = " ++ describeList ([] :: [Int])
    putStrLn $ "describeList [1,2,3] = " ++ describeList [1,2,3]
    putStrLn ""

    -- Функции высшего порядка
    putStrLn "--- Функции высшего порядка ---"
    putStrLn $ "map' square [1..4] = " ++ show (map' square [1,2,3,4])
    putStrLn $ "filter' even [1..6] = " ++ show (filter' even [1,2,3,4,5,6])
    putStrLn $ "myFoldl (+) 0 [1..5] = " ++ show (myFoldl (+) 0 [1,2,3,4,5])
    putStrLn ""

    -- Алгебраические типы
    putStrLn "--- Алгебраические типы ---"
    putStrLn $ "distance (Point 0 0) (Point 3 4) = " ++ show (distance (Point 0 0) (Point 3 4))
    putStrLn $ "isWeekend Saturday = " ++ show (isWeekend Saturday)
    putStrLn $ "isWeekend Monday = " ++ show (isWeekend Monday)
    putStrLn ""

    -- Решения практических заданий
    putStrLn "--- Практические задания ---"
    putStrLn $ "countEven [1,2,3,4,5,6] = " ++ show (countEven [1,2,3,4,5,6])
    putStrLn $ "positiveSquares [-2,-1,0,1,2,3] = " ++ show (positiveSquares [-2,-1,0,1,2,3])
    putStrLn $ "bubbleSort [5,2,8,1,9] = " ++ show (bubbleSort [5,2,8,1,9])
    putStrLn ""

    putStrLn "=== Все примеры выполнены успешно! ==="
