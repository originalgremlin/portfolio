import sys
sys.path.append('../')

from src.heap import Heap
from src.tree import Tree


def bubble(items):
    n = len(items)
    for i in range(n, 0, -1):
        for j in range(0, i - 1):
            if items[j + 1] < items[j]:
                items[j], items[j + 1] = items[j + 1], items[j]
    return items


def heap(items):
    return Heap(items).sort()


def insertion(items):
    n = len(items)
    for i in range(1, n):
        while (i > 0) and (items[i] < items[i - 1]):
            items[i], items[i - 1] = items[i - 1], items[i]
            i = i - 1
    return items


def merge(items):
    n = len(items)
    half_n = int(n / 2)

    # single-item list is already sorted
    if n <= 1:
        return items

    # sort each half of the list
    left = merge(items[:half_n])
    right = merge(items[half_n:])

    # join sorted halves
    rv = []
    i, j, maxi, maxj = 0, 0, len(left), len(right)
    while i < maxi or j < maxj:
        if i == maxi:
            rv.append(right[j])
            j = j + 1
        elif j == maxj:
            rv.append(left[i])
            i = i + 1
        elif left[i] < right[j]:
            rv.append(left[i])
            i = i + 1
        else:
            rv.append(right[j])
            j = j + 1
    return rv


def quick(items, left=None, right=None):
    if left is None:
        left = 0
    if right is None:
        right = len(items) - 1
    if right <= left:
        return items

    # choose pivot value
    pivot = items[left]

    # partition items around pivot
    i, j = left, right
    while True:
        while i < j and items[i] <= pivot:
            i = i + 1
        while j >= i and items[j] >= pivot:
            j = j - 1
        if i < j:
            items[i], items[j] = items[j], items[i]
        else:
            break

    # swap pivot into position
    items[left], items[j] = items[j], items[left]

    # recursively sort partitioned sections
    quick(items, left, j - 1)
    quick(items, j + 1, right)
    return items


def selection(items):
    n = len(items)
    for i in range(n):
        min = i
        for j in range(i, n):
            if items[j] < items[min]:
                min = j
        items[i], items[min] = items[min], items[i]
    return items


def shell(items, gaps=(701, 301, 132, 57, 23, 10, 4, 1)):
    n = len(items)
    for gap in gaps:
        for i in range(gap, n):
            temp = items[i]
            j = i
            while j >= gap and items[j - gap] > temp:
                items[j] = items[j - gap]
                j = j - gap
            items[j] = temp
    return items


def tree(items):
    return Tree(items).sort()
