=======================
Optimisation SQL
=======================

Introduction
------------

L'accès et la récupération de données joue un rôle crucial dans les performances d'une application. C'est même généralement le  goulot d'étranglement (*bottleneck*) de la plus fréquent des applications web, loin devant la complexité algorithmique.

Dans ce cours, on aborde les 3 axes d'optimisation principaux pour permettre d'améliorer les performances d'une base de données SQL. Comme dans le reste du cours, on se servira de MySQL comme SGBDR d'exemple mais la plupart des notions abordées sont également valables pour les autres SGBDR : 

 - Optimisation des requêtes
 - Optimisation du schéma des tables
 - Configuration appropriée du serveur


Optimisation des Requêtes
--------------------------

Remarques générales
~~~~~~~~~~~~~~~~~~~~

Les requêtes mal optimisées peuvent entraîner des performances médiocres. Voici quelques conseils pour optimiser vos requêtes MySQL :

1. **Utiliser des index :** Les index accélèrent la recherche des données. Assurez-vous d'indexer les colonnes utilisées fréquemment dans les clauses WHERE et JOIN.

2. **Éviter les opérations coûteuses :** Évitez l'utilisation excessive des opérations telles que ORDER BY, GROUP BY, et DISTINCT, car elles peuvent être gourmandes en ressources.

3. **Optimiser les sous-requêtes :** Les sous-requêtes peuvent être coûteuses. Utilisez-les avec prudence et cherchez des alternatives, comme les jointures.

Surveillance des requêtes
~~~~~~~~~~~~~~~~~~~~~~~~~~

- Journalisation des requêtes :
    Activez le journal des requêtes SQL pour enregistrer les requêtes exécutées. Cela peut aider à identifier les requêtes lentes ou fréquemment utilisées.

- Utilisation d'EXPLAIN :
    Utilisez la commande EXPLAIN avant une requête pour comprendre le plan d'exécution. Cela fournit des informations sur la façon dont MySQL exécutera la requête, ce qui peut aider à identifier les goulots d'étranglement.

- Suivi des performances avec MySQL performance Schema :
    Activez et utilisez le performance Schema de MySQL pour surveiller l'utilisation des ressources, les verrous, les temps d'attente, etc.

- Analyse des logs d'erreurs :
    Examinez les journaux d'erreurs SQL pour détecter tout problème lié à la configuration ou aux performances du serveur.


Optimisation des temps de traitement
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Indexation :
    Assurez-vous que les colonnes utilisées fréquemment dans les clauses WHERE et JOIN sont correctement indexées.

- Utilisation de LIMIT :
    Limitez le nombre de résultats retournés en utilisant la clause LIMIT lorsque vous n'avez besoin que d'un sous-ensemble des données.

- Optimisation des requêtes complexes :
    Divisez les requêtes complexes en plusieurs étapes ou utilisez des sous-requêtes pour améliorer la lisibilité et la performance.

- Utilisation de caches :
    Configurez le cache de requête pour stocker en mémoire les résultats de requêtes fréquemment exécutées.

- Mise en cache côté application :
    Utilisez des mécanismes de mise en cache côté application pour stocker temporairement les résultats des requêtes : le meilleur moyen de limiter le temps d'exécution des requêtes SQL est encore d'en effectuer le moins possible !

        
Conception des Tables
---------------------

Une conception de table efficace est cruciale pour des performances optimales. Voici quelques conseils pour la conception des tables :

1. **Utiliser le bon type de données :** Choisissez le type de données le plus approprié pour chaque colonne. Par exemple, utilisez INT au lieu de VARCHAR pour les identifiants.

2. **Normalisation :** Appliquez la normalisation pour éliminer la redondance des données. Cependant, évitez la sur-normalisation qui peut entraîner des jointures coûteuses.

3. **Partitionnement :** Envisagez le partitionnement des tables pour améliorer la gestion des données, en particulier pour les tables volumineuses.

Développons un peu ici sur la **normalisation** et le **partitionnement**.

Normalisation
~~~~~~~~~~~~~~

La normalisation est le processus de conception de la structure d'une base de données de manière à réduire la redondance des données et à améliorer l'intégrité des données. Elle se divise généralement en plusieurs formes (1NF, 2NF, 3NF, etc.), chacune visant à éliminer certains types de redondance. Cependant, il est important de trouver un équilibre, car une normalisation excessive peut entraîner des performances médiocres en raison du besoin fréquent de jointures. Pour plus d'informations et d'exemples sur la normalisation, voir cet `excellent lien <https://stph.scenari-community.org/bdd/nor1-lin/co/nor_1.html>`.

Principes de Normalisation :

 - 1ère Forme Normale (1NF) : 
    Assurez-vous que chaque colonne ne contient qu'une seule valeur, évitant ainsi les valeurs multiples ou les tableaux dans une colonne.

 - 2ème Forme Normale (2NF) : 
    Assurez-vous que chaque colonne dépend entièrement de la clé primaire, éliminant ainsi les dépendances partielles.

 - 3ème Forme Normale (3NF) : 
    Éliminez les dépendances transitoires entre les colonnes en déplaçant les colonnes non clé qui dépendent d'autres colonnes non clé.

Avantages de la Normalisation :

- Réduction de la redondance des données.
- Maintien de l'intégrité des données.
- Facilitation des mises à jour et des modifications.

Partitionnement des tables
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Le partitionnement consiste à diviser une table en sections plus petites appelées partitions, basées sur certains critères, généralement une colonne spécifique. Cela peut être particulièrement utile pour gérer des bases de données volumineuses et améliorer les performances en permettant une recherche et une gestion plus rapides des données.

Types de Partitionnement :

- Partitionnement Horizontal : 
    Les lignes d'une table sont réparties entre différentes partitions en fonction d'une condition spécifiée. Cela peut être utile pour diviser une table en sections plus petites basées sur une plage de valeurs.

- Partitionnement Vertical : 
    Les colonnes d'une table sont réparties entre différentes partitions. Cela peut être utile lorsque certaines colonnes sont rarement utilisées ou nécessitent un accès séparé.

Avantages du Partitionnement :

    Amélioration des performances des requêtes, en particulier pour les tables volumineuses.
    Facilitation de la gestion des données, notamment pour l'archivage et la suppression.

Considérations pour le Partitionnement :

    Choisissez la colonne de partitionnement en fonction des types de requêtes fréquemment effectuées.
    Surveillez régulièrement la performance et ajustez la stratégie de partitionnement en conséquence.

En incorporant judicieusement la normalisation et le partitionnement dans la conception de votre base de données, vous pouvez améliorer significativement les performances et l'efficacité de MySQL.


Configuration du Serveur MySQL
-------------------------------

La configuration du serveur MySQL peut également affecter les performances. Voici quelques paramètres à considérer :

1. **Taille du cache :** Ajustez les paramètres de cache, tels que le cache de requête et le cache d'index, en fonction de la mémoire disponible sur le serveur.

2. **Thread cache :** Configurez correctement le thread cache pour éviter une utilisation excessive des ressources.

3. **Optimisation des paramètres InnoDB (MySQL seulement) :** Si vous utilisez le moteur InnoDB, configurez les paramètres tels que `innodb_buffer_pool_size` en fonction de la charge de travail.


