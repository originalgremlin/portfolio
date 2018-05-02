package cache

import "container/heap"

// abstract base class
type xfu struct {
	m        map[Key]*HeapItem
	q        *PriorityQueue
	capacity uint
}

func (cache *xfu) Set(key Key, val Value) bool {
	if len(cache.m) >= cache.capacity {
		// delete over-capacity
		cache.Delete(cache.Next())
	}
	if elem, ok := cache.m[key]; ok {
		// update existing element
		elem.val = val
	} else {
		// add new element
		cache.m[key] = &HeapItem{key, val}
	}
	heap.Push(cache.q, cache.m[key])
	cache.Update(key)
	return true
}

func (cache *xfu) Get(key Key) Value {
	var val Value
	if elem, ok := cache.m[key]; ok {
		val = elem.val
	}
	cache.Update(key)
	return val
}

func (cache *xfu) Has(key Key) bool {
	_, ok := cache.m[key]
	cache.Update(key)
	return ok
}

func (cache *xfu) Delete(key Key) {
	if elem, ok := cache.m[key]; ok {
		delete(cache.m, key)
		heap.Remove(cache.q, elem.index)
	}
}

func (cache *xfu) Next() Key {
	return xfu.q.Peek().key
}

// least recently used
type LFU struct {
	xfu
}

func NewLFU(capacity uint) *LFU {
	return &LFU{
		make(map[Key]*HeapItem),
		NewPriorityQueue(),
		capacity,
	}
}

func (cache *LFU) Update(key Key) {
	if elem, ok := cache.m[key]; ok {
		cache.q.Decrement(elem)
	}
}

// most recently used
type MFU struct {
	xfu
}

func NewMFU(capacity uint) *MFU {
	return &MFU{
		make(map[Key]*HeapItem),
		NewPriorityQueue(),
		capacity,
	}
}

func (cache *MFU) Update(key Key) {
	if elem, ok := cache.m[key]; ok {
		cache.q.Increment(elem)
	}
}
