from copy import deepcopy
from math import ceil


class Heap:
    def __init__(self, values=()):
        self.values = list(values)
        self.heapify()

    def heapify(self):
        half = int(ceil(len(self.values) / 2))
        for i in reversed(range(half)):
            self._sift_down(i)

    def insert(self, value):
        self.values.append(value)
        self._sift_up(len(self.values) - 1)

    def sort(self):
        tmp = deepcopy(self)
        rv = []
        while tmp.values:
            rv.append(tmp.pop())
        return rv

    def peek(self):
        return self.values[0]

    def pop(self):
        self.values[0], self.values[-1] = self.values[-1], self.values[0]
        rv = self.values.pop()
        self._sift_down(0)
        return rv

    def size(self):
        return len(self.values)

    def _parent(self, index):
        return None if index <= 0 else int(ceil(index / 2)) - 1

    def _children(self, index):
        n = len(self.values)
        left = 2 * index + 1
        right = 2 * index + 2
        if left >= n:
            left = None
        if right >= n:
            right = None
        return (left, right)

    # min-heap
    def _sift_down(self, index):
        left, right = self._children(index)
        if left and right:
            down = left if self.values[left] < self.values[right] else right
        elif left and not right:
            down = left
        elif right and not left:
            down = right
        else:
            down = None
        if down and self.values[down] < self.values[index]:
            self.values[down], self.values[index] = self.values[index], self.values[down]
            self._sift_down(down)

    # min-heap
    def _sift_up(self, index):
        parent = self._parent(index)
        while parent is not None and self.values[parent] > self.values[index]:
            self.values[parent], self.values[index] = self.values[index], self.values[parent]
            index, parent = parent, self._parent(parent)

    def __repr__(self):
        return 'Heap[{}]'.format(self.size())

    def __str__(self):
        return str(self.values)
