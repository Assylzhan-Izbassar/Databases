-- task 1

/*
DDL:
DDL is Data Definition Language which is used to define data structures.
It is used to create database schema and can be used to define some constraints as well.
It basically defines the column (Attributes) of the table.
It does not have any further classification.
Basic command present in DDL are CREATE, DROP, RENAME, ALTER etc.
DDL does not use WHERE clause in its statement.

For example:
1)
create table products (
    product_no integer,
    name text,
    price numeric default 9.99
);
2)
drop table if exists products
3)
alter table distributors
    add column address varchar(30);

DML:
DML is Data Manipulation Language which is used to manipulate data itself.
It is used to add, retrieve or update the data.
It add or update the row of the table. These rows are called as tuple.
It is further classified into Procedural and Non-Procedural DML.
BASIC command present in DML are UPDATE, INSERT, MERGE etc.
While DML uses WHERE clause in its statement.

For instance:
1)
insert into course
    values ('CS-437', 'Database Systems', 'Comp. Sci.', 4);
2)
insert into instructor
    select ID, name, dept_name, 18000
    from student
    where dept_name = 'Music' and total_cred > 144;
3)
update instructor
    set salary = salary * 1.05
    where salary < 70000;
4)
delete from instructor
    where dept name
    in (select dept name from department
        where building = 'Watson');

*/