import sys
sys.path.append('../')

from src.tree import Tree


def binary(items, key):
    items.sort()
    low, high = 0, len(items) - 1
    while low <= high:
        mid = int(low + (high - low) / 2)
        if key == items[mid]:
            return True
        elif key < items[mid]:
            low, high = low, mid - 1
        else:
            low, high = mid + 1, high
    return False


def tree(items, key):
    return Tree(items).contains(key)
