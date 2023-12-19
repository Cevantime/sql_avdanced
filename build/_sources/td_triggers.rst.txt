TD triggers 
===========


Création d'une table de modification
------------------------------------

Exercice : Suivi des modifications d'une table

Considérons une base de données simple pour un système de gestion des employés. Vous avez une table _employee_ avec les colonnes suivantes :

.. list-table:: employee
   :widths: 25, 50
   :header-rows: 1

   * - Nom de colonne
     - Commentaire
   * - id
     - clé primaire, auto-incrémentée
   * - firstname
     -
   * - lastname
     -
   * - salary
     - 
   * - hiring_date
     - 


Votre tâche est de créer un trigger qui enregistre chaque modification apportée à la table **employee** dans une table de suivi appelée **employee_updates**. La table de suivi devrait avoir les colonnes suivantes :

.. list-table:: employee_updates
   :widths: 25, 50
   :header-rows: 1

   * - Nom de colonne
     - Commentaire
   * - id
     - clé primaire, auto-incrémentée
   * - employee_id
     - identifiant de l'employé modifié, clé étrangère
   * - updated_field
     - nom de la colonne modifiée
   * - old_value
     - ancienne valeur
   * - new_value
     - nouvelle valeur
   * - updated_at
     - date de modification (timestamp courant)


Votre trigger doit être déclenché après une modification (INSERT, UPDATE) sur la table **employee**. Assurez-vous de gérer les cas où plusieurs colonnes peuvent être modifiées en une seule requête.

Conseils :

.. note::

    * Utilisez les tables temporaires pour stocker les anciennes valeurs avant la mise à jour.
    * Utilisez une structure de contrôle comme IF-ELSE pour gérer les cas où plusieurs colonnes sont modifiées.

Bonne chance ! N'hésitez pas à demander de l'aide si besoin ;) 


Gestion des suppressions dans une table
---------------------------------------

Imaginez une application de gestion de projets où vous avez une table **project** avec les colonnes suivantes :

.. list-table:: project
   :widths: 25, 100
   :header-rows: 1

   * - Nom de colonne
     - Commentaire
   * - id
     - clé primaire, auto-incrémentée
   * - name
     -
   * - started_at
     -
   * - ended_at
     - 
   * - status
     - peut prendre les valeurs 'En Cours', 'Terminé', 'Annulé', etc.


Vous devez créer un trigger qui maintient une trace des projets supprimés dans une table de suivi appelée **deleted_project**. La table de suivi doit avoir les colonnes suivantes :

.. list-table:: project
   :widths: 25, 100
   :header-rows: 1

   * - Nom de colonne
     - Commentaire
   * - id
     - clé primaire, auto-incrémentée
   * - project_id
     - identifiant du projet supprimé, clé étrangère
   * - deleted_at
     -
   * - status_before_deletion
     - statut du projet avant la suppression


Votre trigger doit être déclenché avant la suppression d'une ligne dans la table **project** et doit remplir la table de suivi avec les informations appropriées.

Conseils :

.. note ::
    * Utilisez la variable OLD pour accéder aux valeurs avant la suppression.
    * Assurez-vous de vérifier si la suppression concerne bien un projet existant.


Gestion des contraintes métier
------------------------------

Considérons une base de données pour une application de gestion des stocks. Vous avez une table **product** avec les colonnes suivantes :

.. list-table:: product
   :widths: 25, 100
   :header-rows: 1

   * - Nom de colonne
     - Commentaire
   * - id
     - clé primaire, auto-incrémentée
   * - quantity
     -
   * - minimum_quantity
     - quantité minimale autorisée en stock
   * - maximum_quantity
     - 
   * - status
     - peut prendre les valeurs 'Actif' ou 'Inactif'



Votre tâche est de créer deux triggers pour appliquer les contraintes métier suivantes :

#. Si la quantité disponible d'un produit devient inférieure à son seuil minimum, le statut du produit doit automatiquement changer pour 'Inactif'.
#. Si un produit est marqué comme 'Inactif', la quantité disponible doit être mise à zéro.


Conseils :

.. note ::
    * Utilisez un trigger BEFORE UPDATE pour le premier cas.
    * Utilisez un trigger BEFORE INSERT ou BEFORE UPDATE pour le deuxième cas.
    * Utilisez la variable NEW pour accéder aux nouvelles valeurs.