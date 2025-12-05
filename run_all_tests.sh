#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="src"
DATA_DIR="test/data"

export AWKPATH="${PWD}/src/functions:${AWKPATH:-}"

# retourne 0/1 si rien à tester ou s'il y a une erreur
status_overall=0

# On parcourt tous les fichiers .awk dans src (et sous-répertoires)
find "$SRC_DIR" -type f -name "*.awk" | while read -r awkfile; do
  # On calcule un chemin relatif à SRC_DIR
  relpath="${awkfile#$SRC_DIR/}"         # e.g. "2025/01.awk"
  dirname=$(dirname "$relpath")         # e.g. "2025"
  basename=$(basename "$relpath" .awk) # e.g. "01"

  infile="$DATA_DIR/$dirname/$basename.in"
  outfile="$DATA_DIR/$dirname/$basename.out"

  if [[ -f "$infile" && -f "$outfile" ]]; then
    echo "=== Test pour $relpath ==="
    # Exécute awk en lisant l'entrée
    output=$(awk -f "$awkfile" "$infile")
    # Compare la sortie avec le fichier attendu
    if diff -u <(printf "%s\n" "$output") "$outfile"; then
      echo "✅ OK"
    else
      echo "❌ ERREUR : la sortie ne correspond pas à $outfile"
      status_overall=1
    fi
  elif [[ -f "$DATA_DIR/$dirname/test_$basename.awk" ]]; then
    testfile="$DATA_DIR/$dirname/test_$basename.awk"
    echo "=== Test personnalisé pour $relpath via $testfile ==="
    if awk -f "$testfile"; then
      echo "✅ OK"
    else
      echo "❌ ERREUR dans le test personnalisé $testfile"
      status_overall=1
    fi
  else
    echo " — Aucun test automatique pour $relpath (pas de $infile et/ou $outfile)"
  fi
done

exit $status_overall
