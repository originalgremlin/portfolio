package queue

import "container/heap"

type HeapItem struct {
	key      Key
	val      Value
	priority int
	index    int
}

type PriorityQueue []*HeapItem

func NewPriorityQueue() *PriorityQueue {
	pq := make(PriorityQueue, 0)
	heap.Init(&pq)
	return &pq
}

// sort interface
func (pq PriorityQueue) Len() int {
	return len(pq)
}

func (pq PriorityQueue) Less(i, j int) bool {
	return pq[i].priority < pq[j].priority
}

func (pq PriorityQueue) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}

// heap interface
func (pq *PriorityQueue) Push(x interface{}) {
	item := x.(*HeapItem)
	item.index = len(*pq)
	*pq = append(*pq, item)
}

func (pq *PriorityQueue) Pop() interface{} {
	n := len(*pq) - 1
	item := (*pq)[n]
	*pq = (*pq)[:n]
	return item
}

// pq
func (pq *PriorityQueue) Peek() *HeapItem {
	n := len(*pq) - 1
	item := (*pq)[n]
	return item
}

func (pq *PriorityQueue) Increment(item *HeapItem) {
	item.priority += 1
	heap.Fix(pq, item.index)
}

func (pq *PriorityQueue) Decrement(item *HeapItem) {
	item.priority -= 1
	heap.Fix(pq, item.index)
}

func (pq *PriorityQueue) Update(item *HeapItem, val Value) {
	item.val = val
}
