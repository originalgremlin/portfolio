package filter

import (
	"crypto/sha256"
	"encoding/binary"
)

type BloomFilter struct {
	m uint32
	k uint32
	b []bool
}

func BloomFilter(m uint32, k uint32) *BloomFilter {
	return &BloomFilter{m, k, make([]bool, m)}
}

/*
 Construct any number of hash functions from two independent hash functions.

 "Building a Better Bloom Filter"
 https://www.eecs.harvard.edu/~michaelm/postscripts/tr-02-05.pdf

 As an instructive example case, we consider the following specific application of the general
 technique described in the introduction. We devise a Bloom filter that uses k hash functions,
 each with range {0, 1, 2, . . . , p − 1} for a prime p. Our hash table consists of m = kp bits; each
 hash function is assigned a disjoint subarray of p bits in the filter, that we treat as numbered
 {0, 1, 2, . . . , p − 1}. Our k hash functions will be of the form

	 gi(x) = h1(x) + ih2(x) mod p,

 where h1(x) and h2(x) are two independent, uniform random hash functions on the universe with
 range {0, 1, 2, . . . , p − 1}, and throughout we assume that i ranges from 0 to k − 1.
 */
func (filter *BloomFilter) Hash(data []byte) []uint32 {
	var i, p, h1, h2 uint32

	// define base hashes
	h := sha256.Sum256(data)
	h1 = binary.BigEndian.Uint32(h[0:4])
	h2 = binary.BigEndian.Uint32(h[4:8])
	p = 4294967291 // 2^32 - 5 is prime

	// generate k hashes using the Kirsch-Mitzenmacher Optimization
	g := make([]uint32, len(filter.k))
	for i = 0; i < filter.k; i++ {
		g[i] = h1 + (i * h2) % p
	}
	return g
}

func (filter *BloomFilter) Add(data []byte) {
	for _, hash := range filter.Hash(data) {
		filter.b[hash] = true
	}
}

func (filter *BloomFilter) Has(data []byte) bool {
	rv := true
	for _, hash := range filter.Hash(data) {
		rv &= filter.b[hash]
	}
	return rv
}

func (filter *BloomFilter) Clear() {
	for i := range filter.b {
		filter.b[i] = false
	}
}
