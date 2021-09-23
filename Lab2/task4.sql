-- task 4

-- examples with insertion
-- 1)
insert into customers
    values (
            1,
            'Henry Jackson',
            now(),
            'Washington st.,4A'
           );
-- 2)
insert into customers(id, full_name, timestamp, delivery_address)
    values (
            2,
            'Micheal Grayson',
            now(),
            'Atlanta state, 5B'
           );
-- 3)
insert into products(id, name, description, price)
    values (
            2,
            'iPhone 13',
            'the greatest iPhone ever',
            799.0
           );
-- 4)
insert into products(id, name, description, price)
    values (
            2,
            'iPhone 12',
            'the second greatest iPhone ever',
            699.01
           );

-- 5)
insert into orders(code, customer_id, total_sum, is_paid)
    values (
            1,
            2,
            1,
            true
           );

-- 6)
insert into order_item(order_code, product_id, quantity)
    values (
            1,
            1,
            3
           );

-- examples with update
-- 1)
update customers
    set full_name = 'Micheal Grayson Jr.'
    where full_name = 'Micheal Grayson';

-- 2)
update orders
    set total_sum = (select products.price*order_item.quantity
                    from products, order_item, orders
                    where order_item.product_id = products.id
                    and order_item.order_code = orders.code)
    where total_sum != (select products.price*order_item.quantity
                    from products, order_item, orders
                    where order_item.product_id = products.id
                    and order_item.order_code = orders.code);
-- 3)
update products
    set price = price * 1.10
    where price < 700;

-- examples with delete
-- 1)
delete from order_item;

-- 2)
delete from products
    where id = '1';

-- 3)
delete from customers
    where id != (select customer_id from orders);

select * from customers;
select * from products;
select * from orders;