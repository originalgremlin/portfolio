package graph;

public class Edge implements Comparable<Edge> {
    Node from, to;
    double weight;

    public Edge(Node from, Node to, double weight) {
        this.from = from;
        this.to = to;
        this.weight = weight;
    }

    public Node getFrom() {
        return from;
    }

    public Node getTo() {
        return to;
    }

    public double getWeight() {
        return weight;
    }

    @Override
    public int compareTo(Edge other) {
        return (int) Math.round(Math.signum(weight - other.weight));
    }
}
