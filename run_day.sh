#!/usr/bin/env bash
set -e

source .env.local
export AWKPATH="${PWD}/src/functions:${AWKPATH:-}"

# valeurs par défaut
YEAR=$(date +%Y)
DAY_LIST=($(date +%d))
PART="all"
SHOW_TIME=false

# Parsing options et positionnels
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --year=*) YEAR="${1#*=}"; shift ;;
        --day=*) DAY_INPUT="${1#*=}"; shift ;;
        --part=*) PART="${1#*=}"; shift ;;
        --timing) SHOW_TIME=true; shift ;;
        --year) YEAR="$2"; shift 2 ;;
        --day) DAY_INPUT="$2"; shift 2 ;;
        --part) PART="$2"; shift 2 ;;
        -h|--help) 
            echo "Usage: $0 [YEAR] [DAY] [PART] or --year=YEAR --day=DAY --part=1|2|all"
            exit 0
            ;;
        -*)
            echo "Option inconnue : $1"
            exit 1
            ;;
        *) POSITIONAL+=("$1"); shift ;;
    esac
done

# Traiter les positionnels
[[ ${#POSITIONAL[@]} -ge 1 ]] && YEAR="${POSITIONAL[0]}"
[[ ${#POSITIONAL[@]} -ge 2 ]] && DAY_INPUT="${POSITIONAL[1]}"
[[ ${#POSITIONAL[@]} -ge 3 ]] && PART="${POSITIONAL[2]}"

# --------------------------------------------------
# Fonction pour parser la liste ou la plage de jours
# --------------------------------------------------
parse_days() {
    local input=$1
    local days=()
    IFS=',' read -ra parts <<< "$input"
    for p in "${parts[@]}"; do
        if [[ $p =~ ^([0-9]+)-([0-9]+)$ ]]; then
            for ((i=${BASH_REMATCH[1]}; i<=${BASH_REMATCH[2]}; i++)); do
                days+=($i)
            done
        else
            days+=($p)
        fi
    done
    for i in "${!days[@]}"; do
        days[$i]=$(printf "%02s" "${days[$i]}")
    done
    echo "${days[@]}"
}

# construire la liste de jours
if [[ -n "$DAY_INPUT" ]]; then
    DAY_LIST=($(parse_days "$DAY_INPUT"))
else
    DAY_LIST=($(printf "%02d" "$(date +%d)"))
fi

# --------------------------------------------------
# Fonctions d'exécution
# --------------------------------------------------
download_input() {
    local file=$1
    local year=$2
    local day=$((10#$3))
    if [[ ! -s "$file" ]]; then
        mkdir -p "data/$year"
        echo "Téléchargement de $file..."
        http_code=$(curl --silent --cookie "session=$AOC_SESSION" \
            --write-out "%{http_code}" \
            "https://adventofcode.com/$year/day/$day/input" --output "$file")
        if [[ $http_code -ne 200 ]]; then
            echo "Fichier absent (HTTP $http_code)"
            rm -f "$file"
        fi
    fi
}

run_day() {
    local year=$1
    local day=$2
    local part=$3

    local script="src/$year/$day.awk"
    local data="data/$year/$day.in"

    if [[ ! -f "$script" ]]; then
        echo "Erreur : script $script introuvable."
        return 1
    fi

    if [[ ! -s "$data" ]]; then
        download_input "$data" "$year" "$day"
    fi;

    if $SHOW_TIME; then
        local start=$(date +%s.%N)
        output=$(awk -f "$script" "$data")
        local end=$(date +%s.%N)
        elapsed=$(LC_NUMERIC=C awk "BEGIN {print $end - $start}")
    else
        output=$(awk -f "$script" "$data")
        elapsed=""
    fi

    case "$part" in
        1) echo "$output" | grep "Part 1" ;;
        2) echo "$output" | grep "Part 2" ;;
        all) echo "$output" ;;
        *) echo "Partie invalide : $part"; return ;;
    esac

    if $SHOW_TIME; then
        echo "Durée d'exécution : $elapsed"
    fi
}

# --------------------------------------------------
# Exécution
# --------------------------------------------------
echo "Exécution AoC $YEAR Jour(s) ${DAY_LIST[*]} Partie $PART..."
for d in "${DAY_LIST[@]}"; do
    echo "=== Jour $d ==="
    run_day "$YEAR" "$d" "$PART"
done
