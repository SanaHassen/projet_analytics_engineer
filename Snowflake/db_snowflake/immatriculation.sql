use database accidents_2012_2022;

use schema public;

use warehouse query;


CREATE TABLE immatriculations (
    Id_accident varchar(100),
    annee int,
    lieu_admin_actuel varchar(100),
    type_accident varchar(100),
    categorie_vehicule varchar(100),
    age_vehicule int
);

copy into immatriculations (Id_accident, annee, lieu_admin_actuel, type_accident, categorie_vehicule, age_vehicule )
from @stage_csv/
pattern='.*immatriculation.*[.]csv'
file_format=csv_format_1;