Fonctions et les Procédures SQL
===============================

Introduction
------------

Les fonctions et les procédures permettent de regrouper des blocs de code SQL pour les réutiliser.


Les Fonctions SQL
-----------------

Une fonction SQL est un bloc de code qui effectue une tâche spécifique et renvoie un résultat. Les fonctions peuvent être utilisées dans des expressions SQL, dans la clause SELECT par exemple, pour effectuer des calculs ou manipuler des données.

La syntaxe générale pour créer une fonction SQL est la suivante :

.. code-block:: SQL

    CREATE FUNCTION nom_de_la_fonction([<IN | OUT | INOUT>] paramètre1 <type>, [<IN | OUT | INOUT>] paramètre2 <type>, ...)
    RETURNS <type> 
    -- Corps de la fonction


où :
 * <type> est le type de variable (``INT``, ``VARCHAR(60)``, ``DECIMAL(5,2)`` etc.)
 * ``IN``, ``OUT``, ``INOUT`` précise si le paramètre est un paramètre d'entrée, de sortie ou les deux à la fois 

.. note::
    Les paramètres d'entrée ``IN`` sont présents pour être lus mais pas pour être modifiés/réassignés dans la fonction.
    Les paramètres de sortie ``OUT`` sont conçus pour être modifiés/réassignés mais pas pour être lus. Leur nouvelle valeur peut être réutilisée dans le reste du programme.
    Les paramètres ``INOUT`` combine les deux spécificités. On peut les voir comme de pures _références_.

.. note::
    Par défaut, les paramètres sont de type ``IN`` puisque c'est le mode le plus courant et le plus performant.


.. warning::
    La syntaxe des fonctions peut être un peu plus complexe que celle présentée ci-dessus puisqu'il est possible de préciser d'autres caractéristiques à notre fonction (utiles pour l'optimisation des performances, par exemple). Pour voir cela en détail, consultez le `manuel <https://dev.mysql.com/doc/refman/8.0/en/create-procedure.html>`_.



Quelques exemples de fonction SQL
---------------------------------

Voici une fonction simple qui calcule la somme de deux nombres :

.. code-block:: SQL

    CREATE FUNCTION calculer_somme(a INT, b INT)
    RETURNS INT DETERMINISTIC
    RETURN a + b;

Cette fonction s'utilisera comme ceci :

.. code-block:: SQL

    SELECT calculer_somme(5, 3) AS Resultat;
    -- Résultat : 8

.. note::
    Notez la présence du mot clé ``DETERMINISTIC`` qui permet de préciser que la valeur de retour de notre fonction est entièrement déterminée par ses paramètres.


Autre exemple, utilisant cette fois la notion de paramètre de sortie :

.. code-block:: SQL

    CREATE FUNCTION calculer_montant_total(IN montant DECIMAL(10, 2), IN taxe_pourcentage DECIMAL(5, 2), OUT montant_taxe DECIMAL(10, 2))
    RETURNS DECIMAL(10, 2)
    BEGIN
        -- Calcul du montant total
        DECLARE total DECIMAL(10, 2);
        SET total = montant + (montant * taxe_pourcentage / 100);

        -- Attribution de la valeur de la taxe à la variable OUT
        SET montant_taxe = total - montant;

        -- Retour du montant total
        RETURN total;
    END;

Cette fonction peut s'utiliser comme ceci:

.. code-block:: SQL

    -- Appel de la fonction
    SET @montant_taxe_resultat = 0;
    SELECT calculer_montant_total(100, 10, @montant_taxe_resultat) AS Montant_Total, @montant_taxe_resultat AS Montant_Taxe;
    -- Résultat : 
    -- +---------------+--------------+
    -- | Montant_Total | Montant_Taxe |
    -- +---------------+--------------+
    -- | 110           | 10           |
    -- +---------------+--------------+


Les Procédures SQL
------------------

Une procédure SQL est un ensemble d'instructions SQL regroupées sous un nom spécifique. Contrairement aux fonctions, les procédures ne retournent pas de valeurs. Elles sont souvent utilisées pour effectuer des opérations ou des modifications sur la base de données. On peut les voir comme **un cas particulier de fonction**.

Syntaxe des procédures

La syntaxe générale pour créer une procédure SQL est la suivante :

.. code-block:: SQL

    CREATE PROCEDURE nom_de_la_procedure([<IN | OUT | INOUT>] paramètre1 <type>, [<IN | OUT | INOUT>] paramètre2 <type>, ...)
    BEGIN
        -- Corps de la procédure
    END;


Comme on le voit, il existe deux différences syntaxiques entre les fonctions et les procédures :
 
 * mot clé ``PROCEDURE`` à la place de ``FUNCTION``
 * par de ``RETURNS``

Par conséquent, une procédure ne peut pas contenir dans son corps de mot clé ``RETURN`` non plus !

.. warning:: 
    Comme pour les fonctions, la syntaxe des procédures peut être plus complexe que celle présentée ci-dessus.

Exemple de procédure SQL
------------------------

Voici une procédure qui met à jour la quantité disponible d'un produit en fonction d'un utilisateur :

.. code-block:: SQL

    CREATE PROCEDURE mettre_a_jour_quantite_produit(IN produit_id INT, IN nouvelle_quantite INT)
    BEGIN
        UPDATE produit SET quantity = nouvelle_quantite WHERE id = produit_id;
    END;


Pour exécuter une procédure, utilisez la commande ``CALL`` :

.. code-block:: SQL

    CALL mettre_a_jour_quantite_produit(1, 50);
    -- Cette commande mettra à jour la quantité disponible du produit avec l'ID 1 à 50.


Autre exemple
-------------

Cette procédure permet de décomposer un nombre de secondes en années, jours et heures et assigne ces valeurs en variable de sortie.

.. code-block:: SQL

    CREATE PROCEDURE decomposer_en_annee_jour_heure(IN seconds INT, OUT years INT, OUT days INT, OUT hours INT)
    BEGIN
        SET year = seconds / (24 * 365 * 3600);
        SET days = (seconds % (24 * 365 * 3600)) / (24 * 3600);
        SET hours = ((seconds % (24 * 365 * 3600)) % (24 * 3600)) / 3600;
    END;  

Elle peut être utilisée comme ceci :

.. code-block:: SQL

    CALL decomposer_en_annee_jour_heure(536435, @y, @d, @h);
    SELECT @y années, @d jours, @h heures;

    -- Résultat : 
    -- +--------+-------+--------+
    -- | années | jours | heures |
    -- +--------+-------+--------+
    -- | 2      | 256   | 21     |
    -- +--------+-------+--------+

