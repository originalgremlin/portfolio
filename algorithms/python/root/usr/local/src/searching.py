import sorting
from tree import Tree


def binary(key, items):
    items = sorting.quick(items)
    low, high = 0, len(items) - 1
    while low < high:
        mid = int(low + (high - low) / 2)
        if key == items[mid]:
            return True
        elif key < items[mid]:
            low, high = low, mid
        else:
            low, high = mid, high
    return False


def tree(key, items):
    return Tree(items).contains(key)
