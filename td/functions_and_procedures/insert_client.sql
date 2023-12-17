-- Procédure pour insérer un client et obtenir l'identifiant généré
CREATE PROCEDURE insert_client(IN client_name VARCHAR(50), IN client_email VARCHAR(100), OUT generated_client_id INT)
BEGIN
    INSERT INTO client (`name`, email) VALUES (client_name, client_email);
    SET generated_client_id = LAST_INSERT_ID();
END;

-- Exemple d'utilisation
CALL insert_client('John Doe', 'john.doe@example.com', @id_client);
SELECT @id_client AS ID_client_genere;