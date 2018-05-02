package cache

import "container/list"

// abstract base class
type xru struct {
	m        map[Key]*list.Element
	l        *list.List
	capacity uint
}

func (cache *xru) Set(key Key, val Value) bool {
	if len(cache.m) >= cache.capacity {
		// delete over-capacity
		cache.Delete(cache.Next())
	}
	if elem, ok := cache.m[key]; ok {
		// update existing element
		((elem.Value).(*KV)).val = val
		cache.l.MoveToFront(elem)
	} else {
		// add new element
		cache.m[key] = cache.list.PushFront(KV{key, val})
	}
	return true
}

func (cache *xru) Get(key Key) Value {
	var val Value
	if elem, ok := cache.m[key]; ok {
		val = ((elem.Value).(*KV)).val
	}
	cache.Update(key)
	return val
}

func (cache *xru) Has(key Key) bool {
	_, ok := cache.m[key]
	cache.Update(key)
	return ok
}

func (cache *xru) Delete(key Key) {
	if elem, ok := cache.m[key]; ok {
		delete(cache.m, key)
		cache.l.Remove(elem)
	}
}

func (cache *xru) Update(key Key) {
	if elem, ok := cache.m[key]; ok {
		cache.l.MoveToFront(elem)
	}
}

func (cache *xru) Next() Key {
	return nil
}

// least recently used
type LRU struct {
	xru
}

func NewLRU(capacity uint) *LRU {
	return &LRU{
		make(map[Key]*list.Element),
		list.New(),
		capacity,
	}
}

func (cache *LRU) Next() Key {
	if elem := cache.l.Back(); elem != nil {
		return ((elem.Value).(*KV)).key
	} else {
		return nil
	}
}

// most recently used
type MRU struct {
	xru
}

func NewMRU(capacity uint) *MRU {
	return &MRU{
		make(map[Key]*list.Element),
		list.New(),
		capacity,
	}
}

func (cache *MRU) Next() Key {
	if elem := cache.l.Front(); elem != nil {
		return ((elem.Value).(*KV)).key
	} else {
		return nil
	}
}
