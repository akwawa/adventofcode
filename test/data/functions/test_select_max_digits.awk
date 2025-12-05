# ======================================================================
# Test script for select_max_digits()
# ======================================================================

@include "max_digit_pos.awk"

# Définition de select_max_digits (si elle n'est pas incluse)
function select_max_digits(str, max_count, start,    n, pos, i, result) {
    n = length(str)
    pos = start - 1
    result = ""

    for (i = 1; i <= max_count; i++) {
        pos = max_digit_pos(str, pos + 1, n - (max_count - i))
        result = result substr(str, pos, 1)
    }

    return result
}

BEGIN {
    print "=== Test select_max_digits ==="

    # Tableau de tests : str,max_count,start,expected
    test_cases[1] = "89121,3,1,921"        # sélectionner 3 chiffres → 921
    test_cases[2] = "69187,3,1,987"        # sélectionner 3 chiffres → 987
    test_cases[3] = "123456789,4,1,6789"  # sélectionner 4 chiffres → 6789
    test_cases[4] = "987654321,5,1,98765"  # sélectionner 5 chiffres → 98765
    test_cases[5] = "9081726354,4,1,9876"  # sélectionner 4 chiffres → 9876
    test_cases[6] = "1112233,3,1,233"      # sélectionner 3 chiffres → 123
    test_cases[7] = "7654321,2,1,76"       # sélectionner 2 chiffres → 76
    test_cases[8] = "102030405,3,1,405"    # sélectionner 3 chiffres → 304

    n = length(test_cases)

    for (i = 1; i <= n; i++) {
        split(test_cases[i], fields, ",")
        str = fields[1]
        max_count = fields[2]
        start = fields[3]
        expected = fields[4]

        result = select_max_digits(str, max_count, start)
        if (result == expected) {
            print "✅ Test", i, "passed:", result
        } else {
            print "❌ Test", i, "FAILED: got", result, "expected", expected
        }
    }

    print "=== End of tests ==="
    exit
}
