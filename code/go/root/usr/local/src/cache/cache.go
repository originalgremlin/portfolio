package cache

type Key []byte

type Value interface{}

type CapacityCache interface {
	Set(key Key, val Value) bool
	Get(key Key) Value
	Has(key Key) bool
	Delete(key Key)
	Update(key Key)
	Next() Key
}

type KV struct {
	key Key
	val Value
}
