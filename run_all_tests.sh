#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="src"
DATA_DIR="test/data"

export AWKPATH="${PWD}/src/functions:${AWKPATH:-}"

# retourne 0/1 si rien à tester ou s'il y a une erreur
status_overall=0

is_nonempty_file() {
    # renvoie 0 si fichier existe ET n'est pas vide
    [[ -f "$1" && -s "$1" ]]
}

# On parcourt tous les fichiers .awk dans src (et sous-répertoires)
find "$SRC_DIR" -type f -name "*.awk" | while read -r awkfile; do
  # On calcule un chemin relatif à SRC_DIR
  relpath="${awkfile#$SRC_DIR/}"         # e.g. "2025/01.awk"
  dirname=$(dirname "$relpath")         # e.g. "2025"
  basename=$(basename "$relpath" .awk) # e.g. "01"

  echo "=== Test pour $relpath ==="

  #
  # 1️⃣ Cas 1 : test simple 05.in / 05.out
  #
  simple_in="$DATA_DIR/$dirname/$basename.in"
  simple_out="$DATA_DIR/$dirname/$basename.out"

  ran_any_test=0

  if is_nonempty_file "$simple_in" && is_nonempty_file "$simple_out"; then
    ran_any_test=1
    echo "--- Test simple ---"
    # Exécute awk en lisant l'entrée
    output=$(awk -f "$awkfile" "$simple_in")
    # Compare la sortie avec le fichier attendu
    if diff -u <(printf "%s\n" "$output") "$simple_out"; then
      echo "✅ OK"
    else
      echo "❌ ERREUR : la sortie ne correspond pas à $simple_out"
      status_overall=1
    fi
  fi

  #
  # 2️⃣ Cas 2 : tests multiples 05/01.in, 05/01.out, 05/02.in...
  #
  testdir="$DATA_DIR/$dirname/$basename"

  if [[ -d "$testdir" ]]; then
    shopt -s nullglob
    for infile in "$testdir"/*.in; do
      outfile="${infile%.in}.out"

      # SI in ou out vide → ignorer le test
      if ! is_nonempty_file "$infile" || ! is_nonempty_file "$outfile"; then
        continue
      fi

      ran_any_test=1
      name=$(basename "$infile" .in)

      echo "--- Test multiple $name ---"
      output=$(awk -f "$awkfile" "$infile")
      if diff -u <(printf "%s\n" "$output") "$outfile"; then
        echo "  ✅ OK"
      else
        echo "  ❌ ERREUR test $name"
        status_overall=1
      fi
    done
    shopt -u nullglob
  fi

  #
  # 3️⃣ Cas 3 : test personnalisé test_<basename>.awk
  #
  custom="$DATA_DIR/$dirname/test_${basename}.awk"
  if is_nonempty_file "$custom"; then
    ran_any_test=1
    echo "=== Test personnalisé pour $relpath via $custom ==="
    if awk -f "$custom"; then
      echo "✅ OK"
    else
      echo "❌ ERREUR dans le test personnalisé $custom"
      status_overall=1
    fi
  fi


  #
  # 4️⃣ Aucun test trouvé ?
  #
  if [[ $ran_any_test -eq 0 ]]; then
    echo "  — Aucun test trouvé pour $relpath"
  fi
done

exit $status_overall
