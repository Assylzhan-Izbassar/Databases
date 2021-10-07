-- Task 3

/* a. Find all students who have taken Comp. Sci. course and got an excellent
grade (i.e., A, or A-) and sort them alphabetically; */
select distinct(name), student.id from student
left join takes t on student.id = t.id
where dept_name = 'Comp. Sci.' and grade in ('A', 'A-')
order by name
asc;

/* b. Find all advisors of students who got grades lower than B on any class; */
-- select * from advisor;
-- select * from instructor;
-- select * from student;
-- select * from takes;

select distinct instructor.id, name, dept_name, salary from (select * from takes
left join advisor on advisor.s_id = takes.id
where grade not in ('B+', 'A-', 'A')) as subdata
left join instructor on instructor.id = subdata.i_id
where name is not null;

/* c. Find all departments whose students have never gotten an F or C grade; */
select distinct(dept_name) from student
left join takes t on student.id = t.id
where grade not in ('C', 'F');

/* d. Find all instructors who have never given an A grade in any of the courses
they taught; */
select distinct name from (
    select instructor.id, name, course_id, dept_name from instructor
        left join teaches t on instructor.id = t.id
                  ) as subinstructor
left join takes on takes.course_id = subinstructor.course_id
where grade != 'A';

/* e. Find all courses offered in the morning hours (i.e., courses ending before
13:00); */
-- select * from section;
-- select * from time_slot;
select * from course
where course_id in (
    select distinct course_id from section
        left join time_slot ts on section.time_slot_id = ts.time_slot_id
    where end_hr < 13);