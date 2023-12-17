-- Procédure pour mettre à jour le stock avec historique
CREATE PROCEDURE update_stock(IN product_id INT, IN new_quantity INT)
BEGIN
    DECLARE quantity_before INT;

    -- Récupérer la quantité actuelle
    SELECT quantity INTO quantity_before FROM product WHERE id = product_id;

    -- Mettre à jour la quantité dans la table product
    UPDATE product SET quantity = new_quantity WHERE id = product_id;

    -- Ajouter une entrée dans l'historique
    INSERT INTO stock_history (id, quantity_before, quantity_after)
    VALUES (product_id, quantity_before, new_quantity);
END;

-- Exemple d'utilisation
CALL update_stock(1, 50);
CALL update_stock(2, 75);