create database accidents_2012_2022;
use database accidents_2012_2022;

use schema public;

use warehouse query;

create table if not exists vehicules(
vehicule_id number identity(1,1) primary key,
num_acc number,
num_veh string,
category_veh number,
obstacle number,
obstacle_m	number,
choc	number,
manoeuvre number
);

create file format if not exists csv_format 
    TYPE=CSV
    SKIP_HEADER=1
    FIELD_DELIMITER=','
    TRIM_SPACE=TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY='"'
    REPLACE_INVALID_CHARACTERS=TRUE
    DATE_FORMAT=AUTO
    TIME_FORMAT=AUTO
    TIMESTAMP_FORMAT=AUTO; 


copy into vehicules(num_acc, num_veh, category_veh, obstacle, obstacle_m, choc, manoeuvre)
from @load_stage/
pattern='.*vehicules.*[.]csv'
file_format=csv_format;


create table if not exists category_veh(
category_id number primary key,
category_name string
);

insert into category_veh
values 
(0 , 'inconnu'),
(1 , 'Bicyclette'),
(2 , 'Cyclomoteur'),
(3 , 'Voiturette' ),
(4 , 'scooter immatriculé'),
(5 , 'motocyclette'),
(6 , 'side-car'),
(7 , 'VL seul'),
(8 , 'VL + caravane'),
(9 , 'VL + remorque'),
(10 ,' VU seul'),
(11 ,' VU (10) + caravane'),
(12 ,' VU (10) + remorque'),
(13 ,' PL seul 3,5T '),
(14 ,' PL seul > 7,5T'),
(15 ,' PL + remorque'),
(16 ,' Tracteur routier seul'),
(17 ,' Tracteur routier + semi-remorque'),
(18 ,' transport en commun'),
(19 ,' tramway'),
(20 ,' Engin spécial'),
(21 ,' Tracteur agricole'),
(30 ,' Scooter'),
(31 ,' Motocyclette > 50 cm3 et <= 125 cm3'),
(32 ,' Scooter > 50 cm3 et <= 125 cm3'),
(33 ,' Motocyclette > 125 cm3'),
(34 ,' Scooter > 125 cm3'),
(35 ,' Quad léger <= 50 cm3 '),
(36 ,' Quad lourd > 50 cm3 '),
(37 ,' Autobus'),
(38 ,' Autocar'),
(39 ,' Train'),
(40 ,' Tramway'),
(41 ,' 3RM <= 50 cm3'),
(42 ,' 3RM > 50 cm3 <= 125 cm3'),
(43 ,' 3RM > 125 cm3'),
(50 ,' EDP à moteur'),
(60 ,' EDP sans moteur'),
(80 ,' VAE'),
(99 ,' Autre véhicule');


create table if not exists obs(
obs_id number primary key,
obs_name string
);

insert into obs
values
(-1, 'Non renseigné'),
(0 , 'Sans objet'),
(1 , 'Véhicule en stationnement'),
(2 , 'Arbre'),
(3 , 'Glissière métallique'),
(4 , 'Glissière béton'),
(5 , 'Autre glissière'),
(6 , 'Bâtiment, mur, pile de pont'),
(7 , 'Support de signalisation verticale ou poste d’appel d’urgence'),
(8 , 'Poteau'),
(9 , 'Mobilier urbain'),
(10 ,'Parapet'),
(11 ,'Ilot, refuge, borne haute'),
(12 ,'Bordure de trottoir'),
(13 ,'Fossé, talus, paroi rocheuse'),
(14 ,'Autre obstacle fixe sur chaussée'),
(15 ,'Autre obstacle fixe sur trottoir ou accotement'),
(16 ,'Sortie de chaussée sans obstacle');


create table if not exists obsm(
obsm_id number primary key,
obsm_name string
);

insert into obsm
values
(-1, 'Non renseigné'),
(0 , 'Aucun'),
(1 , 'Piéton'),
(2 , 'Véhicule'),
(4 , 'Véhicule sur rail'),
(5 , 'Animal domestique'),
(6 , 'Animal sauvage'),
(9 , 'Autre');

create table if not exists choc(
choc_id number primary key,
choc_name string
);

insert into choc
values
(-1, 'Non renseigné'),
(0 , 'Aucun'),
(1 , 'Avant'),
(2 , 'Avant droit'),
(3 , 'Avant gauche'),
(4 , 'Arrière'),
(5 , 'Arrière droit'),
(6 , 'Arrière gauche'),
(7 , 'Côté droit'),
(8 , 'Côté gauche'),
(9 , 'Chocs multiples (tonneaux)');



create table if not exists manv(
manv_id number primary key,
manv_name string
);

insert into manv
values 
(-1 ,' Non renseigné'),
(0 , 'Inconnue'),
(1 , 'Sans changement de direction'),
(2 , 'Même sens, même file'),
(3 , 'Entre 2 files'),
(4 , 'En marche arrière'),
(5 , 'A contresens'),
(6 , 'En franchissant le terre-plein central'),
(7 , 'Dans le couloir bus, dans le même sens'),
(8 , 'Dans le couloir bus, dans le sens inverse'),
(9 , 'En s’insérant'),
(10 ,' En faisant demi-tour sur la chausséeChangeant de file'),
(11 ,' changement de file assert gauche'),
(12 ,' changement de file assert droite'),
(13  , 'Déporté à gauche'),
(14 , 'Déporté à droite'),
(15 ,' Tournant à gauche'),
(16 ,' Tournant à droite'),
(17 ,' Dé passant à gauche'),
(18 ,' Dépassant à droite'),
(19 ,' Traversant la chaussée'),
(20 ,' Manoeuvre de stationnement'),
(21 ,' Manoeuvre d’évitement'),
(22 ,' Ouverture de porte'),
(23 ,' Arrêté (hors stationnement)'),
(24 ,' En stationnement (avec occupants)'),
(25 ,' Circulant sur trottoir'),
(26 ,' Autres manoeuvres');


Alter table vehicules
add constraint FK_OBS FOREIGN KEY(obstacle) REFERENCES obs(obs_id);

Alter table vehicules
add constraint FK_OBSM FOREIGN KEY(obstacle_m) REFERENCES obsm(obsm_id);

Alter table vehicules 
add constraint FK_CHOC FOREIGN key(choc) REFERENCES choc(choc_id);

Alter table vehicules 
add constraint FK_MANV FOREIGN KEY(manoeuvre) REFERENCES manv(manv_id);
