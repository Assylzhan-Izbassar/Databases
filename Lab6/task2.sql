/* 2. Create following views: */

/* a. count the number of unique clients, compute average
   and total purchase amount of client orders by each date. */
drop view IF EXISTS charge_earned;

create or replace view client_view as
select count(distinct (name)) as num_of_uniq_clients,
       avg(amount)            as avg_amount,
       sum(amount)            as total_amount,
       s.date                 as date
from client as c
         left join sell s on c.id = s.client_id
group by s.date
order by s.date;

select num_of_uniq_clients, avg_amount, total_amount
from client_view;

/* b. find top 5 dates with the greatest total sell amount */
create view date_tot_sell as
select sum(amount) as total_sell, date
from sell
group by date
order by total_sell desc;

select date, total_sell
from date_tot_sell
limit 5;

/* c. count the number of sales, compute average and total amount
   of all sales of each dealer */
create view dealer_info as
select count(id)   as num_sales,
       avg(amount) as avg_amt,
       sum(amount) as tot_amt,
       dealer_id
from sell
group by dealer_id;

select num_sales, avg_amt, tot_amt, name
from dealer_info as di
         inner join dealer d on d.id = di.dealer_id;

/* d. compute how much all dealers
   earned from charge(total sell amount * charge) in each location */
create or replace view charge_earned as
select sum(earned) as all_earnings
from (select d.id as id, name, location, charge, amount, charge * amount as earned
      from dealer as d
               inner join sell as s on s.dealer_id = d.id) as dealer_sell
group by location;

select *
from charge_earned;

/* e. compute number of sales,
   average and total amount of all sales dealers made in each location */
create or replace view sale_by_loc as
select count(s.id) as num_sales, avg(amount) as avg_amt, sum(amount) as tot_amt
from sell as s
         inner join dealer d on s.dealer_id = d.id
group by location;

select *
from sale_by_loc;

/* f. compute number of sales,
   average and total amount of expenses in each city clients made. */
create view client_purchase as
select count(s.id) as num_of_sale, avg(amount) as avg_exps, sum(amount) as tot_exps, city
from client as c
         inner join sell s on c.id = s.client_id
group by city;

select *
from client_purchase;

/* g. find cities where total expenses more than total amount of sales in locations */
select distinct(city) from client_purchase as cp, sale_by_loc as sl
where cp.tot_exps > sl.tot_amt;