#/usr/bin/awk -f src/2025/05.awk data/2025/05.in

BEGIN {
    FS = "," # Séparateur de champs = virgule
    part1 = part2 = 0;
    delete arr_range;
    delete arr_range_fresh;
}

END {
    part2 = calc_segments(arr_range_fresh);
    # print count_union(arr_range_fresh, length(arr_range_fresh));

    printf "Part 1: %d\n", part1;
    printf "Part 2: %d\n", part2;
}

# Fonction : calcule les longueurs des segments "begin" ... "end"
# arr : tableau de valeur à 2 dimensions contenant "b" pour begin et "e" pour end
# retourne : somme des longueurs de tous les segments externes
function calc_segments(arr,    key, val_b, val_e, begin, key_begin, total) {
    # Parcours trié numériquement
    PROCINFO["sorted_in"] = "@ind_num_asc";

    begin = key_begin = total = 0;

    for (key in arr) {
        # Ouverture des segments
        begin += arr[key]["b"];
        if (begin > 0 && key_begin == 0) {
            # Début d'un segment
            key_begin = key;
            # print "begin " key;
        }

        # Fermeture des segments
        begin -= arr[key]["e"];
        if (begin == 0 && key_begin > 0) {
            # Fin d'un segment
            total += key - key_begin + 1;
            # print "end " key_begin " -> " key;
            key_begin = 0;
        }
    }
    return total
}

(/-/){
    arr_range[length(arr_range)+1] = $0;

    split($0, bounds, "-");
    if (int(bounds[2]) >= int(bounds[1])) {
        arr_range_fresh[int(bounds[1])]["b"]++;
        arr_range_fresh[int(bounds[1])]["e"] += 0;
        arr_range_fresh[int(bounds[2])]["b"] += 0;
        arr_range_fresh[int(bounds[2])]["e"]++;
    }

    next;
}

(/^[0-9]+$/) {
    for (i=1; i<=length(arr_range); i++) {
        split(arr_range[i], bounds, "-");
        if (int($0) >= int(bounds[1]) && int($0) <= int(bounds[2])) {
            part1++;
            break;
        }
    }
}

# 427691213577478
# 111819404056106
#   5481818643364
#  75239447580669
#  70604527103323
# 345755049374924
# 345755049374924
