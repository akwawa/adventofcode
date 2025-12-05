# ======================================================================
# Test script for repeat()
# ======================================================================

@include "repeat.awk"

BEGIN {
    print "=== Test repeat ==="

    # Test cases: str_to_repeat,times,expected
    test_cases[1] = "a,5,aaaaa"
    test_cases[2] = "ab,3,ababab"
    test_cases[3] = "x,0,"           # times = 0 → empty string
    test_cases[4] = "hello,1,hello"
    test_cases[5] = "!,4,!!!!"
    test_cases[6] = "abc,2,abcabc"

    n = length(test_cases)

    for (i = 1; i <= n; i++) {
        split(test_cases[i], fields, ",")
        str = fields[1]
        times = fields[2]
        expected = fields[3]

        result = repeat(str, times)
        if (result == expected) {
            print "✅ Test", i, "passed:", result
        } else {
            print "❌ Test", i, "FAILED: got", result, "expected", expected
        }
    }

    print "=== End of tests ==="
    exit
}
