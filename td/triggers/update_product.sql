CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    quantity INT,
    minimum_quantity INT,
    `status` VARCHAR(20) CHECK (`status` IN ('Actif', 'Inactif'))
);

DELIMITER //
CREATE TRIGGER trig_before_update_quantity
BEFORE UPDATE 
ON product
FOR EACH ROW
BEGIN
    IF NEW.quantity < NEW.minimum_quantity THEN
        SET NEW.`status` = 'Inactif';
    END IF;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER trig_before_update_status
BEFORE UPDATE 
ON product
FOLLOWS trig_before_update_quantity
FOR EACH ROW
BEGIN
    IF NEW.`status` = 'Inactif' THEN
        SET NEW.quantity = 0;
    END IF;
END;
//