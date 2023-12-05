Avant propos
============

Dans cette partie, nous aborderons de instructions composées et stockées plus complexes que de simples requêtes. Cela requiert, en SQL, quelques précautions syntaxiques. Ce sont ces précisions que nous allons étudier ici.

D'autre part, les exemples et TD de ce cours utilisent le langage SQL de MySQL. D'autres SGBDR peuvent peuvent avoir des syntaxes et fonctionnalités légèrement différentes.

Si vous souhaitez a voir un aperçu de ces différences, voici une `excellente ressource <https://troels.arvin.dk/db/rdbms/>`_.

BEGIN... END
------------

En MySQL (et en postgresql aussi d'ailleurs), l'écriture de programmes stockés implique la création d'instructions multiples. Par conséquent, lorsque vous créez une fonction/procédure/trigger/event à plusieurs instructions, vous devez impérativement entourer celles-ci des mot-clés ``BEGIN`` et ``END;``.

Exemple 

.. code-block:: sql
    CREATE PROCEDURE ma_procedure(a INT, b INT)
    BEGIN
        -- premiere instruction
        -- deuxième instruction
    END;



Modification du délimiteur
--------------------------

Démarrons par une fonctionnalité indispensable lorsqu'on commence à créer des instructions multiples en MySQL, à savoir la **modification du délimiteur**. 

.. warning:: 
    Ce problème est spécifique à MySQL. Si vous utilisez un autre SGBDR, vous pouvez ignorer cette section

Lorsqu'une instruction est soumise au serveur MySQL celui-ci va exécuter toutes les instructions qui se termine par un point virgule ``;``

Ceci peut être problématique dans le cas de l'écriture d'instructions stockées qui ne doivent pas être exécutées au moment de leur création (comme les fonctions).

Voici un exemple : 

.. code-block:: sql

    CREATE FUNCTION calculer_somme(a INT, b INT)
    RETURNS INT
    RETURN a + b;
    

Lorsque ceci est envoyé à MySQL, le serveur va vouloir exécuter l'instruction ``RETURN a + b;`` car celle-ci est terminée par un ``;``, ce qui n'est pas ce que l'on souhaite faire. Cette instruction ne doit être exécutée que **lorsque la fonction est appelée** et non au moment de sa création. 

Pour éviter cela, nous allons **changer temporairement de délimiteur**, afin que ce soit la création de la fonction qui soit exécutée, et non les instructions qu'elle contient. Pour cela, on utilise le mot-clé ``DELIMITER`` : 

.. code-block:: sql
  :emphasize-lines: 1,5

    DELIMITER //
    CREATE FUNCTION calculer_somme(a INT, b INT)
    RETURNS INT
    RETURN a + b;
    //

Ici, on change le délimiteur en ``//`` afin que l'instruction se termine à la fin de la déclaration de la fonction. 

Mais si l'on maintient ce code en l'état, notre modification risque d'être permanente puisque le délimiteur va rester ``//``. Pour revenir au comportement par défaut après notre déclaration de fonction, il faut redéfinir le délimiteur comme ``;`` :

.. code-block:: sql
  :emphasize-lines: 6

    DELIMITER //
    CREATE FUNCTION calculer_somme(a INT, b INT)
    RETURNS INT
    RETURN a + b;
    //
    DELIMITER ;


.. warning::
    Pour ne pas les alourdir, les exemples montrés dans ce cours n'incluent pas la modification de délimiteur. Cependant, il est toujours **indispensable** de l'utiliser.


