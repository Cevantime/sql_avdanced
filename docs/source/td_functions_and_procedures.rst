TD Fonctions et Procédures
==========================

Exercice 1 : Fonction de calcul de moyenne
---------------------------------------------

Créez une fonction appelée ``compute_average`` qui prend trois paramètres (notes) en entrée et renvoie la moyenne. Utilisez cette fonction pour calculer la moyenne de trois ensembles de notes différents.



Exercice 2 : Procédure d'insertion
----------------------------------

En utilisant la table suivante : 

.. code-block:: sql

    CREATE TABLE client (
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(50),
        email VARCHAR(100)
    );

Créez une procédure appelée ``insert_client`` qui prend le nom et l'email d'un client en paramètres, insère une nouvelle entrée dans une table ``client`` avec un nouvel identifiant auto-incrémenté, et renvoie en paramètre ``OUT`` l'identifiant nouvellement généré.


Exercice 3 : Fonction de conversion de devise
---------------------------------------------

Créez une fonction appelée ``convert_dollars`` qui prend un montant en dollars américains et un taux de change en paramètres, puis renvoie le montant converti dans une autre devise. Testez la fonction pour convertir plusieurs montants avec des taux de change différents.


Exercice 4 : Procédure de mise à jour avec historique
-----------------------------------------------------
Avec le schéma suivant :

.. code-block:: sql

    -- Table pour stocker les produits
    CREATE TABLE product (
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(50),
        quantity INT
    );

    -- Table pour stocker l'historique du stock
    CREATE TABLE stock_history (
        id INT PRIMARY KEY AUTO_INCREMENT,
        ID_Produit INT,
        quantity_before INT,
        quantity_after INT,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_product) REFERENCES product(id)
    );


Créez une procédure appelée ``update_stock`` qui prend l'ID d'un produit et la nouvelle quantité en paramètres. La procédure devrait mettre à jour la quantité disponible dans une table stock et ajouter une entrée dans une table ``stock_history`` avec l'ID du produit, la quantité avant la mise à jour, et la quantité après la mise à jour.