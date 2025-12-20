package async

import (
	"sync"
)

// Counter - потокобезопасный счетчик
type Counter struct {
	mu    sync.Mutex
	value int
}

// NewCounter создает новый счетчик
func NewCounter() *Counter {
	return &Counter{}
}

// Increment увеличивает счетчик
func (c *Counter) Increment() {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.value++
}

// Value возвращает текущее значение
func (c *Counter) Value() int {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.value
}

// ProcessItems параллельно обрабатывает элементы
func ProcessItems(items []int, processor func(int) int, numWorkers int) []int {
	if numWorkers <= 0 {
		numWorkers = 4
	}

	results := make([]int, len(items))
	var wg sync.WaitGroup
	semaphore := make(chan struct{}, numWorkers)

	for i, item := range items {
		wg.Add(1)
		go func(index int, value int) {
			defer wg.Done()
			semaphore <- struct{}{}        // Acquire
			defer func() { <-semaphore }() // Release

			results[index] = processor(value)
		}(i, item)
	}

	wg.Wait()
	return results
}

// MapConcurrent параллельно применяет функцию к элементам
func MapConcurrent(items []int, fn func(int) int) []int {
	return ProcessItems(items, fn, 4)
}

// FilterConcurrent параллельно фильтрует элементы
func FilterConcurrent(items []int, predicate func(int) bool) []int {
	var result []int
	var mu sync.Mutex

	var wg sync.WaitGroup
	for _, item := range items {
		wg.Add(1)
		go func(value int) {
			defer wg.Done()
			if predicate(value) {
				mu.Lock()
				result = append(result, value)
				mu.Unlock()
			}
		}(item)
	}

	wg.Wait()
	return result
}

// ReduceConcurrent параллельно сокращает массив
func ReduceConcurrent(items []int, initial int, fn func(int, int) int) int {
	if len(items) == 0 {
		return initial
	}

	// Для простоты используем последовательное выполнение с параллельными вычислениями
	result := initial
	var mu sync.Mutex
	var wg sync.WaitGroup

	for _, item := range items {
		wg.Add(1)
		go func(value int) {
			defer wg.Done()
			computed := fn(result, value)
			mu.Lock()
			result = computed
			mu.Unlock()
		}(item)
	}

	wg.Wait()
	return result
}

// RunWorkers запускает N рабочих горутин
func RunWorkers(tasks []func(), numWorkers int) {
	if numWorkers <= 0 {
		numWorkers = 4
	}

	taskChan := make(chan func(), numWorkers)
	var wg sync.WaitGroup

	// Запуск рабочих
	for i := 0; i < numWorkers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for task := range taskChan {
				task()
			}
		}()
	}

	// Отправка задач
	for _, task := range tasks {
		taskChan <- task
	}

	close(taskChan)
	wg.Wait()
}
