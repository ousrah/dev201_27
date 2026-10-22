#Exercice 1 :
#Écrire une fonction qui renvoie une chaine qui sera exprimée 
#sous la forme Jour, Mois et Année à partir d’une date passée comme
# paramètre où :
#­	Mois est exprimé en toutes lettres
#exemple : décembre 
##Exemple : 12/09/2011 -----> 12 septembre 2011
drop function if exists month_date;
delimiter //
create function month_date( d date)
returns varchar(50)
deterministic
begin 
declare date_month varchar(50);
case month(d)
	when 1 then set date_month =concat(day(d),"/janvrier/",year(d));
	when 2 then set date_month =concat(day(d),"/fevrier/",year(d));
	when 3 then set date_month =concat(day(d),"mars/",year(d));
	when 4 then set date_month =concat(day(d),"/avril/",year(d));
	when 5 then set date_month =concat(day(d),"/may/",year(d));
	when 6 then set date_month =concat(day(d),"/juin/",year(d));
	when 7 then set date_month =concat(day(d),"/juillet/",year(d));
	when 8 then set date_month =concat(day(d),"/aout/",year(d));
	when 9 then set date_month =concat(day(d),"/septembre/",year(d));
	when 10 then set date_month =concat(day(d),"/octobre/",year(d));
	when 11 then set date_month =concat(day(d),"/novembre/",year(d));
	when 12 then set date_month =concat(day(d),"/decembre/",year(d));
end case;
return date_month;
end//
delimiter ;
select month_date('2024/02/01');



drop function if exists month_date;
delimiter //
create function month_date( d date)
returns varchar(50)
deterministic
begin 
declare date_month varchar(50);
	set lc_time_names='fr_FR';
	set date_month =concat(day(d),'/',monthname(d),'/',year(d));
	set lc_time_names='en_US';	
return date_month;
end//
delimiter ;
select month_date('2024/02/01');


#Exercice 2:
#Ecrire une fonction qui reçoit deux dates comme paramètre et calcule
# l’écart en fonction de l’unité de calcul passée à la fonction ;
#L’unité de calcul peut être de type : jour, mois, année, heure, minute, seconde
#select difference('10/10/2001','15/10/201','jour');  --> 5 jours
#select difference('10/10/2001 08:00;00','15/10/201 12:00:00',heure);  --> 5 jours

drop function if exists cdate;
delimiter //
create function cdate( date1 date , date2 date , unite varchar(20))
	returns int
	deterministic
begin 

    return case unite
		when "annee" then timestampdiff(year , date1,date2)
		when "mois" then  timestampdiff(month , date1,date2)
		when "jour" then timestampdiff(day , date1,date2)
		when "heures" then timestampdiff(hour , date1,date2)
		when "minutes" then timestampdiff(minute , date1,date2)
		when "seconde" then timestampdiff(second , date1,date2)
    end;

end//
delimiter ;
select cdate("2012/11/09","2013/11/10","mois") 


#Exercice 3 : application sur la bd ‘gestion_vols’
#Gestion vol
#Pilote(numpilote,nom,titre,villepilote,daten,datedebut)
#Vol(numvol,villed,villea,dated,datea, #numpil,#numav)
#Avion(numav,typeav ,capav)



drop database if exists vols_201;

create database vols_201 collate utf8mb4_general_ci;
use vols_201;

create table Pilote(
numpilote int auto_increment primary key,
nom varchar(50) ,
titre varchar(50) ,
villepilote varchar(50) ,
daten date,
datedebut date);

create table Vol(numvol int auto_increment primary key,
villed varchar(50) ,
villea varchar(50) ,
dated date ,
datea date , 
numpil int not null,
numav int not null);

create table Avion(numav int auto_increment primary key,
typeav  varchar(50) ,
capav int);

alter table vol add constraint fk_vol_pilote foreign key(numpil) references pilote(numpilote);
alter table vol add constraint fk_vol_avion foreign key(numav) references avion(numav);


insert into avion values (1,'boeing',350),
						(2,'caravel',50),
                        (3,'airbus',500),
                        (4,'test',350);
                        
insert into pilote values (1,'hassan','M.','tetouan','2000-01-01','2022-01-01'),
						(2,'saida','Mme.','casablanca','1980-01-01','2005-01-01'),
						(3,'youssef','M.','tanger','1983-01-01','2002-01-01');



update pilote set datedebut = '2002-01-01' where numpilote = 2;

insert into vol values (1,'tetouan','casablanca','2023-09-10','2023-09-10',1,1),
						(2,'casablanca','tetouan','2023-09-10','2023-09-10',1,1),
						(3,'tanger','casablanca','2023-09-11','2023-09-11',2,2),
						(4,'casablanca','tanger','2023-09-11','2023-09-11',2,2),
						(5,'agadir','casablanca','2023-09-11','2023-09-11',3,3),
						(6,'casablanca','agadir','2023-09-11','2023-09-11',3,3);


insert into vol values (7,'tetouan','casablanca','2023-09-10','2023-09-12',1,1),
						(8,'casablanca','tetouan','2023-09-10','2023-09-12',1,1),
						(9,'tanger','casablanca','2023-09-11','2023-09-13',1,2),
						(10,'casablanca','tanger','2023-09-11','2023-09-13',1,2),
						(11,'agadir','casablanca','2023-09-11','2023-09-13',3,3),
						(12,'casablanca','agadir','2023-09-11','2023-09-13',3,3),
                        (13,'tetouan','casablanca','2023-09-10','2023-09-15',2,1),
						(14,'casablanca','tetouan','2023-09-10','2023-09-15',3,1);  



select * from vol;

#1.	Ecrire une fonction qui retourne le nombre de pilotes ayant effectué
# un nombre de vols supérieur à un nombre donné comme paramètre ;

drop function if exists ex3_q1;
delimiter //
create function ex3_q1(num int)
	returns int
	deterministic
begin 
    return( 
				with f as (
					select numpil, count(*) nb_vol 
									from vol 
									group by numpil
									having nb_vol >num
					)
					select count(*) from f
			);
end//
delimiter ; 

select ex3_q1(10);
drop function if exists q1;
delimiter $$
create function q1(n int)
	returns int
	deterministic
begin
	declare r int;
	select count(*) into r from (
						select numpil, count(*)
						from vol
						group by numpil
						having count(*)>n ) f  ;
	return r;

end$$
delimiter ;

select q1(5);








#2.	Ecrire une fonction qui retourne la durée de travail d’un pilote dont
# l’identifiant est passé comme paramètre ;
DROP function if exists ex3_q2;
delimiter $$
create function ex3_q2(id_pilote int)
	returns int
	deterministic
begin
	declare duree int;
    select datediff(curdate(),datedebut) into duree
    from pilote 
    where numpilote=id_pilote;
    return duree;
end $$
delimiter ;
    
    
    
select ex3_q2(3);
    

#3.	Ecrire une fonction qui renvoie le nombre des avions qui ne sont pas
# affectés à des vols ;
drop function if exists ex3_q3;
delimiter $$ 
create function ex3_q3()
returns int
deterministic
begin
return(
		select count(*) 
		from avion 
		where numav not in (select numav from vol));
end $$
delimiter ;
select ex3_q3(); 

select * from avion;
select distinct numav from vol;

#4.	Ecrire une fonction qui retourne le numero du plus ancien pilote 
# 'le plus ancien c'est celui qui a été recruté le premier'
#qui a piloté l’avion dont le numero est passé en paramètre ;

drop function if exists ex3_q4;
delimiter //
create function ex3_q4(id int)
	returns int
    deterministic
begin
	return(
    select numpilote
from pilote join vol on pilote.numpilote = vol.numpil
where numav = id
order by datedebut asc
limit 1
    );
end//
delimiter ;

select ex3_q4(3);




select pilot_encien(2);
#a piloté l’avion dont le numero est passé en paramètre ;




#5.	Ecrire une fonction table qui retourne le nombre des pilotes dont 
#le salaire est inférieur à une valeur passée comme paramètre ;

alter table pilote add salaire decimal(8,2) ;
select * from pilote;
update pilote set salaire = 18000 where numpilote = 1;
update pilote set salaire = 28000 where numpilote = 2;
update pilote set salaire = 38000 where numpilote = 3;


drop function if exists ex4_q5;
delimiter //
create function ex4_q5(sal int)
returns int
deterministic
begin
 return(select count(*) from pilote where salaire<sal);
 end//
 delimiter ;
 select ex4_q5(50000);

select  salaire from pilote where salaire <30000 limit 1;

#sur my sql on ne peut pas créer des fonction tables, 
#les seules fonction que mysql accept c'est les fonctins sclaires

#Exercice 4:
#Considérant la base de données suivante :
#DEPARTEMENT (ID_DEP, NOM_DEP, Ville)
#EMPLOYE (ID_EMP, NOM_EMP, PRENOM_EMP, DATE_NAIS_EMP, SALAIRE,#ID_DEP)






drop database if exists employes_201;

create database employes_201 COLLATE "utf8mb4_general_ci";
use employes_201;


create table DEPARTEMENT (
ID_DEP int auto_increment primary key, 
NOM_DEP varchar(50), 
Ville varchar(50));

create table EMPLOYE (
ID_EMP int auto_increment primary key, 
NOM_EMP varchar(50), 
PRENOM_EMP varchar(50), 
DATE_NAIS_EMP date, 
SALAIRE float,
ID_DEP int ,
constraint fkEmployeDepartement foreign key (ID_DEP) references DEPARTEMENT(ID_DEP));

insert into DEPARTEMENT (nom_dep, ville) values 
		('FINANCIER','Tanger'),
		('Informatique','Tétouan'),
		('Marketing','Martil'),
		('GRH','Mdiq');

insert into EMPLOYE (NOM_EMP , PRENOM_EMP , DATE_NAIS_EMP , SALAIRE ,ID_DEP ) values 
('said','said','1990/1/1',8000,1),
('hassan','hassan','1990/1/1',8500,1),
('khalid','khalid','1990/1/1',7000,2),
('souad','souad','1990/1/1',6500,2),
('Farida','Farida','1990/1/1',5000,3),
('Amal','Amal','1990/1/1',6000,4),
('Mohamed','Mohamed','1990/1/1',7000,4);


select * from employe;

#1.	Créer une fonction qui retourne le nombre d’employés


drop function if exists ex4_q1;
delimiter //
create function ex4_q1()
returns int
deterministic
begin
	return(select count(*) from employe);
end//
delimiter ;
select ex4_q1();







#2.	Créer une fonction qui retourne la somme des salaires de tous les 
#employés




drop function if exists ex4_q2;
delimiter //
create function ex4_q2()
returns int
deterministic
begin
	return(select sum(salaire) from employe);
end//
delimiter ;
select ex4_q2();


#3.	Créer une fonction pour retourner le salaire minimum de tous les 
#employés
drop function if exists ex4_q3;
delimiter //
create function ex4_q3()
returns int
deterministic
begin
	return(select min(salaire) from employe);
end//
delimiter ;
select ex4_q3();

#4.	Créer une fonction pour retourner le salaire maximum de tous les 
#employés

drop function if exists ex4_q4;
delimiter //
create function ex4_q4()
returns int
deterministic
begin
	return(select max(salaire) from employe);
end//
delimiter ;
select ex4_q4();


#5.	En utilisant les fonctions créées précédemment, Créer une requête 
#pour afficher le nombre des employés, la somme des salaires, le salaire 
#minimum et le salaire maximum

select 
	ex4_q1() as nb,
    ex4_q2() as somme,
    ex4_q3() as minimum,
    ex4_q4() as maximum;





#6.	Créer une fonction pour retourner le nombre d’employés 
#d’un département donné.



drop function if exists ex4_q6;
delimiter //
create function ex4_q6(id int)
returns int
deterministic
begin
	return(select count(*) from employe where id_dep = id);
end//
delimiter ;
select ex4_q6(1);





#7.	Créer une fonction la somme des salaires des employés 
#d’un département donné


drop function if exists ex4_q7;
delimiter //
create function ex4_q7(id int)
returns int
deterministic
begin
	return(select sum(salaire) from employe where id_dep = id);
end//
delimiter ;
select ex4_q7(1);

#8.	Créer une fonction pour retourner le salaire minimum 
#des employés d’un département donné

drop function if exists ex4_q8;
delimiter //
create function ex4_q8(id int)
returns int
deterministic
begin
	return(select min(salaire) from employe where id_dep = id);
end//
delimiter ;
select ex4_q8(1);

#9.	Créer une fonction pour retourner le salaire maximum 
#des employés d’un département.


drop function if exists ex4_q9;
delimiter //
create function ex4_q9(id int)
returns int
deterministic
begin
	return(select max(salaire) from employe where id_dep = id);
end//
delimiter ;
select ex4_q9(1);


#10.	En utilisant les fonctions créées précédemment, 
#Créer une requête pour afficher pour les éléments suivants : 
#a.	Le nom de département en majuscule. 
#b.	La somme des salaires du département
#c.	Le salaire minimum
#d.	Le salaire maximum


select upper(NOM_DEP),ex4_q7(id_dep),ex4_q8(id_dep),ex4_q9(id_dep) from DEPARTEMENT;


#11.	Créer une fonction qui accepte comme paramètres 
#2 chaines de caractères et elle retourne les deux chaines 
#en majuscules concaténé avec un espace entre eux.
drop function if exists chaines;
delimiter $$
create function chaines(c1 varchar(40),c2 varchar(40))
   returns varchar(80)
   deterministic
begin
     declare rslt varchar(80);
     set rslt=concat(c1,' ',c2);
     return upper(rslt);
end$$
delimiter ;
select chaines('hello','friend');
