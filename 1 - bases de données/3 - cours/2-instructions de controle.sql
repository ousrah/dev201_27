# programmation procedurale sous mysql
# les instructions de controles
# declaration, l'affectation, les conditions, les boucles, la gestion des erreurs
# les fonctions, les procedures, les transactions, les curseurs
select 5*3;
use courses201;

drop function if exists hello;
delimiter $$
create function hello()
	returns varchar(100)
	deterministic
begin
	return("bonjour les developpeurs");
end$$
delimiter ;

select hello();


drop function if exists helloName;
delimiter &&
create function helloName(name varchar(50))
	returns varchar(150)
    deterministic
begin
	return concat("bonjour ",name);
end &&
delimiter ;



select helloName('ysf');


drop function if exists addition;
delimiter $$
create function addition(a int, b int)
	returns int
    deterministic
begin
	return a+b;
end $$
delimiter ;

select addition(1,3);
select addition(51,3);



drop function if exists multiplication;
delimiter $$
create function multiplication(a int, b int)
	returns bigint
    deterministic
begin    
	declare c bigint; #declaration
  # set c = a*b; #affecation avec set
    select a*b into c; #affectation avec select
    return c;
end $$
delimiter ;


select multiplication(3,0);


drop function if exists get_nb_chevaux;
delimiter $$
create function get_nb_chevaux()
	returns int
    deterministic
begin
	declare nb int;
   # set nb =  count(*) on ne peut pas utiliser set pour compter les chevaux et affecter leurs nombre a la variable nb
    select count(*) into nb from cheval;
	return nb;
end $$
delimiter ;

select get_nb_chevaux();



drop function if exists division;
delimiter $$
create function division(a int, b int)
	returns float
    deterministic
begin    
	declare c float; 
	set c = a/b;
    return c;
end $$
delimiter ;


select division(3,2);




drop function if exists division;
delimiter $$
create function division(a int, b int)
	returns varchar(50)
    deterministic
begin    
	declare c varchar(50); 
    if b=0 then
		set c = 'impossible';
	else
		set c = round(a/b,2);
	end if;
    return c;
end $$
delimiter ;


select division(5,2);



drop function if exists comparaison;
delimiter $$
create function comparaison(a int, b int)
	returns varchar(150)
    deterministic
begin    
	
    if a>b then
		return 'a est la plus grande';
	elseif a<b then
		return 'b est la plus grande';
	else
		return 'a et b sont egaux';
	end if;

end $$
delimiter ;


select comparaison(12,12);

# c'est la meilleure solution de comparaison de plusieurs variable
drop function if exists comparaison;
delimiter $$
create function comparaison(a int, b int,c int)
	returns varchar(150)
    deterministic
begin    
	declare max int;
    set max=a;
    if max<b then
		set max=b;
	elseif max<c then
		set max=c;
	end if;
	return concat(max," est la plus grand");
end $$
delimiter ;
select comparaison(16,111,20);



#très mauvais algorithme il ne couvre les cas d'églité et il répète inutilement les comparaison
drop function if exists comparaison;
delimiter $$
create function comparaison(a int, b int,c int)
	returns varchar(150)
    deterministic
begin    
    if a>b and a> c then
		return concat(a ," est la plus grande");
	end if;
    if b>a and b>c then
		return concat(b ," est la plus grande");
	end if;
    if c>a and c>b then
		return concat(c ," est la plus grande");
	end if;
    
	
end $$
delimiter ;
select comparaison(111,200,200);


#bon algorithme pour 3 variables pour plus de variable il faut utiliser le max de la première solution
drop function if exists comparaison;
delimiter $$
create function comparaison(a int, b int,c int)
	returns varchar(150)
    deterministic
begin    
    if a>b then
		if a>c then
			return concat(a ," est la plus grande");
		else
			return concat(c ," est la plus grande");
		end if;
	else
		if b>c then
			return concat(b ," est la plus grande");
		else 
			return concat(c ," est la plus grande");
		end if;
	end if;
end $$
delimiter ;
select comparaison(3,3,3);



#exercice 1
#ecrire un algorithme qui permet de resoudre une euqation de premier degrès
Ax+B = 0

si A = 0 et B = 0 alors  x = l''ensemble R
si A = 0 et B <> 0 alors x = impossible
si A <> 0 alors x = -B/A

drop function if exists premier;
delimiter $$
create function premier(a int, b int)
	returns varchar(150)
    deterministic
begin 
	if a = 0  then
		if b = 0 then
			return "l'ensemble R";
		else
    		return "impossible";
		end if;
	else 
		return round(-b/a,2);
	end if;
end $$
delimiter ;
select premier (2,3);





#exercice 2
#ecrire un algorithme qui permet de resoudre une euqation de deuxième degrès
/*
Ax²+Bx+C = 0 
A=0, B=0, C= 0  x = R
A=0, B=0,C<>0 x=impossible
A=0, B<> 0 x = -C/B
A<>0
	delta = B*B - 4*A*C 
    si delta >0 alors x1=(-B-racine(delta))/(2*A)  x2=(-B+racine(delta))/(2*A) 
    si delta = 0 alors x1=x2= -B/(2*A)
    si delta <0 alors impossible dans R
    
    
select pow(5,3);    
select sqrt(25);
*/
drop function if exists deuxiemme;
delimiter $$
create function if not exists deuxiemme(a float, b float,c float)
	returns varchar(150)
    deterministic
begin 
	declare delta float;
	if a=0 then
		if b=0 then
			if c=0 then
				return 'x est l''ensemble R';
			else 
				return 'impossible';
			end if;
		else
			return concat("x=",-c/b);
        end if;
	else
		set delta= (b*b) - (4*a*c);
        if delta>0 then
			return concat( "x1=",(-b-sqrt(delta))/(2*a), " x2=",(-b+sqrt(delta))/(2*a));
		elseif delta=0 then
			return concat("x1=x2=",-b/(2*a));
		else
			return 'impossible dans R';
		end if;
	end if;
end $$
delimiter ;


select deuxiemme(0,0,0); 
select deuxiemme(0,0,3); 
select deuxiemme(0,3,2); 
select deuxiemme(4,4,1);  # delta = 0
select deuxiemme(4,6,1);  # delta > 0
select deuxiemme(4,1,1);  # delta < 0



#exercice 3
#un patron decide de participer aux prix de repas de ces employés
#il instaure les règles suivantes
# pour chaque employé on contribu de 20% de son prix de repars
#si il est marié il aura 25% au lieu de 20%
# pour chaque enfant il va avoir 10% avec un plafond de 50%
# si il a un salaire inférieur à 3000 dh il aura un surplus de 10%
drop function if exists participation;
delimiter $$
create function participation(prix decimal, marie boolean , nb_enfant int , salair decimal)
	returns varchar(150)
    deterministic
begin 
	declare pourcentage int;
    set pourcentage = 20;
    if marie = true then 
		set pourcentage=pourcentage+5;
    end if;
    set pourcentage=pourcentage+(nb_enfant*10);
    if pourcentage>50 then 
		set pourcentage=50;
	end if;
    if salair<3000 then
		set pourcentage=pourcentage+10;
    end if;
    return concat("le montant payer par le patron est ",round((pourcentage*prix)/100 ,2));
end $$
delimiter ;

select participation(100,false,0,8000);
select participation(100,false,0,2000);
select participation(100,true,7,2000);
select participation(100,true,2,7000);


# ecrire une fonction qui reçoit le numero du jour et qui retourn son nom en français
#exemple select nom_jour(1)  -->  'dimanche';
#			   nom_jour(6)  -->  'venderid';
               
 drop function if exists num_jour;
delimiter $$
create function num_jour(nb int)
	returns varchar(150)
    deterministic
begin
	if nb=1 then 
		return 'dimanche';
	elseif nb=2 then 
		return 'lundi' ;
	elseif nb=3 then 
		return 'mardi' ;
	elseif nb=4 then 
		return 'mercredi' ;
	elseif nb=5 then 
		return 'jeudi' ;
	elseif nb=6 then 
		return 'vendredi' ;
	elseif nb=7 then 
		return 'samedi' ;
	else 
		return 'numero invalide';
	end if;
end $$
delimiter ;
select num_jour(1);
 
 
 
            
 drop function if exists num_jour;
delimiter $$
create function num_jour(nb int)
	returns varchar(150)
    deterministic
begin
	declare jour varchar(150);
    case 
		when nb=1 then set jour = "Dimanche";
		when nb=2 then set jour = "Lundi";
		when nb=3 then set jour = "Mardi";
		when nb=4 then set jour = "Mercredi";
		when nb=5 then set jour = "Jeudi";
		when nb=6 then set jour = "Vendredi";
		when nb=7 then set jour = "samedi";
    else
		set jour = "incorrect";
	end case;
    return jour;
end $$
delimiter ;



 drop function if exists num_jour;
delimiter $$
create function num_jour(nb int)
	returns varchar(150)
    deterministic
begin
	declare jour varchar(150);
    set jour = case nb
					when 1 then  "Dimanche"
					when 2 then  "Lundi"
					when 3 then  "Mardi"
					when 4 then "Mercredi"
					when 5 then  "Jeudi"
					when 6 then  "Vendredi"
					when 7 then  "samedi"
				else
					 "incorrect"
				end;
    return jour;
end $$
delimiter ;


select num_jour(2);




# exercice : ecrire une fonction qui récupère une note et qui affiche sa mention
# en respectant les valeurs suivantes
# si note < 5 très faible
# si note entre 5 et <9 faible
# si note entre 9 et <10 insuffisant
# si note entre 10 et <12 passable
# si note entre 12 et <14 assez bien
# si note entre 14 et <16 bien
# si note entre 16 et <18 très bien
# si note entre 18 et <=20 excellent
# si note non inclus entre 0 et 20 erreur


