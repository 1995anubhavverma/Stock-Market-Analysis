/* calling in the schema created to be used */
use assignment;

/* Importing all the tables by using the csv files */
/* forming the tables 'bajaj', 'Eicher', 'Hero', 'Infosys', 'TCS', 'TVS' from the csv files*/

/* creating table with the columns having the 20 days moving average and 50 days moving average  */

create table bajaj1 as 
select Date, `Close price` as Close_price, avg(`Close price`) over (order by date rows 20 preceding) as `20 Day MA`, avg(`Close price`) over (order by date rows 50 preceding) as `50 Day MA`
from bajaj;

select * 
from bajaj1;

/* bajaj1 table is created with the dates, close price and moving averages for 20 and 50 days refereing to the short term and long term moving averages */
create table Eicher1 as 
select Date, `Close price` as Close_price, avg(`Close price`) over (order by date rows 20 preceding) as `20 Day MA`, avg(`Close price`) over (order by date rows 50 preceding) as `50 Day MA`
from eicher;

create table Infosys1 as 
select Date, `Close price` as Close_price, avg(`Close price`) over (order by date rows 20 preceding) as `20 Day MA`, avg(`Close price`) over (order by date rows 50 preceding) as `50 Day MA`
from infosys;

create table Hero1 as 
select Date, `Close price` as Close_price, avg(`Close price`) over (order by date rows 20 preceding) as `20 Day MA`, avg(`Close price`) over (order by date rows 50 preceding) as `50 Day MA`
from hero;

create table TCS1 as 
select Date, `Close price` as Close_price, avg(`Close price`) over (order by date rows 20 preceding) as `20 Day MA`, avg(`Close price`) over (order by date rows 50 preceding) as `50 Day MA`
from tcs;

create table TVS1 as 
select Date, `Close price` as Close_price, avg(`Close price`) over (order by date rows 20 preceding) as `20 Day MA`, avg(`Close price`) over (order by date rows 50 preceding) as `50 Day MA`
from tvs;

/* Creating Master Table having the close price of each of the stocks as columns named after the stocks */
Create Table Master_tbl as
 select b.Date, b.`Close Price` as bajaj, e.`Close price` as Eicher, h.`Close price` as Hero, i.`Close price` as Infosys, tcs.`Close price` as TCS, tvs.`Close price` as TVS
 from bajaj b inner join eicher e on b.Date = e.Date
 inner join hero h on e.Date = h.Date
 inner join infosys i on h.Date = i.Date
 inner join tcs tcs on i.Date = tcs.Date
 inner join tvs tvs on tcs.Date = tvs.Date
 group by b.Date;
 
select *
from master_tbl;

/* Forming the tables with date, close price and the signals which indicates whether to buy, sell or hold onto the stocks by looking at the pattern. */
create table bajaj2 as 
select Date, Close_price, 
(case 
	when row_number() over(order by date) < 50 then 'NULL'
	when (`20 Day MA`) > (`50 Day MA` + 0.01*`50 Day MA`) then 'BUY'
    when (`20 Day MA` + 0.01*`20 Day MA`) < (`50 Day MA`) then 'SELL'
    else 'HOLD'
end) as `Signal`
from bajaj1;

select *
from bajaj2;

create table eicher2 as 
select Date, Close_price, 
(case 
	when row_number() over(order by date) < 50 then 'NULL'
	when (`20 Day MA`) > (`50 Day MA` + 0.01*`50 Day MA`) then 'BUY'
    when (`20 Day MA` + 0.01*`20 Day MA`) < (`50 Day MA`) then 'SELL'
    else 'HOLD'
end) as `Signal`
from eicher1;

create table hero2 as 
select Date, Close_price, 
(case 
	when row_number() over(order by date) < 50 then 'NULL'
    when (`20 Day MA`) > (`50 Day MA` + 0.01*`50 Day MA`) then 'BUY'
    when (`20 Day MA` + 0.01*`20 Day MA`) < (`50 Day MA`) then 'SELL'
    else 'HOLD'
end) as `Signal`
from hero1;

create table infosys2 as 
select Date, Close_price, 
(case 
	when row_number() over(order by date) < 50 then 'NULL'
    when (`20 Day MA`) > (`50 Day MA` + 0.01*`50 Day MA`) then 'BUY'
    when (`20 Day MA` + 0.01*`20 Day MA`) < (`50 Day MA`) then 'SELL'
    else 'HOLD'
end) as `Signal`
from infosys1;

create table TCS2 as 
select Date, Close_price, 
(case 
	when row_number() over(order by date) < 50 then 'NULL'
    when (`20 Day MA`) > (`50 Day MA` + 0.01*`50 Day MA`) then 'BUY'
    when (`20 Day MA` + 0.01*`20 Day MA`) < (`50 Day MA`) then 'SELL'
    else 'HOLD'
end) as `Signal`
from TCS1;

create table TVS2 as 
select Date, Close_price, 
(case 
	when row_number() over(order by date) < 50 then 'NULL'
    when (`20 Day MA`) > (`50 Day MA` + 0.01*`50 Day MA`) then 'BUY'
    when (`20 Day MA` + 0.01*`20 Day MA`) < (`50 Day MA`) then 'SELL'
    else 'HOLD'
end) as `Signal`
from TVS1;

/* Creating a user defined function 'signals' which takes date as input and gives out the 'signal' whether one should buy or sell the stocks. 
   Hold signal for when the short term and long term values are not crossing each other by significant values.*/
delimiter //
create function signals (dates datetime)
returns varchar(25) deterministic
begin
	declare verdict varchar(25);
	select `signal`
    into verdict
	from bajaj2
	where date = dates;
	return verdict;
end;
//
delimiter ;
/* using this function a date is taken as input and the signal for the 'bajaj auto' stocks is given out. */
