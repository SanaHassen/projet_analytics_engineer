create database accidents_2012_2022;

use database accidents_2012_2022;

use schema public;

use warehouse query;

CREATE TABLE IF NOT EXISTS "ACCIDENTS_2012_2022"."PUBLIC"."FACT_VEHICULES" (vehicule_id NUMBER identity(1,1) primary key, num_Acc NUMBER(38, 0) , 
num_veh VARCHAR , category_veh NUMBER(38, 0) , obstacle NUMBER(38, 0) , obstacle_m NUMBER(38, 0) , choc NUMBER(38, 0) , manoeuvre NUMBER(38, 0) ); 


CREATE TABLE IF NOT EXISTS "ACCIDENTS_2012_2022"."PUBLIC"."FACT_LIEUX" ( Num_Acc NUMBER(38, 0) primary key , category_route NUMBER(38, 0) , regime_circulation NUMBER(38, 0) , voie_reserve NUMBER(38, 0) , profil_route NUMBER(38, 0) , etat_surface NUMBER(38, 0) , Infrastructure NUMBER(38, 0) , situation NUMBER(38, 0) , nb_voies NUMBER(38, 0) );


CREATE TABLE "ACCIDENTS_2012_2022"."PUBLIC"."FACT_USAGERS" (usager_id NUMBER identity(1,1) primary key,  Num_Acc NUMBER(38, 0) , num_veh VARCHAR , category_usager NUMBER(38, 0) , gravite NUMBER(38, 0) , sexe NUMBER(38, 0) , motif_deplacement NUMBER(38, 0) , secu1 NUMBER(38, 0) , secu2 NUMBER(38, 0) , secu3 NUMBER(38, 0) , localisation_pieton NUMBER(38, 0) , action_pieton VARCHAR , pieton_seul_ou_non NUMBER(38, 0) , annee_naissance NUMBER(38, 0) ); 


CREATE TABLE "ACCIDENTS_2012_2022"."PUBLIC"."FACT_CARACTERISTIQUES" ( Num_Acc NUMBER(38, 0) PRIMARY KEY, jour VARCHAR , mois VARCHAR , an VARCHAR , hr NUMBER(38, 0) , condition_eclairage NUMBER(38, 0) , departement VARCHAR , commune VARCHAR , condition_agglomeration NUMBER(38, 0) , intersection NUMBER(38, 0) , condition_atmosphere NUMBER(38, 0) , type_collision NUMBER(38, 0) , adresse VARCHAR , lattitude NUMBER(38, 7) , longitude NUMBER(38, 7) ); 


CREATE TABLE "ACCIDENTS_2012_2022"."PUBLIC"."IMMATRICULATION" ( Id_accident VARCHAR , annee NUMBER(38, 0) , lieu_admin_actuel VARCHAR , type_accident VARCHAR , categorie_vehicule VARCHAR , age_vehicule NUMBER(38, 0) );


CREATE TABLE IF NOT EXISTS DIM_V_CATEGORY(
category_id NUMBER primary key,
category_name VARCHAR
);

CREATE TABLE IF NOT EXISTS DIM_V_OBS(
obs_id number primary key,
obs_name VARCHAR
);

CREATE TABLE IF NOT EXISTS DIM_V_OBSM(
obsm_id NUMBER primary key,
obsm_name VARCHAR
);

CREATE TABLE IF NOT EXISTS DIM_V_CHOC(
choc_id NUMBER primary key,
choc_name VARCHAR
);

CREATE TABLE IF NOT EXISTS DIM_V_MANV(
manv_id NUMBER primary key,
manv_name VARCHAR
);


CREATE TABLE IF NOT EXISTS dim_l_catr(
catr_id number primary key,
catr_name VARCHAR
);

CREATE TABLE IF NOT EXISTS dim_l_circ(
circ_id number primary key,
circ_name VARCHAR
);

CREATE TABLE IF NOT EXISTS dim_l_vosp(
vosp_id number primary key,
vosp_name VARCHAR
);

CREATE TABLE IF NOT EXISTS dim_l_prof(
prof_id number primary key,
prof_name VARCHAR
);

CREATE TABLE IF NOT EXISTS dim_l_surf(
surf_id number primary key,
surf_name VARCHAR
);

CREATE TABLE IF NOT EXISTS dim_l_infra(
infra_id number primary key,
infra_name VARCHAR
);

CREATE TABLE IF NOT EXISTS dim_l_situ(
situ_id number primary key,
situ_name VARCHAR
);

CREATE TABLE IF NOT EXISTS dim_u_catu(
catu_id INT PRIMARY KEY,
catu_intitule VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS dim_u_grav (
grav_id INT PRIMARY KEY,
grav_intitule VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS dim_u_sexe (
sexe_id INT PRIMARY KEY,
sexe_intitule VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_u_trajet (
trajet_id INT PRIMARY KEY,
trajet_intitule VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS dim_u_secu1 (
secu1_id INT PRIMARY KEY,
secu1_intitule VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS dim_u_secu2 (
secu2_id INT PRIMARY KEY,
secu2_intitule VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS dim_u_secu3 (
secu3_id INT PRIMARY KEY,
secu3_intitule VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS dim_u_locp (
locp_id INT PRIMARY KEY,
locp_intitule VARCHAR(50));


CREATE TABLE IF NOT EXISTS dim_u_actp (
actp_id varchar PRIMARY KEY,
actp_intitule VARCHAR(50));



CREATE TABLE IF NOT EXISTS dim_u_etatp (
etatp_id INT PRIMARY KEY,
etatp_intitule VARCHAR(50));


CREATE TABLE IF NOT EXISTS dim_c_lum (
lum_id INT PRIMARY KEY,
lum_intitule VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS dim_c_agg (
agg_id INT PRIMARY KEY,
agg_intitule VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS dim_c_inter (
inter_id INT PRIMARY KEY,
inter_intitule VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS dim_c_atm (
atm_id INT PRIMARY KEY,
atm_intitule VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS dim_c_col (
col_id INT PRIMARY KEY,
col_intitule VARCHAR(50)
);



-------------------------------------------------------------------------------
-- VEHICULES
-------------------------------------------------------------------------------
Alter table FACT_VEHICULES
add constraint FK_OBS FOREIGN KEY(category_veh) REFERENCES DIM_V_CATEGORY&(obs_id);

Alter table FACT_VEHICULES
add constraint FK_OBS FOREIGN KEY(obstacle) REFERENCES DIM_V_OBS(obs_id);

Alter table FACT_VEHICULES
add constraint FK_OBSM FOREIGN KEY(obstacle_m) REFERENCES DIM_V_OBSM(obsm_id);

Alter table FACT_VEHICULES 
add constraint FK_CHOC FOREIGN key(choc) REFERENCES DIM_V_CHOC(choc_id);

Alter table FACT_VEHICULES 
add constraint FK_MANV FOREIGN KEY(manoeuvre) REFERENCES DIM_V_MANV(manv_id);

-------------------------------------------------------------------------------
-- LIEUX
-------------------------------------------------------------------------------
Alter table FACT_LIEUX
add constraint FK_CATR FOREIGN KEY(category_route) REFERENCES dim_l_catr(catr_id);

Alter table FACT_LIEUX
add constraint FK_SITU FOREIGN KEY(situation) REFERENCES dim_l_situ(situ_id);

Alter table FACT_LIEUX
add constraint FK_INFRA FOREIGN KEY(Infrastructure) REFERENCES dim_l_infra(infra_id);

Alter table FACT_LIEUX
add constraint FK_SURF FOREIGN KEY(etat_surface) REFERENCES dim_l_surf(surf_id);

Alter table FACT_LIEUX
add constraint FK_PROF FOREIGN KEY(profil_route) REFERENCES dim_l_prof(prof_id);

Alter table FACT_LIEUX
add constraint FK_CIRC FOREIGN KEY(regime_circulation) REFERENCES dim_l_circ(circ_id);

Alter table FACT_LIEUX
add constraint FK_VOSP FOREIGN KEY(voie_reserve) REFERENCES dim_l_vosp(vosp_id);

-------------------------------------------------------------------------------
-- USAGERS
-------------------------------------------------------------------------------
Alter table FACT_USAGERS
add constraint FK_CATU FOREIGN KEY(category_usager) REFERENCES dim_u_catu(catu_id);

Alter table FACT_USAGERS
add constraint FK_GRAV FOREIGN KEY(gravite) REFERENCES dim_u_grav(grav_id);

Alter table FACT_USAGERS
add constraint FK_SEXE FOREIGN KEY(sexe) REFERENCES dim_u_sexe(sexe_id);

Alter table FACT_USAGERS
add constraint FK_TRAJET FOREIGN KEY(motif_deplacement) REFERENCES dim_u_trajet(trajet_id);

Alter table FACT_USAGERS
add constraint FK_SECU1 FOREIGN KEY(secu1) REFERENCES dim_u_secu1(secu1_id);

Alter table FACT_USAGERS
add constraint FK_SECU2 FOREIGN KEY(secu2) REFERENCES dim_u_secu2(secu2_id);

Alter table FACT_USAGERS
add constraint FK_SECU3 FOREIGN KEY(secu3) REFERENCES dim_u_secu3(secu3_id);

Alter table FACT_USAGERS
add constraint FK_LOCP FOREIGN KEY(localisation_pieton) REFERENCES dim_u_locp(locp_id);

Alter table FACT_USAGERS
add constraint FK_ACTP FOREIGN KEY(action_pieton) REFERENCES dim_u_actp(actp_id);

Alter table FACT_USAGERS
add constraint FK_ETATP FOREIGN KEY(pieton_seul_ou_non) REFERENCES dim_u_etatp(etatp_id);

-------------------------------------------------------------------------------
-- CARAC
-------------------------------------------------------------------------------

Alter table FACT_CARACTERISTIQUES
add constraint FK_LUM FOREIGN KEY(condition_eclairage) REFERENCES dim_c_lum(lum_id);

Alter table FACT_CARACTERISTIQUES
add constraint FK_AGG FOREIGN KEY(condition_agglomeration) REFERENCES dim_c_agg (agg_id);

Alter table FACT_CARACTERISTIQUES
add constraint FK_INTER FOREIGN KEY(intersection) REFERENCES dim_c_inter (inter_id);

Alter table FACT_CARACTERISTIQUES
add constraint FK_ATM FOREIGN KEY(condition_atmosphere) REFERENCES dim_c_atm (atm_id);

Alter table FACT_CARACTERISTIQUES
add constraint FK_COL FOREIGN KEY(type_collision) REFERENCES dim_c_col (col_id);




