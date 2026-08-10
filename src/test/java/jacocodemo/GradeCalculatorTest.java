package jacocodemo;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class GradeCalculatorTest {

    @Test
    void scoreAboveBoundaryReturnsA() {
        assertEquals('A', GradeCalculator.toLetterGrade(90));
    }

    @Test
    void scoreAtBoundaryReturnsA() {
        assertEquals('A', GradeCalculator.toLetterGrade(85));
    }

    @Test
    void scoreInBRangeReturnsB() {
        assertEquals('B', GradeCalculator.toLetterGrade(80));
    }

    @Test
    void lowScoreReturnsF() {
        assertEquals('F', GradeCalculator.toLetterGrade(30));
    }

    // Note: intentionally no tests for the C range, the D range, the
    // invalid-score exception path, or isPassing() -- run
    // `gradlew jacocoTestReport` and open the HTML report to see JaCoCo
    // flag these as uncovered.
}
