package jacocodemo;

public class GradeCalculator {

    public static char toLetterGrade(int score) {
        if (score < 0 || score > 100) {
            throw new IllegalArgumentException("Score must be between 0 and 100");
        }

        if (score >= 85) {
            return 'A';
        } else if (score >= 75) {
            return 'B';
        } else if (score >= 65) {
            return 'C';
        } else if (score >= 50) {
            return 'D';
        } else {
            return 'F';
        }
    }

    public static boolean isPassing(char grade) {
        return grade != 'F';
    }
}
