package graph;

import java.util.Collection;
import java.util.HashSet;

public class Graph {
    private HashSet<Node> nodes;

    public Graph() {
        nodes = new HashSet<>();
    }

    public Graph(Collection<Node> c) {
        nodes = new HashSet<>(c);
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

    public HashSet<Edge> getEdges() {
        HashSet<Edge> edges = new HashSet<>();
        for (Node n : nodes) {
            edges.addAll(n.getEdges());
        }
        return edges;
    }

    public void addEdge(Edge edge) {
        addEdge(edge.getFrom(), edge.getTo(), edge.getWeight());
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
