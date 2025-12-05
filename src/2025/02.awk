#/usr/bin/awk -f src/2025/02.awk data/2025/02.in

@include "repeat.awk" # Charger la fonction repeat depuis le fichier externe

BEGIN {
    FS = "," # Séparateur de champs = virgule
    part1 = part2 = 0;
}

END {
    printf "Part 1: %d\n", part1;
    printf "Part 2: %d\n", part2;
}

{
    for(i=1; i<=NF; i++) {   # NF = nombre de champs sur la ligne
        split($i, fields, "-"); # Séparer le champ i en utilisant "-" comme séparateur
        for (actualNumber = (fields[1] + 0); actualNumber <= (fields[2] + 0); actualNumber++) {
            lengthActualNumber = length(actualNumber);

            if (lengthActualNumber % 2 == 0) { # Doit être un nombre pair
                debut = substr(actualNumber, 1, lengthActualNumber / 2);
                fin = substr(actualNumber, (lengthActualNumber / 2 + 1));
                if (debut == fin) {
                    part1 += actualNumber;
                }
            }

            for (letters = 1; letters <= int(lengthActualNumber / 2); letters++) {
                actualLetters = substr(actualNumber, 1, letters);
                repetedLetters = repeat(actualLetters, int(lengthActualNumber / length(actualLetters)));
                if (repetedLetters == actualNumber) {
                    if (!(actualNumber in invalidIds)) {
                        part2 += actualNumber;
                        invalidIds[actualNumber] = 1;
                    }
                }
            }
        }
    }
}