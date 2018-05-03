package spirograph;
//import java.awt.Graphics2D;
import java.awt.geom.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.event.ChangeListener;
import javax.swing.event.ChangeEvent;

/**
 *
 * @author barry
 */
public class Spirograph {
    private static final int FRAME_WIDTH    = 800;
    private static final int FRAME_HEIGHT   = 800;
    private static final int MAX_POINTS     = 101;

    private static Point2D.Double center;
    private static Point2D.Double[] points = new Point2D.Double[MAX_POINTS];
    private static Color[] colors = new Color[MAX_POINTS];

    private static JComboBox lineStylesList, shapesList;
    private static JSlider numPoints, gapPoints, radSlider;
    private static JFrame frame;
    private static JPanel drawingArea;
    private static JLabel numPointsLabel, gapPointsLabel, radiusLabel;

    /**
     * @param args the command line arguments
     */
    public static void main (String[] args) {
        setupFrame();
        center = new Point2D.Double(
                drawingArea.getWidth() / 2,
                drawingArea.getHeight() / 2
        );
        setPoints();
        updateLabels();
        paint((Graphics2D) drawingArea.getGraphics());
    }

    private static void setupFrame () {
        // choose the most flexible layout manager
        GridBagLayout gb = new GridBagLayout();
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.gridwidth = 1;
        gbc.gridheight = 1;
        gbc.weightx = 1;
        gbc.weighty = 1;
        gbc.anchor = GridBagConstraints.NORTHWEST;
        gbc.insets = new Insets(5, 5, 5, 5);

        // Create and set up the window.
        frame = new JFrame("Spirograph");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setBackground(new Color(255, 255, 255));
        frame.setPreferredSize(new Dimension(FRAME_WIDTH, FRAME_HEIGHT));
        frame.setLayout(gb);

        // line style
        gbc.gridx = 0;
        gbc.gridy = 0;
        JLabel lineStylesLabel = new JLabel("Line Style");
        gb.setConstraints(lineStylesLabel, gbc);
        frame.add(lineStylesLabel);

        gbc.gridx = 0;
        gbc.gridy = 1;
        String[] lineStyles = {"Straight", "Curved"};
        lineStylesList = new JComboBox(lineStyles);
        lineStylesList.setSelectedIndex(1);
        lineStylesList.addActionListener(new ComboBoxListener());
        gb.setConstraints(lineStylesList, gbc);
        frame.add(lineStylesList);

        // number of points
        gbc.gridx = 1;
        gbc.gridy = 0;
        numPointsLabel = new JLabel();
        gb.setConstraints(numPointsLabel, gbc);
        frame.add(numPointsLabel);

        gbc.gridx = 1;
        gbc.gridy = 1;
        numPoints = new JSlider(JSlider.HORIZONTAL, 1, MAX_POINTS, 25);
        numPoints.addChangeListener(new SliderListener());
        numPoints.setMajorTickSpacing(20);
        numPoints.setPaintTicks(true);
        numPoints.setPaintLabels(true);
        gb.setConstraints(numPoints, gbc);
        frame.add(numPoints);

        // the number of points to skip between lines
        gbc.gridx = 2;
        gbc.gridy = 0;
        gapPointsLabel = new JLabel();
        gb.setConstraints(gapPointsLabel, gbc);
        frame.add(gapPointsLabel);

        gbc.gridx = 2;
        gbc.gridy = 1;
        gapPoints = new JSlider(JSlider.HORIZONTAL, 1, 101, 3);
        gapPoints.addChangeListener(new SliderListener());
        gapPoints.setMajorTickSpacing(20);
        gapPoints.setPaintTicks(true);
        gapPoints.setPaintLabels(true);
        gb.setConstraints(gapPoints, gbc);
        frame.add(gapPoints);

        // spirograph radius
        gbc.gridx = 3;
        gbc.gridy = 0;
        radiusLabel = new JLabel();
        gb.setConstraints(radiusLabel, gbc);
        frame.add(radiusLabel);
        
        gbc.gridx = 3;
        gbc.gridy = 1;
        radSlider = new JSlider(JSlider.HORIZONTAL, 50, 350, 250);
        radSlider.addChangeListener(new SliderListener());
        radSlider.setMajorTickSpacing(100);
        radSlider.setPaintTicks(true);
        radSlider.setPaintLabels(true);
        gb.setConstraints(radSlider, gbc);
        frame.add(radSlider);

        // spirograph drawing area
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 4;
        gbc.gridheight = 1;
        gbc.weighty = 12;
        gbc.anchor = GridBagConstraints.CENTER;
        drawingArea = new JPanel();
        drawingArea.setPreferredSize(new Dimension(600, 600));
        gb.setConstraints(drawingArea, gbc);
        frame.add(drawingArea);

        // display all components
        frame.pack();
        frame.setVisible(true);
    }

    private static void setPoints () {
        double radians, radx, rady, cos, sin;
        int np = numPoints.getValue();
        int radius = radSlider.getValue();
        double cx = center.getX();
        double cy = center.getY();
        for (int i = 0; i < np; i++) {
            radians = 2 * Math.PI * i / np;
            cos = Math.cos(radians);
            sin = Math.sin(radians);
            points[i] = new Point2D.Double(
                    cx + (radius * cos),
                    cy + (radius * sin)
            );
            colors[i] = new Color(
                    0.5f,
                    (float) ((cos + 1) / 2),
                    (float) ((sin + 1) / 2)
            );
        }
    }

    private static void updateLabels () {
        numPointsLabel.setText("Number of points [" + numPoints.getValue() + "]");
        gapPointsLabel.setText("Jump between points [" + gapPoints.getValue() + "]");
        radiusLabel.setText("Radius [" + radSlider.getValue() + "]");
    }
    
    private static void paint (Graphics2D g) {
        // clear drawing area
        drawingArea.update(g);

        BasicStroke solid = new BasicStroke(5.0f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND);
        g.setStroke(solid);

        // cycle though points by gap width until we return to our origin
        int p1 = 0;
        int p2 = gapPoints.getValue() % numPoints.getValue();
        do {
            // paint the next line
            g.setPaint(new GradientPaint(points[p1], colors[p1], points[p2], colors[p2]));
            switch (lineStylesList.getSelectedIndex()) {
                case 0:
                    g.draw(new Line2D.Double(
                        points[p1],
                        points[p2])
                    );
                    break;
                case 1:
                default:
                    g.draw(new QuadCurve2D.Double(
                        points[p1].getX(), points[p1].getY(),
                        center.getX(), center.getY(),
                        points[p2].getX(), points[p2].getY())
                    );
                    break;
            }
            // advance the spirograph
            p1 = p2;
            p2 = (p2 + gapPoints.getValue()) % numPoints.getValue();
        } while (p1 != 0);
    }

    private static class ComboBoxListener implements ActionListener {
        public void actionPerformed (ActionEvent e) {
            // JComboBox cb = (JComboBox) e.getSource();
            Spirograph.setPoints();
            Spirograph.updateLabels();
            Spirograph.paint((Graphics2D) drawingArea.getGraphics());
        }
    }

    private static class SliderListener implements ChangeListener {
        public void stateChanged(ChangeEvent e) {
            // JSlider s = (JSlider) e.getSource();
            Spirograph.setPoints();
            Spirograph.updateLabels();
            Spirograph.paint((Graphics2D) drawingArea.getGraphics());
        }
    }
}
