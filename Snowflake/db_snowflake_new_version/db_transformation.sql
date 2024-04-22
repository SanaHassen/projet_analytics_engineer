use database accidents_2012_2022;

use schema public;

use warehouse load;


ALTER TABLE FACT_CARACTERISTIQUES
ADD COLUMN date DATE;

UPDATE FACT_CARACTERISTIQUES
SET date = TO_DATE(jour || '/' || mois || '/' || an, 'DD/MM/YYYY'); 

ALTER TABLE FACT_CARACTERISTIQUES DROP COLUMN jour;
ALTER TABLE FACT_CARACTERISTIQUES DROP COLUMN mois;
ALTER TABLE FACT_CARACTERISTIQUES DROP COLUMN an;


ALTER TABLE FACT_USAGERS
ADD COLUMN age_usager int;

UPDATE FACT_USAGERS
SET age_usager = CASE 
                 WHEN annee_naissance = -1 THEN -1
                 ELSE YEAR(CURRENT_DATE()) - annee_naissance
                 END;

                 
ALTER TABLE FACT_USAGERS DROP COLUMN annee_naissance;

