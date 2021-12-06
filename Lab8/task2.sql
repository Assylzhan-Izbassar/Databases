/* 2. Create a trigger that: */

-- a. Return timestamp of the occurred action within the database.
create or replace function timestamp_exc()
    returns trigger as
$$
begin
    select now();
end;
$$;

create trigger timestamp_trg
    after insert or update or delete
    on employee
    for each row
execute procedure timestamp_exc();

-- b. Computes the age of a person when persons’ date of birth is inserted.

drop table employee_audit;

create table employee_audit
(
    id          int generated always as identity,
    employee_id int         not null,
    name        varchar(20) not null,
    age         int         not null,
    primary key (id)
);

create or replace function trigger_age()
    returns trigger
    language plpgsql
as
$$
begin
    insert into employee_audit(employee_id, name, age)
    values (new.id, new.name, floor(extract(days from now() - new.date_of_birth) / 365));

    return new;
end;
$$;

create trigger when_birth_inserted
    after insert
    on employee
    for each row
execute procedure trigger_age();

select *
from employee;

insert into employee
values (7, 'Henry', '1994-12-05', 28, 4000, 6, 0);

select *
from employee_audit;

-- c. Adds 12% tax on the price of the inserted item.
create table order_details
(
    order_id   int,
    product_id int,
    price      double precision,
    quantity   int,
    discount   double precision,
    primary key (order_id, product_id)
);

create function add_12(o_id int, p_id int)
    language plpgsql
as
$$
begin
    update order_details
    set price = price + price * 0.12
    where order_id = o_id
      and product_id = p_id;
end;
$$;

create trigger add_12_trg
    after insert
    on order_details
    referencing new row as nrow
    for each row
execute procedure add_12(nrow.order_id, nrow.product_id);

-- d. Prevents deletion of any row from only one table.
create function not_delete()
    returns trigger
    language plpgsql
as
$$
begin
    raise exception;
end;
$$;

create trigger undo_delete
    before delete
    on employee
    for each row
execute procedure not_delete();

-- e. Launches functions 1.d and 1.e.

-- Task 1 / d. Checks some password for validity.
create or replace function validation(x varchar)
    returns boolean as
$$
begin
    if length(x) >= 8 and x = initcap(x) then
        return true;
    else
        return false;
    end if;
end
$$ language plpgsql;

-- Task 1 / e. Returns two outputs, but has one input.
create or replace function pair_output(x int, out y int, out z int)
as
$$
begin
    y = x;
    z = x + 1;
end;
$$ language plpgsql;


create or replace function call_2f(for_first varchar, for_sec int)
    returns trigger as
$$
begin
    select validation(for_first);
    select pair_output(for_sec);
end;
$$;

create trigger call_2f_trg
    after insert or update or delete
    on employee
    for each row
execute procedure call_2f();