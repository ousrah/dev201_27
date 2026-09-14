
select ceiling(rand()*22);



-- 1.	Insertion de Données (5 pts)
-- 1.	Insérez les genres 'Horreur', 'Documentaire' et 'Fantastique' en une seule requête INSERT.

insert into genre(LIBELLE_GENRE) values("horreur"),("documentaire"), ("fantastique");



-- 2.	Ajoutez un nouvel utilisateur de votre choix. Ensuite, simulez le fait 
-- qu'il ait regardé 30 minutes du film 'Inception'.

insert into utilisateurs (id_abonnement,nom_utilisateur,email,`password`) values(1,"ibtissam","ibtissam@gmail.com","1234");
#methode 1
insert into historique values(6,1,30);

#methode2
insert into historique value (
(select id_utilisateur from utilisateurs where nom_utilisateur = 'ibtissam'),
(select id_contenu from contenus where titre = 'inception'),
30);





-- 2.	Modification et Suppression (10 pts)
-- 1.	Avec ALTER TABLE, ajoutez une colonne nationalite (VARCHAR(50)) à la table Acteurs.

alter table acteurs add column nationalite varchar(50);




-- 2.	Mettez à jour la nationalité de l'acteur Keanu Reeves pour 'Canadienne'.

select * from acteurs;

update acteurs
SET nationalite='Canadienne'
where nom_acteur= 'Keanu Reeves';


-- 3.	Mettez à jour tous les contenus de "Science-Fiction" sortis avant 2000 pour ajouter la mention "[CLASSIQUE]" au début de leur titre.

select * from genre;
select * from appartien where id_genre = 4;
select * from contenus;

select titre,annee_sortie,libelle_genre 
from contenus  c #alias
join appartien  a on c.id_contenu =  a.id_contenu  #using(id_contenu) au lieu de on...
join genre using(id_genre)
where LIBELLE_GENRE = 'science-fiction'
and annee_sortie < 2000;

select * from contenus;
update contenus  join appartien using(id_contenu)
				 join genre using(id_genre)
				 set contenus.titre=concat("[CLASSIQUE]"," - ", titre)
				 where LIBELLE_GENRE = 'science-fiction'
				 and annee_sortie < 2000;



-- 4.	Supprimez la série "Breaking Bad". Vérifiez que les épisodes associés ont bien été supprimés également (grâce à la contrainte ON DELETE CASCADE).

delete from series where libelle_serie ='Breaking Bad';
select * from series;
select * from saisons;
select * from contenus;
alter table saisons drop constraint fk_fait_partie;
alter table contenus drop constraint fk_associe;
alter table appartien drop constraint fk_appartien;
alter table historique drop constraint fk_historique2;
alter table jouer drop constraint fk_jouer;


alter table saisons add constraint fk_saisons_series foreign key (id_serie) references series(id_serie) on delete cascade;
alter table contenus add constraint fk_contenus_saisons foreign key (id_saison) references saisons(id_saison) on delete cascade;
alter table appartien add constraint fk_appartien_contenus foreign key (id_contenu) references contenus(id_contenu) on delete cascade;
alter table historique add constraint fk_historique_contenus foreign key (id_contenu) references contenus(id_contenu) on delete cascade;
alter table jouer add constraint fk_jouer_contenus foreign key (id_contenu) references contenus(id_contenu) on delete cascade;


-- 3.	Optimisation de Requêtes (5 pts)
-- Expliquez l'utilité d'un index. Sur quelle(s) colonne(s) de la table Contenus serait-il le plus pertinent d'ajouter un index pour accélérer la recherche par titre ? Justifiez et écrivez la requête CREATE INDEX.
