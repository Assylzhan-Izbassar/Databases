-- Task 2
/*
a. For each department, find the average salary of instructors in that
department and list them in ascending order. Assume that every
department has at least one instructor;
*/
select dept_name, avg(salary) as avg_salary
from instructor
group by dept_name
order by avg_salary
asc;

-- additional checking from the data
select dept_name, count(dept_name) as cnt_dept
from instructor
group by dept_name;

/* b. Find the building where the biggest number of courses takes place; */
select building, count(building) as cnt_build from section
group by building
having count(building) = (
    select max(cnt_build)
                        from (
                            select building, count(building) as cnt_build
                            from section
                            group by building)
                            as subsection
    );

/* c. Find the department with the lowest number of courses offered; */
select dept_name, count(dept_name) as cnt_dept
from course
group by dept_name
having count(dept_name) = (select min(cnt_dept)
    from (
         select dept_name, count(dept_name) as cnt_dept
         from course
         group by dept_name
         ) as subdeptartment);

/* d. Find the ID and name of each student who has taken more than 3 courses
from the Computer Science department; */
select id, name /*, dept_name, count(dept_name)*/
from student
where dept_name='Comp. Sci.'
group by dept_name, name, id
having count(dept_name) > 3;

/* e. Find all instructors who work either in Biology, Philosophy, or Music
departments; */
select *
from instructor
where dept_name
          in ('Biology', 'Philosophy', 'Music');

/* f. Find all instructors who taught in the 2018 year but not in the 2017 year; */
-- select * from instructor;
-- select * from teaches;
--
-- select *
-- from instructor
-- left join teaches t on instructor.id = t.id;

select * from instructor
where id in (select distinct instructor.id
    from instructor
    left join teaches t on instructor.id = t.id
    where year = 2018 and instructor.id not in (
        select id
        from teaches
        where year = 2017
    ));