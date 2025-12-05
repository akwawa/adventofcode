# /usr/bin/awk -f max_digit_pos.awk

# ======================================================================
# File: max_digit_pos.awk
# Description:
#   Returns the position of the highest digit in a substring of STR,
#   between START and END (inclusive).
#
# Usage:
#   pos = max_digit_pos(str, start, end)
#
# Parameters:
#   str     : Input string containing digits.
#   start   : Starting index (1-based).
#   end     : Ending index (1-based).
#
# Returns:
#   Integer : The position of the largest digit found in str[start..end].
#
# Notes:
#   - Comparison is numeric, not lexicographic.
#   - If equal digits exist, the first occurrence is returned.
#
# Dependencies:
#   None.
# ======================================================================

# Retourne la position du chiffre le plus élevé dans str[start..end]
function max_digit_pos(str, start, end,    max_val, pos_max, i, digit) {
    max_val = -1
    pos_max = start
    for (i = start; i <= end; i++) {
        digit = int(substr(str, i, 1))
        if (digit > max_val) {
            max_val = digit
            pos_max = i
        }
    }
    return pos_max
}
