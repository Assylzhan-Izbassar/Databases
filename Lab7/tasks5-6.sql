-- Task 5. Create indexes:

-- index so that each customer can only have one account of one currency
create unique index cust_curr_index on accounts (customer_id, currency);
-- index for searching transactions by currency and balance
create index curr_bal_index on accounts (currency, balance);

-- Task 6. Write a SQL transaction that illustrates money transaction from one account to another:
create or replace procedure money_transaction2(sender varchar,
                                               receiver varchar, amount double precision)
    language plpgsql
as
$$
declare
    transaction_id int;
    after_balance double precision;
    acc_limit double precision;
begin
    select id+1 into transaction_id from transactions order by id desc limit 1;
    select "limit" into acc_limit from accounts where account_id = sender;

    /* create transaction with “init” status */
    insert into transactions
    values (transaction_id, now(), sender, receiver, amount, 'init');

    /* increase balance for destination account and decrease for source account */
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
        /* update transaction with appropriate status(commit or rollback) */
        rollback;
        insert into transactions values (transaction_id, now(), sender, receiver, amount, 'rollback');
    else
        update transactions set status = 'committed' where id = transaction_id;
        commit;
    end if;
end
$$;

begin;
update accounts
set balance = balance + 300
where account_id = 'RS88012';
select *
from accounts;
rollback;

select *
from accounts;
select *
from transactions;

call money_transaction2('RS88012', 'NT10204', 3700);
call money_transaction2('NT10204', 'RS88012', 300);

call money_transaction2('AB10203', 'NK90123', 300);

begin;
delete from transactions
where amount = 300 and status = 'init';
delete from transactions
where id = 6;
select * from transactions;
commit;

