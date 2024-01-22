-- Création de la table project
CREATE TABLE project (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(50),
    started_at DATE,
    ended_at DATE,
    project_status VARCHAR(20)
);

-- Création de la table deleted_project
CREATE TABLE deleted_project (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    project_name VARCHAR(50),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    project_status_before_deletion VARCHAR(20)
);

-- Création du trigger
DELIMITER //
CREATE TRIGGER trig_before_delete_project
BEFORE DELETE ON project
FOR EACH ROW
BEGIN
    INSERT INTO deleted_project (project_id, project_name, project_status_before_deletion)
    VALUES (OLD.id, OLD.project_name, OLD.project_status);
END;
//