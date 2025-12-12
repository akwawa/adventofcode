#!/usr/bin/env bash
set -e

# --------------------------------------------------
# Configuration
# --------------------------------------------------
source .env.local
export AWKPATH="${PWD}/src/functions:${AWKPATH:-}"

# --------------------------------------------------
# Fonctions
# --------------------------------------------------

# Récupère toutes les années présentes dans src/
get_years() {
    local dirs=()
    for year_dir in src/*/; do
        [[ ! -d "$year_dir" ]] && continue
        year_dir="${year_dir%/}"
        year=$(basename "$year_dir")
        [[ ! $year =~ ^[0-9]{4}$ ]] && continue
        dirs+=("$year")
    done
    IFS=$'\n' sorted=($(sort <<<"${dirs[*]}"))
    unset IFS
    echo "${sorted[@]}"
}

# Détermine le nombre maximal de jours pour ces années
get_max_day() {
    local max=0
    local years=("$@")
    for year in "${years[@]}"; do
        for script in src/"$year"/*.awk; do
            [[ ! -f "$script" ]] && continue
            day=$(basename "$script" .awk)
            [[ ${#day} -eq 1 ]] && day="0$day"
            day_num=$((10#$day))
            (( day_num > max )) && max=$day_num
        done
    done
    echo "$max"
}

# Appelle run_day.sh avec --timing et retourne le temps d'exécution
run_day_with_timing() {
    local year=$1
    local day=$2
    # On capture seulement la dernière ligne qui contient le temps
    t=$(./run_day.sh --year="$year" --day="$day" --part=all --timing | grep "Durée d'exécution : " | awk '{print $NF}')
    echo "$t"
}

# Génère le tableau Markdown pivoté avec totaux
generate_table() {
    local years=("$@")
    local max_day=$(get_max_day "${years[@]}")
    declare -A col_totals
    declare -A row_totals
    grand_total=0
    declare -A times

    # En-tête
    printf "| Jour |"
    for y in "${years[@]}"; do printf " %s |" "$y"; done
    printf " Total |\n"

    printf "|------"
    for y in "${years[@]}"; do printf "|------"; done
    printf "|-------|\n"

    # Lignes par jour
    for ((d=1; d<=max_day; d++)); do
        day=$(printf "%02d" "$d")
        printf "| %s |" "$day"
        row_sum=0
        for y in "${years[@]}"; do
            t=$(run_day_with_timing "$y" "$day")
            times["$y $day"]=$t
            LC_NUMERIC=C printf " %.3fs |" "$t"
            col_totals["$y"]=$(awk "BEGIN {print ${col_totals["$y"]:-0} + $t}")
            row_sum=$(awk "BEGIN {print $row_sum + $t}")
        done
        row_totals["$day"]=$row_sum
        grand_total=$(awk "BEGIN {print $grand_total + $row_sum}")
        LC_NUMERIC=C printf " %.3fs |\n" "$row_sum"
    done

    # Totaux
    printf "| Total |"
    for y in "${years[@]}"; do
        LC_NUMERIC=C printf " %.3fs |" "${col_totals["$y"]:-0}"
    done
    LC_NUMERIC=C printf " %.3fs |\n" "$grand_total"
}

# --------------------------------------------------
# Script principal
# --------------------------------------------------
main() {
    local years=($(get_years))
    generate_table "${years[@]}"
}

main
