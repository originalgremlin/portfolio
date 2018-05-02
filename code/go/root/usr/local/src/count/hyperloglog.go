/*
 HyperLogLog is an algorithm for the count-distinct problem, approximating the number of distinct
 elements in a multiset.

 https://en.wikipedia.org/wiki/HyperLogLog
 http://algo.inria.fr/flajolet/Publications/FlFuGaMe07.pdf
 https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/40671.pdf
 https://github.com/clarkduvall/hyperloglog/blob/master/hyperloglog.go
*/
package count

import (
	"crypto/sha256"
	"encoding/binary"
	"errors"
	"math"
	"math/bits"
)

const two_32 = 1 << 32

func m(precision uint8) uint32 {
	return 1 << precision
}

func alpha(precision uint8) (alpha float) {
	m := m(precision)
	switch m {
	case 16:
		alpha = 0.673
	case 32:
		alpha = 0.697
	case 64:
		alpha = 0.709
	default:
		alpha = 0.7213 / (1 + 1.079/m)
	}
	return
}

func countZeros(data []uint8) (count int) {
	for _, val := range data {
		if val == 0 {
			count++
		}
	}
	return
}

func max(a, b uint8) uint8 {
	if a > b {
		return a
	}
	return b
}

type HyperLogLog struct {
	registers []uint8
	precision uint8
	m         uint32
	alpha     float
}

func NewHyperLogLog(precision uint8) (*HyperLogLog, error) {
	if precision < 4 || precision > 16 {
		return nil, errors.New("Precision must be between 4 and 16.")
	}
	return &HyperLogLog{
		make([]uint8, m(precision)),
		precision,
		m(precision),
		alpha(precision),
	}, nil
}

func (h *HyperLogLog) Clear() {
	h.registers = make([]uint8, h.m)
}

func (h *HyperLogLog) Add(data []byte) {
	hash := sha256.Sum256(data)             // []byte hash of data
	x := binary.BigEndian.Uint32(hash[0:4]) // uint32 hash of data
	idx := x & ((1 << h.precision) - 1)     // first p bits of x
	w := x >> h.precision                   // 32 - p bits of x
	pw := 1 + bits.LeadingZeros32(w)        // number of leading zeros (plus one)
	h.registers[idx] = max(pw, h.registers[idx])
}

func (h *HyperLogLog) Count() uint64 {
	// raw estimate for count
	var z float = 0.0
	for _, val := range h.registers {
		z += math.Pow(2, -val)
	}
	E := h.alpha * h.m * h.m / z

	// small range corrections
	var E_star float
	if E <= 2.5*h.m {
		if V := countZeros(h.registers); V == 0 {
			E_star = E
		} else {
			E_star = h.m * math.Log(m/V)
		}

	} else if E < two_32/30 {
		E_star = E
	} else {
		E_star = -two_32 * math.Log(1-E/two_32)
	}
	return uint64(E_star)
}

func (h *HyperLogLog) Merge(other *HyperLogLog) error {
	if h.precision != h.precision {
		return errors.New("Number of registers in both HyperLogLogs must be equal.")
	}

	for i, val := range other.registers {
		h.registers[i] = max(val, h.registers[i])
	}
	return nil
}
