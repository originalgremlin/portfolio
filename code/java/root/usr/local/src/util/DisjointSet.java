package util;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

// https://en.wikipedia.org/wiki/Disjoint-set_data_structure
public class DisjointSet<T> {
    // child -> parent
    private Map<T, T> parents = new HashMap<>();

    // item -> number of items in the sub-tree rooted at item
    private Map<T, Integer> size = new HashMap<>();

    // initialize to a disjoint forest where every node is its own root
    public DisjointSet(Collection<T> c) {
        c.forEach(x -> {
            parents.put(x, x);
            size.put(x, 1);
        });
    }

    private T getParent(T x) {
        return parents.getOrDefault(x, x);
    }

    private int getSize(T x) {
        return size.getOrDefault(x, 1);
    }

    // find with path splitting
    public T find(T x) {
        T next = getParent(x);
        while (next != x) {
            parents.put(x, getParent(next));
            x = next;
            next = getParent(x);
        }
        return x;
    }

    // union by size
    public void union(T x, T y) {
        T xRoot = find(x);
        T yRoot = find(y);
        int xSize = getSize(x);
        int ySize = getSize(y);

        if (xRoot == yRoot) {
            // x and y are already in the same set
            return;
        } else if (xSize < ySize) {
            // merge x into y
            parents.put(xRoot, yRoot);
            size.put(yRoot, xSize + ySize);
        } else {
            // merge y into x
            parents.put(yRoot, xRoot);
            size.put(xRoot, xSize + ySize);
        }
    }
}
