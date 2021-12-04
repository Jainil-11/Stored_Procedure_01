create or replace procedure book_taxi
(userid DECIMAL(5,0),modelno VARCHAR(10),picloc VARCHAR(50),offerid VARCHAR(6)) 
as $BODY$
declare
t_book DECIMAL(8);
t_billno DECIMAL(8);
t_regno VARCHAR(10);
t_driverid DECIMAL(4,0);
begin
select max(bill_no)+1 into t_billno from bill_detail;
select max(booking_id)+1 into t_book from ride;
begin
select reg_no into t_regno from taxi where status='True' and model_no=modelno;
If not found then
	raise exception 'No Taxi Found';
	end if;
select driver_id into t_driverid from driver where status='True';
If not found then
	raise exception 'No driver found';
	end if;
end;

begin
insert into ride values(t_book,CURRENT_TIME,NULL,picloc,NULL,CURRENT_DATE,null,userid,t_driverid,offerid,t_regno);
insert into bill_detail values(t_billno,NULL,NULL,NULL,NULL,NULL,NULL,t_book);
exception
 when foreign_key_violation then
 	raise exception 'Foreign key constraint violated';
end;
update driver set status='False' where driver_id=t_driverid;
update taxi set status='False' where reg_no=t_regno;

end $BODY$ LANGUAGE 'plpgsql';
