package graph;

import java.util.HashSet;

public class Graph {
    private HashSet<Node> nodes;

    public Graph() {
        nodes = new HashSet<>();
    }

    public HashSet<Node> getNodes() {
        return nodes;
    }

    public boolean addNode(Node n) {
        return nodes.add(n);
    }

    public boolean removeNode(Node n) {
        for (Node node : nodes) {
            removeEdge(node, n);
        }
        return nodes.remove(n);
    }

    public int getNumNodes() {
        return nodes.size();
    }

    public void addEdge(Node from, Node to, double weight) {
        from.addEdge(to, weight);
    }

    public void removeEdge(Node from, Node to) {
        from.removeEdge(to);
    }

    public boolean hasEdge(Node from, Node to) {
        return from.hasEdge(to);
    }
}
