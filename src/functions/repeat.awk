# /usr/bin/awk -f repeat.awk

# ======================================================================
# File: repeat.awk
# Description:
#   Repeats a string multiple times and returns the concatenated result.
#
# Usage:
#   result = repeat(str_to_repeat, times)
#
# Parameters:
#   str_to_repeat : The string to repeat.
#   times         : Number of times to repeat the string (integer >= 0).
#
# Returns:
#   String : The concatenation of str_to_repeat repeated times.
#
# Notes:
#   - If times <= 0, returns an empty string.
#   - Pure AWK implementation, compatible with all AWK variants.
# ======================================================================

function repeat(str_to_repeat, times, repeated_string, i) {
    repeated_string = ""
    for (i = 1; i <= times; i++) {
        repeated_string = repeated_string str_to_repeat
    }
    return repeated_string
}
