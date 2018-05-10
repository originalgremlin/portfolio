package graph;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

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

    public HashSet<Edge> getEdges() {
        HashSet<Edge> rv = new HashSet<>(edges.size() + 1, 1.0f);
        for (Map.Entry<Node, Double> e : edges.entrySet()) {
            rv.add(new Edge(this, e.getKey(), e.getValue()));
        }
        return rv;
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
