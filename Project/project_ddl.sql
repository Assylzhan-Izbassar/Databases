create database package_delivery_company;

drop table customers;
drop table orders;
drop table packages;
drop table international_shipments;
drop table declarations;
drop table types;
drop table locations;
drop table invoices;
drop table debts;
drop table contracts;

/* Package side */
-- creating package table
create table packages
(
    package_id          varchar(8),
    destination         varchar(56),
    city varchar(20),
    street varchar(20),
    apartment varchar(20),
    approximate_delivery_date timestamp,
    sent_time           timestamp,
    actual_delivery_date timestamp,
    is_delivered boolean,
    primary key (package_id)
);

-- creating type table
create table types
(
    type_id    varchar(8),
    package_id varchar(8),
    item_type  varchar(20),
    wight      double precision,
    dimensions varchar(20),
    primary key (type_id),
    foreign key (package_id) references package
        on delete cascade
);

-- creating international shipment table
create table international_shipments
(
    shipment_id varchar(8),
    package_id varchar(8),
    country_name varchar(20),
    international_stamp varchar(20),
    creation_date timestamp,
    primary key (shipment_id),
    foreign key (package_id) references package
        on delete set null
);

-- creating declaration table
create table declarations
(
    declaration_id varchar(8),
    shipment_id varchar(8),
    title varchar(20),
    package_content varchar(52),
    price double precision,
    primary key (declaration_id),
    foreign key (shipment_id) references international_shipment
        on delete cascade
);

/* Customer side */

-- creating customer table
create table customers
(
    customer_id varchar(8),
    order_id varchar(8),
    first_name varchar(20),
    last_name varchar(20),
    city varchar(20),
    street varchar(20),
    apartment varchar(20),
    phone_number varchar(14),
    email varchar(20),
    is_received boolean,
    primary key (customer_id),
    foreign key (order_id) references orders
        on delete set null
);

/* Order side */
-- creating order table
create table orders
(
    order_id varchar(8),
    package_id varchar(8),
    customer_id varchar(8),
    title varchar(20),
    receiver_name varchar(20),
    price double precision,
    creation_date timestamp,
    primary key (order_id, package_id)
);

-- creating invoice table
create table invoices
(
    invoice_id varchar(8),
    customer_id varchar(8),
    order_id varchar(8),
    invoice_date timestamp,
    billed_taxes double precision,
    billed_amount double precision,
    primary key (invoice_id),
    foreign key (customer_id) references customers
        on delete cascade
);

-- creating debt table
create table debts
(
    debt_id varchar(8),
    invoice_id varchar(8),
    debt_type varchar(8),
    generated_date timestamp,
    due_date timestamp,
    finished_time timestamp,
    primary key (debt_id),
    foreign key (invoice_id) references debt
        on delete cascade
);

-- creating contract table
create table contracts
(
    contract_id varchar(8),
    debt_id varchar(8),
    title varchar(20),
    subject varchar(20),
    expiration_date timestamp,
    primary key (contract_id),
    foreign key (debt_id) references debt
        on delete cascade
);

/* Location side */
-- creating location table
create table locations
(
    location_id varchar(8),
    package_id varchar(8),
    latitude double precision,
    longitude double precision,
    status varchar(20),
    date_in_time timestamp,
    truck_id varchar(8),
    plan_id varchar(8),
    warehouse_code varchar(8),
    primary key (package_id),
    foreign key (package_id) references package
        on delete cascade
);