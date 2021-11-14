-- Task 2

select * from accounts;
select * from customers;
select * from transactions;

/*
- A user is a person or thing that uses something such as a place, facility, product, or machine.
- A user privilege is a right to execute a particular type of SQL statement,
or a right to access another user's object.
- Roles, on the other hand, are created by users (usually administrators)
and are used to group together privileges or other roles.
They are a means of facilitating the granting of multiple privileges or roles to users.
*/

-- create accountant, administrator, support roles and grant appropriate privileges
create role accountant;
create role administrator;
create role support;

grant select on accounts to accountant;
grant all privileges on accounts, customers, transactions to administrator;
grant select, insert, update on accounts, customers, transactions to support;

-- create some users and assign them roles
create user Martin;
create user Jack;
create user Kevin;

grant accountant to Kevin;
grant administrator to Jack;
grant support to Martin;

-- give to some of them permission to grant roles to other users
grant accountant, support to Jack with admin option;

-- revoke some privilege from particular user
revoke admin option for accountant, support from Jack;