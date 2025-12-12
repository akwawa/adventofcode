#!/usr/bin/awk -f functions/trim.awk
# Ce fichier définit trois fonctions utilitaires pour
# supprimer les espaces autour d'une chaîne.


# ltrim(s)
# Supprime tous les espaces, tabulations et retours à la ligne
# AU DÉBUT (à gauche) de la chaîne s.
# sub() remplace la première occurrence du motif par une chaîne vide.
function ltrim(s) {
    sub(/^[ \t\r\n]+/, "", s)
    return s
}

# rtrim(s)
# Supprime tous les espaces, tabulations et retours à la ligne
# À LA FIN (à droite) de la chaîne s.
function rtrim(s) {
    sub(/[ \t\r\n]+$/, "", s)
    return s
}

# trim(s)
# Combine ltrim et rtrim pour retirer les espaces
# au début et à la fin de la chaîne.
function trim(s) {
    return rtrim(ltrim(s))
}