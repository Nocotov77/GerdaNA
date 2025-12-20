# 23 примера использования Lab Async Go

## 1. Базовая горутина с WaitGroup

\`\`\`go
var wg sync.WaitGroup
wg.Add(1)
go func() {
    defer wg.Done()
    fmt.Println("Горутина работает")
}()
wg.Wait()
\`\`\`

## 2. Потокобезопасный счетчик

\`\`\`go
counter := async.NewCounter()
var wg sync.WaitGroup

for i := 0; i < 100; i++ {
    wg.Add(1)
    go func() {
        defer wg.Done()
        counter.Increment()
    }()
}
wg.Wait()
fmt.Println("Счетчик:", counter.Value()) // 100
\`\`\`

## 3. Параллельный Map

\`\`\`go
data := []int{1, 2, 3, 4, 5}
result := async.MapConcurrent(data, func(x int) int {
    return x * x
})
fmt.Println(result) // [1 4 9 16 25]
\`\`\`

## 4. Параллельная фильтрация

\`\`\`go
data := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
evenNumbers := async.FilterConcurrent(data, func(x int) bool {
    return x%2 == 0
})
fmt.Println(evenNumbers) // [2 4 6 8 10]
\`\`\`

## 5. Параллельная редукция (сумма)

\`\`\`go
data := []int{1, 2, 3, 4, 5}
sum := async.ReduceConcurrent(data, 0, func(acc, x int) int {
    return acc + x
})
fmt.Println(sum) // 15
\`\`\`

## 6. Параллельная редукция (произведение)

\`\`\`go
data := []int{1, 2, 3, 4, 5}
product := async.ReduceConcurrent(data, 1, func(acc, x int) int {
    return acc * x
})
fmt.Println(product) // 120
\`\`\`

## 7. Producer-Consumer паттерн

\`\`\`go
ch := make(chan int, 10)

// Производитель
go async.Producer(ch, 5)

// Потребитель
async.Consumer(ch, 5)
fmt.Println("Обмен завершен")
\`\`\`

## 8. Pipeline с двумя этапами

\`\`\`go
ctx := context.Background()
input := []int{1, 2, 3, 4, 5}

output := async.Pipeline(ctx, input,
    func(x int) int { return x * 2 },   // Умножить на 2
    func(x int) int { return x + 10 },  // Добавить 10
)

fmt.Println(output) // [12 14 16 18 20]
\`\`\`

## 9. Pipeline с тремя этапами

\`\`\`go
ctx := context.Background()
input := []int{1, 2, 3}

output := async.Pipeline(ctx, input,
    func(x int) int { return x * 2 },
    func(x int) int { return x + 10 },
    func(x int) int { return x / 2 },
)

fmt.Println(output) // [6 7 8]
\`\`\`

## 10. Fan-Out распределение

\`\`\`go
ctx := context.Background()
input := []int{1, 2, 3, 4, 5}

// Распределяем на 3 горутины
channels := async.FanOut(ctx, input, 3)

// Собираем результаты
result := async.FanIn(ctx, channels...)

fmt.Println(result) // [1 2 3 4 5] (в другом порядке)
\`\`\`

## 11. Объединение каналов

\`\`\`go
ctx := context.Background()

ch1 := make(chan int)
ch2 := make(chan int)

go func() {
    ch1 <- 1
    close(ch1)
}()

go func() {
    ch2 <- 2
    close(ch2)
}()

merged := async.MergeChannels(ctx, ch1, ch2)
for val := range merged {
    fmt.Println(val)
}
\`\`\`

## 12. Worker Pool с 3 рабочими

\`\`\`go
pool := async.NewWorkerPool(3)
tasks := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

results := pool.ProcessTasks(tasks, func(task int) string {
    return fmt.Sprintf("результат-%d", task*task)
})

fmt.Printf("Обработано %d задач\\n", len(results))
\`\`\`

## 13. Dynamic Worker Pool

\`\`\`go
dynamicPool := async.NewDynamicWorkerPool(2, 8)
tasks := []int{1, 2, 3, 4, 5}

for _, task := range tasks {
    dynamicPool.Submit(func() {
        time.Sleep(100 * time.Millisecond)
        fmt.Println("Задача обработана")
    })
}

dynamicPool.Stop()
\`\`\`

## 14. Priority Worker Pool

\`\`\`go
prioPool := async.NewPriorityWorkerPool(4)

// Высокий приоритет
prioPool.Submit(10, func() {
    fmt.Println("Важная задача")
})

// Низкий приоритет
prioPool.Submit(1, func() {
    fmt.Println("Менее важная задача")
})

prioPool.Stop()
\`\`\`

## 15. Rate Limiter - ограничение частоты

\`\`\`go
limiter := async.NewRateLimiter(10) // 10 операций в секунду
defer limiter.Stop()

for i := 0; i < 5; i++ {
    limiter.Wait()
    fmt.Printf("Операция %d выполнена\\n", i+1)
}
\`\`\`

## 16. Semaphore - управление ресурсами

\`\`\`go
sem := async.NewSemaphore(3) // Максимум 3 одновременно

var wg sync.WaitGroup
for i := 0; i < 10; i++ {
    wg.Add(1)
    go func(id int) {
        defer wg.Done()
        sem.Acquire()
        defer sem.Release()
        
        fmt.Printf("Задача %d работает\\n", id)
        time.Sleep(100 * time.Millisecond)
    }(i)
}
wg.Wait()
\`\`\`

## 17. Bounded Queue - ограниченная очередь

\`\`\`go
queue := async.NewBoundedQueue(5)

// Добавляем элементы
queue.Enqueue("элемент-1")
queue.Enqueue("элемент-2")

// Получаем элементы
item := queue.Dequeue()
fmt.Println(item) // "элемент-1"
\`\`\`

## 18. HTTP Server - базовый запуск

\`\`\`go
srv := server.NewServer(":8080")
go srv.Start()

time.Sleep(2 * time.Second)

ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()
srv.Stop(ctx)
\`\`\`

## 19. HTTP Server - concurrent requests

\`\`\`go
srv := server.NewServer(":8080")
go srv.Start()
defer srv.Stop(context.Background())

var wg sync.WaitGroup
for i := 0; i < 100; i++ {
    wg.Add(1)
    go func() {
        defer wg.Done()
        resp, _ := http.Get("http://localhost:8080/health")
        resp.Body.Close()
    }()
}
wg.Wait()
fmt.Println("100 запросов выполнено")
\`\`\`

## 20. Context с отменой

\`\`\`go
ctx, cancel := context.WithCancel(context.Background())

go func() {
    time.Sleep(2 * time.Second)
    cancel() // Отмена после 2 секунд
}()

output := async.Pipeline(ctx, []int{1, 2, 3, 4, 5},
    func(x int) int { return x * 2 },
)
fmt.Println(output)
\`\`\`

## 21. Обработка больших данных с Pipeline

\`\`\`go
// Генерируем 1000 чисел
data := make([]int, 1000)
for i := range data {
    data[i] = i + 1
}

ctx := context.Background()
result := async.Pipeline(ctx, data,
    func(x int) int { return x * 2 },     // Умножаем
    func(x int) int { return x + 100 },   // Добавляем
    func(x int) int { return x / 3 },     // Делим
)

fmt.Printf("Обработано %d элементов\\n", len(result))
\`\`\`

## 22. Стресс-тестирование с Worker Pool

\`\`\`go
pool := async.NewWorkerPool(10)
tasks := make([]int, 1000)
for i := range tasks {
    tasks[i] = i
}

start := time.Now()
results := pool.ProcessTasks(tasks, func(task int) string {
    return fmt.Sprintf("result-%d", task)
})
duration := time.Since(start)

fmt.Printf("Обработано %d задач за %v\\n", len(results), duration)
\`\`\`

## 23. Advanced: Комбинированный паттерн

\`\`\`go
// Используем Producer-Consumer + Pipeline + Worker Pool

pool := async.NewWorkerPool(4)

// Производитель отправляет задачи в пул
go func() {
    for i := 1; i <= 20; i++ {
        pool.Submit(func() {
            ctx := context.Background()
            result := async.Pipeline(ctx, []int{i},
                func(x int) int { return x * 2 },
                func(x int) int { return x + 10 },
            )
            fmt.Println(result)
        })
    }
}()

time.Sleep(3 * time.Second)
pool.Stop()
\`\`\`