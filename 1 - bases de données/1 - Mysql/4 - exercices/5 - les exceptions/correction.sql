#Exercice 1 : Gestion simple d'une erreur (Procédure stockée + SQLEXCEPTION)
#Objectif : Créer une procédure qui tente d'insérer un utilisateur. 
#Si une erreur se produit (par exemple, un doublon sur la clé primaire 
#ou un champ obligatoire manquant), on intercepte l'exception via 
#SQLEXCEPTION pour éviter le plantage et renvoyer un message personnalisé.
#Instructions :
#1.	Créez une table utilisateurs avec un identifiant (id INT PRIMARY KEY) 
#et un nom (nom VARCHAR(50) NOT NULL).
#2.	Écrivez une procédure stockée ajouter_utilisateur
#(IN p_id INT, IN p_nom VARCHAR(50)) qui insère une ligne.
#3.	Utilisez un gestionnaire d'erreur
# (DECLARE CONTINUE HANDLER FOR SQLEXCEPTION) pour capturer 
# l'erreur et positionner un message ou une variable d'état.
drop database if exists utilisateurs_201;
create database utilisateurs_201 collate utf8mb4_general_ci;
use utilisateurs_201;

create table utilisateur(id int auto_increment primary key, nom varchar(50));

select ceiling(rand()*22);

drop procedure if exists pr1;
delimiter & 
create procedure pr1(u_id int , u_nom varchar(50)) 
begin 
declare continue handler for sqlexception 
	begin
	select "erruer";
	end;
	insert into utilisateur values(u_id,u_nom);
end &
delimiter ;
call pr1(null,"ibtissam");
call pr1(1,"ibtissam");



#Exercice 2 : Gestion de données introuvables ou erreur de calcul 
#(Procédure + NOT FOUND)
#Objectif : Utiliser le gestionnaire NOT FOUND pour intercepter le cas où une requête de sélection (SELECT ... INTO) ne retourne aucune ligne.
#Instructions :
#1.	Utilisez la table utilisateurs précédente.
#2.	Écrivez une procédure stockée recuperer_nom(IN p_id INT) qui 
#cherche le nom d'un utilisateur grâce à son ID et le stocke dans 
#une variable locale avec SELECT ... INTO.
#3.	Utilisez DECLARE   HANDLER FOR NOT FOUND pour afficher 
#un message propre si l'ID recherché n'existe pas dans la table.#


drop procedure if exists recuperer_nom;
delimiter $$
create procedure recuperer_nom(u_id int) 
begin 
    declare u varchar(60);
    declare continue handler for not found select "user not found" ;
	select nom into u from utilisateur where id= u_id;
    select u;
end$$
delimiter ;
call pr1(null,"ibtissam");
call recuperer_nom(2);

#Exercice 3 : Utilisation de SQLSTATE spécifique (Procédure stockée + SQLSTATE)
#Objectif : Gérer spécifiquement une erreur de type clé dupliquée 
#(dont le code SQLSTATE standard est '23000') en plus d'une gestion 
#générale des autres erreurs.
#Instructions :
#1.	En reprenant la table utilisateurs, écrivez une procédure 
#stockée inserer_securise(IN p_id INT, IN p_nom VARCHAR(50)).
#2.	Déclarez un gestionnaire spécifique pour le SQLSTATE '23000' 
#(Violation de contrainte d'intégrité / doublon).
#3.	Déclarez un second gestionnaire pour toutes les autres SQLEXCEPTION.
drop procedure if exists inserer_securise;
delimiter $$
create procedure inserer_securise (IN p_id INT, IN p_nom VARCHAR(50)) 
begin 
declare exit  handler for sqlstate "23000" 
	begin
		select 'Doublant de constrainte';
	end;
declare exit handler for sqlexception  select "Insertion imposible";
insert into utilisateur values(p_id,p_nom);
end$$
delimiter ;

call inserer_securise(2,'test');
select * from utilisateur;

#Exercice 4 : Remontée d'erreur personnalisée avec SIGNAL (Trigger + SIGNAL)
#Objectif : Empêcher l'insertion d'un employé dont le salaire est négatif ou égal à zéro en déclenchant une erreur explicite à l'aide de l'instruction SIGNAL.
#Instructions :
#1.	Créez une table employes avec un champ salaire DECIMAL(10,2).
#2.	Créez un trigger avant_insertion_employe sur les opérations 
#BEFORE INSERT de la table employes.
#3.	Si le salaire inséré est inférieur ou égale à  0 , utilisez 
#SIGNAL SQLSTATE '45000' avec un message explicite (MESSAGE_TEXT) 
#pour bloquer l'insertion.



drop trigger if exists trig1 ;
delimiter //
create trigger trig1 before insert on employes
for each row
begin 
if new.salaire <=0 then 
	signal sqlstate '45000'
	set message_text = "error le salaire doit etre superiere a zero";
end if ;
end //
delimiter ;

create table employes (id int auto_increment primary key, nom varchar(50),salaire float);
insert into employes values (1,'test',100);
select * from employes;
insert into employes values (1,'test',-100);




#Exercice 5 : Extraction des détails de l'erreur avec GET DIAGNOSTICS 
#(Procédure + DIAGNOSTICS)
#Objectif : Capturer une erreur, puis utiliser la clause GET DIAGNOSTICS pour récupérer des informations précises sur l'erreur (le code d'erreur MySQL et le texte exact de l'erreur) afin de les afficher proprement.
#Instructions :
#1.	Écrivez une procédure stockée tester_diagnostics(IN p_id INT,
# IN p_nom VARCHAR(50)) qui tente d'insérer dans la table utilisateurs.
#2.	En cas de SQLEXCEPTION, capturez l'erreur.
#3.	À l'intérieur du gestionnaire d'erreur, utilisez GET DIAGNOSTICS 
#pour extraire le message (MESSAGE_TEXT) et l'état (MYSQL_ERRNO),
# puis affichez-les.


DELIMITER //
CREATE PROCEDURE tester_diagnostics(IN p_id INT, IN p_nom VARCHAR(50))
BEGIN
    DECLARE v_errno INT;
    DECLARE v_message TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_errno = MYSQL_ERRNO,
            v_message = MESSAGE_TEXT;
        SELECT  v_errno AS code_erreur, v_message AS message_erreur;
    END;
    INSERT INTO utilisateurs (id, nom)  VALUES (p_id, p_nom);
    SELECT 'Insertion réussie' AS resultat;
END //
DELIMITER ;

CALL tester_diagnostics(1, 'Ali');
CALL tester_diagnostics(1, 'Sara');


