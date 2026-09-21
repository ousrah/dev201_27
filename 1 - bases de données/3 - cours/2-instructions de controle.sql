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



#exercice 2
#ecrire un algorithme qui permet de resoudre une euqation de deuxième degrès
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


#exercice 3
#un patron decide de participer aux prix de repas de ces employés
#il instaure les règles suivantes
# pour chaque employé on contribu de 20% de son prix de repars
#si il est marié il aura 25% au lieu de 20%
# pour chaque enfant il va avoir 10% avec un plafond de 50%
# si il a un salaire inférieur à 3000 dh il aura un surplus de 10%




