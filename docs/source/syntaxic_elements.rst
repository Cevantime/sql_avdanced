Éléments syntaxiques cruciaux
=============================

Pour survivre dans les eaux troubles des programmes SQL, il est bon de connaître certains éléments syntaxiques. Cette page tente de lister les plus cruciaux. 

Déclaration de variable
-----------------------

L'une des premières choses à savoir faire reste de déclarer des variables. Trois manières cohabitent en MySQL.

#. Édition d'une variable globale avec ``@@`` 
#. Déclaration d'une variable de session avec ``@``
#. Déclaration d'une variable locale avec ``DECLARE``


Variables globales
------------------

On ne peut pas créer de nouvelles variables globales en SQL. L'usage est uniquement de **modifier la valeur de variables globales déjà existantes.** Dans tous les cas, cela se fait en utilisant ``SET`` :

.. code-block:: sql

    SET @@sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'

Ceci modifie la valeur de la variable globale sql_mode.

Notez que cette syntaxe est également possible :

.. code-block:: sql

    SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'

Et qu'il est possible de modifier une variable globale pour la durée d'une session uniquement, en faisant :

.. code-block:: sql

    SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'


Variables de session
--------------------

Il est possible de créer des variable dont la portée se limite à la session courante, c'est-à-dire une session d'échange avec le serveur tant qu'elle n'est pas fermée par le serveur. 

Cette syntaxe utilise `SET` et nécessite de préfixer le nom de sa variable par `@` : 

.. code-block:: sql

    SET @ma_variable_de_session = 3

Il est également possible de fixer la valeur d'une variable directement dans un SELECT, mais il faudra alors utiliser l'opérateur ``:=`` pour le différencier de ``=`` :

.. code-block:: sql

    SELECT @ma_variable_de_session := 3


Variables locales
-----------------

On peut déclarer des variables localement dans des programmes stockés tels que des fonctions et des procédures. Ces variables n'existeront que dans le programme stocké où elles sont déclarées. Pour cela, on utilise ``DECLARE``. Voici la syntaxe : 

.. code-block:: sql

    DECLARE var_name [, var_name] ... <type> [DEFAULT value]

Pour assigner ensuite une valeur à cette variable, il faut utiliser ``SET``.
Exemple:

.. code-block:: sql

    DECLARE date_de_naissance DATE DEFAULT CURDATE();
    SET date_de_naissance = '18/05/1988';


Bloc conditionnel IF..ELSE
--------------------------

Vous le connaissez déjà dans d'autres langages, voici comment s'organise un bloc conditionnel en MySQL :

.. code-block:: SQL

    IF condition1 THEN
        {...statements to execute when condition1 is TRUE...}

    [ ELSEIF condition2 THEN
        {...statements to execute when condition1 is FALSE and condition2 is TRUE...} ]

    [ ELSE
        {...statements to execute when both condition1 and condition2 are FALSE...} ]

    END IF;

Et voici un exemple : 

.. code-block:: SQL

    DECLARE resultat VARCHAR(50);

    IF valeur > 10 THEN
        SET resultat = 'Supérieur à 10';
    ELSEIF valeur = 10 THEN
        SET resultat = 'Égal à 10';
    ELSEIF valeur > 5 THEN
        SET resultat = 'Entre 6 et 10';
    ELSE
        SET resultat = 'Inférieur ou égal à 5';
    END IF;
