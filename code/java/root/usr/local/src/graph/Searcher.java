package graph;

import java.util.*;
import util.PriorityQueue;

public class Searcher {
    private Graph graph;

    public Searcher(Graph graph) {
        this.graph = graph;
    }

    // https://en.wikipedia.org/wiki/Breadth-first_search
    public LinkedList<Node> breadthFirst(Node from, Node to) {
        Deque<Node> open = new LinkedList<>();
        Map<Node, Node> closed = new HashMap<>();
        Node current;

        // search the graph, starting with "from" as root
        open.add(from);
        current = open.poll();
        while (current != null) {
            for (Node next : current.getEdges().keySet()) {
                if (!closed.containsKey(next)) {
                    open.addLast(next); // BFS: add to back
                    closed.put(next, current);
                }
                if (next.equals(to)) {
                    break;
                }
            }
            current = open.poll();
        }

        // back-calculate a path from beginning to end
        LinkedList<Node> path = new LinkedList<>();
        current = to;
        while (closed.containsKey(current)) {
            path.addFirst(current);
            current = closed.get(current);
        }
        return path;
    }

    // https://en.wikipedia.org/wiki/Depth-first_search
    public LinkedList<Node> depthFirst(Node from, Node to) {
        Deque<Node> open = new LinkedList<>();
        Map<Node, Node> closed = new HashMap<>();
        Node current;

        // search the graph, starting with "from" as root
        open.add(from);
        current = open.poll();
        while (current != null) {
            for (Node next : current.getEdges().keySet()) {
                if (!closed.containsKey(next)) {
                    open.addFirst(next); // DFS: add to front
                    closed.put(next, current);
                }
                if (next.equals(to)) {
                    break;
                }
            }
            current = open.poll();
        }

        // back-calculate a path from beginning to end
        LinkedList<Node> path = new LinkedList<>();
        current = to;
        while (closed.containsKey(current)) {
            path.addFirst(current);
            current = closed.get(current);
        }
        return path;
    }

    // https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
    public Map<Node, Node> dijkstra(Node from) {
        PriorityQueue<Node> open = new PriorityQueue<Node>();
        Map<Node, Node> parents = new HashMap<>();

        // Mark all nodes unvisited. Create a set of all the unvisited nodes called the unvisited set.
        // Assign to every node a tentative distance value: set it to zero for our initial node and to infinity for all other nodes.
        for (Node n : graph.getNodes()) {
            open.add(n, n.equals(from) ? 0.0 : Double.POSITIVE_INFINITY);
            parents.put(n, null);
        }

        // Set the initial node as current.
        // PriorityQueue<Node>.Element current = open.pollElement();
        Node current = open.poll();

        // If the smallest tentative distance among the nodes in the unvisited set is infinity, then stop.
        // (Occurs when there is no connection between the initial node and remaining unvisited nodes.)
        while (current != null && open.getPriority(current) < Double.POSITIVE_INFINITY) {
            Double priority_current = open.getPriority(current);

            for (Map.Entry<Node, Double> next : current.getEdges().entrySet()) {
                Node child = next.getKey();
                Double weight = next.getValue();

                // Consider all unvisited neighbors
                if (open.contains(child)) {
                    // Compare the newly calculated tentative distance to the current assigned value and assign the smaller one.
                    Double priority_child = open.getPriority(child);
                    open.updatePriority(child, Math.min(priority_child, priority_current + weight));

                    // Allow path reconstruction by storing the first-seen parent of each node.
                    parents.putIfAbsent(child, current);
                }
            }
            // When we are done considering all of the neighbors of the current node, remove it from the unvisited set.
            // A visited node will never be checked again.
            current = open.poll();
        }

        // return ability to reconstruct all paths from the source
        return parents;
    }

    // https://en.wikipedia.org/wiki/Prim%27s_algorithm
    public Graph prim() {
        PriorityQueue<Node> open = new PriorityQueue<Node>();
        Map<Node, Node> edges = new HashMap<>();
        Graph mst = new Graph();

        // Associate with each vertex v of the graph a number C[v] (the cheapest cost of a connection to v)
        // and an edge E[v] (the edge providing that cheapest connection).
        // To initialize these values, set all values of C[v] to +∞ (or to any number larger than the maximum edge weight)
        // and set each E[v] to a special flag value indicating that there is no edge connecting v to earlier vertices.
        for (Node v : graph.getNodes()) {
            open.add(v, Double.POSITIVE_INFINITY);
            edges.put(v, null);
        }

        while (!open.isEmpty()) {
            Node v, w;
            double weight;

            // Find and remove a vertex v from the unvisited set having the minimum possible value of C[v]
            // Add v to the MST.
            v = open.poll();
            mst.addNode(v);

            // if E[v] is not the special flag value, also add E[v] to the MST.
            w = edges.get(v);
            if (w != null) {
                mst.addEdge(v, w, v.getEdgeWeight(w));
            }

            // Loop over the edges vw connecting v to other vertices w.
            // For each such edge, if w is still unvisited and vw has smaller weight than C[w], perform the following steps:
            // - Set C[w] to the cost of edge vw
            // - Set E[w] to point to edge vw
            for (Map.Entry<Node, Double> edge : v.getEdges().entrySet()) {
                w = edge.getKey();
                weight = edge.getValue();
                if (open.contains(w) && weight < open.getPriority(w)) {
                    open.updatePriority(w, weight);
                    edges.put(v, w);
                }
            }
        }

        // Return the MST.
        return mst;
    }
}
