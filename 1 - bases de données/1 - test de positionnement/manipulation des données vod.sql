
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

select * from contenus where annee_sortie = 2016;


create index idx_annee_sortie on contenus(annee_sortie);

create index idx_titre on contenus(titre);


-- Partie 3 : Requêtes de Sélection (30 points)
-- (Pour cette partie, les étudiants utiliseront le script SQL corrigé fourni par l'enseignant pour s'assurer que tout le monde travaille sur la même base de données.)

-- Instructions : Rédigez une requête SQL pour chacune des demandes suivantes (chaque requête vaut 2 points).
-- Niveau 1 : Sélection, Filtrage et Tri
-- 1.	Lister les titres et années de sortie de tous les contenus disponibles.
select titre , annee_sortie from contenus ;
-- 2.	Lister tous les utilisateurs inscrits en triant les résultats du plus
-- récent au plus ancien.
select * from utilisateurs
order by id_utilisateur desc;
-- 3.	Afficher les titres des contenus qui durent plus de 2 heures (120 minutes).
select titre,duree from contenus
where duree>120;
-- 4.	Trouver tous les films (non les épisodes) sortis en 1994.
select * from contenus where id_saison is null and ANNEE_SORTIE=1994;
-- 5.	Lister les noms et prénoms de tous les acteurs dont le nom de famille est 'Hanks' ou 'Reeves'.
select nom_acteur from acteurs where nom_acteur like "%hanks" or  nom_acteur like "%reeves";

-- select nom, prenom from acteurs where nom like 'hanks' or nom like 'reeves';
-- select nom, prenom from acteurs where nom in  ('hanks' ,'reeves');

-- Niveau 2 : Jointures et Agrégations
-- 6.	Afficher le titre de la série ainsi que les titres de tous ses épisodes.

select series.libelle_serie,contenus.titre
from series 
join saisons using(id_serie) 
join contenus  using(id_saison); #on saisons.id_saison=contenus.id_saison;

-- 7. Compter le nombre total de films disponibles dans la base de données.
select count(*) nombre_films 
from contenus 
where id_saison is null;


-- 8. Lister les genres et le nombre de contenus associés à chaque genre, triés par 
-- ordre décroissant du nombre de contenus.

# non optimisée
select libelle_genre,count(*) num_contenue 
from genre
join appartien using (id_genre)
join contenus using (id_contenu)
group by id_genre
order by num_contenue desc;

#optimisée
select libelle_genre,count(*) num_contenue 
from genre
join appartien using (id_genre)
group by id_genre
order by num_contenue desc;


-- 9. Calculer la durée moyenne (en minutes) des films du genre "Action".

select avg(duree)  as moyenne
from genre 
join appartien using(id_genre)
join contenus using (id_contenu)
where libelle_genre='action' and id_saison is null;

-- 10. Afficher les noms des utilisateurs et les titres des 
-- contenus qu'ils ont regardés.

select u.nom_utilisateur,contenus.titre as contenu_regardes
from utilisateurs u
join historique using(id_utilisateur)
join contenus using(id_contenu);

-- Niveau 3 : Sous-requêtes et Requêtes Complexes
-- 11. Lister les titres de tous les contenus dans lesquels l'acteur 
-- 'Tom Hanks' a joué (utilisez une sous-requête dans la clause WHERE).

 
select titre 
from contenus 
where id_contenu in (select id_contenu 
					 from jouer 
					 where id_acteur = (select id_acteur 
										from acteurs 
                                        where nom_acteur='keanu reeves'
                                        )
					);


;


;

select titre #, nom_acteur
from contenus 
where id_contenu in (select id_contenu 
					from jouer 
                    where id_acteur in (select id_acteur 
										from acteurs 
                                        where nom_acteur = 'keanu reeves'
                                        )
					);

select titre , nom_acteur
from contenus join jouer using(id_contenu)
			 join acteurs using(id_acteur)
where nom_acteur = 'keanu reeves';


select *
from contenus, jouer
where contenus.id_contenu = jouer.id_contenu;

select 17*9;

-- 12. Afficher les titres des contenus qui n'ont encore jamais 
#été vus par aucun utilisateur.

#methode 1
select titre from contenus 
where id_contenu not in (select id_contenu 
						from historique);
                        
#methode 2                        
select distinct titre
from contenus left join historique using(id_contenu)
where id_utilisateur is null;

                        

-- 13. Lister les genres qui sont associés à plus de 2 contenus différents 
-- (utilisez HAVING).
select libelle_genre 
from genre join appartien using (id_genre) 
group by libelle_genre 
having count(id_contenu)>2;






-- 14. Afficher le nom de l'utilisateur qui a regardé le plus de minutes au total.


select nom_utilisateur , sum(minute_regardee) as minutes
from utilisateurs
join historique using (id_utilisateur)
group by id_utilisateur
order by minutes desc
limit 1;


select nom_utilisateur , sum(minute_regardee) as minutes
from utilisateurs 
join historique using (id_utilisateur)
group by id_utilisateur
having minutes in (select max(minutes) maximum 
					from (select nom_utilisateur , sum(minute_regardee) as minutes
							from utilisateurs
							join historique using (id_utilisateur)
							group by id_utilisateur
                           ) req1
					) 
;

select 156+49;
select * from utilisateurs;
select * from historique where id_utilisateur=2;
-- 15. En utilisant une clause WITH (Common Table Expression), affichez pour chaque genre le titre du film le plus récent.


