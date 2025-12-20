package main

import (
	"context"
	"fmt"
	"lab-async-go/internal/async"
	"lab-async-go/internal/server"
	"strings"
	"sync"
	"time"
)

func main() {
	fmt.Println("Lab Async Go - Асинхронное программирование в Go")
	fmt.Println(strings.Repeat("=", 60))

	// Пример 1: Базовая горутина
	fmt.Println("\n1. Базовые горутины (WaitGroup)")
	example1BasicGoroutine()

	// Пример 2: Counter с мьютексом
	fmt.Println("\n2. Counter (потокобезопасный)")
	example2Counter()

	// Пример 3: MapConcurrent
	fmt.Println("\n3. MapConcurrent (параллельный map)")
	example3MapConcurrent()

	// Пример 4: FilterConcurrent
	fmt.Println("\n4. FilterConcurrent (параллельная фильтрация)")
	example4FilterConcurrent()

	// Пример 5: ReduceConcurrent
	fmt.Println("\n5. ReduceConcurrent (параллельная редукция)")
	example5ReduceConcurrent()

	// Пример 6: Producer-Consumer
	fmt.Println("\n6. Producer-Consumer паттерн")
	example6ProducerConsumer()

	// Пример 7: Pipeline
	fmt.Println("\n7. Pipeline (конвейер обработки)")
	example7Pipeline()

	// Пример 8: Fan-Out/Fan-In
	fmt.Println("\n8. Fan-Out/Fan-In (распределение нагрузки)")
	example8FanOutFanIn()

	// Пример 9: Worker Pool
	fmt.Println("\n9. Worker Pool")
	example9WorkerPool()

	// Пример 10: HTTP Server
	fmt.Println("\n10. HTTP Server (graceful shutdown)")
	example10HTTPServer()

	fmt.Println("\n" + strings.Repeat("=", 60))
	fmt.Println("Все примеры завершены!")
}

func example1BasicGoroutine() {
	var wg sync.WaitGroup
	for i := 1; i <= 3; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			fmt.Printf("  Горутина %d: работаю\n", id)
			time.Sleep(100 * time.Millisecond)
			fmt.Printf("  Горутина %d: готово\n", id)
		}(i)
	}
	wg.Wait()
	fmt.Println("  ✓ Все горутины завершены")
}

func example2Counter() {
	counter := async.NewCounter()
	var wg sync.WaitGroup

	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for j := 0; j < 100; j++ {
				counter.Increment()
			}
		}()
	}

	wg.Wait()
	fmt.Printf("  ✓ Counter = %d (ожидали 500)\n", counter.Value())
}

func example3MapConcurrent() {
	data := []int{1, 2, 3, 4, 5}
	result := async.MapConcurrent(data, func(x int) int {
		return x * x
	})
	fmt.Printf("  Исходный: %v\n", data)
	fmt.Printf("  Результат (x²): %v\n", result)
}

func example4FilterConcurrent() {
	data := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	result := async.FilterConcurrent(data, func(x int) bool {
		return x%2 == 0 // только четные
	})
	fmt.Printf("  Исходный: %v\n", data)
	fmt.Printf("  Четные: %v\n", result)
}

func example5ReduceConcurrent() {
	data := []int{1, 2, 3, 4, 5}
	sum := async.ReduceConcurrent(data, 0, func(acc, x int) int {
		return acc + x
	})
	fmt.Printf("  Массив: %v\n", data)
	fmt.Printf("  Сумма: %d\n", sum)
}

func example6ProducerConsumer() {
	ch := make(chan int, 10)

	// Producer
	go async.Producer(ch, 5)

	// Consumer
	async.Consumer(ch, 5)
	fmt.Println("  ✓ Обмен данных завершен")
}

func example7Pipeline() {
	ctx := context.Background()
	input := []int{1, 2, 3, 4, 5}

	output := async.Pipeline(ctx, input,
		func(x int) int { return x * 2 },  // Stage 1: x2
		func(x int) int { return x + 10 }, // Stage 2: +10
	)

	fmt.Printf("  Исходный: %v\n", input)
	fmt.Printf("  После pipeline: %v\n", output)
}

func example8FanOutFanIn() {
	ctx := context.Background()
	input := []int{1, 2, 3, 4, 5}

	channels := async.FanOut(ctx, input, 3)
	result := async.FanIn(ctx, channels...)

	fmt.Printf("  Исходный: %v\n", input)
	fmt.Printf("  После Fan-Out/Fan-In: %v\n", result)
}

func example9WorkerPool() {
	pool := async.NewWorkerPool(3)
	tasks := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

	results := pool.ProcessTasks(tasks, func(task int) string {
		return fmt.Sprintf("результат-%d", task*task)
	})

	fmt.Printf("  Задач: %d\n", len(tasks))
	fmt.Printf("  Результатов: %d\n", len(results))
	fmt.Printf("  Примеры: %v\n", results[:3])
}

func example10HTTPServer() {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	srv := server.NewServer(":8080")
	go srv.Start()
	defer srv.Stop(ctx)

	fmt.Println("  ✓ Сервер запущен на :8080")
	fmt.Println("  ✓ Graceful shutdown включен")
	time.Sleep(2 * time.Second)
}
