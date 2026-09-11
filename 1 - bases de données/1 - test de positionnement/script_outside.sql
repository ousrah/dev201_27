##script de creation de la base de données vod201 avec les contraintes de clé étrangères externes


drop database if exists vod201;
create database if not exists vod201 collate utf8mb4_general_ci;
use vod201;

create table utilisateur(
id_utilisateur bigint auto_increment primary key,
nom_utilisateur varchar(50) not null,
email varchar(50) not null,
`password` varchar(50) not null,
id_abonnement bigint not null
);



create table abonnement(
id_abonnement bigint auto_increment primary key,
libelle_abonnement varchar(50) not null
);


create table contenu(
id_contenu bigint auto_increment primary key,
titre varchar(50) not null,
duree smallint,
`resume` text,
annee_sortie smallint,
num_episode smallint,
id_saison bigint,
id_langue bigint not null,
id_classification bigint not null);


create table saison(
id_saison bigint auto_increment primary key,
titre_saison varchar(50) not null,
nombre_episodes smallint,
id_serie bigint not null);


create table acteur(
id_acteur bigint auto_increment primary key,
nom_acteur varchar(50) not null
);

create table serie(
id_serie bigint auto_increment primary key,
libelle_serie varchar(50) not null
);

create table classification(
id_classification bigint auto_increment primary key,
libelle_classification varchar(50) not null
);

create table langue(
id_langue bigint auto_increment primary key,
libelle_langue varchar(50) not null
);

create table genre(
id_genre bigint auto_increment primary key,
libelle_genre varchar(50) not null
);

create table historique(
minute_vue smallint,
id_utilisateur bigint not null,
id_contenu bigint not null,
foreign key (id_utilisateur) references utilisateur(id_utilisateur),
constraint fk_historique_contenu foreign key (id_contenu) references contenu(id_contenu),
constraint pk_historique primary key (id_utilisateur, id_contenu)

);

create table jouer(
id_acteur bigint not null,
id_contenu bigint not null,
constraint fk_jouer_acteur foreign key (id_acteur) references acteur(id_acteur),
constraint fk_jouer_contenu foreign key (id_contenu) references contenu(id_contenu),
constraint pk_jouer primary key (id_acteur, id_contenu)
);

create table appartien(
id_genre bigint not null,
id_contenu bigint not null,
constraint fk_appartien_genre foreign key (id_genre) references genre(id_genre),
constraint fk_appartien_contenu foreign key (id_contenu) references contenu(id_contenu),
constraint pk_appartien primary key (id_genre, id_contenu)
);



alter table  utilisateur   add constraint  fk_utilisateur_abonnement foreign key (id_abonnement) references abonnement(id_abonnement)   ;
alter table contenu    add constraint  fk_contenu_langue foreign key (id_langue) references langue(id_langue)  on delete cascade on update cascade  ;
alter table  contenu   add constraint fk_contenu_classification foreign key (id_classification)  references classification (id_classification)     ;
alter table  contenu   add constraint fk_contenu_saison foreign key (id_saison)  references saison(id_saison)  on delete set null  ;
alter table  saison   add constraint fk_saison_serie foreign key (id_serie) references serie(id_serie)    ;











 