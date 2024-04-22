use database accidents_2012_2022;

use schema public;

use warehouse load;

CREATE FILE FORMAT CSV_FORMAT
	TYPE=CSV
    SKIP_HEADER=1
    FIELD_DELIMITER=','
    TRIM_SPACE=TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY='"'
    REPLACE_INVALID_CHARACTERS=TRUE
    DATE_FORMAT=AUTO
    TIME_FORMAT=AUTO
    TIMESTAMP_FORMAT=AUTO; 

    
COPY INTO FACT_VEHICULES(Num_acc, num_veh, category_veh, obstacle, obstacle_m, choc, manoeuvre)
FROM @LOAD_STAGE/
PATTERN='.*vehicules.*[.]csv'
FILE_FORMAT = CSV_FORMAT
ON_ERROR=ABORT_STATEMENT;


copy into FACT_LIEUX
from @load_stage/
pattern='.*lieux.*[.]csv'
file_format=CSV_FORMAT
ON_ERROR=ABORT_STATEMENT;


COPY INTO FACT_USAGERS (Num_Acc,num_veh, category_usager, gravite, sexe, motif_deplacement, secu1, secu2, secu3, localisation_pieton ,action_pieton, pieton_seul_ou_non, annee_naissance)
FROM @load_stage/
PATTERN='.*usagers.*[.]csv'
FILE_FORMAT=CSV_FORMAT
ON_ERROR=ABORT_STATEMENT;


COPY INTO FACT_CARACTERISTIQUES
FROM @load_stage/
PATTERN='.*caracteristiques.*[.]csv'
FILE_FORMAT=CSV_FORMAT
ON_ERROR=ABORT_STATEMENT;


copy into IMMATRICULATION
from @load_stage/
pattern='.*immatriculation.*[.]csv'
file_format=CSV_FORMAT
ON_ERROR=ABORT_STATEMENT;


insert into DIM_V_CATEGORY
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




insert into DIM_V_OBS
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




insert into DIM_V_OBSM
values
(-1, 'Non renseigné'),
(0 , 'Aucun'),
(1 , 'Piéton'),
(2 , 'Véhicule'),
(4 , 'Véhicule sur rail'),
(5 , 'Animal domestique'),
(6 , 'Animal sauvage'),
(9 , 'Autre');




insert into DIM_V_CHOC
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




insert into DIM_V_MANV
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



insert into dim_l_catr
values
(1 , 'Autoroute'),
(2 , 'Route nationale'),
(3 , 'Route Départementale'),
(4 , 'Voie Communales'),
(5 , 'Hors réseau public'),
(6 , 'Parc de stationnement ouvert à la circulation publique'),
(7 , 'Routes de métropole urbaine'),
(9 , 'autre');



insert into dim_l_circ
values
(-1, 'Non renseigné'),
(1 , 'A sens unique'),
(2 , 'Bidirectionnelle'),
(3 , 'A chaussées séparées'),
(4 , 'Avec voies d’affectation variable');



insert into dim_l_vosp
values
(-1, 'Non renseigné'),
(0 , 'Sans objet'),
(1 , 'Piste cyclable'),
(2 , 'Bande cyclable'),
(3 , 'Voie réservée');



insert into dim_l_prof
values
(-1, 'Non renseigné'),
(1 , 'Plat'),
(2 , 'Pente'),
(3 , 'Sommet de côte'),
(4 , 'Bas de côte');




insert into dim_l_surf
values
(-1 , 'Non renseigné'),
(1 , 'Normale'),
(2 , 'Mouillée'),
(3 , 'Flaques'),
(4 , 'Inondée'),
(5 , 'Enneigée'),
(6 , 'Boue'),
(7 , 'Verglacée'),
(8 , 'Corps gras , huile'),
(9 , 'Autre');




insert into dim_l_infra
values
(-1, 'Non renseigné'),
(0 , 'Aucun'),
(1 , 'Souterrain - tunnel'),
(2 , 'Pont - autopont'),
(3 , 'Bretelle d’échangeur ou de raccordement'),
(4 , 'Voie ferrée'),
(5 , 'Carrefour aménagé'),
(6 , 'Zone piétonne'),
(7 , 'Zone de péage'),
(8 , 'Chantier'),
(9 , 'Autres');




insert into dim_l_situ
values
(-1, 'Non renseigné'),
(0 , 'Aucun'),
(1 , 'Sur chaussée'),
(2 , 'Sur bande d’arrêt d’urgence'),
(3 , 'Sur accotement'),
(4 , 'Sur trottoir'),
(5 , 'Sur piste cyclable'),
(6 , 'Sur autre voie spéciale'),
(8 , 'Autres');






INSERT INTO dim_u_catu 
VALUES
(1, 'Conducteur'),
(2, 'Passager'),
(3, 'Piéton'),
(4, 'Piéton en roller ou en trotinette');



INSERT INTO dim_u_grav 
VALUES
(1, 'Indemne'),
(2, 'Tué'),
(3, 'Blessé hospitalisé'),
(4, 'Blessé léger');



INSERT INTO dim_u_sexe 
VALUES
(1, 'Masculin'),
(2, 'Féminin');



INSERT INTO dim_u_trajet
VALUES
(-1, 'Non renseigné'),
(0, 'Non renseigné'),
(1, 'Domicile - travail'),
(2, 'Domicile - école'),
(3, 'Courses - achats'),
(4, 'Utilisation professionnelle'),
(5, 'Promenade - loisirs'),
(9, 'Autre');



INSERT INTO dim_u_secu1
VALUES
(-1, 'Non renseigné'),
(0, 'Aucun équipement'),
(1, 'Ceinture'),
(2, 'Casque'),
(3, 'Dispositifs enfants'),
(4, 'Gilet réfléchissant'),
(5, 'Airbag (2RM/3RM)'),
(6, 'Gants (2RM/3RM)'),
(7, 'Gants + Airbag (2RM/3RM)'),
(8, 'Non déterminable'),
(9, 'Autre');



INSERT INTO dim_u_secu2
VALUES
(-1, 'Non renseigné'),
(0, 'Aucun équipement'),
(1, 'Ceinture'),
(2, 'Casque'),
(3, 'Dispositifs enfants'),
(4, 'Gilet réfléchissant'),
(5, 'Airbag (2RM/3RM)'),
(6, 'Gants (2RM/3RM)'),
(7, 'Gants + Airbag (2RM/3RM)'),
(8, 'Non déterminable'),
(9, 'Autre');



INSERT INTO dim_u_secu3
VALUES
(-1, 'Non renseigné'),
(0, 'Aucun équipement'),
(1, 'Ceinture'),
(2, 'Casque'),
(3, 'Dispositifs enfants'),
(4, 'Gilet réfléchissant'),
(5, 'Airbag (2RM/3RM)'),
(6, 'Gants (2RM/3RM)'),
(7, 'Gants + Airbag (2RM/3RM)'),
(8, 'Non déterminable'),
(9, 'Autre');



INSERT INTO dim_u_locp
VALUES
(-1, 'Non renseigné'),
(0, 'Sans objet'),
(1, 'Sur chaussée, à plus de 50m du passage piéton'),
(2, 'Sur chaussée, à moins de 50m du passage piéton'),
(3, 'Sur passage piéton, sans signalisation lumineuse'),
(4, 'Sur passage piéton, avec signalisation lumineuse'),
(5, 'Sur trottoir'),
(6, 'Sur accotement'),
(7, 'Sur refuge ou BAU'),
(8, 'Sur contre allée'),
(9, 'Inconnue');


INSERT INTO dim_u_actp
VALUES
('-1', 'Non renseigné'),
('0', 'Non renseigné ou sans objet'),
('1', 'Sens véhicule heurtant'),
('2', 'Sens inverse du véhicule'),
('3', 'Traversant'),
('4', 'Masqué'),
('5', 'Jouant - courant'),
('6', 'Avec animal'),
('9', 'Autre'),
('A', 'Monte/descend du véhicule'),
('B', 'Inconnue');



INSERT INTO dim_u_etatp 
VALUES
(-1, 'Non renseigné'),
(1, 'Seul'),
(2, 'Accompagné'),
(3, 'En groupe');


INSERT INTO dim_c_lum
VALUES
(1, 'Plein jour'),
(2, 'Crépuscule ou aube'),
(3, 'Nuit sans éclairage public'),
(4, 'Nuit avec éclairage public non allumé'),
(5, 'Nuit avec éclairage public allumé');



INSERT INTO dim_c_agg
VALUES
(1, 'Hors agglomération'),
(2, 'En agglomération');



INSERT INTO dim_c_inter
VALUES
(1, 'Hors intersection'),
(2, 'Intersection en X'),
(3, 'Intersection en T'),
(4, 'Intersection en Y'),
(5, 'Intersection à plus de 4 branches'),
(6, 'Giratoire'),
(7, 'Place'),
(8, 'Passage à niveau'),
(9, 'Autre intersection');



INSERT INTO dim_c_atm
VALUES
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




INSERT INTO dim_c_col
VALUES
(-1, 'Non renseigné'),
(1, 'Deux véhicules - frontale'),
(2, 'Deux véhicules – par l’arrière'),
(3, 'Deux véhicules – par le coté'),
(4, 'Trois véhicules et plus – en chaîne'),
(5, 'Trois véhicules et plus - collisions multiples'),
(6, 'Autre collision'),
(7, 'Sans collision');


































