-- Task 3. Add appropriate constraints

select * from accounts;
select * from customers;
select * from transactions;

-- check if transaction has same currency for source and destination accounts (use assertion)

create or replace procedure money_transfer(sender varchar,
                                               receiver varchar, amount double precision)
    language plpgsql
as
$$
declare
    after_balance double precision;
    acc_limit double precision;
    sender_currency varchar(3);
    receiver_currency varchar(3);
begin
    select "limit" into acc_limit from accounts where account_id = sender;
    select currency into sender_currency from accounts where account_id = sender;
    select currency into receiver_currency from accounts where account_id = receiver;

    -- checking the currencies
    assert sender_currency = receiver_currency, 'sender and receiver have not equal currencies.';

    -- adding the amount to the receiver's account
    update accounts
    set balance = balance + amount
    where account_id = receiver;

    -- subtracting the amount from the sender's account
    update accounts
    set balance = balance - amount
    where account_id = sender;

    select balance into after_balance from accounts where account_id = sender;

    /* if in source account balance becomes below limit, then make rollback */
    if(after_balance < acc_limit) then
        rollback;
    else
        commit;
    end if;
end
$$;

call money_transfer('AB10203', 'DK12000', 200);

-- add not null constraints
alter table accounts alter column currency set not null;
alter table customers alter column name set not null;
alter table transactions alter column date set not null;

-- Task 4. Change currency column type to user-defined in accounts table
alter table accounts drop column user_type_currency;
select * from accounts;

begin;
create type currency_code as (code varchar(3));
alter table accounts add column user_type_currency currency_code;
select * from accounts;
update accounts set user_type_currency.code = currency where account_id = account_id;
select * from accounts;
alter table accounts drop column currency;
select * from accounts;
rollback;

select * from accounts;