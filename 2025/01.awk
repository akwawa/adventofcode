#awk

BEGIN {
    number = 50;
    nb_zero = 0;
    nb_passage = 0;
    printf "Starting number: %d\n", number;
}
END {
    printf "Part 1: %d\n", nb_zero;
    printf "Part 2: %d\n", nb_passage;
}
{
    dir = substr($1, 1, 1);
    value = substr($1, 2) + 0;

    # Déterminer le pas : +1 pour droite, -1 pour gauche
    step = (dir == "R" ? 1 : -1);

    # Boucle sur tous les clics sauf le dernier
    for(i = 1; i <= value; i++) {
        number += step;
        number %= 100;
        if(number < 0) {number += 100;}
        if(number == 0) {nb_passage++;}
    }

    # Vérifier si on est à zéro à la fin du mouvement
    if(number == 0) {nb_zero++;}
}
