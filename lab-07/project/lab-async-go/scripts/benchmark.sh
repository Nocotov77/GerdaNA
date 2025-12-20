#!/bin/bash

# Скрипт для запуска бенчмарков с профилированием
# Использование: bash scripts/benchmark.sh

set -e

echo "🚀 Lab Async Go - Бенчмарки и профилирование"
echo "=================================================="

# Проверка Go
if ! command -v go &> /dev/null; then
    echo "❌ ОШИБКА: Go не установлен"
    exit 1
fi

# Создание папки для результатов
mkdir -p bench_results

echo ""
echo "⏱️  БЕНЧМАРКИ ВСЕ"
echo "=================================================="
go test -bench=. -benchmem ./internal/async/... | tee bench_results/all_benchmarks.txt

echo ""
echo "💾 CPU ПРОФИЛИРОВАНИЕ"
echo "=================================================="
go test -cpuprofile=bench_results/cpu.prof -bench=. ./internal/async/...

echo "📊 Анализ CPU профиля:"
go tool pprof -top bench_results/cpu.prof

echo ""
echo "🧠 MEMORY ПРОФИЛИРОВАНИЕ"
echo "=================================================="
go test -memprofile=bench_results/mem.prof -bench=. ./internal/async/...

echo "📊 Анализ Memory профиля:"
go tool pprof -top bench_results/mem.prof

echo ""
echo "📈 БЕНЧМАРКИ SPECIFIC"
echo "=================================================="
echo "Counter бенчмарк:"
go test -bench=Counter -benchtime=10s -benchmem ./internal/async

echo ""
echo "Worker Pool бенчмарк:"
go test -bench=WorkerPool -benchtime=10s -benchmem ./internal/async

echo ""
echo "HTTP Server бенчмарк:"
go test -bench=Server -benchtime=10s -benchmem ./internal/server

echo ""
echo "✅ ПРОФИЛИРОВАНИЕ ЗАВЕРШЕНО"
echo "=================================================="
echo "Результаты сохранены в bench_results/"
echo ""
echo "Для интерактивного анализа:"
echo "  go tool pprof bench_results/cpu.prof"
echo "  go tool pprof bench_results/mem.prof"