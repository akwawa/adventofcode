#!/usr/bin/awk -f

# Pour exécuter le script, utilisez la commande suivante :
# awk -f sort.awk <order> input.txt
# où <order> est "asc" pour croissant ou "desc" pour décroissant

# Variable globale pour stocker le résultat
result = ""

# Fonction pour trier une ligne en ordre croissant ou décroissant
function sort_line(line, order,   arr, n, i) {
    split(line, arr, " ")      # Divise la ligne en un tableau
    n = asort(arr)             # Trie le tableau en ordre croissant
    result = ""                # Réinitialise le résultat
    if (order == "desc") {
        for (i = n; i > 0; i--) {
            result = result (i < n ? " " : "") arr[i]  # Construit la chaîne triée
        }
    } else {
        for (i = 1; i <= n; i++) {
            result = result (i > 1 ? " " : "") arr[i]  # Construit la chaîne triée
        }
    }
}

# Traitement de chaque ligne d'entrée
{
    sort_line($0, ARGV[1])     # Appelle la fonction avec la ligne actuelle et l'ordre spécifié
    print result                # Affiche le résultat après le traitement de chaque ligne
}
