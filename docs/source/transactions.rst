Les transactions SQL
==============================

Introduction aux transactions SQL
----------------------------------

Qu'est-ce qu'une transaction SQL ?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Une transaction SQL est une suite d'instructions SQL exécutée d'un seul bloc. Elle peut comprendre autant d'opérations que nécessaire.

Propriétés ACID
~~~~~~~~~~~~~~~~

Le but des transactions SQL est de maximiser la fiabilité des interactions avec la base de données, de manière à garantir son intégrité, sa cohérence, sa sécurité etc. Pour cela, elles possèdent certaines propriétés, dites propriétés ACID :

- **Atomicité (A)** : Si une partie de la transaction échoue, l'ensemble de la transaction est annulé.

- **Cohérence (C)** : Une transaction doit laisser la base de données dans un état valide en respectant toutes les contraintes d'intégrité définies.

- **Isolation (I)** : Les transactions en cours doivent être isolées les unes des autres, garantissant que les opérations d'une transaction ne sont pas affectées par d'autres transactions s'exécutant dans d'autres session.

- **Durabilité (D)** : Une fois qu'une transaction est validée, ses modifications doivent être permanentes, même en cas de panne du système.


Syntaxe des transactions
---------------------------

Syntaxe de début de transaction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Le début d'une nouvelle transaction s'écrit de cette manière en SQL :

.. code-block:: sql

    START TRANSACTION;


Syntaxe de Fin de Transaction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Contrairement à ce qu'on pourrait croire, il n'existe pas de `END TRANSACTION` en SQL. La validation d'uns transaction (et sa fin !) sont marqués par le mot-clé `COMMIT` :

.. code-block:: sql

    COMMIT;




Retours en arrière
~~~~~~~~~~~~~~~~~~~

La plupart du temps, les SGBDR sont configurés de manière à effectuer un retour en arrière automatique si une opération échoue durant la transaction. Néanmoins, il est possible d'effectuer cette opération manuellement en utilisant ROLLBACK à tout moment de la transaction.

.. code-block:: sql

    ROLLBACK;

Ceci a pour effet d'annuler l'entièreté de la transaction.

Voici un exemple :

.. code-block:: sql

    START TRANSACTION;

    -- Tentative de mise à jour du salaire de l'employé 101
    UPDATE employee
    SET salary = salary + 5000
    WHERE id = 101;


    DECLARE total_salary DECIMAL(7,2);

    SELECT SUM(salary) INTO total_salary FROM employee;

    -- On vérifie que le total des salaires versé n'est pas un supérieur à 1 million d'€
    -- Si c'est le cas, on annule l'augmentation :(
    IF (total_salary > 1000000) 
    BEGIN
        ROLLBACK;
        PRINT 'La transaction a été annulée car vous payez trop vos employés.';
    END
    ELSE
    BEGIN
        -- Validation de la transaction
        COMMIT;
        PRINT 'La transaction a été validée.';
    END



Un peu plus loin dans les transactions
---------------------------------------


Points de sauvegarde
~~~~~~~~~~~~~~~~~~~~~

Si le comportement le plus standard est d'annuler purement et simplement une transaction SQL. Il est également possible de ne valider qu'une partie de la transaction en effectuer un retour en arrière vers un **point de sauvegarde**. On parle alors de *Rollback partiel*. Pour créer un point de sauvegarde, on utilise la syntaxe suivante :

.. code-block:: sql

    SAVEPOINT nom_point_de_sauvegarde;


Pour effectuer un retour en arrière vers un point de sauvegarde préalablement défini, on utilise `ROLLBACK TO` :


.. code-block:: sql

    ROLLBACK TO nom_point_de_sauvegarde;

Ceci annule la transaction jusqu'au point de sauvegarde spécifié.

.. warning:: 
    Un retour en arrière annule simplement les opérations qui suivent le point de sauvegarde mais ne les retente pas.


Voici un exemple de rollback partiel ou l'on valide un échange d'argent si celui-ci s'est bien passé en annulant uniquement la mise à jour du journal des échanges qui est moins critique.

.. code-block:: sql

    -- Début de la transaction
    START TRANSACTION;

    -- Transfert de 100 euros du client 1 au client 2
    UPDATE customer
    SET money = money - 100
    WHERE id = 1;

    UPDATE customer
    SET money = money + 100
    WHERE id = 2;

    -- Définition d'un point de sauvegarde après le transfert
    SAVEPOINT after_transaction;

    -- Mise à jour de l'enregistrement de journal (hypothétique)
    UPDATE money_exchange_log
    SET status = 'finished'
    WHERE id = 123;

    -- Supposez que quelque chose a mal tourné ici

    -- En cas d'erreur, annuler seulement la mise à jour du journal
    IF (condition_d_erreur)
    BEGIN
        ROLLBACK TO apres_transfert;
        PRINT 'La mise à jour du journal a échoué. Annulation de cette partie de la transaction.';
    END
    ELSE
    BEGIN
        -- Si tout s'est bien passé, valider la transaction
        COMMIT;
        PRINT 'La transaction a été validée avec succès.';
    END



Isolation des Transactions
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Les transactions sont en principe isolées les unes des autres. Cela signifie que tout ce que lit ou manipule une transaction est en principe laissée dans un état gelé et inaccessible aux autres sessions SQL.

Néanmoins, il est possible d'autoriser des niveaux d'isolation plus laxiste en fonction des besoins (souvent pour éviter de bloquer complètement des transactions et créer ainsi des files d'attente !)

- **READ UNCOMMITTED** : C'est le niveau d'isolation le plus faible. Il permet à une transaction d'accéder à des données non validées (non confirmées) par d'autres transactions. Cela peut entraîner des phénomènes de lecture sale, de lecture fantôme et de lecture non répétable.

- **READ COMMITTED** : C'est le niveau d'isolation par défaut dans de nombreux systèmes de gestion de bases de données. Il garantit qu'une transaction ne peut lire que des données validées (confirmées) par d'autres transactions. Cependant, il peut encore permettre des phénomènes de lecture non répétable et de lecture fantôme.

- **REPEATABLE READ** : Ce niveau d'isolation empêche les phénomènes de lecture non répétable et de lecture fantôme. Il garantit qu'une transaction peut relire les mêmes données plusieurs fois sans qu'elles ne changent, même si d'autres transactions les modifient.

- **SERIALIZABLE** : C'est le niveau d'isolation le plus élevé. Il garantit un niveau maximal d'isolation en bloquant les ressources partagées, ce qui empêche les phénomènes de lecture non répétable, de lecture fantôme et d'écriture perdue. Cependant, cela peut entraîner une diminution des performances en raison des verrous.

Pour définir le niveau d'isolation, on écrit ceci **avant le démarrage de la transaction** :

.. code-block:: sql

    SET TRANSACTION ISOLATION LEVEL niveau;





