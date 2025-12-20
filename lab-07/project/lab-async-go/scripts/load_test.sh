#!/bin/bash

# Скрипт для нагрузочного тестирования HTTP сервера
# Использование: bash scripts/load_test.sh

set -e

echo "🚀 Lab Async Go - Нагрузочное тестирование"
echo "=========================================="

# Параметры
TARGET_URL="${1:-http://localhost:8080}"
REQUESTS="${2:-1000}"
CONCURRENT="${3:-100}"

# Проверка зависимостей
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "⚠️  $1 не установлен, пропускаем..."
        return 1
    fi
    return 0
}

# Проверка сервера
echo "🔍 Проверка доступности сервера..."
if ! curl -s "$TARGET_URL/health" > /dev/null; then
    echo "❌ ОШИБКА: Сервер не доступен на $TARGET_URL"
    echo "Запустите сервер: go run cmd/main.go"
    exit 1
fi
echo "✓ Сервер доступен"

# Создание папки для результатов
mkdir -p load_test_results
cd load_test_results

echo ""
echo "📊 ПАРАМЕТРЫ ТЕСТИРОВАНИЯ"
echo "=========================================="
echo "Целевой URL: $TARGET_URL"
echo "Количество запросов: $REQUESTS"
echo "Одновременных соединений: $CONCURRENT"
echo ""

# ApacheBench
if check_tool "ab"; then
    echo "🔨 ApacheBench тест"
    echo "=========================================="
    ab -n $REQUESTS -c $CONCURRENT "$TARGET_URL/" 2>&1 | tee ab_results.txt
    echo ""
fi

# wrk (если установлен)
if check_tool "wrk"; then
    echo "⚡ Wrk тест (30 сек)"
    echo "=========================================="
    wrk -t4 -c$CONCURRENT -d30s "$TARGET_URL/" | tee wrk_results.txt
    echo ""
fi

# curl простой тест
echo "📡 Простой curl тест"
echo "=========================================="
echo "Тестирование различных endpoints:"

endpoints=("/" "/health" "/stats" "/echo?message=test" "/delay?seconds=0.1")

for endpoint in "${endpoints[@]}"; do
    echo ""
    echo "GET $endpoint"
    curl -w "Status: %{http_code} | Time: %{time_total}s\n" -s "$TARGET_URL$endpoint" | head -c 100
    echo ""
done

# Простая нагрузка параллельными запросами
echo ""
echo "🔄 Параллельные запросы (10 запросов)"
echo "=========================================="
for i in {1..10}; do
    curl -s "$TARGET_URL/health" -o /dev/null &
done
wait
echo "✓ 10 параллельных запросов завершены"

# Стресс-тест /stats
echo ""
echo "💥 Стресс-тест /stats (50 быстрых запросов)"
echo "=========================================="
start_time=$(date +%s%N)
for i in {1..50}; do
    curl -s "$TARGET_URL/stats" > /dev/null &
done
wait
end_time=$(date +%s%N)
elapsed=$((($end_time - $start_time) / 1000000))
echo "✓ Выполнено за ${elapsed}ms"
echo "  Средний ответ: $((elapsed / 50))ms"

echo ""
echo "✅ НАГРУЗОЧНОЕ ТЕСТИРОВАНИЕ ЗАВЕРШЕНО"
echo "=========================================="
echo "Результаты сохранены в load_test_results/"
echo ""
echo "Для анализа ApacheBench:"
echo "  cat load_test_results/ab_results.txt"
echo ""
echo "Для анализа Wrk:"
echo "  cat load_test_results/wrk_results.txt"

cd ..