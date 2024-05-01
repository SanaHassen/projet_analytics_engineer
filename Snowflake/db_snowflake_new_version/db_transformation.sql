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



ALTER TABLE FACT_LIEUX
ADD COLUMN date DATE;
ALTER TABLE FACT_LIEUX
ADD COLUMN departement_id varchar;



UPDATE FACT_LIEUX
SET date = FACT_CARACTERISTIQUES.date
FROM FACT_CARACTERISTIQUES
WHERE FACT_CARACTERISTIQUES.num_acc = FACT_LIEUX.num_acc;



UPDATE FACT_LIEUX
SET departement_id = FACT_CARACTERISTIQUES.departement_id
FROM FACT_CARACTERISTIQUES
WHERE FACT_CARACTERISTIQUES.num_acc = FACT_LIEUX.num_acc;

ALTER TABLE FACT_USAGERS
ADD COLUMN date DATE;
ALTER TABLE FACT_USAGERS
ADD COLUMN departement_id varchar;



UPDATE FACT_USAGERS
SET date = FACT_CARACTERISTIQUES.date,
    departement_id = FACT_CARACTERISTIQUES.departement_id
FROM FACT_CARACTERISTIQUES
WHERE FACT_CARACTERISTIQUES.num_acc = FACT_USAGERS.num_acc;




ALTER TABLE FACT_USAGERS
ADD COLUMN age_usager int;

UPDATE FACT_USAGERS
SET age_usager = CASE 
                 WHEN annee_naissance = -1 THEN -1
                 ELSE YEAR(date) - annee_naissance
                 END;

                 
ALTER TABLE FACT_USAGERS DROP COLUMN annee_naissance;


ALTER TABLE FACT_VEHICULES
ADD COLUMN date DATE;
ALTER TABLE FACT_VEHICULES
ADD COLUMN departement_id varchar;


UPDATE FACT_VEHICULES
SET date = FACT_CARACTERISTIQUES.date,
    departement_id = FACT_CARACTERISTIQUES.departement_id
FROM FACT_CARACTERISTIQUES
WHERE FACT_CARACTERISTIQUES.num_acc = FACT_VEHICULES.num_acc;




--TEST
select f.num_acc, f.departement_id as carac_departement_id, l.departement_id
from fact_caracteristiques f
join fact_lieux l on f.num_acc = l.num_acc
where f.departement_id = '01';

select f.num_acc, f.departement_id as carac_departement_id, l.departement_id, f.date as carac_date, l.date
from fact_caracteristiques f
join fact_usagers l on f.num_acc = l.num_acc
where f.departement_id = '01';


select f.num_acc, f.departement_id as carac_departement_id, l.departement_id, f.date as carac_date, l.date
from fact_caracteristiques f
join FACT_VEHICULES l on f.num_acc = l.num_acc
where f.departement_id = '01';































