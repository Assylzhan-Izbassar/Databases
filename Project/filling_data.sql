/* Filling the tables with data */

CREATE OR REPLACE FUNCTION random_between(low INT, high INT)
    RETURNS INT AS
$$
BEGIN
    RETURN floor(random() * (high - low + 1) + low);
END;
$$ language plpgsql STRICT;

create or replace function getRandomChar()
    returns varchar as
$$
begin
    return substr('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefggijklmnopqrstuvwxyz', floor(random() * 52 + 1)::int, 1);
end;
$$ language plpgsql strict;

create or replace function getRandomChar(len int)
    returns varchar as
$$
begin
    return substr('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefggijklmnopqrstuvwxyz', floor(random() * (52 - len) + 1)::int, len);
end;
$$ language plpgsql strict;

create or replace function getRandomChar(from_ int, to_ int)
    returns varchar as
$$
begin
    return substr('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefggijklmnopqrstuvwxyz', from_, to_);
end;
$$ language plpgsql strict;

-- setting of the packages table with random data
create or replace procedure setRandomData2Packages(n int)
    language plpgsql
as
$$
declare
    -- data
    t_id           varchar(8);
    t_destination  varchar(56);
    t_city         varchar(20);
    t_street       varchar(20);
    t_apartment    varchar(20);
    t_app_del_date timestamp;
    t_sent_time    timestamp;
    t_act_del_date timestamp;
    t_is_del       boolean;

    -- needed
    iteration      int;
    chk            int;

begin
    select 0 into iteration;

    while (iteration < n)
        loop
            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select concat(getRandomChar(), getRandomChar(floor(random() * 10 + 1)::int)) into t_destination;
            select concat(getRandomChar(), getRandomChar(floor(random() * 10 + 1)::int)) into t_city;
            select concat(getRandomChar(), getRandomChar(floor(random() * 10 + 1)::int)) into t_street;
            select concat(getRandomChar(), getRandomChar(floor(random() * 10 + 1)::int)) into t_apartment;

            select timestamp '2016-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2015-01-10 10:00:00')
            into t_sent_time;

            select timestamp '2016-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2018-01-10 10:00:00')
            into t_app_del_date;

            select timestamp '2016-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2018-01-10 10:00:00')
            into t_act_del_date;

            select random_between(0, 1) into t_is_del;

            select count(package_id)
            from packages
            where package_id = t_id
            into chk;

            if (chk = 0) then
                insert into packages
                values (t_id, t_destination, t_city, t_street, t_apartment, t_app_del_date, t_sent_time, t_act_del_date,
                        t_is_del);
            end if;
            select iteration + 1 into iteration;
        end loop;
end;
$$;

call setRandomData2Packages(30);
select *
from packages;

-- setting of the customers table with random data
create or replace procedure setRandomData2Customers(n int)
    language plpgsql
as
$$
declare
    -- data
    t_id          varchar(8);
    t_f_name      varchar(8);
    t_l_name      varchar(8);
    t_city        varchar(20);
    t_street      varchar(20);
    t_apartment   varchar(20);
    t_p_num       varchar(14);
    t_email       varchar(20);
    t_is_received boolean;

    -- needed
    iteration     int;
    chk           int;
begin

    select 0 into iteration;

    while (iteration < n)
        loop

            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select concat(getRandomChar(floor(random() * 8 + 1)::int, 1), getRandomChar(floor(random() * 5 + 1)::int))
            into t_f_name;
            select concat(getRandomChar(floor(random() * 8 + 1)::int, 1), getRandomChar(floor(random() * 5 + 1)::int))
            into t_l_name;
            select concat(getRandomChar(), getRandomChar(floor(random() * 10 + 1)::int)) into t_city;
            select concat(getRandomChar(), getRandomChar(floor(random() * 10 + 1)::int)) into t_street;
            select concat(getRandomChar(), getRandomChar(floor(random() * 10 + 1)::int)) into t_apartment;
            select concat(random_between(100000, 999999)) into t_p_num;
            select concat(getRandomChar(floor(random() * 10 + 1)::int), '@', getRandomChar(), 'mail.com') into t_email;
            select random_between(0, 1) into t_is_received;

            select count(customer_id)
            from customers
            where customer_id = t_id
            into chk;

            if (chk = 0) then
                insert into customers
                values (t_id, t_f_name, t_l_name, t_city, t_street, t_apartment, t_p_num, t_email, t_is_received);
            end if;
            select iteration + 1 into iteration;

        end loop;
end;
$$;

call setRandomData2Customers(25);
select *
from customers;

-- setting of the orders table with random data
create or replace procedure setRandomData2Orders(n int)
    language plpgsql
as
$$
declare

    -- data
    t_id       varchar(8);
    t_pid      varchar(8);
    t_cid      varchar(20);
    t_title    varchar(20);
    t_rec_name varchar(20);
    t_price    double precision;
    t_c_date   timestamp;

    -- needed
    iteration  int;
    chk        int;
begin

    select 0 into iteration;

    while (iteration < n)
        loop

            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select package_id from packages limit 1 offset random_between(1, 25) into t_pid;
            select customer_id from customers limit 1 offset random_between(1, 25) into t_cid;
            select concat(getRandomChar(), getRandomChar(floor(random() * 10 + 1)::int)) into t_title;
            select concat(getRandomChar(), getRandomChar(floor(random() * 10 + 1)::int)) into t_rec_name;
            select round(cast(random() * 10 + 1 as numeric), 2) into t_price;
            select timestamp '2016-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2018-01-10 10:00:00')
            into t_c_date;

            select count(order_id)
            from orders
            where order_id = t_id
            into chk;

            if (chk = 0) then
                insert into orders
                values (t_id, t_pid, t_cid, t_title, t_rec_name, t_price, t_c_date);
            end if;
            select iteration + 1 into iteration;

        end loop;
end;
$$;

call setRandomData2Orders(10);
select *
from orders;

-- setting of the invoices table with random data
create or replace procedure setRandomData2Invoices(n int)
    language plpgsql
as
$$
declare
    -- data
    t_id       varchar(8);
    t_cid      varchar(8);
    t_oid      varchar(20);
    t_inv_date timestamp;
    t_billed_t double precision;
    t_billed_a double precision;

    -- needed
    iteration  int;
    chk        int;
begin

    select 0 into iteration;

    while (iteration < n)
        loop

            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select customer_id from customers limit 1 offset random_between(1, 25) into t_cid;
            select order_id from orders limit 1 offset random_between(1, 25) into t_oid;
            select timestamp '2016-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2018-01-10 10:00:00')
            into t_inv_date;
            select round(cast(random() * 2 + 1 as numeric), 2) into t_billed_t;
            select round(cast(random() * 1 + 1 as numeric), 2) into t_billed_a;

            select count(invoice_id)
            from invoices
            where invoice_id = t_id
            into chk;

            if (chk = 0) then
                insert into invoices
                values (t_id, t_cid, t_oid, t_inv_date, t_billed_t, t_billed_a);
            end if;
            select iteration + 1 into iteration;

        end loop;
end;
$$;

call setRandomData2Invoices(27);
select *
from invoices;


-- setting of the debts table with random data
create or replace procedure setRandomData2Debts(n int)
    language plpgsql
as
$$
declare

    -- data
    t_id            varchar(8);
    t_iid           varchar(8);
    t_d_type        varchar(8);
    t_gen_date      timestamp;
    t_due_date      timestamp;
    t_finished_time timestamp;

    -- needed
    iteration       int;
    chk             int;
    rand            int;

begin

    select 0 into iteration;

    while (iteration < n)
        loop

            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select invoice_id from invoices limit 1 offset random_between(1, 25) into t_iid;

            select floor(random() * 3 + 1)::int into rand;

            if (rand = 1) then
                select 'monthly' into t_d_type;
            elseif (rand = 2) then
                select 'quarter' into t_d_type;
            else
                select 'year' into t_d_type;
            end if;

            select timestamp '2016-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2018-01-10 10:00:00')
            into t_gen_date;
            select timestamp '2016-01-10 20:00:00' +
                   random() * (timestamp '2016-01-20 20:00:00' -
                               timestamp '2016-01-10 10:00:00')
            into t_due_date;
            select timestamp '2020-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2018-01-10 10:00:00')
            into t_finished_time;

            select count(debt_id)
            from debts
            where debt_id = t_id
            into chk;

            if (chk = 0) then
                insert into debts
                values (t_id, t_iid, t_d_type, t_gen_date, t_due_date, t_finished_time);
            end if;
            select iteration + 1 into iteration;

        end loop;
end;
$$;

call setRandomData2Debts(29);
select *
from debts;

delete
from debts
where invoice_id is null;

-- setting of the contracts table with random data
create or replace procedure setRandomData2Contracts(n int)
    language plpgsql
as
$$
declare
    -- data
    t_id      varchar(8);
    t_did     varchar(8);
    t_title   varchar(20);
    t_subject varchar(20);
    t_ex_date timestamp;

    -- needed
    iteration int;
    chk       int;
begin

    select 0 into iteration;

    while (iteration < n)
        loop

            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select debt_id from debts limit 1 offset random_between(1, 25) into t_did;
            select concat(getRandomChar(), getRandomChar(floor(random() * 18 + 1)::int)) into t_title;
            select concat(getRandomChar(), getRandomChar(floor(random() * 18 + 1)::int)) into t_subject;
            select timestamp '2020-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2018-01-10 10:00:00')
            into t_ex_date;


            select count(contract_id)
            from contracts
            where contract_id = t_id
            into chk;

            if (chk = 0) then
                insert into contracts
                values (t_id, t_did, t_title, t_subject, t_ex_date);
            end if;
            select iteration + 1 into iteration;
        end loop;
end;
$$;

call setRandomData2Contracts(20);
select *
from contracts;

-- setting of the international shipments table with random data
create or replace procedure setRandomData2InterShipments(n int)
    language plpgsql
as
$$
declare

    -- data
    t_id            varchar(8);
    t_pid           varchar(8);
    t_country_name  varchar(20);
    t_inter_stamp   varchar(20);
    t_creation_date timestamp;

    -- needed
    iteration       int;
    chk             int;

begin

    select 0 into iteration;

    while (iteration < n)
        loop

            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select package_id from packages limit 1 offset random_between(1, 25) into t_pid;
            select concat(getRandomChar(), getRandomChar(floor(random() * 18 + 1)::int)) into t_country_name;
            select concat(getRandomChar(), getRandomChar(floor(random() * 5 + 1)::int)) into t_inter_stamp;
            select timestamp '2015-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2018-01-10 10:00:00')
            into t_creation_date;


            select count(shipment_id)
            from international_shipments
            where shipment_id = t_id
            into chk;

            if (chk = 0) then
                insert into international_shipments
                values (t_id, t_pid, t_country_name, t_inter_stamp, t_creation_date);
            end if;
            select iteration + 1 into iteration;
        end loop;

end;
$$;

call setRandomData2InterShipments(13);
select *
from international_shipments;

-- setting of the declarations table with random data
create or replace procedure setRandomData2Declarations(n int)
    language plpgsql
as
$$
declare

    -- data
    t_id              varchar(8);
    t_sid             varchar(8);
    t_title           varchar(20);
    t_package_content varchar(52);
    t_price           double precision;

    -- needed
    iteration         int;
    chk               int;

begin


    select 0 into iteration;

    while (iteration < n)
        loop

            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select shipment_id from international_shipments limit 1 offset random_between(1, 10) into t_sid;
            select concat(getRandomChar(), getRandomChar(floor(random() * 18 + 1)::int)) into t_title;
            select concat(getRandomChar(), getRandomChar(floor(random() * 28 + 1)::int)) into t_package_content;
            select round(cast(random() * 10 + 1 as numeric), 2) into t_price;


            select count(declaration_id)
            from declarations
            where declaration_id = t_id
            into chk;

            if (chk = 0) then
                insert into declarations
                values (t_id, t_sid, t_title, t_package_content, t_price);
            end if;
            select iteration + 1 into iteration;
        end loop;
end;
$$;

call setRandomData2Declarations(2);
select *
from declarations;

delete
from declarations
where shipment_id is null;

-- setting of the types table with random data
create or replace procedure setRandomData2Types(n int)
    language plpgsql
as
$$
declare
    -- data
    t_id         varchar(8);
    t_pid        varchar(8);
    t_i_type     varchar(20);
    t_wight      double precision;
    t_dimensions varchar(20);

    -- needed
    iteration    int;
    chk          int;
    rand_num     int;
begin

    select 0 into iteration;

    while (iteration < n)
        loop

            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select package_id from packages limit 1 offset random_between(1, 10) into t_pid;

            select floor(random() * 3 + 1)::int into rand_num;

            if (rand_num = 1) then
                select 'hazard' into t_i_type;
            elseif (rand_num = 2) then
                select 'postal' into t_i_type;
            else
                select 'normal' into t_i_type;
            end if;

            select round(cast(random() * 15 + 1 as numeric), 2) into t_wight;
            select concat(floor(random() * 18 + 1)::int, 'x', floor(random() * 18 + 1)::int, 'x',
                          floor(random() * 18 + 1)::int)
            into t_dimensions;


            select count(type_id)
            from types
            where type_id = t_id
            into chk;

            if (chk = 0) then
                insert into types
                values (t_id, t_pid, t_i_type, t_wight, t_dimensions);
            end if;
            select iteration + 1 into iteration;
        end loop;
end;
$$;

call setRandomData2Types(26);
select *
from types;

-- setting of the locations table with random data
create or replace procedure setRandomData2Locations(n int)
    language plpgsql
as
$$
declare

    -- data
    t_id       varchar(8);
    t_pid      varchar(8);
    t_lat      double precision;
    t_long     double precision;
    t_status   varchar(20);
    t_d_i_time timestamp;
    t_tid      varchar(8);
    t_plane_id varchar(8);
    t_wid      varchar(8);

    -- needed
    iteration  int;
    chk        int;
    rand_num   int;

begin

    select 0 into iteration;

    while (iteration < n)
        loop

            select concat(getRandomChar(), random_between(1000, 9999)) into t_id;
            select package_id from packages limit 1 offset random_between(1, 10) into t_pid;


            select round(cast(random() * (55 - 40 + 1) + 40 as numeric), 5) into t_lat;
            select round(cast(random() * (84 - 46 + 1) + 46 as numeric), 5) into t_long;

            select floor(random() * 3 + 1)::int into rand_num;

            if (rand_num = 1) then
                select 'delivered' into t_status;
            elseif (rand_num = 2) then
                select 'broken' into t_status;
            else
                select 'route' into t_status;
            end if;

            select timestamp '2018-01-10 20:00:00' +
                   random() * (timestamp '2020-01-20 20:00:00' -
                               timestamp '2017-01-10 10:00:00')
            into t_d_i_time;

            select null into t_tid;
            select null into t_plane_id;
            select null into t_wid;

            select floor(random() * 3 + 1)::int into rand_num;

            if (rand_num = 1) then
                select concat(random_between(1000, 9999)) into t_tid;
            elseif (rand_num = 2) then
                select concat(getRandomChar(), random_between(1000, 9999), getRandomChar()) into t_plane_id;
            else
                select concat(getRandomChar(), random_between(100, 999)) into t_wid;
            end if;


            select count(location_id)
            from locations
            where location_id = t_id
            into chk;

            if (chk = 0) then
                insert into locations
                values (t_id, t_pid, t_lat, t_long, t_status, t_d_i_time, t_tid, t_plane_id, t_wid);
            end if;
            select iteration + 1 into iteration;
        end loop;

end;
$$;

call setRandomData2Locations(8);
select *
from locations;