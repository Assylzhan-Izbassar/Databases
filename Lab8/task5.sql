/*
5. Produce a CTE that can return the upward recommendation chain for any member.
   You should be able to select recommender from recommenders where member=x.
   Demonstrate it by getting the chains for members 12 and 22.
   Results table should have member and recommender, ordered by member ascending, recommender descending.
*/

create table members
(
    memid         int,
    surname       varchar(200) not null,
    firstname     varchar(200) not null,
    address       varchar(300),
    zipcode       int,
    telephone     varchar(20),
    recommendedby integer,
    joindate      timestamp,
    primary key (memid)
);

create table booking
(
    facid     int,
    memid     int,
    starttime timestamp,
    slots     int,
    primary key (facid, memid)
);

create table facilities
(
    facid              int,
    name               varchar(100) not null,
    membercost         numeric,
    guestcost          numeric,
    initialoutlay      numeric,
    monthlymaintenance numeric,
    primary key (facid)
);

insert into members
values (1, 'M1', 'SM1', 'A1', 0, '123', NULL, '2016-02-02'),
       (2, 'M2', 'SM2', 'A2', 4321, '133', NULL, '2016-03-01'),
       (3, 'M3', 'SM3', 'A3', 4321, '132', 6, '2012-07-02'),
       (4, 'M4', 'SM4', 'A4', 23423, '122', 3, '2012-07-03'),
       (5, 'M5', 'SM5', 'A5', 234, '142', 1, '2012-07-01'),
       (6, 'M6', 'SM6', 'A6', 56754, '145', 1, '2012-07-09'),
       (7, 'M7', 'SM7', 'A7', 45678, '143', 22, '2012-07-15'),
       (8, 'M8', 'SM8', 'A8', 45678, '149', 12, '2012-01-25'),
       (9, 'M9', 'SM9', 'A9', 45678, '148', NULL, '2012-11-03'),
       (10, 'M10', 'SM10', 'A10', 45678, '153', NULL, '2012-05-21'),
       (11, 'M11', 'SM11', 'A11', 45678, '143', NULL, '2012-07-15'),
       (12, 'M12', 'SM12', 'A12', 45678, '156', 4, '2012-09-02'),
       (13, 'M13', 'SM13', 'A13', 45678, '134', NULL, '2012-02-01'),
       (14, 'M14', 'SM14', 'A14', 45678, '131', NULL, '2012-10-06'),
       (15, 'M15', 'SM15', 'A15', 45678, '128', NULL, '2012-07-19'),
       (16, 'M16', 'SM16', 'A16', 45678, '147', NULL, '2012-03-22'),
       (22, 'M22', 'SM22', 'A22', 45678, '139', 4, '2012-04-28');

with recursive recommenders(recommender, member) as (
    select recommendedby, memid
    from members
    union all
    select mems.recommendedby, recs.member
    from recommenders recs
             inner join members mems
                        on mems.memid = recs.recommender
)

select recs.member member, recs.recommender, mems.firstname, mems.surname
from recommenders recs
         inner join members mems
                    on recs.recommender = mems.memid
where recs.member = 22
   or recs.member = 12
order by recs.member asc, recs.recommender desc

