-- Fonction pour calculer la moyenne
CREATE FUNCTION compute_average(note1 INT, note2 INT, note3 INT)
RETURNS DECIMAL(2,2) DETERMINISTIC
BEGIN
    RETURN (note1 + note2 + note3) / 3.0;
END;

-- Exemple d'utilisation
SELECT compute_average(85, 90, 78) AS Moyenne1,
       compute_average(92, 88, 95) AS Moyenne2,
       compute_average(75, 80, 85) AS Moyenne3;