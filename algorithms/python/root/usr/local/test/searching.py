import random
import searching
import unittest
from inspect import getmembers, isfunction

class TestSearchingMethods(unittest.TestCase):
    def test_methods(self):
        # test all methods
        methods = [m[1] for m in getmembers(searching) if isfunction(m[1])]

        for method in methods:
            # edge cases
            with self.subTest(method=method):
                self.assertTrue([0], 0)
                self.assertTrue([0, 0], 0)
                self.assertTrue([0, 1, 2], 1)
                self.assertTrue([2, 1, 0], 1)
                self.assertFalse([], 0)
                self.assertFalse([0], 1)
                self.assertFalse([0, 0], 1)
                self.assertFalse([0, 1, 2], 3)
                self.assertFalse([0, 1, 2], -1)
                self.assertFalse([0, 1, 2], 0.5)

            # random samples
            for i in range(0, 101, 10):
                items = random.sample(range(i), i)
                with self.subTest(method=method, items=items):
                    self.assertTrue(method(items, 0))
                    self.assertTrue(method(items, i - 1))
                    self.assertTrue(method(items, int(i / 3)))
                    self.assertTrue(method(items, int(i / 5)))
                    self.assertTrue(method(items, int(i / 7)))
                    self.assertFalse(method(items, -1))
                    self.assertFalse(method(items, i))
                    self.assertFalse(method(items, i * 2))
                    self.assertFalse(method(items, 0.5))


if __name__ == '__main__':
    unittest.main()
