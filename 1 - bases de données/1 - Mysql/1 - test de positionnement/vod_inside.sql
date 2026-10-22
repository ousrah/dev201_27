/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     19/09/2026 09:56:56                          */
/*==============================================================*/


/*==============================================================*/
/* Table: ACCUEIL                                               */
/*==============================================================*/
create table ACCUEIL
(
   ID_CATEGORIE         int not null,
   ID_CHAMPS            int not null,
   primary key (ID_CATEGORIE, ID_CHAMPS)
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
   ID_CHAMPS            int not null auto_increment,
   NOM_CHAMPS           varchar(50),
   NB_PLACES            bigint,
   primary key (ID_CHAMPS)
);

/*==============================================================*/
/* Table: CHEVAL                                                */
/*==============================================================*/
create table CHEVAL
(
   ID_CHEVAL            int not null auto_increment,
   ID_PROPRIETAIRE      int not null,
   NOM_CHEVAL           varchar(50),
   SEXE_CHEVALE         char(1),
   DATE_NAISSANCE       date,
   primary key (ID_CHEVAL)
);

/*==============================================================*/
/* Table: COURSE                                                */
/*==============================================================*/
create table COURSE
(
   ID_COURSE            int not null auto_increment,
   ID_CATEGORIE         int not null,
   ID_CHAMPS            int not null,
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
   ID_JOCKEY            int not null,
   ID_SAISON            int not null,
   ID_CHEVAL            int not null,
   CLASSEMENT           int,
   primary key (ID_JOCKEY, ID_SAISON, ID_CHEVAL)
);

/*==============================================================*/
/* Table: PROPRIETAIRE                                          */
/*==============================================================*/
create table PROPRIETAIRE
(
   ID_PROPRIETAIRE      int not null auto_increment,
   NOM_PROPRIETAIRE     varchar(50),
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

alter table ACCUEIL add constraint FK_ACCUEIL foreign key (ID_CATEGORIE)
      references CATEGORIE (ID_CATEGORIE) on delete restrict on update restrict;

alter table ACCUEIL add constraint FK_ACCUEIL2 foreign key (ID_CHAMPS)
      references CHAMPS (ID_CHAMPS) on delete restrict on update restrict;

alter table CHEVAL add constraint FK_POSEDE foreign key (ID_PROPRIETAIRE)
      references PROPRIETAIRE (ID_PROPRIETAIRE) on delete restrict on update restrict;

alter table COURSE add constraint FK_APPARTIENT foreign key (ID_CATEGORIE)
      references CATEGORIE (ID_CATEGORIE) on delete restrict on update restrict;

alter table COURSE add constraint FK_SE_DEROULE foreign key (ID_CHAMPS)
      references CHAMPS (ID_CHAMPS) on delete restrict on update restrict;

alter table PARENT add constraint FK_PARENT foreign key (ID_CHEVAL)
      references CHEVAL (ID_CHEVAL) on delete restrict on update restrict;

alter table PARENT add constraint FK_PARENT2 foreign key (CHE_ID_CHEVAL)
      references CHEVAL (ID_CHEVAL) on delete restrict on update restrict;

alter table PARTICIPE add constraint FK_PARTICIPE foreign key (ID_JOCKEY)
      references JOCKEY (ID_JOCKEY) on delete restrict on update restrict;

alter table PARTICIPE add constraint FK_PARTICIPE2 foreign key (ID_SAISON)
      references SAISON (ID_SAISON) on delete restrict on update restrict;

alter table PARTICIPE add constraint FK_PARTICIPE3 foreign key (ID_CHEVAL)
      references CHEVAL (ID_CHEVAL) on delete restrict on update restrict;

alter table SAISON add constraint FK_ORAGNISER foreign key (ID_COURSE)
      references COURSE (ID_COURSE) on delete restrict on update restrict;

