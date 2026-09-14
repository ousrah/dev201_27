/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     11/09/2026 11:19:38                          */
/*==============================================================*/


drop table if exists ABONNEMENT;

drop table if exists ACTEURS;

drop table if exists APPARTIEN;

drop table if exists CLASSIFICATION;

drop table if exists CONTENUS;

drop table if exists GENRE;

drop table if exists HISTORIQUE;

drop table if exists JOUER;

drop table if exists LANGUE;

drop table if exists SAISONS;

drop table if exists SERIES;

drop table if exists UTILISATEURS;

/*==============================================================*/
/* Table: ABONNEMENT                                            */
/*==============================================================*/
create table ABONNEMENT
(
   ID_ABONNEMENT        int not null auto_increment,
   LIBELLE_ABONNEMENT   varchar(50),
   primary key (ID_ABONNEMENT)
);

/*==============================================================*/
/* Table: ACTEURS                                               */
/*==============================================================*/
create table ACTEURS
(
   ID_ACTEUR            int not null auto_increment,
   NOM_ACTEUR           varchar(50),
   primary key (ID_ACTEUR)
);

/*==============================================================*/
/* Table: LANGUE                                                */
/*==============================================================*/
create table LANGUE
(
   ID_LANGUE            int not null auto_increment,
   LIBELLE_LANGUE       varchar(50),
   primary key (ID_LANGUE)
);

/*==============================================================*/
/* Table: CLASSIFICATION                                        */
/*==============================================================*/
create table CLASSIFICATION
(
   ID_CLASSIFICATION    int not null auto_increment,
   LIBELLE_CLASSIFICATION varchar(50),
   primary key (ID_CLASSIFICATION)
);

/*==============================================================*/
/* Table: SERIES                                                */
/*==============================================================*/
create table SERIES
(
   ID_SERIE             int not null auto_increment,
   LIBELLE_SERIE        varchar(250),
   primary key (ID_SERIE)
);

/*==============================================================*/
/* Table: SAISONS                                               */
/*==============================================================*/
create table SAISONS
(
   ID_SAISON            int not null auto_increment,
   ID_SERIE             int not null,
   TITRE_SAISON         varchar(250),
   NB_EPISODES          int,
   primary key (ID_SAISON),
   constraint FK_FAIT_PARTIE foreign key (ID_SERIE)
      references SERIES (ID_SERIE) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: CONTENUS                                              */
/*==============================================================*/
create table CONTENUS
(
   ID_CONTENU           int not null auto_increment,
   ID_SAISON            int,
   ID_CLASSIFICATION    int not null,
   ID_LANGUE            int not null,
   TITRE                varchar(250) not null,
   RESUME               text not null,
   ANNEE_SORTIE         int not null,
   DUREE                int not null,
   NUM_EPISODE          int,
   primary key (ID_CONTENU),
   constraint FK_DOUBLAGE foreign key (ID_LANGUE)
      references LANGUE (ID_LANGUE) on delete restrict on update restrict,
   constraint FK_CLASSIFIE foreign key (ID_CLASSIFICATION)
      references CLASSIFICATION (ID_CLASSIFICATION) on delete restrict on update restrict,
   constraint FK_ASSOCIE foreign key (ID_SAISON)
      references SAISONS (ID_SAISON) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: GENRE                                                 */
/*==============================================================*/
create table GENRE
(
   ID_GENRE             int not null auto_increment,
   LIBELLE_GENRE        varchar(50),
   primary key (ID_GENRE)
);

/*==============================================================*/
/* Table: APPARTIEN                                             */
/*==============================================================*/
create table APPARTIEN
(
   ID_CONTENU           int not null,
   ID_GENRE             int not null,
   primary key (ID_CONTENU, ID_GENRE),
   constraint FK_APPARTIEN foreign key (ID_CONTENU)
      references CONTENUS (ID_CONTENU) on delete restrict on update restrict,
   constraint FK_APPARTIEN2 foreign key (ID_GENRE)
      references GENRE (ID_GENRE) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: UTILISATEURS                                          */
/*==============================================================*/
create table UTILISATEURS
(
   ID_UTILISATEUR       int not null auto_increment,
   ID_ABONNEMENT        int not null,
   NOM_UTILISATEUR      varchar(50),
   EMAIL                varchar(80),
   PASSWORD             varchar(20),
   primary key (ID_UTILISATEUR),
   constraint FK_ACHETE foreign key (ID_ABONNEMENT)
      references ABONNEMENT (ID_ABONNEMENT) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: HISTORIQUE                                            */
/*==============================================================*/
create table HISTORIQUE
(
   ID_UTILISATEUR       int not null,
   ID_CONTENU           int not null,
   MINUTE_REGARDEE      int,
   primary key (ID_UTILISATEUR, ID_CONTENU),
   constraint FK_HISTORIQUE foreign key (ID_UTILISATEUR)
      references UTILISATEURS (ID_UTILISATEUR) on delete restrict on update restrict,
   constraint FK_HISTORIQUE2 foreign key (ID_CONTENU)
      references CONTENUS (ID_CONTENU) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: JOUER                                                 */
/*==============================================================*/
create table JOUER
(
   ID_CONTENU           int not null,
   ID_ACTEUR            int not null,
   primary key (ID_CONTENU, ID_ACTEUR),
   constraint FK_JOUER foreign key (ID_CONTENU)
      references CONTENUS (ID_CONTENU) on delete restrict on update restrict,
   constraint FK_JOUER2 foreign key (ID_ACTEUR)
      references ACTEURS (ID_ACTEUR) on delete restrict on update restrict
);

