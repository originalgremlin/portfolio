import random
import sorting
import unittest
from inspect import getmembers, isfunction

class TestSortingMethods(unittest.TestCase):
    @staticmethod
    def issorted(items):
        return all(items[i] <= items[i + 1] for i in range(len(items) - 1))

    def test_methods(self):
        # test all methods
        methods = [m[1] for m in getmembers(sorting) if isfunction(m[1])]

        for method in methods:
            # edge cases
            arrs = ([], [0], [1], [0, 1], [1, 0], [0, 0], [1, 1], [0, 1, 0], [-1], [-1, -1], [-1, -2, -3], [-1, -2, -1])
            for arr in arrs:
                with self.subTest(method=method, arr=arr):
                    self.assertTrue(self.issorted(method(arr)))

            # random samples
            for i in range(0, 101, 10):
                items = random.sample(range(i), i)
                with self.subTest(method=method, items=items):
                    self.assertTrue(self.issorted(method(items)))


if __name__ == '__main__':
    unittest.main()
