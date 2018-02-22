import random

class Node:
    def __init__(self, value):
        self.left = None
        self.right = None
        self.value = value

    def __repr__(self):
        return 'Node[{}]'.format(self.value)

    def __str__(self):
        return str(self.value)


class Tree:
    def __init__(self, values=()):
        self.root = None
        # shuffle to avoid perverse inputs (i.e. already sorted lists)
        for v in random.sample(values, len(values)):
            self.insert(v)

    def __repr__(self):
        return 'Tree[{}]'.format(self.root)

    def __str__(self):
        return str(self.sort())

    def contains(self, value):
        node = self.root
        while node is not None:
            if node.value == value:
                return True
            elif value < node.value:
                node = node.left
            else:
                node = node.right
        return False

    def insert(self, value):
        def _insert(node, value):
            while True:
                if value < node.value:
                    if node.left is None:
                        node.left = Node(value)
                        return
                    else:
                        node = node.left
                else:
                    if node.right is None:
                        node.right = Node(value)
                        return
                    else:
                        node = node.right

        if self.root is None:
            self.root = Node(value)
        else:
            _insert(self.root, value)

    def sort(self):
        values = []

        def _sort(node):
            if node is None:
                return
            else:
                _sort(node.left)
                values.append(node.value)
                _sort(node.right)
        _sort(self.root)

        return values
