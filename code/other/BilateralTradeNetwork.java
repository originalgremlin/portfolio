package BilateralTradeNetworks.Models;
import BilateralTradeNetworks.Agents.*;
import sim.engine.*;
import sim.field.continuous.*;
import sim.field.network.*;
import sim.util.*;
import java.util.*;
import java.util.Random;
import java.awt.*;

// TODO: logging
// TODO: good console selector, or launching in general
// TODO: run from command line
// TODO: parse logs to make charts

abstract public class BilateralTradeNetwork extends SimState {
    // traders can be located anywhere
    public Continuous2D traders            = new Continuous2D(100, 100, 100);
    // trade routes are undirected networks
    public Network localRoutes             = new Network(false);
    public Network crossoverRoutes         = new Network(false);
    // generic initial model values
    // set more specific ones in the subclass constructor
    public int numTraders                  = 500;
    public int numGroups                   = 50;
    public int numCrossoverRoutes          = 5;
    // reset these at the start of every run
    public int trades                      = 0;
    public int searches                    = 0;
    public boolean hasTraded               = false;
    // initial amounts of tradable goods
    public static final int MIN_INIT_GOOD1 = 100;
    public static final int MAX_INIT_GOOD1 = 1000;
    public static final int MIN_INIT_GOOD2 = 1000;
    public static final int MAX_INIT_GOOD2 = 10000;

    public static void main (String[] args) throws ClassNotFoundException {
        // get the model class
        Class model = ClassLoader.getSystemClassLoader().loadClass(args[0]);
        // pass the proper class to the loop
        doLoop(model, args);
        System.exit(0);
    }

    // Constructors
    public BilateralTradeNetwork () {
        this(System.currentTimeMillis());
    }

    public BilateralTradeNetwork (long seed) {
        super(seed);
    }

    // Bean properties
    public int getNumTraders () {
        return numTraders;
    }

    public void setNumTraders (int i) {
        if (i >= 1) numTraders = i;
    }

    public int getNumGroups () {
        return numGroups;
    }

    public int getNumCrossoverRoutes () {
        return numCrossoverRoutes;
    }

    public int getTrades () {
        return trades;
    }

    public int getSearches () {
        return searches;
    }

    /***
     *  most networks do not allow setting the number of groups or crossovers
        if you need to do so, then add these methods to your subclass:

        public void setNumGroups (int i) {
            if (i >= 0) numGroups = i;
        }

        public void setNumCrossoverRoutes (int i) {
            if (i >= 0) numCrossoverRoutes = i;
        }
     *
     */

    // Real work
    @Override
    public void start () {
        super.start();
        // reset instance variables
        trades   = 0;
        searches = 0;
        // clear old values, if any
        traders.clear();
        Trader.reset();
        localRoutes.clear();
        crossoverRoutes.clear();
        // create everything afresh
        createTraders();
        createLocalRoutes();
        createCrossoverRoutes();
    }

    protected void createTraders () {
        for(int i = 0; i < numTraders; i++) {
            // make the trader
            Trader trader = new Trader(
                MIN_INIT_GOOD1 + random.nextInt(MAX_INIT_GOOD1),
                MIN_INIT_GOOD2 + random.nextDouble() * MAX_INIT_GOOD2
            );
            assignGroups(trader);
            assignColor(trader);
            assignLocation(trader);
            // add him to the trade networks
            localRoutes.addNode(trader);
            crossoverRoutes.addNode(trader);
            // let him trade
            schedule.scheduleRepeating(trader);
        }
    }

    // create local routes between all members of each group
    protected void createLocalRoutes () {
        Bag b = traders.getAllObjects();
        Trader from, to;
        for (int i = 0; i < b.numObjs - 1; i++) {
            for (int j = i + 1; j < b.numObjs; j++) {
                from = (Trader) b.objs[i];
                to   = (Trader) b.objs[j];
                if (from.groups.intersects(to.groups))
                    localRoutes.addEdge(from, to, new LocalRoute());
            }
        }
    }

    // create random crossover routes
    // crossovers MAY NOT run between members of the same group
    // that's what local routes are for
    // crossovers are not created when the trader is a member of more than one group
    protected void createCrossoverRoutes () {
        Trader from, to;
        int routes = 0;

        // loop through traders in random order
        Bag b = traders.getAllObjects();
        b.shuffle(random);

        FROM:
        for (int i = 0; i < b.numObjs; i++) {
            // are all routes created? if so, we're done
            if (++routes > numCrossoverRoutes)
                break FROM;

            // "from" is first trader in only one group
            from = (Trader) (b.objs[i]);
            if (from.groups.cardinality() > 1)
                continue FROM;

            // look for "to" everywhere, but start from a random spot
            int start = random.nextInt(b.numObjs);
            
            TO:
            for (int j = 0; j < b.numObjs; j++) {
                // "to" is in only one group, but not "from's"
                to = (Trader) (b.objs[(start + j) % b.numObjs]);
                if (to.groups.cardinality() > 1)
                    continue TO;
                if (to.groups.intersects(from.groups))
                    continue TO;
                // create a route between "from" and "to"
                crossoverRoutes.addEdge(from, to, new CrossoverRoute());
                continue FROM;
            }
            // end TO
        }
        // end FROM
    }

    // trader is in no groups
    protected void assignGroups (Trader t) {
        t.groups = new BitSet(numGroups);
    }

    // set his color based on his group
    protected void assignColor (Trader t) {
        Random r = new Random((long) t.groups.hashCode());
        t.color = new Color(r.nextInt());
    }

    // place him on the edge of a pow-wow
    protected void assignLocation (Trader t) {
        traders.setObjectLocation(
            t,
            new Double2D(50 + 45 * Math.cos(t.id * 2 * Math.PI / numTraders),
                         50 + 45 * Math.sin(t.id * 2 * Math.PI / numTraders))
        );
    }
}
