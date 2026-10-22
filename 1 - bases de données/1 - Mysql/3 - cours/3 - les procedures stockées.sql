# les procedures stockées
use vols_201;

delimiter $$
create procedure test1()
begin
	select * from pilote;
    select * from avion;
    select * from vol;
end $$
delimiter ;



call test1();



drop procedure if exists test2;
delimiter $$
create procedure if not exists test2(nump int)
begin
	select * from pilote where numpilote = nump;
    select * from avion where numav in (select numav from vol where numpil = nump);
    select * from vol where numpil = nump;
end $$
delimiter ;


call test2(1);


drop procedure if exists addition;
delimiter $$
create procedure if not exists addition(a int, b int)
begin
	declare r int;
    set r = a + b;
    select r;
end $$
delimiter ;

call addition(3,5);



drop procedure if exists addition;
delimiter $$
create procedure if not exists addition(in a int, in b int)
begin
	declare r int;
    set r = a + b;
    select r;
end $$
delimiter ;

call addition(3,5);



drop procedure if exists addition;
delimiter $$
create procedure if not exists addition(in a int, in b int, out r int)
begin
    set r = a + b;
end $$
delimiter ;


call addition(13,5,@result);

select @result;

drop procedure if exists calculs;
delimiter $$
create procedure if not exists calculs(in x int, y int, op char ,out r varchar(50))
begin
case op
when '+' then set r = x+y;
when 'x' then set r = x*y;
when '/' then if y !=0 then 
				set r = x/y ;
			  else 
                set r = "div by zero" ;
              end if;
when '-' then set r = x-y;
else 
	set r = 'invalide';
end case;
end $$
delimiter ;


call calculs(3,5,'x',@r);
select @r;






drop procedure if exists augmenter_salaire;
delimiter $$
create procedure if not exists augmenter_salaire(inout salaire float)
begin
	set salaire = salaire * 1.2;
end $$
delimiter ;

set @s = 5000;
call augmenter_salaire(@s);
select @s;


addition(3,5);
calculs(3,5,'+',@r);
augmenter_salaire(@s)


