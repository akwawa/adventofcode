# remove_one.awk

# Fonction pour générer les combinaisons en supprimant un élément
function remove_one(arr, n) {
    ind = 1
    # Imprimer la combinaison complète
    for (i = 1; i <= n; i++) {
        result[ind] = result[ind] " " arr[i]
    }
    ind++;

    # Générer les combinaisons en supprimant un nombre à chaque fois
    for (i = 1; i <= n; i++) {
        for (j = 1; j <= n; j++) {
            if (j != i) {
                result[ind] = result[ind] " " arr[j]
            }
        }
        ind++;
    }

    for (k in result) {
        print result[k];
    }
}

# Traitement de chaque ligne d'entrée
{
    # Diviser la ligne en un tableau de nombres
    split($0, arr, " ")
    n = length(arr)  # Longueur de l'array

    # Appeler la fonction pour générer les combinaisons
    remove_one(arr, n)
}
