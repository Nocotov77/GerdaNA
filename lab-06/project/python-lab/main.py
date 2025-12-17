"""
ЛАБОРАТОРНАЯ РАБОТА 6. ЧАСТЬ 2
Функциональное программирование в Python
Полный файл со всеми концепциями и заданиями
"""

import time
from functools import reduce, wraps

# ============================================================================
# 1. ФУНКЦИИ КАК ОБЪЕКТЫ ПЕРВОГО КЛАССА
# ============================================================================

print("\n" + "=" * 70)
print("1. ФУНКЦИИ КАК ОБЪЕКТЫ ПЕРВОГО КЛАССА")
print("=" * 70)


def square(x):
    return x * x


def cube(x):
    return x * x * x


# Присваивание функции переменной
my_function = square
print(f"square(5) = {square(5)}")
print(f"my_function(5) = {my_function(5)}")


# Функции можно передавать как аргументы
def apply_function(func, value):
    """Применяет функцию к значению"""
    return func(value)


print(f"apply_function(square, 4) = {apply_function(square, 4)}")
print(f"apply_function(cube, 3) = {apply_function(cube, 3)}")


# Функции можно возвращать из функций
def create_multiplier(factor):
    """Создает функцию-умножитель"""

    def multiplier(x):
        return x * factor

    return multiplier


double = create_multiplier(2)
triple = create_multiplier(3)

print(f"double(10) = {double(10)}")
print(f"triple(10) = {triple(10)}")

# ============================================================================
# 2. LAMBDA-ФУНКЦИИ И ЗАМЫКАНИЯ
# ============================================================================

print("\n" + "=" * 70)
print("2. LAMBDA-ФУНКЦИИ И ЗАМЫКАНИЯ")
print("=" * 70)

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Lambda с map
squares = list(map(lambda x: x * x, numbers))
print(f"Квадраты: {squares}")

# Lambda с filter
even_numbers = list(filter(lambda x: x % 2 == 0, numbers))
print(f"Четные числа: {even_numbers}")

# Сложные lambda-функции
complex_operation = lambda x: x**2 + 2 * x + 1
result = [complex_operation(x) for x in range(5)]
print(f"Результат сложной операции (x^2 + 2x + 1): {result}")


# Замыкания
def create_counter():
    """Создает счетчик с замыканием"""
    count = 0

    def counter():
        nonlocal count
        count += 1
        return count

    return counter


# Создаем два независимых счетчика
counter1 = create_counter()
counter2 = create_counter()

print(f"Счетчик 1: {[counter1() for _ in range(3)]}")
print(f"Счетчик 2: {[counter2() for _ in range(2)]}")

# ============================================================================
# 3. ФУНКЦИИ ВЫСШЕГО ПОРЯДКА (map, filter, reduce)
# ============================================================================

print("\n" + "=" * 70)
print("3. ФУНКЦИИ ВЫСШЕГО ПОРЯДКА: map, filter, reduce")
print("=" * 70)

# Данные для работы
students = [
    {"name": "Alice", "grade": 85, "age": 20},
    {"name": "Bob", "grade": 92, "age": 22},
    {"name": "Charlie", "grade": 78, "age": 19},
    {"name": "Diana", "grade": 95, "age": 21},
    {"name": "Eve", "grade": 88, "age": 20},
]

# map - преобразование данных
student_names = list(map(lambda student: student["name"], students))
print(f"Имена студентов (map): {student_names}")

# filter - фильтрация данных
top_students = list(filter(lambda student: student["grade"] >= 90, students))
print(f"Студенты с оценкой >= 90: {[s['name'] for s in top_students]}")

# reduce - свертка данных
product = reduce(lambda x, y: x * y, numbers)
print(f"Произведение чисел от 1 до 10: {product}")


# Комбинирование функций
def process_student_data(students):
    """Обработка данных студентов с использованием ФП"""
    result = list(
        map(
            lambda s: {
                "name": s["name"].upper(),
                "status": "Excellent" if s["grade"] >= 90 else "Good",
            },
            filter(lambda s: s["grade"] >= 80, students),
        )
    )
    return result


processed_data = process_student_data(students)
print(f"Обработанные данные: {processed_data}")

# ЗАДАНИЕ 1: Анализ студентов
print("\n--- ЗАДАНИЕ 1: Анализ студентов ---")


def analyze_students(students):
    """Анализ данных студентов"""
    # Средний балл через reduce
    avg_grade = reduce(lambda acc, s: acc + s["grade"], students, 0) / len(students)

    # Список отличников через filter
    excellent_students = list(filter(lambda s: s["grade"] >= 90, students))

    # Общее количество
    total_count = len(students)

    return {
        "average_grade": avg_grade,
        "excellent_students": excellent_students,
        "total_count": total_count,
    }


analysis_result = analyze_students(students)
print(f"Средний балл: {analysis_result['average_grade']:.2f}")
print(f"Отличники: {[s['name'] for s in analysis_result['excellent_students']]}")
print(f"Всего студентов: {analysis_result['total_count']}")

# ============================================================================
# 4. СПИСКОВЫЕ ВКЛЮЧЕНИЯ И ГЕНЕРАТОРЫ
# ============================================================================

print("\n" + "=" * 70)
print("4. СПИСКОВЫЕ ВКЛЮЧЕНИЯ И ГЕНЕРАТОРЫ")
print("=" * 70)

# Простые включения
squares = [x * x for x in numbers]
print(f"Квадраты (list comprehension): {squares}")

# Включения с условием
even_squares = [x * x for x in numbers if x % 2 == 0]
print(f"Квадраты четных (с условием): {even_squares}")

# Словарные включения
student_dict = {student["name"]: student["grade"] for student in students}
print(f"Словарь студентов: {student_dict}")

# Множества (set) включения
unique_ages = {student["age"] for student in students}
print(f"Уникальные возрасты: {sorted(unique_ages)}")


# Генератор Фибоначчи
def fibonacci_generator(limit):
    """Генератор чисел Фибоначчи"""
    a, b = 0, 1
    count = 0
    while count < limit:
        yield a
        a, b = b, a + b
        count += 1


print("\nЧисла Фибоначчи (первые 10):")
fib_list = list(fibonacci_generator(10))
print(fib_list)

# Генераторные выражения
squares_gen = (x * x for x in numbers)
print(f"Генератор квадратов: {list(squares_gen)}")

# ЗАДАНИЕ 3: Генератор простых чисел
print("\n--- ЗАДАНИЕ 3: Генератор простых чисел ---")


def prime_generator():
    """Генератор простых чисел"""
    yield 2
    candidates = 3

    while True:
        is_prime = True
        for divisor in range(2, int(candidates**0.5) + 1):
            if candidates % divisor == 0:
                is_prime = False
                break

        if is_prime:
            yield candidates

        candidates += 2


# Использование генератора простых чисел
prime_gen = prime_generator()
primes = [next(prime_gen) for _ in range(10)]
print(f"Первые 10 простых чисел: {primes}")

# ============================================================================
# 5. ДЕКОРАТОРЫ
# ============================================================================

print("\n" + "=" * 70)
print("5. ДЕКОРАТОРЫ")
print("=" * 70)


# Простой декоратор
def timer(func):
    """Декоратор для измерения времени выполнения"""

    @wraps(func)
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        end_time = time.time()
        print(
            f"  ⏱️  Функция '{func.__name__}' выполнилась за {end_time - start_time:.4f} секунд"
        )
        return result

    return wrapper


# Декоратор с параметрами
def repeat(num_times=2):
    """Декоратор для повторного выполнения функции"""

    def decorator_repeat(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for i in range(num_times):
                result = func(*args, **kwargs)
            return result

        return wrapper

    return decorator_repeat


# Применение декораторов
@timer
def slow_function():
    """Медленная функция для демонстрации"""
    time.sleep(0.2)
    return "Готово!"


@repeat(num_times=3)
def greet(name):
    """Функция приветствия"""
    print(f"  👋 Привет, {name}!")


print("Тест timer декоратора:")
slow_function()

print("\nТест repeat декоратора (3 раза):")
greet("Иван")


# Декоратор для кэширования
def cache(func):
    """Простой декоратор для кэширования"""
    cached_results = {}

    @wraps(func)
    def wrapper(*args):
        if args in cached_results:
            print(f"  💾 Кэш для {args}")
            return cached_results[args]
        print(f"  🔄 Вычисление для {args}...")
        result = func(*args)
        cached_results[args] = result
        return result

    return wrapper


@cache
def expensive_operation(x):
    """Дорогая операция"""
    time.sleep(0.2)
    return x * x


print("\nТест cache декоратора:")
print(f"expensive_operation(5) = {expensive_operation(5)}")
print(f"expensive_operation(5) = {expensive_operation(5)}")  # Должен использовать кэш
print(f"expensive_operation(10) = {expensive_operation(10)}")

# ЗАДАНИЕ 2: Логирование (декоратор)
print("\n--- ЗАДАНИЕ 2: Логирование (декоратор) ---")


def logger(func):
    """Декоратор для логирования"""

    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"  📋 [LOG] Вызов функции: {func.__name__}")
        print(f"  📋 [LOG] Аргументы: args={args}, kwargs={kwargs}")
        try:
            result = func(*args, **kwargs)
            print(f"  📋 [LOG] Результат: {result}")
            return result
        except Exception as e:
            print(f"  📋 [LOG] Ошибка: {e}")
            raise

    return wrapper


@logger
def add(a, b):
    """Сложение двух чисел"""
    return a + b


add(5, 3)

# ============================================================================
# ИТОГОВАЯ ДЕМОНСТРАЦИЯ
# ============================================================================

print("\n" + "=" * 70)
print("ИТОГОВАЯ ДЕМОНСТРАЦИЯ: Комбинирование всех концепций")
print("=" * 70)

# Комплексный пример: обработка данных с использованием всех концепций
print("\nОбработка данных студентов:")

# Используем функции высшего порядка + списковые включения + lambda
result = {
    name.upper(): grade
    for name, grade in map(
        lambda s: (s["name"], s["grade"]), filter(lambda s: s["grade"] >= 85, students)
    )
}
print(f"Студенты с оценкой >= 85: {result}")

# Используем reduce + map + lambda
total_sum = reduce(
    lambda acc, grade: acc + grade, map(lambda s: s["grade"], students), 0
)
print(f"Сумма всех оценок: {total_sum}")


# Используем генератор для обработки большого потока данных
def grade_range_generator(min_grade, max_grade):
    """Генератор студентов в диапазоне оценок"""
    for student in students:
        if min_grade <= student["grade"] <= max_grade:
            yield student


print("\nСтуденты с оценкой от 80 до 90:")
for student in grade_range_generator(80, 90):
    print(f"  • {student['name']}: {student['grade']}")

# ============================================================================
# КОНТРОЛЬНЫЕ ВОПРОСЫ (Кратко)
# ============================================================================

print("\n" + "=" * 70)
print("КРАТКИЕ ОТВЕТЫ НА КОНТРОЛЬНЫЕ ВОПРОСЫ")
print("=" * 70)

print(
    """
1️⃣  Функции первого класса:
   • Можно присваивать переменным: f = square
   • Передавать как аргументы: apply_function(square, 5)
   • Возвращать из функций: return multiplier
   • Хранить в структурах: functions = [square, cube]

2️⃣  Lambda vs обычные функции:
   • Lambda: одна строка, анонимная, для коротких операций
   • Обычные: многострочные, именованные, сложная логика

3️⃣  Замыкания:
   • Функция запомнит переменные из окружения
   • Используется для: фабрик функций, инкапсуляции, кэширования

4️⃣  Декораторы:
   • Функция, которая модифицирует другую функцию
   • С параметрами: @decorator(param) def func(): pass

5️⃣  Генераторы vs списки:
   • Генераторы: ленивое вычисление, экономия памяти
   • Списки: всё в памяти, но быстрый доступ
"""
)

print("\n" + "=" * 70)
print("✅ ВСЕ ПРИМЕРЫ ВЫПОЛНЕНЫ УСПЕШНО!")
print("=" * 70 + "\n")
