-- create a database for lab 2
create database lab2;

-- task 2
create table customers (
    id                  integer primary key,
    full_name           varchar(50) not null,
    timestamp           timestamp not null,
    delivery_address    text not null
);

create table orders (
    code        integer primary key,
    customer_id integer references customers(id),
    total_sum   double precision not null check ( total_sum > 0 ),
    is_paid     boolean not null
);

create table products (
    id      varchar primary key,
    name    varchar unique not null,
    description     text,
    price   double precision not null check ( price > 0 )
);

create table order_items (
    order_code  integer references orders(code) on delete cascade,
    product_id  varchar references products(id) on delete restrict,
    quantity    integer not null check ( quantity > 0 ),
    primary key (order_code, product_id)
);

drop table if exists customers;

drop table if exists orders;

drop table if exists products;

drop table if exists order_item;

select * from customers;