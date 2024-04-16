use database accidents_2012_2022;

use schema public;

use warehouse query;

create table if not exists lieux(
num_acc number primary key,
catr number,
circ number,
vosp number,
prof number,
surf	number,
infra number,
situ number,
nbv number
);

copy into lieux
from @load_stage/
pattern='.*lieux.*[.]csv'
file_format=csv_format;

create table if not exists catr(
catr_id number primary key,
catr_name string
);

insert into catr
values
(1 , 'Autoroute'),
(2 , 'Route nationale'),
(3 , 'Route Départementale'),
(4 , 'Voie Communales'),
(5 , 'Hors réseau public'),
(6 , 'Parc de stationnement ouvert à la circulation publique'),
(7 , 'Routes de métropole urbaine'),
(9 , 'autre');


create table if not exists circ(
circ_id number primary key,
circ_name string
);

insert into circ
values
(-1, 'Non renseigné'),
(1 , 'A sens unique'),
(2 , 'Bidirectionnelle'),
(3 , 'A chaussées séparées'),
(4 , 'Avec voies d’affectation variable');


create table if not exists vosp(
vosp_id number primary key,
vosp_name string
);

insert into vosp
values
(-1, 'Non renseigné'),
(0 , 'Sans objet'),
(1 , 'Piste cyclable'),
(2 , 'Bande cyclable'),
(3 , 'Voie réservée');


create table if not exists prof(
prof_id number primary key,
prof_name string
);

insert into prof
values
(-1, 'Non renseigné'),
(1 , 'Plat'),
(2 , 'Pente'),
(3 , 'Sommet de côte'),
(4 , 'Bas de côte');


create table if not exists surf(
surf_id number primary key,
surf_name string
);

insert into surf
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



create table if not exists infra(
infra_id number primary key,
infra_name string
);

insert into infra
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


create table if not exists situ(
situ_id number primary key,
situ_name string
);

insert into situ
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

Alter table lieux
add constraint FK_CATR FOREIGN KEY(catr) REFERENCES catr(catr_id);

Alter table lieux
add constraint FK_SITU FOREIGN KEY(situ) REFERENCES situ(situ_id);

Alter table lieux
add constraint FK_INFRA FOREIGN KEY(infra) REFERENCES infra(infra_id);

Alter table lieux
add constraint FK_SURF FOREIGN KEY(surf) REFERENCES surf(surf_id);

Alter table lieux
add constraint FK_PROF FOREIGN KEY(prof) REFERENCES prof(prof_id);

Alter table lieux
add constraint FK_CIRC FOREIGN KEY(circ) REFERENCES circ(circ_id);

Alter table lieux
add constraint FK_VOSP FOREIGN KEY(vosp) REFERENCES vosp(vosp_id);