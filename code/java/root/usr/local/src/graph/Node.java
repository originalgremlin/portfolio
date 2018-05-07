package graph;

import java.util.HashMap;

public class Node {
    private Object data;
    private HashMap<Node, Double> edges;

    public Node(Object data) {
        this.data = data;
        this.edges = new HashMap<>();
    }

    public void setData(Object data) {
        this.data = data;
    }

    public Object getData() {
        return data;
    }

    public HashMap<Node, Double> getEdges() {
        return edges;
    }

    public double getEdgeWeight(Node n) {
        return edges.getOrDefault(n, Double.NEGATIVE_INFINITY);
    }

    public void addEdge(Node n, double weight) {
        edges.put(n, weight);
    }

    public void removeEdge(Node n) {
        edges.remove(n);
    }

    public boolean hasEdge(Node n) {
        return edges.containsKey(n);
    }

    public int getNumEdges() {
        return edges.size();
    }
}
