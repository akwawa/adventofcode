# /usr/bin/awk -f select_max_digits.awk

# ======================================================================
# File: select_max_digits.awk
# Description:
#   Selects MAX_COUNT digits from STR (keeping original order)
#   to form the largest possible number.
#
# Usage:
#   result = select_max_digits(str, max_count, start)
#
# Parameters:
#   str        : The input string containing digits.
#   max_count  : Number of digits to select.
#   start      : Starting index (1-based). Usually 1.
#
# Returns:
#   String : A sequence of MAX_COUNT digits, forming the maximum number.
#
# Notes:
#   - Uses a greedy windowed algorithm ensuring correctness.
#   - Requires max_digit_pos() from max_digit_pos.awk.
#
# Dependencies:
#   max_digit_pos.awk
# ======================================================================
@include "max_digit_pos.awk"

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
