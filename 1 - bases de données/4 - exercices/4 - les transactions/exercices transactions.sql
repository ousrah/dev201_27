
-- Série Transactions et exceptions


-- Soit une base de données MySQL  contenant les tables suivantes :

-- Salle (NumSalle, Etage, NombreChaises)
-- Transfert (NumSalleOrigine#, NumSalleDestination#, DateTransfert, NbChaisesTransférées,)

-- 1.	Créer les tables de cette base de données
-- 2.	Le nombre de chaises dans une salle doit être compris entre 20 et 30 chaises par salle, Implémenter cette règle


drop database if exists salles_201;
create database salles_201 collate utf8mb4_general_ci;
use salles_201;

create table Salle (
NumSalle int auto_increment primary key, 
Etage int, 
NombreChaises int, 
constraint chk_NombreChaises check (NombreChaises between 20 and 30));

create table Transfert (
NumSalleOrigine int, 
NumSalleDestination int, 
DateTransfert datetime, 
NbChaisesTransferees  int,
constraint fk_NumSalleOrigine foreign key (NumSalleOrigine) references salle(numsalle),
constraint fk_NumSalleDestination foreign key (NumSalleDestination) references salle(numsalle)
);



-- 3.	Saisir les données suivantes :


-- Numéro salle	Etage	Nombre de chaises
-- 1	1	24
-- 2	1	26
-- 3	1	26
-- 4	2	28
insert into salle values (1,1,24), (2,1,26), (3,1,26), (4,2,28);
select * from salle;

-- 4.	À l’aide d’une transaction, écrire le code qui permet de déplacer un nombre de chaise d’une salle à une autre : 
-- a.	Déclarer les variables suivantes :

-- Variable	type	Valeur
-- SalleOrigine	int	2
-- SalleDest	int	3
-- NbChaises	int	4
-- dateTransfert	Date	Current_date


-- b.	écrire le code qui permet de :
-- i.	débuter une transaction
-- ii.	modifier le nombre de chaises de la salle dont le numéro = SalleOrigine (NombreChaises = NombreChaises - NbChaises)
-- iii.	modifier le nombre de chaises de la salle dont le numéro = SalleDest (NombreChaises = NombreChaises + NbChaises)
-- iv.	Enregistrer l’opération dans la table transfert
-- v.	Valider la transaction


-- c.	écrire le code qui permet de :

-- i.	Annuler la transaction 
-- ii.	afficher le message d’erreur « Impossible d’effectuer le transfert des chaises »
-- d.	Exécuter le code puis consulter les tables salle et transfert, le transfert doit être effectué parce que la contrainte CHECK est vérifiée pour les deux salles
-- e.	En essayant de ré-exécuter le code une deuxième fois, le message d’erreur sera affiché


drop procedure if exists trnsfr;
 delimiter //
 create procedure trnsfr(id_SalleOrigine int, id_SalleDest int,nb_chaise int)
 begin
	declare datetransfert datetime default current_date();
	declare exit handler for sqlexception
    begin
		rollback;
		select "transfert annulé";
    end;
    
    start transaction ;
		update salle set NombreChaises=NombreChaises + nb_chaise where numSalle=id_SalleDest;
		update salle set NombreChaises=NombreChaises - nb_chaise where numSalle=id_SalleOrigine;
		insert into transfert values (id_SalleOrigine,id_SalleDest,datetransfert,nb_chaise);
    commit;
 end //
 delimiter ;

select * from salle;
select * from transfert;
call trnsfr(4,2,3);
