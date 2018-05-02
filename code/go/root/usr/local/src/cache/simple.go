package cache

// map wrapper
type Map struct {
	m        map[Key]Value
	capacity uint
}

func NewSimple(capacity uint) *Map {
	return &Map{
		make(map[Key]Value),
		capacity,
	}
}

func (cache *Map) Set(key Key, val Value) bool {
	if len(cache.m) >= cache.capacity {
		return false
	} else {
		cache.m[key] = val
		return true
	}
}

func (cache *Map) Get(key Key) Value {
	return cache.m[key]
}

func (cache *Map) Has(key Key) bool {
	_, ok := cache.m[key]
	return ok
}

func (cache *Map) Delete(key Key) {
	delete(cache.m, key)
}

func (cache *Map) Update(key Key) {
	return
}

func (cache *Map) Next() Key {
	return nil
}
