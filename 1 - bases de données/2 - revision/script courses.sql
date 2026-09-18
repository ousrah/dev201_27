drop database if exists courses201;
create database if not exists courses201 collate utf8mb4_general_ci;
use courses201;

/*==============================================================*/
/* Table: ACCUEIL                                               */
/*==============================================================*/
create table ACCUEIL
(
   ID_CHAMP             int not null,
   ID_CATEGORIE         int not null,
   primary key (ID_CHAMP, ID_CATEGORIE)
);

/*==============================================================*/
/* Table: CATEGORIE                                             */
/*==============================================================*/
create table CATEGORIE
(
   ID_CATEGORIE         int not null auto_increment,
   LIBELLE_CATEGORIE    varchar(50),
   primary key (ID_CATEGORIE)
);

/*==============================================================*/
/* Table: CHAMPS                                                */
/*==============================================================*/
create table CHAMPS
(
   ID_CHAMP             int not null auto_increment,
   NOM_CHAMP            varchar(50),
   NB_PLACES            int,
   primary key (ID_CHAMP)
);

/*==============================================================*/
/* Table: CHEVAL                                                */
/*==============================================================*/
create table CHEVAL
(
   ID_CHEVAL            int not null auto_increment,
   ID_PROPRIETAIRE      int not null,
   NOM_CHEVAL           varchar(50),
   DATE_NAISSANCE       date,
   SEXE                 char(1),
   primary key (ID_CHEVAL)
);

/*==============================================================*/
/* Table: COURSE                                                */
/*==============================================================*/
create table COURSE
(
   ID_COURSE            int not null auto_increment,
   ID_CHAMP             int not null,
   ID_CATEGORIE         int not null,
   DESIGNATION          varchar(50),
   primary key (ID_COURSE)
);

/*==============================================================*/
/* Table: JOCKEY                                                */
/*==============================================================*/
create table JOCKEY
(
   ID_JOCKEY            int not null auto_increment,
   NOM_JOCKEY           varchar(50),
   PRENOM_JOCKEY        varchar(50),
   primary key (ID_JOCKEY)
);

/*==============================================================*/
/* Table: PARENT                                                */
/*==============================================================*/
create table PARENT
(
   ID_CHEVAL            int not null,
   CHE_ID_CHEVAL        int not null,
   primary key (ID_CHEVAL, CHE_ID_CHEVAL)
);

/*==============================================================*/
/* Table: PARTICIPE                                             */
/*==============================================================*/
create table PARTICIPE
(
   ID_CHEVAL            int not null,
   ID_SAISON            int not null,
   ID_JOCKEY            int not null,
   CLASSEMENT           int,
   primary key (ID_CHEVAL, ID_SAISON, ID_JOCKEY)
);

/*==============================================================*/
/* Table: PROPRIETAIRE                                          */
/*==============================================================*/
create table PROPRIETAIRE
(
   ID_PROPRIETAIRE      int not null auto_increment,
   NOM_PRORIETAIRE      varchar(50),
   PRENOM_PROPRIETAIRE  varchar(50),
   primary key (ID_PROPRIETAIRE)
);

/*==============================================================*/
/* Table: SAISON                                                */
/*==============================================================*/
create table SAISON
(
   ID_SAISON            int not null auto_increment,
   ID_COURSE            int not null,
   DATE_COURSE          datetime,
   DOTATION             decimal,
   primary key (ID_SAISON)
);

alter table ACCUEIL add constraint FK_ACCUEIL foreign key (ID_CHAMP)
      references CHAMPS (ID_CHAMP) on delete restrict on update restrict;

alter table ACCUEIL add constraint FK_ACCUEIL2 foreign key (ID_CATEGORIE)
      references CATEGORIE (ID_CATEGORIE) on delete restrict on update restrict;

alter table CHEVAL add constraint FK_POSSEDE foreign key (ID_PROPRIETAIRE)
      references PROPRIETAIRE (ID_PROPRIETAIRE) on delete restrict on update restrict;

alter table COURSE add constraint FK_APPARTIENT foreign key (ID_CATEGORIE)
      references CATEGORIE (ID_CATEGORIE) on delete restrict on update restrict;

alter table COURSE add constraint FK_SE_DEROULE foreign key (ID_CHAMP)
      references CHAMPS (ID_CHAMP) on delete restrict on update restrict;

alter table PARENT add constraint FK_PARENT foreign key (ID_CHEVAL)
      references CHEVAL (ID_CHEVAL) on delete restrict on update restrict;

alter table PARENT add constraint FK_PARENT2 foreign key (CHE_ID_CHEVAL)
      references CHEVAL (ID_CHEVAL) on delete restrict on update restrict;

alter table PARTICIPE add constraint FK_PARTICIPE foreign key (ID_CHEVAL)
      references CHEVAL (ID_CHEVAL) on delete restrict on update restrict;

alter table PARTICIPE add constraint FK_PARTICIPE2 foreign key (ID_SAISON)
      references SAISON (ID_SAISON) on delete restrict on update restrict;

alter table PARTICIPE add constraint FK_PARTICIPE3 foreign key (ID_JOCKEY)
      references JOCKEY (ID_JOCKEY) on delete restrict on update restrict;

alter table SAISON add constraint FK_ORGANISER foreign key (ID_COURSE)
      references COURSE (ID_COURSE) on delete restrict on update restrict;


-- Insertion des Propriétaires
INSERT INTO PROPRIETAIRE (ID_PROPRIETAIRE, NOM_PRORIETAIRE, PRENOM_PROPRIETAIRE) VALUES
(1, 'Dupont', 'Jean'),
(2, 'Martin', 'Claire'),
(3, 'Bernard', 'Luc'),
(4, 'Thomas', 'Sophie'),
(5, 'Petit', 'Marc');

-- Insertion des Chevaux (10 chevaux)
INSERT INTO CHEVAL (ID_CHEVAL, ID_PROPRIETAIRE, NOM_CHEVAL, DATE_NAISSANCE, SEXE) VALUES
(1, 1, 'Éclair', '2018-05-12', 'M'),
(2, 1, 'Tonnerre', '2019-03-15', 'M'),
(3, 2, 'Storm', '2017-07-22', 'F'),
(4, 2, 'Vitesse', '2018-09-10', 'F'),
(5, 3, 'Spirit', '2020-01-05', 'M'),
(6, 3, 'Galant', '2019-11-18', 'M'),
(7, 4, 'Bora', '2017-04-30', 'F'),
(8, 4, 'Comète', '2018-08-14', 'F'),
(9, 5, 'Zephyr', '2019-06-25', 'M'),
(10, 5, 'Fuego', '2020-02-11', 'M');

-- Insertion des Champs de courses
INSERT INTO CHAMPS (ID_CHAMP, NOM_CHAMP, NB_PLACES) VALUES
(1, 'Hippodrome de Longchamp', 12),
(2, 'Hippodrome de Chantilly', 10),
(3, 'Hippodrome de Deauville', 8);

-- Insertion des Catégories
INSERT INTO CATEGORIE (ID_CATEGORIE, LIBELLE_CATEGORIE) VALUES
(1, 'Galop - Groupe I'),
(2, 'Galop - Groupe II'),
(3, 'Obstacle');

-- Association Accueil (Champs / Catégories)
INSERT INTO ACCUEIL (ID_CHAMP, ID_CATEGORIE) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 1);

-- Insertion des Courses (5 courses)
INSERT INTO COURSE (ID_COURSE, ID_CHAMP, ID_CATEGORIE, DESIGNATION) VALUES
(1, 1, 1, 'Grand Prix de Paris'),
(2, 1, 2, 'Prix du Printemps'),
(3, 2, 2, 'Derby de Chantilly'),
(4, 2, 3, 'Grand Steeple-Chase'),
(5, 3, 1, 'Prix de la Côte Fleurie');

-- Insertion des Saisons (20 saisons réparties sur les 5 courses)
INSERT INTO SAISON (ID_SAISON, ID_COURSE, DATE_COURSE, DOTATION) VALUES
(1, 1, '2024-06-15 14:00:00', 150000.00),
(2, 1, '2025-06-14 14:00:00', 160000.00),
(3, 1, '2026-06-13 14:00:00', 175000.00),
(4, 2, '2024-04-10 15:30:00', 80000.00),
(5, 2, '2025-04-09 15:30:00', 85000.00),
(6, 2, '2026-04-08 15:30:00', 90000.00),
(7, 3, '2024-07-20 16:00:00', 120000.00),
(8, 3, '2025-07-19 16:00:00', 125000.00),
(9, 3, '2026-07-18 16:00:00', 130000.00),
(10, 4, '2024-05-05 13:30:00', 200000.00),
(11, 4, '2025-05-04 13:30:00', 210000.00),
(12, 4, '2026-05-03 13:30:00', 220000.00),
(13, 5, '2024-08-25 17:00:00', 100000.00),
(14, 5, '2025-08-24 17:00:00', 105000.00),
(15, 5, '2026-08-23 17:00:00', 110000.00),
(16, 1, '2023-06-17 14:00:00', 140000.00),
(17, 2, '2023-04-12 15:30:00', 75000.00),
(18, 3, '2023-07-22 16:00:00', 115000.00),
(19, 4, '2023-05-07 13:30:00', 190000.00),
(20, 5, '2023-08-27 17:00:00', 95000.00);

-- Insertion des Jockeys
INSERT INTO JOCKEY (ID_JOCKEY, NOM_JOCKEY, PRENOM_JOCKEY) VALUES
(1, 'Moreau', 'Antoine'),
(2, 'Lefevre', 'Julien'),
(3, 'Roussel', 'Thomas'),
(4, 'Guerin', 'David');

-- Insertion des Participations (Liaison Cheval - Saison - Jockey)
INSERT INTO PARTICIPE (ID_CHEVAL, ID_SAISON, ID_JOCKEY, CLASSEMENT) VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 1, 3, 3),
(4, 2, 1, 1),
(5, 2, 4, 2),
(6, 3, 2, 1),
(7, 4, 3, 1),
(8, 5, 1, 2),
(9, 6, 4, 1),
(10, 7, 2, 1);

-- Insertion des Relations Parents (Généalogie optionnelle)
INSERT INTO PARENT (ID_CHEVAL, CHE_ID_CHEVAL) VALUES
(3, 1),
(4, 2);


#1.	la liste de tous les cheveaux.

select * from cheval;


#2.	la listes de champs qui peuvent acceuillir la catégorie "Galop - Groupe I"
select nom_champ
from champs
join accueil using(id_champ)
join categorie using(id_categorie)
where libelle_categorie="Galop - Groupe I";


select nom_champ 
from champs 
where id_champ in (select id_champ 
					from accueil 
                    where id_categorie in (select id_categorie 
											from categorie 
                                            where libelle_categorie = 'Galop - Groupe I')
					);


#3.	la liste des cheveaux qui participent a la course "Grand Prix de paris" de l'edition 'Juin 2024' triés par classement

select nom_cheval, classement
from cheval
join participe using(id_cheval)
join saison using(id_saison)
join course using(id_course)
where designation like "Grand Prix de paris"
and year(date_course)=2024
and month(date_course)=6
#and date_course  like "2024-06%"
order by classement;

#4.	la liste des jockeys qui ont monté le cheval "Éclair" 
#durant tout son historique

select NOM_JOCKEY 
from jockey
join participe using (ID_JOCKEY)
join cheval using (id_cheval)
where NOM_CHEVAL like "Éclair" ;

#5.	Le cheval qui a remporté le plus grand nombre de compétitions
with Nombre_victoir as (select id_cheval , count(*) as nb_vct from participe 
						where CLASSEMENT = 1
                        group by ID_CHEVAL),
	 Nombre_victoir_max as (select max(nb_vct) nb_vct_max from Nombre_victoir)
select NOM_CHEVAL,DATE_NAISSANCE,SEXE from cheval 
join Nombre_victoir  NV using (id_cheval)
join Nombre_victoir_max NVM on NVM.nb_vct_max=NV.nb_vct;

select * from participe;


#6.	Les parents du cheval qui a remporté le plus grand nombre de compétitions



#7.	Le montant total remporté par Idao de Tillard dans toutes les compétitions qu'il a remporté
#8.	La catégorie que le cheval Idao de Tillardremporte le plus

