drop database if  exists banque201;
create database if not exists banque201 collate utf8mb4_general_ci;
use banque201;

drop procedure if exists test;
delimiter $$
create procedure test(a int)
begin
	declare x smallint;
    declare exit handler for sqlexception
    begin
		select("probleme d'affectation");
    end;
    set x = a;
    select concat("la valeur de x est ",x);
end$$
delimiter ;


call test(654555454);


drop procedure if exists division;
delimiter $$
create procedure division(a float, b float)
begin
   declare x float;
   declare exit handler for sqlexception
   begin
		select("impossible de diviser par zero");
   end;
   set x = a/b;
   select concat("la valeur de x est ",x);
end$$
delimiter ;

call division(3,0);



























-- exemple gestion des exception






create table account (
account_number varchar(50) primary key ,
funds decimal(8,2),
check (funds>=0),
check (funds<=50000));


insert into account value(1,10000);
insert into account value(2,10000);

select * from account;


drop procedure if exists transfert;
delimiter $$
create procedure transfert(acc1 int, acc2 int , amount double)
begin
	declare exit handler for sqlexception
    begin
       rollback;
       select ("operation annulée");
    end;
	start transaction;
		update account set funds = funds + amount where account_number = acc2;
		update account set funds = funds - amount where account_number = acc1;
	commit; 
 
end $$
delimiter ;
use banque201;
call transfert (1,2,11000);
select * from account;
update account set funds = 10000;