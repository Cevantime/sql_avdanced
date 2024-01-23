TP Optimisation des performances d'une application
==================================================


L'objectif de ce TP est d'optimiser les performances d'une application similaire à X (anciennement Twitter).

Elle se décompose en plusieurs phase :

- L'implémentation de l'application elle-même (ou du moins de quelques pages fake)
- La création d'un faux jeu de données massif automatisé qui ne prenne pas plus de quelques heures à se générer
- L'optimisation des requêtes

Bonus : Création d'un mécanisme de mise en cache pour les pages critiques comme la page d'accueil

L'application
--------------

On souhaite implémenter un *remake* de twitter (aujourd'hui X). Voici les fonctionnalités demandées :

 - L'utilisateur doit pouvoir s'inscrire et s'identifier grâce à un nom d'utilisateur ou une adresse email.
 - L'utilisateur doit pouvoir ajouter un post lié à son identité (nom d'utilisateur ou email)
 - Un post est constitué au minimum d'un titre (60 caractères max) et d'un message (512 caractères max) mais d'autres colonnes seront probablement nécessaires (à vous de voir !)
 - Les tweets n'affichent par défaut que leur titre
 - L'utilisateur doit pouvoir voir les tweets d'autres utilisateurs
 - L'utilisateur doit pouvoir ajouter des utilisateurs comme amis
 - L'utilisateur doit pouvoir voir ses amis
 - L'utilisateur doit avoir une page où il peut voir les tweets de ses amis
 - L'utilisateur doit pouvoir liker un tweet par l'appui d'un bouton "liker"
 - L'utilisateur doit pouvoir voir un tweet en cliquant sur le tweet. Le contenu du message s'affiche alors et le tweet et considéré comme vu. 
 - Les tweets doivent afficher leur nombre de like **ainsi que** leur nombre de vue.
 - L'utilisateur doit pouvoir voir ses propres tweets et les vues associées
 - L'utilisateur doit pouvoir accéder à un historique de ces likes et de ses vues au jour le jour

Vous êtes libre d'utiliser l'outil que vous souhaitez. Le guide de démarrage que nous effectuerons en cours utilisera le framework Symfony.

L'application livrée doit être fonctionnelle. Le mode de livraison est libre mais parlez m'en avant (git, archive etc.)

.. info::
    Évidemment, je dois pouvoir accéder facilement au code source et aux requêtes.


Création d'un faux jeu de données
-----------------------------------

Vous devez fournir un script permettant de remplir la base de données avec *beaucoup* de données (plusieurs dizaines de millions au moins)

.. warning::
    Ce script doit pouvoir être lancé facilement (une ligne de commande, un bouton sur une UI etc.)


Optimisation des requêtes
---------------------------

La base de données doit utiliser MySQL et vous **devez** me livrer un export de son schéma uniquement (pas de ses données puisque les données peuvent être ajoutées par un script)

.. warning::
    Le schéma livré doit faire apparaître les optimisation de structure que vous avez effectuées, notamment au niveau des index. 