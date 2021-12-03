/*
5. Produce a CTE that can return the upward recommendation chain for any member.
   You should be able to select recommender from recommenders where member=x.
   Demonstrate it by getting the chains for members 12 and 22.
   Results table should have member and recommender, ordered by member ascending, recommender descending.
*/

create table members
(
    memid int,
    surname varchar(200) not null,
    firstname varchar(200) not null,
    address varchar(300),
    zipcode int,
    telephone varchar(20),
    recommendedby integer,
    joindate timestamp,
    primary key (memid)
);

create table booking
(
    facid int,
    memid int,
    starttime timestamp,
    slots int,
    primary key (facid, memid)
);

create table facilities
(
    facid int,
    name varchar(100) not null,
    membercost numeric,
    guestcost numeric,
    initialoutlay numeric,
    monthlymaintenance numeric,
    primary key (facid)
);

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
	where recs.member = 22 or recs.member = 12
order by recs.member asc, recs.recommender desc
