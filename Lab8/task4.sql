/* Task 4. Create procedures that: */

drop table employee;

create table employee
(
    id              int,
    name            varchar(20) not null,
    date_of_birth   date,
    age             int check ( age >= 18 and age <= 63 ),
    salary          int,
    work_experience int check ( work_experience <= 60 ),
    discount        int check ( discount >= 0 ),
    primary key (id)
);

insert into employee
values (1, 'John', '1996-12-31', 25, 3000, 5, 5);
insert into employee
values (2, 'Mike', '1990-05-12', 31, 2000, 4, 5);
insert into employee
values (3, 'Alex', '1995-04-03', 26, 1500, 3, 2);
insert into employee
values (4, 'Tim', '2002-12-31', 19, 900, 1, 0);
insert into employee
values (5, 'Dick', '1998-06-29', 23, 1200, 2, 0);

select *
from employee;

/*
a) Increases salary by 10% for every 2 years of work experience and provides
10% discount and after 5 years adds 1% to the discount.
*/

create or replace procedure inc_salary_discount()
    language plpgsql
as
$$
begin
    update employee
    set salary   = salary + salary * (work_experience / 2) * 0.1,
        discount = 10
    where work_experience >= 2;

    update employee
    set discount = discount + 1
    where work_experience >= 5;
end;
$$;

begin;
call inc_salary_discount();
select * from employee;
rollback;
select * from employee;

/*
b) After reaching 40 years, increase salary by 15%. If work experience is more
than 8 years, increase salary for 15% of the already increased value for work experience
and provide a constant 20% discount.
*/

create or replace procedure after_40()
    language plpgsql
as
$$
begin
    update employee
    set salary = salary + employee.salary * 0.15
    where age >= 40;

    update employee
    set salary   = salary + employee.salary * 0.15,
        discount = 20
    where work_experience >= 8;
end;
$$;

insert into employee
values (6, 'Sam', '1982-06-29', 39, 4000, 10, 10);

select *
from employee;

begin;
call after_40();
select * from employee;
commit;