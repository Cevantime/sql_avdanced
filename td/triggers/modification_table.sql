-- Création de la table employee
CREATE TABLE employee (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(50),
    firstname VARCHAR(50),
    salary DECIMAL(10, 2),
    hiring_date DATE
);


-- Création de la table employee_updates
CREATE TABLE employee_updates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    updated_field VARCHAR(50),
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);

-- Création du trigger
DELIMITER //
CREATE TRIGGER `trig_after_update_employee` 
AFTER UPDATE 
ON `employee`
FOR EACH ROW 
BEGIN
    IF NEW.lastname <> OLD.lastname THEN
        INSERT INTO employee_updates (employee_id, updated_field, old_value, new_value)
        VALUES (NEW.id, 'lastname', OLD.lastname, NEW.lastname);
    END IF;

    IF NEW.firstname <> OLD.firstname THEN
        INSERT INTO employee_updates (employee_id, updated_field, old_value, new_value)
        VALUES (NEW.id, 'firstname', OLD.firstname, NEW.firstname);
    END IF;

    IF NEW.salary <> OLD.salary THEN
        INSERT INTO employee_updates (employee_id, updated_field, old_value, new_value)
        VALUES (NEW.id, 'salary', OLD.salary, NEW.salary);
    END IF;

    IF NEW.hiring_date <> OLD.hiring_date THEN
        INSERT INTO employee_updates (employee_id, updated_field, old_value, new_value)
        VALUES (NEW.id, 'hiring_date', OLD.hiring_date, NEW.hiring_date);
    END IF;
END
//