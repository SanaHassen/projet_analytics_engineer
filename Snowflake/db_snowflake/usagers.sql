use database accidents_2012_2022

use schema public;

use warehouse query;

CREATE TABLE usagers(
  num_acc int,
  catu int,
  grav int,
  sexe int,
  trajet int,
  secu1 int,
  secu2 int,
  secu3 int,
  locp int,
  actp varchar(2),
  etatp int,
  an_nais int
);

COPY INTO usagers (num_acc, catu, grav, sexe, trajet, secu1, secu2, secu3, locp, actp, etatp, an_nais)
FROM @stage_csv/
PATTERN='.*usagers.*[.]csv'
FILE_FORMAT=csv_format
ON_ERROR = 'CONTINUE';



CREATE TABLE dim_u_catu(
    id_catu INT PRIMARY KEY,
    intitule VARCHAR(100)
);

INSERT INTO dim_u_catu (id_catu, intitule) VALUES
(1, 'Conducteur'),
(2, 'Passager'),
(3, 'Piéton'),
(4, 'Piéton en roller ou en trotinette');


CREATE TABLE dim_u_grav (
    id_grav INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_u_grav (id_grav, intitule) VALUES
(1, 'Indemne'),
(2, 'Tué'),
(3, 'Blessé hospitalisé'),
(4, 'Blessé léger');


CREATE TABLE dim_u_sexe (
    id_sexe INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_u_sexe (id_sexe, intitule) VALUES
(1, 'Masculin'),
(2, 'Féminin');


CREATE TABLE dim_u_trajet (
    id_trajet INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_u_trajet (id_trajet, intitule) VALUES
(-1, 'Non renseigné'),
(0, 'Non renseigné'),
(1, 'Domicile - travail'),
(2, 'Domicile - école'),
(3, 'Courses - achats'),
(4, 'Utilisation professionnelle'),
(5, 'Promenade - loisirs'),
(9, 'Autre');


CREATE TABLE dim_u_secu1 (
    id_secu1 INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_u_secu1 (id_secu1, intitule) VALUES
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

CREATE TABLE dim_u_secu2 (
    id_secu2 INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_u_secu2 (id_secu2, intitule) VALUES
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

CREATE TABLE dim_u_secu3 (
    id_secu3 INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_u_secu3 (id_secu3, intitule) VALUES
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

CREATE TABLE dim_u_locp (
    id_locp INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_u_locp (id_locp, intitule) VALUES
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

CREATE TABLE dim_u_actp (
    id_actp INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_u_actp (id_actp, intitule) VALUES
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

CREATE TABLE dim_u_etatp (
    id_etatp INT PRIMARY KEY,
    intitule VARCHAR(50)
);

INSERT INTO dim_u_etatp (id_etatp, intitule) VALUES
(-1, 'Non renseigné'),
(1, 'Seul'),
(2, 'Accompagné'),
(3, 'En groupe');


Alter table usagers
add constraint FK_CATU FOREIGN KEY(catu) REFERENCES dim_u_catu(id_catu);

Alter table usagers
add constraint FK_GRAV FOREIGN KEY(grav) REFERENCES dim_u_grav(id_grav);

Alter table usagers
add constraint FK_SEXE FOREIGN KEY(sexe) REFERENCES dim_u_sexe(id_sexe);

Alter table usagers
add constraint FK_TRAJET FOREIGN KEY(trajet) REFERENCES dim_u_trajet(id_trajet);

Alter table usagers
add constraint FK_SECU1 FOREIGN KEY(secu1) REFERENCES dim_u_secu1(id_secu1);

Alter table usagers
add constraint FK_SECU2 FOREIGN KEY(secu2) REFERENCES dim_u_secu2(id_secu2);

Alter table usagers
add constraint FK_SECU3 FOREIGN KEY(secu3) REFERENCES dim_u_secu3(id_secu3);

Alter table usagers
add constraint FK_LOCP FOREIGN KEY(locp) REFERENCES dim_u_locp(id_locp);

Alter table usagers
add constraint FK_ACTP FOREIGN KEY(actp) REFERENCES dim_u_actp(id_actp);

Alter table usagers
add constraint FK_ETATP FOREIGN KEY(etatp) REFERENCES dim_u_etatp(id_etatp);

select * from usagers limit 10;