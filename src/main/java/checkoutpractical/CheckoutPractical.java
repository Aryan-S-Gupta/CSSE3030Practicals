package checkoutpractical;
import java.util.*;

public class CheckoutPractical {

    enum Browser { CHROME, FIREFOX, SAFARI }
    enum Device { DESKTOP, TABLET, PHONE }
    enum Payment { CARD, PAYPAL }
    enum Account { GUEST, MEMBER }
    enum Delivery { STANDARD, EXPRESS }

    /*
     * Code under test.
     */
    static boolean isSupported(
            Browser browser,
            Device device,
            Payment payment,
            Account account,
            Delivery delivery) {

        if (account == Account.GUEST && delivery == Delivery.EXPRESS) {
            return false;
        }

        if (device == Device.TABLET && payment == Payment.PAYPAL) {
            return false;
        }

        if (browser == Browser.SAFARI
                && device == Device.PHONE
                && payment == Payment.PAYPAL) {
            return false;
        }

        return true;
    }

    /*
     * Paste the constrained ACTS test suite here.
     *
     * Each row must use this order:
     * Browser, Device, Payment, Account, Delivery
     */
    static final String[][] GENERATED_TESTS = {
        {"Chrome", "Desktop", "Card", "Guest", "Standard"},
        {"Chrome", "Phone", "PayPal", "Member", "Express"},
        {"Firefox", "Tablet", "Card", "Member", "Standard"},
        {"Firefox", "Phone", "PayPal", "Guest", "Standard"},
        {"Safari", "Desktop", "Card", "Member", "Express"},
        {"Safari", "Desktop", "PayPal", "Guest", "Standard"},
        {"Chrome", "Tablet", "Card", "Guest", "Standard"},
        {"Firefox", "Desktop", "Card", "Member", "Express"},
        {"Safari", "Tablet", "Card", "Member", "Express"},
        {"Safari", "Phone", "Card", "Guest", "Standard"}
    };

    public static void main(String[] args) {
        int passed = 0;
        int failed = 0;

        System.out.println("Running " + GENERATED_TESTS.length + " generated tests...");

        for (int i = 0; i < GENERATED_TESTS.length; i++) {
            String[] row = GENERATED_TESTS[i];

            if (row.length != 5) {
                System.out.println("FAIL test " + (i + 1) + ": expected 5 values.");
                failed++;
                continue;
            }

            try {
                Browser browser = Browser.valueOf(row[0].trim().toUpperCase());
                Device device = Device.valueOf(row[1].trim().toUpperCase());
                Payment payment = Payment.valueOf(row[2].trim().toUpperCase());
                Account account = Account.valueOf(row[3].trim().toUpperCase());
                Delivery delivery = Delivery.valueOf(row[4].trim().toUpperCase());

                boolean supported = isSupported(
                        browser, device, payment, account, delivery);

                if (supported) {
                    System.out.println("PASS test " + (i + 1) + ": "
                            + String.join(", ", row));
                    passed++;
                } else {
                    System.out.println("FAIL test " + (i + 1)
                            + " violates a system constraint: "
                            + String.join(", ", row));
                    failed++;
                }
            } catch (IllegalArgumentException error) {
                System.out.println("FAIL test " + (i + 1)
                        + " contains an unknown value: "
                        + String.join(", ", row));
                failed++;
            }
        }

        System.out.println();
        System.out.println("Passed: " + passed);
        System.out.println("Failed: " + failed);

        if (failed > 0) {
            throw new AssertionError("The generated test suite contains invalid tests.");
        }

        System.out.println("All generated tests are valid.");
    }
}