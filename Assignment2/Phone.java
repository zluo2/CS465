
public class Phone {

    public final static int ROWS = 4;
    public final static int COLS = 3;

    public int tour(final int x, final int y, final int length) {
        int total = 0;

        if ((x == 3 && y != 1)) {
            // A symbol
            return total;
        } else if(length == 7) {
            return 1;
        } else {
            if (!(x + 2 >= ROWS || y + 1 >= COLS || x + 2 < 0 || y + 1 < 0)) {
                total += tour(x + 2, y + 1, length + 1);
            }
            if (!(x + 2 >= ROWS || y - 1 >= COLS || x + 2 < 0 || y - 1 < 0)) {
                total += tour(x + 2, y - 1, length + 1);
            }
            if (!(x + 1 >= ROWS || y - 2 >= COLS || x + 1 < 0 || y - 2 < 0)) {
                total += tour(x + 1, y - 2, length + 1);
            }
            if (!(x - 1 >= ROWS || y - 2 >= COLS || x - 1 < 0 || y - 2 < 0)) {
                total += tour(x - 1, y - 2, length + 1);
            }
            if (!(x + 1 >= ROWS || y + 2 >= COLS || x + 1 < 0 || y + 2 < 0)) {
                total += tour(x + 1, y + 2, length + 1);
            }
            if (!(x - 1 >= ROWS || y + 2 >= COLS || x - 1 < 0 || y + 2 < 0)) {
                total += tour(x - 1, y + 2, length + 1);
            }
            if (!(x - 2 >= ROWS || y - 1 >= COLS || x - 2 < 0 || y - 1 < 0)) {
                total += tour(x - 2, y - 1, length + 1);
            }
            if (!(x - 2 >= ROWS || y + 1 >= COLS || x - 2 < 0 || y + 1 < 0)) {
                total += tour(x - 2, y + 1, length + 1);
            }
        }
        return total;
    }

    public static void main(final String[] args) {
        final Phone phone = new Phone();
        int total = 0;
        for (int i = 0; i < ROWS - 1; i++) {
            for (int j = 0; j < COLS; j++) {
                if(i == 0 && j == 0) {
                    // do nothing
                } else {
                    total += phone.tour(i, j, 1);
                }
            }
        }
        // total += phone.tour(0, 1, 0);
        System.out.println(total);
    }
}