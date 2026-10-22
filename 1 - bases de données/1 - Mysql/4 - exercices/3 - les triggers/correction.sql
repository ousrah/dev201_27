#EX 1 - Soit la base de données suivante :  (Utilisez celle de la série des fonctions):
#Pilote(numpilote,nom,titre,villepilote,daten,datedebut)
#Vol(numvol,villed,villea,dated,datea, #numpil,#numav)
#Avion(numav,typeav ,capav)


use vols_201;

#1 – Ajouter la table pilote le champ nb d’heures de vols ‘NBHV’ sous la forme  « 00:00:00 ».
alter table pilote add column nbhv time default '00:00:00';


#2 – Ajouter un déclencheur qui calcule le nombre heures lorsqu’on ajoute un nouveau vol
# et qui augmente automatiquement le nb d’heures de vols du pilote qui a effectué le vol.

select * from vol;

drop trigger if exists tr1;
delimiter $$
create trigger if not exists tr1 after insert on vol for each row
begin
   update pilote set nbhv= addtime(nbhv,timediff(new.datea,new.dated))
   where pilote.numpilote=new.numpil;
end$$
delimiter ;
select * from pilote;
select * from vol;
alter table vol modify dated datetime;
alter table vol modify datea datetime;

insert into vol values (null,'test','test2','2026-10-05 08:00:00', '2026-10-05 10:00:00',1,1);
select * from pilote;
select * from vol;
insert into vol values (null,'test','test2','2026-10-05 12:00:00', '2026-10-05 14:30:00',1,1);



#3 – Si on supprime un vol le nombre d’heures de vols du pilote qui a effectué ce vol doit 
#être recalculé. Proposez une solution.

drop trigger if exists tr2;
delimiter $$
create trigger if not exists tr2 after delete on vol for each row
begin
   update pilote set nbhv= subtime(nbhv,timediff(old.datea,old.dated))
   where pilote.numpilote=old.numpil;
end$$
delimiter ;
delete from vol where numpil=1;


#4 – Si on modifie la date de départ ou d’arrivée d’un vol le nombre d’heures de vols du
# pilote qui a effectué ce vol doit être recalculé. Proposez une solution.
drop trigger if exists tr3;
delimiter $$
create trigger if not exists tr3 after update on vol for each row
begin
   update pilote set nbhv= subtime(nbhv,timediff(old.datea,old.dated))  where pilote.numpilote=old.numpil;
   update pilote set nbhv= addtime(nbhv,timediff(NEW.datea,new.dated))   where pilote.numpilote=old.numpil;
end
$$
delimiter ;




#EX 2 - Soit la base de données suivante :  (Utilisez celle de la série des PS):

#DEPARTEMENT (ID_DEP, NOM_DEP, Ville)
#EMPLOYE (ID_EMP, NOM_EMP, PRENOM_EMP, DATE_NAIS_EMP, SALAIRE, #ID_DEP)
#1 – Ajouter le champs salaire moyen dans la table département.
use employes_201;
alter table departement add salaire_moyen float default 0;

select * from departement;

#2 – On souhaite que le salaire moyen soit recalculé automatiquement si on ajoute 
#un nouvel employé, on supprime ou on modifie le salaire d’un ou plusieurs employés.
# Proposez une solution.
use employes_201;

drop procedure if exists calucler_moeynne_salaire_par_dep;
delimiter //
create procedure calucler_moeynne_salaire_par_dep(id_depa int)
begin
	   update departement set salaire_moyen=(select avg(SALAIRE) from employe where ID_DEP=id_depa) where ID_DEP=id_depa;
end //
delimiter ;

drop trigger if exists tr1;
delimiter $$
create trigger tr1 after insert on employe for each row
begin
	call calucler_moeynne_salaire_par_dep(new.id_dep);
end$$
delimiter ;


drop trigger if exists tr2;
delimiter $$
create trigger tr2 after delete on employe for each row
begin
	call calucler_moeynne_salaire_par_dep(old.id_dep);
end$$
delimiter ;


drop trigger if exists tr3;
delimiter $$
create trigger tr3 after update on employe for each row
begin
	call calucler_moeynne_salaire_par_dep(new.id_dep);
end$$
delimiter ;

select * from employe;

insert into employe values (null,'test','test',curdate(),900,1);
update employe set salaire = 9000 where id_emp = 9;
select * from departement;
delete from employe where id_emp = 9;

#EX 2 - Soit la base de données suivante : (Utilisez celle de la série des PS):
#Recettes (NumRec, NomRec, MethodePreparation, TempsPreparation)
#Ingrédients (NumIng, NomIng, PUIng, UniteMesureIng, NumFou)
#Composition_Recette (NumRec, NumIng, QteUtilisee)
#Fournisseur (NumFou, RSFou, AdrFou)
#1 – Ajoutez le champ prix à la table recettes.
use cuisine_201;
alter table recettes add prix float;
update recettes set prix = 0;
select * from recettes;


#2 – On souhaite que le prix de la recette soit calculé automatiquement si on ajoute 
#un nouvel ingrédient, on supprime un ingrédient ou on modifie la quantité ou 
#le prix d’un ou plusieurs ingrédients. Proposez une solution. 
delimiter ::
create function calculer_prix (id_recette int)
returns float 
deterministic
begin 
	return (select sum(qteUtilisee*Puing) 
			from composition_recette 
            join ingredients using(NumIng)
            where NumRec=id_recette);
end ::
delimiter ;
select calculer_prix(1);

drop trigger if exists tr1;
delimiter ::
create trigger if not exists tr1 after update on composition_recette for each row
begin
	update recettes set prix = calculer_prix(new.numrec) where numrec=new.numrec ;
end::
delimiter ;

drop trigger if exists tr2;
delimiter ::
create trigger if not exists tr2 after delete on composition_recette for each row
begin
	update recettes set prix = calculer_prix(old.numrec) where numrec=old.numrec ;
end::
delimiter ;

drop trigger if exists tr3;
delimiter ::
create trigger if not exists tr3 after insert on composition_recette for each row
begin
	update recettes set prix = calculer_prix(new.numrec) where numrec=new.numrec ;
end::
delimiter ;


select * from composition_recette;
insert into composition_recette values (1,1,1);
select * from recettes;
delimiter ::
create trigger tr2 after update on ingredients for each row
begin 
declare  id_rect int;
declare nevPrix float; 
# on  a besoin d'un courseur pour traiter toutes ls recettes concerné par l'ingrédient modifié


