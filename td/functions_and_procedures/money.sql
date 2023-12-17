-- Fonction pour convertir un montant en dollars en une autre devise
CREATE FUNCTION convert_dollars(dollar DECIMAL(10, 2), convert_rate DECIMAL(10, 4))
RETURNS DECIMAL(10, 2)
BEGIN
    RETURN dollar * convert_rate;
END;

-- Exemple d'utilisation
SELECT convert_dollars(100, 0.85) AS Montant_Euros,
       convert_dollars(100, 110.25) AS Montant_Yens,
       convert_dollars(100, 0.74) AS Montant_Livres;
