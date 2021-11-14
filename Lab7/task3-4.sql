-- Task 3. Add appropriate constraints

select * from accounts;
select * from customers;
select * from transactions;

-- check if transaction has same currency for source and destination accounts (use assertion)

-- add not null constraints
alter table accounts alter column currency set not null;
alter table customers alter column name set not null;
alter table transactions alter column date set not null;

-- Task 4. Change currency column type to user-defined in accounts table
create type currency_code as (code varchar(3));
alter table accounts alter column currency type currency_code using currency::varchar(3)::currency_code;