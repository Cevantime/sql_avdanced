Les triggers
============

Que sont les triggers ?
-----------------------

Un trigger SQL sert à déclencher une action lorsque des opérations **d'écriture** (``INSERT``, ``UPDATE``) ou de **suppression** (``DELETE``) sont effectués dans une base de données SQL.

Concrètement, cela revient à écrire un script SQL qui s'exécutera **avant** ou **après** que les données d'une table soient modifiées.

Voici un exemple de besoin pouvant justifier la création d'un trigger : 

.. note::
    Je souhaite m'assurer que chaque nouveau produit inséré en base soit associé à une fiche produit.
    Si ce n'est pas le cas, je souhaite associer une fiche par défaut.

Ceci n'est évidemment qu'un exemple puisque les triggers sont avant tout **des scripts** pouvant être utilisés pour toutes sortes de choses.


Les types de trigger
--------------------

Il existe deux types de trigger en SQL :
 * Les row level triggers
 * Les statement level triggers

Les **row level triggers** (déclencheurs s'exécutant par rangée) s'exécutent pour chacune des rangées concernées par une requête.

Exemple:

.. note::
    Si je mets à jour (``UPDATE``) la colonne "status" de tous les utilisateur ayant moins de 18 ans et que j'ai configuré un trigger sur cette table, ce trigger s'exécutera pour chacun des utilisateurs ayant moins de 18 ans.

Les **statement level trigger** (déclencheurs s'exécutant par requête) sont des triggers s'exécutant **une fois par requête**. Il sont utilisés uniquement dans certains SGBDR (Oracle, notamment) et affecte l'entièreté d'une requête.

.. warning::
    Dans cette section, nous n'aborderons que les **statement level triggers**


Cas d'usage
-----------

Comme dit précédemment, les triggers peuvent être utilisés pour tout et n'importe quoi, puisque ce sont de simples scripts. Néanmoins, précisons quelques cas d'usage : 

 * **Appliquer certaines règles métiers** : on peut par exemple créer un trigger s'assurant qu'un utilisateur n'ait pas accès à certains contenus d'une application
 * **Garantir l'intégrité d'une base de données** : on peut s'assurer qu'une colonne sensée être non nulle ait une valeur par défaut adaptée.
 * **Automatiser des tâches** : on peut créer une rangée dans une autre table lorsqu'une donnée est créee. Pourquoi pas une table de notifications ?

Syntaxe SQL
-----------

Voici la synthaxe à utiliser pour créer des trigger

.. code-block:: sql
    
    CREATE
    [DEFINER = utilisateur_bdd]
    TRIGGER [IF NOT EXISTS] <nom_du_trigger> 
    <BEFORE ou AFTER> <INSERT, UPDATE ou DELETE>
    ON <nom_table> FOR EACH ROW
    [<PRECEDES ou FOLLOWS> <nom_autre_trigger>]
    <code_du_trigger>

où :
 * ``DEFINER`` : nom de l'utilisateur définissant le niveau de privilège requis pour exécuter le trigger (*optionnel*)
 * ``<nom_du_trigger>`` : nom du trigger à créer
 * ``<BEFORE ou AFTER>`` : si le trigger s'exécute **avant** ou **après** l'opération de mise à jour visée
 * ``<INSERT, UPDATE ou DELETE>`` : si l'opération visée par le trigger est une opération d'**ajout**, de **modification** ou de **suppression**
 * ``<nom_table>`` : nom de la table où définir le trigger
 * ``<PRECEDES ou FOLLOWS> <nom_autre_trigger>`` : si plusieurs triggers sont déclarés, permet de définir un ordre de priorité en prrécisant **avant** ou **après** quel autre trigger ce trigger doit s'exécuter. (*optionnel*)
 * ``<code_du_trigger>`` : le code du trigger en lui-même

.. note::

    Notez que les mots clé ``OLD`` et ``NEW`` peuvent être utilisés pour faire référence à la valeur de la rangée **avant** et **après** modification. 

.. warning::

    Pour les triggers ``INSERT``, seul ``NEW`` est accepté.

.. warning::

    Pour les triggers ``DELETE``, seul ``OLD`` est accepté.


Quelques exemples
------------------

Voici un trigger forçant tous les noms de produit à être en majuscules en base:

.. code-block:: sql

    CREATE TRIGGER `force_uc_for_products_names_insert` 
    BEFORE INSERT 
    ON `product` FOR EACH ROW
        SET NEW.name = UPPER(NEW.name)

Voici un trigger permettant de mettre à jour les commentaires des produits en fonction de l'évolution de leur prix.
Ce trigger ne peut être exécuté que si l'utilisateur a le niveau de privilège de "brand_administrator" et doit s'exécuter après le trigger précédent.

.. code-block:: sql    

    CREATE TRIGGER `update_comment_trigger` 
    DEFINER `brand_administrator`
    BEFORE UPDATE 
    ON `product` 
    FOLLOWS `force_uc_for_products_names_insert`
    FOR EACH ROW 
        IF (OLD.price < NEW.price) THEN
            SET NEW.comment = 'En augmentation !';
        ELSEIF(OLD.price > NEW.price) THEN
            SET NEW.comment = 'En promotion !';
        END IF

