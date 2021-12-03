create database lab8;

/*
Task 1
Create a function that:
*/

-- a. Increments given values by 1 and returns it.
create or replace function increment(num integer)
    returns integer as
$$
begin
    return num + 1;
end;
$$ language plpgsql;

select increment(5) as new_number;

-- b. Returns sum of 2 numbers.
create or replace function sum_of(st int, nd int)
returns integer as
$$
begin
    return st + nd;
end;
$$ language plpgsql;

select sum_of(5, 3) as sum_of_numbers;

-- c. Returns true or false if numbers are divisible by 2.
create or replace function is_even(x int)
returns boolean as
$$
begin
    if x % 2 = 0 then
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

select is_even(4) as is_even;

-- d. Checks some password for validity. ???
create or replace function validation(x varchar)
    returns boolean as
$$
begin
    if x.length > 8 then
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-- e. Returns two outputs, but has one input.
create or replace function pair_output(x int, out y int, out z int)
as
$$
begin
    y = x;
    z = x+1;
end;
$$ language plpgsql;

select pair_output(4);