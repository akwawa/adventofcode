#/usr/bin/awk -f src/2025/03.awk data/2025/03.in

@include "select_max_digits.awk"

BEGIN {
    FS = "," # Séparateur de champs = virgule
    part1 = part2 = 0;
}

END {
    printf "Part 1: %d\n", part1;
    printf "Part 2: %d\n", part2;
}

{
    part1 += select_max_digits($1, 2, 1);
    part2 += select_max_digits($1, 12, 1);
}
