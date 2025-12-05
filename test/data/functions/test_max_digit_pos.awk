# ======================================================================
# Test script for max_digit_pos()
# ======================================================================

@include "max_digit_pos.awk"

BEGIN {
    print "=== Test max_digit_pos ==="

    # Tableau de tests
    # Format: str,start,end,expected_pos
    test_cases[1] = "98121,1,5,1"   # max digit 9 at position 1
    test_cases[2] = "69187,1,5,2"   # max digit 9 at position 2
    test_cases[3] = "123456789,1,9,9" # max digit 9 at position 9
    test_cases[4] = "987654321,3,7,3" # substring 7 6 5 4 3 → max 7 at position 3
    test_cases[5] = "11111,1,5,1"   # all digits equal → first position
    test_cases[6] = "9081726354,2,8,3" # substring 0 8 1 7 2 6 3 → max 8 at position 3

    n = length(test_cases)

    for (i = 1; i <= n; i++) {
        split(test_cases[i], fields, ",")
        str = fields[1]
        start = fields[2]
        end = fields[3]
        expected = fields[4]

        pos = max_digit_pos(str, start, end)
        if (pos == expected) {
            print "✅ Test", i, "passed: max_digit_pos(" str "," start "," end ") =", pos
        } else {
            print "❌ Test", i, "FAILED: max_digit_pos(" str "," start "," end ") =", pos, "expected", expected
        }
    }

    print "=== End of tests ==="
    exit
}
