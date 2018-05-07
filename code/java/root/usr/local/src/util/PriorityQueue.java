package util;

import java.util.*;

public class PriorityQueue<T> implements Queue<T> {
    public class Element implements Comparable<Element> {
        T data;
        double priority;

        Element(T data, double priority) {
            this.data = data;
            this.priority = priority;
        }

        public T getData() {
            return data;
        }

        public double getPriority() {
            return priority;
        }

        @Override
        public int compareTo(Element other) {
            return (int) Math.round(Math.signum(priority - other.priority));
        }
    }

    private HashMap<T, Integer> map = new HashMap<>();
    private ArrayList<Element> heap = new ArrayList<>();

    public boolean add(T data, double priority) {
        Element element = new Element(data, priority);
        int n = heap.size();
        heap.add(element);
        map.put(data, n);
        siftUp(n);
        return true;
    }

    public double getPriority(T data) {
        if (contains(data)) {
            return getPriority(map.get(data));
        } else {
            throw new NoSuchElementException();
        }
    }

    private double getPriority(int i) {
        return heap.get(i).priority;
    }

    public void updatePriority(T data, double priority) {
        if (contains(data)) {
            int i = map.get(data);
            Element element = heap.get(i);
            element.priority = priority;
            sift(i);
        }
    }

    private int parent(int i) {
        if (i <= 0) {
            return -1;
        } else {
            return (int) Math.ceil(i / 2.0) - 1;
        }
    }

    private void swap(int i, int j) {
        // store tmp values
        Element ei = heap.get(i);
        Element ej = heap.get(j);
        // swap map values
        map.put(ei.data, j);
        map.put(ej.data, i);
        // swap heap values
        heap.set(i, ej);
        heap.set(j, ei);
    }

    private void sift(int i) {
        if (getPriority(parent(i)) > getPriority(i)) {
            siftUp(i);
        } else {
            siftDown(i);
        }
    }

    private void siftUp(int i) {
        int parent = parent(i);
        while (parent >= 0 && getPriority(parent) > getPriority(i)) {
            swap(i, parent);
            i = parent;
            parent = parent(parent);
        }
    }

    private void siftDown(int i) {
        int n = size();
        int left = 2 * i + 1;
        int right = 2 * i + 2;
        int down = -1;
        if (left < n && right < n) {
            down = getPriority(left) < getPriority(right) ? left : right;
        } else if (left < n) {
            down = left;
        } else if (right < n) {
            down = right;
        }
        if (down >= 0 && getPriority(i) > getPriority(down)) {
            swap(i, down);
            siftDown(down);
        }
    }

    private T remove(int i) {
        if (i < 0 || i >= heap.size()) {
            return null;
        } else {
            Element curr = heap.get(i);
            Element last = heap.remove(heap.size() - 1);
            map.remove(curr.data);
            heap.set(i, last);
            siftDown(i);
            return last.data;
        }
    }

    @Override
    public int size() {
        return heap.size();
    }

    @Override
    public boolean isEmpty() {
        return heap.isEmpty();
    }

    @Override
    public boolean contains(Object o) {
        return map.containsKey(o);
    }

    @Override
    public Iterator<T> iterator() {
        return map.keySet().iterator();
    }

    @Override
    public Object[] toArray() {
        return heap.toArray();
    }

    @Override
    public <T1> T1[] toArray(T1[] a) {
        return (T1[]) heap.toArray(a);
    }

    @Override
    public boolean add(T data) {
        return add(data, Double.POSITIVE_INFINITY);
    }

    @Override
    public boolean remove(Object o) {
        if (!contains(o)) {
            return false;
        } else {
            remove(map.get(o));
            return true;
        }
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        return heap.containsAll(c);
    }

    @Override
    public boolean addAll(Collection<? extends T> c) {
        c.forEach(this::add);
        return true;
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        c.forEach(this::remove);
        return true;
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        return false;
    }

    @Override
    public void clear() {
        heap.clear();
        map.clear();
    }

    @Override
    public boolean offer(T data) {
        add(data);
        return true;
    }

    @Override
    public T remove() {
        if (heap.isEmpty()) {
            throw new NoSuchElementException();
        } else {
            return remove(0);
        }
    }

    @Override
    public T poll() {
        if (heap.isEmpty()) {
            return null;
        } else {
            return remove(0);
        }
    }

    @Override
    public T element() {
        if (heap.isEmpty()) {
            throw new NoSuchElementException();
        } else {
            return heap.get(0).data;
        }
    }

    @Override
    public T peek() {
        if (heap.isEmpty()) {
            return null;
        } else {
            return heap.get(0).data;
        }
    }
}
