/* 1. Write a SQL query using Joins: */

-- a. combine each row of dealer table with each row of client table
select * from dealer
inner join client c on dealer.id = c.dealer_id;

-- b. find all dealers along with client name, city, grade, sell number, date, and amount
select ds.id, ds.name, location, charge, c.name as client_name, city, priority as grade, sell_number, date, amount from (select d.id, name, location, charge, s.id as sell_number, date, amount, client_id
from dealer as d
left join sell as s on d.id = s.dealer_id) as ds
left join client as c on c.id = ds.client_id;

-- c. find the dealer and client who belongs to same city
select * from dealer as d
inner join client as c on d.id = c.dealer_id
where d.location = c.city;

/* d. find sell id, amount, client name, city those sells
   where sell amount exists between 100 and 500 */
select s.id as sell_id, amount, name as client_name, city from sell as s
left join client as c on s.client_id = c.id
where amount >= 100 and amount <= 500;

/* e. find dealers who works either for one or more client
   or not yet join under any of the clients */
select * from dealer
full outer join client c on dealer.id = c.dealer_id;

/* f. find the dealers and the clients he service,
   return client name, city, dealer name, commission. */
select c.name as client_name, city, d.name as dealer_name, charge as commission from dealer as d
inner join client as c on d.id = c.dealer_id;

/* g. find client name, client city, dealer, commission
   those dealers who received a commission from the sell more than 12% */
select c.name as client_name, city as client_city, d.name as dealer, charge as commission from dealer as d
inner join client as c on d.id = c.dealer_id
where charge > 0.12;

/* h. make a report with client name, city, sell id, sell date, sell amount, dealer name
   and commission to find that either any of the existing clients haven’t made
   a purchase(sell) or made one or more purchase(sell) by their dealer or by own. */
select client_name, city, sell_id, sell_date, sell_amount, name as dealer_name, charge as commission
from (
    select name as client_name, city, s.id as sell_id, date as sell_date,
           amount as sell_amount, c.dealer_id from client as c
           full outer join sell as s on c.id = s.client_id
    ) as cs
full outer join dealer as d on cs.dealer_id = d.id;

/* i. find dealers who either work for one or more clients.
   The client may have made, either one or more purchases,
   or purchase amount above 2000 and must have a grade,
   or he may not have made any purchase to the associated dealer.
   Print client name, client grade, dealer name, sell id, sell amount
*/
select c.name as client_name, c.priority as client_grade, d.name as dealer_name,
       s.id as sell_id, s.amount as sell_amount from dealer as d
left join client c on d.id = c.dealer_id
left join sell s on c.id = s.client_id
where s.amount > 2000 and c.priority is not null;