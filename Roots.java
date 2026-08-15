public class Roots {
    // Classifies a*x^2 + b*x + c = 0 by its number of real roots.
    // Returns 2, 1, or 0. Coefficients are integers for this exercise.
    public static int numRoots(int a, int b, int c) {
        int q = b*b - 4*a*c;
        if (q > 0 && a != 0) {
            return 2;
        } else if (q == 0) {              // BUG: missing "a != 0" check
            int root = (0 - b) / (2*a);
            return 1;
        } else {
            return 0;
        }
    }
}