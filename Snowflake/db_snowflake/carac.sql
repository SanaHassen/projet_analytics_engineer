use database accidents_2012_2022

use schema public;

use warehouse query;

CREATE TABLE caracteristiques(
    Num_acc varchar(12) primary key,
    an int,
    mois int,
    jour int,
    hrmn varchar(100),
    lum varchar(10),
    agg varchar(10),
    inter varchar(10),
    atm varchar(10),
    col varchar(10),
    com varchar(30),
    adr varchar(250),
    lat varchar(50),
    longi varchar(50),
    dep varchar(10)    
);

COPY INTO caracteristiques (Num_acc, an, mois, jour, hrmn, lum, agg, inter, atm, col, com, adr, lat, longi, dep)
FROM @stage_csv/
PATTERN='.*caract.*[.]csv'
FILE_FORMAT=csv_format_1
ON_ERROR = 'CONTINUE';



CREATE TABLE dim_c_lum (
    id_lum INT,
    intitule VARCHAR(100)
);

INSERT INTO dim_c_lum (id_lum, intitule) VALUES
(1, 'Plein jour'),
(2, 'Crépuscule ou aube'),
(3, 'Nuit sans éclairage public'),
(4, 'Nuit avec éclairage public non allumé'),
(5, 'Nuit avec éclairage public allumé');


CREATE TABLE dim_c_agg (
    id_agg INT,
    intitule VARCHAR(50)
);

INSERT INTO dim_c_agg (id_agg, intitule) VALUES
(1, 'Hors agglomération'),
(2, 'En agglomération');


CREATE TABLE dim_c_inter (
    id_inter INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_c_inter (id_inter, intitule) VALUES
(1, 'Hors intersection'),
(2, 'Intersection en X'),
(3, 'Intersection en T'),
(4, 'Intersection en Y'),
(5, 'Intersection à plus de 4 branches'),
(6, 'Giratoire'),
(7, 'Place'),
(8, 'Passage à niveau'),
(9, 'Autre intersection');


CREATE TABLE dim_c_atm (
    id_atm INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_c_atm (id_atm, intitule) VALUES
(-1, 'Non renseigné'),
(1, 'Normale'),
(2, 'Pluie légère'),
(3, 'Pluie forte'),
(4, 'Neige - grêle'),
(5, 'Brouillard - fumée'),
(6, 'Vent fort - tempête'),
(7, 'Temps éblouissant'),
(8, 'Temps couvert'),
(9, 'Autre');


CREATE TABLE dim_c_col (
    id_col INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_c_col (id_col, intitule) VALUES
(-1, 'Non renseigné'),
(1, 'Deux véhicules - frontale'),
(2, 'Deux véhicules – par l’arrière'),
(3, 'Deux véhicules – par le coté'),
(4, 'Trois véhicules et plus – en chaîne'),
(5, 'Trois véhicules et plus - collisions multiples'),
(6, 'Autre collision'),
(7, 'Sans collision');


Alter table caracteristiques
add constraint FK_LUM FOREIGN KEY(lum) REFERENCES dim_c_lum(id_lum);

Alter table caracteristiques
add constraint FK_AGG FOREIGN KEY(agg) REFERENCES dim_c_agg (id_agg);

Alter table caracteristiques
add constraint FK_INTER FOREIGN KEY(inter) REFERENCES dim_c_inter (id_inter);

Alter table caracteristiques
add constraint FK_ATM FOREIGN KEY(atm) REFERENCES dim_c_atm (id_atm);

Alter table caracteristiques
add constraint FK_COL FOREIGN KEY(col) REFERENCES dim_c_col (id_col);

select * from caracteristiques limit 10;