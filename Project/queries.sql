/*
    Queries.
Assume truck 1721 is destroyed in a crash.
*/
select * from customers;
select * from orders;
select * from packages;
select * from locations;

-- * Find all customers who had a package on that truck at the time of the crash.

select distinct first_name, last_name from customers as c
left join orders o on c.customer_id = o.customer_id
left join packages p on o.package_id = p.package_id
left outer join locations l on p.package_id = l.package_id
where l.truck_id = '1721' and status = 'broken' and l.package_id is not null;

-- Find all recipients who had a package on that truck at the time of the crash.
select distinct o.receiver_name from customers as c
left join orders o on c.customer_id = o.customer_id
left join packages p on o.package_id = p.package_id
left outer join locations l on p.package_id = l.package_id
where l.truck_id = '1721' and status = 'broken' and l.package_id is not null;

-- Find the last successful delivery by that truck prior to the crash.
select *
from locations
where truck_id = '1721' and status = 'delivered' and package_id is not null
order by date_in_time desc
limit 1;

-- * Find the customer who has shipped the most packages in the past year.
select t.customer_id, first_name, last_name from (select count(c.customer_id) as number, c.customer_id from customers as c
left join orders o on c.customer_id = o.customer_id
where extract(year from creation_date) = 2018
group by c.customer_id, extract(year from creation_date)
order by number
limit 1) as t, customers
where customers.customer_id = t.customer_id;

-- * Find the street with the most customers.
select count(street) as count, street from customers
group by street
order by count
limit 1;

-- * Find those packages that were not delivered within the promised time.
select * from packages
where actual_delivery_date > packages.approximate_delivery_date and is_delivered = true;

/*
Generate the bill for each customer for the past month.
Consider creating several types of bills.
*/

-- A simple bill: customer, address, and amount owed.
select * from orders;
select * from invoices;
select * from debts;

select first_name, last_name, city, street, apartment, (price+i.billed_taxes+i.billed_amount) / (12*(extract(year from finished_time) - extract(year from generated_date))) as amount from invoices as i
left join orders o on i.order_id = o.order_id
left join debts d on i.invoice_id = d.invoice_id
left join customers c on c.customer_id = i.customer_id
where finished_time > generated_date;

-- A bill listing charges by type of service.
select first_name, last_name, city, street, apartment, price from invoices as i
left join orders o on i.order_id = o.order_id
left join debts d on i.invoice_id = d.invoice_id
left join customers c on c.customer_id = i.customer_id
where finished_time > generated_date;

-- An itemize billing listing each individual shipment and the charges for it.
select first_name, last_name, city, street, apartment, billed_taxes, billed_amount from invoices as i
left join orders o on i.order_id = o.order_id
left join debts d on i.invoice_id = d.invoice_id
left join customers c on c.customer_id = i.customer_id
where finished_time > generated_date;

-- // ADDING INDEX
create index customer_ind on customers(city);