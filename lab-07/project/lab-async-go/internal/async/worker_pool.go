package async

import (
	"sync"
)

// WorkerPool базовый пул рабочих
type WorkerPool struct {
	workers  int
	tasksCh  chan func()
	stopChan chan struct{}
	wg       sync.WaitGroup
}

// NewWorkerPool создает новый пул рабочих
func NewWorkerPool(numWorkers int) *WorkerPool {
	if numWorkers <= 0 {
		numWorkers = 4
	}

	pool := &WorkerPool{
		workers:  numWorkers,
		tasksCh:  make(chan func(), numWorkers*2),
		stopChan: make(chan struct{}),
	}

	// Запуск рабочих
	for i := 0; i < numWorkers; i++ {
		pool.wg.Add(1)
		go pool.worker()
	}

	return pool
}

func (wp *WorkerPool) worker() {
	defer wp.wg.Done()

	for {
		select {
		case task, ok := <-wp.tasksCh:
			if !ok {
				return
			}
			task()
		case <-wp.stopChan:
			return
		}
	}
}

// Submit отправляет задачу в пул
func (wp *WorkerPool) Submit(task func()) {
	wp.tasksCh <- task
}

// ProcessTasks обрабатывает срез задач
func (wp *WorkerPool) ProcessTasks(tasks []int, processor func(int) string) []string {
	results := make([]string, len(tasks))
	var mu sync.Mutex
	var wg sync.WaitGroup

	for i, task := range tasks {
		wg.Add(1)
		go func(index int, value int) {
			defer wg.Done()
			result := processor(value)
			mu.Lock()
			results[index] = result
			mu.Unlock()
		}(i, task)
	}

	wg.Wait()
	return results
}

// Stop останавливает пул
func (wp *WorkerPool) Stop() {
	close(wp.tasksCh)
	wp.wg.Wait()
}

// DynamicWorkerPool пул с динамическим числом рабочих
type DynamicWorkerPool struct {
	minWorkers  int
	maxWorkers  int
	tasksCh     chan func()
	activeCount int
	mu          sync.Mutex
	stopChan    chan struct{}
	wg          sync.WaitGroup
}

// NewDynamicWorkerPool создает динамический пул
func NewDynamicWorkerPool(minWorkers, maxWorkers int) *DynamicWorkerPool {
	if minWorkers <= 0 {
		minWorkers = 2
	}
	if maxWorkers <= minWorkers {
		maxWorkers = minWorkers * 2
	}

	pool := &DynamicWorkerPool{
		minWorkers: minWorkers,
		maxWorkers: maxWorkers,
		tasksCh:    make(chan func(), maxWorkers*2),
		stopChan:   make(chan struct{}),
	}

	// Запуск минимального числа рабочих
	for i := 0; i < minWorkers; i++ {
		pool.startWorker()
	}

	return pool
}

func (dwp *DynamicWorkerPool) startWorker() {
	dwp.mu.Lock()
	dwp.activeCount++
	dwp.mu.Unlock()

	dwp.wg.Add(1)
	go dwp.worker()
}

func (dwp *DynamicWorkerPool) worker() {
	defer dwp.wg.Done()

	for {
		select {
		case task, ok := <-dwp.tasksCh:
			if !ok {
				return
			}
			task()
		case <-dwp.stopChan:
			return
		}
	}
}

// Submit отправляет задачу
func (dwp *DynamicWorkerPool) Submit(task func()) {
	dwp.tasksCh <- task
}

// Stop останавливает пул
func (dwp *DynamicWorkerPool) Stop() {
	close(dwp.tasksCh)
	dwp.wg.Wait()
}

// PriorityWorkerPool пул с приоритизацией
type PriorityTask struct {
	Priority int
	Task     func()
}

type PriorityWorkerPool struct {
	workers  int
	tasksCh  chan PriorityTask
	stopChan chan struct{}
	wg       sync.WaitGroup
}

// NewPriorityWorkerPool создает пул с приоритизацией
func NewPriorityWorkerPool(numWorkers int) *PriorityWorkerPool {
	if numWorkers <= 0 {
		numWorkers = 4
	}

	pool := &PriorityWorkerPool{
		workers:  numWorkers,
		tasksCh:  make(chan PriorityTask, numWorkers*2),
		stopChan: make(chan struct{}),
	}

	for i := 0; i < numWorkers; i++ {
		pool.wg.Add(1)
		go pool.worker()
	}

	return pool
}

func (pwp *PriorityWorkerPool) worker() {
	defer pwp.wg.Done()

	for {
		select {
		case task, ok := <-pwp.tasksCh:
			if !ok {
				return
			}
			task.Task()
		case <-pwp.stopChan:
			return
		}
	}
}

// Submit отправляет задачу с приоритетом
func (pwp *PriorityWorkerPool) Submit(priority int, task func()) {
	pwp.tasksCh <- PriorityTask{Priority: priority, Task: task}
}

// Stop останавливает пул
func (pwp *PriorityWorkerPool) Stop() {
	close(pwp.tasksCh)
	pwp.wg.Wait()
}
