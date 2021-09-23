-- task 3
create table students
(
    student_id integer primary key,
    full_name  varchar(50) not null check (length(full_name) > 3),
    birth_date date not null,
    gender varchar(6) not null check (gender = 'male' or gender = 'female'),
    average_grade double precision default (0.0),
    info_of_stud text,
    is_need_dormitory boolean default (false)
);

create table instructors
(
    instructor_id integer primary key,
    full_name varchar(50) not null check ( length(full_name) > 3 ),
    speaking_languages text,
    work_experience integer check(work_experience > 0),
    is_having_remote_lessons boolean default (false)
);

create table lesson_participants
(
    lesson_title varchar(30) primary key check ( length(lesson_title) > 3 ),
    teaching_instructor integer references instructors(instructor_id) on delete restrict,
    student_id integer references students(student_id),
    room_number numeric(5)
);

