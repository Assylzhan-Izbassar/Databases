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
    package_id                varchar(8),
    destination               varchar(56),
    city                      varchar(20) not null,
    street                    varchar(20) not null,
    apartment                 varchar(20),
    approximate_delivery_date timestamp not null,
    sent_time                 timestamp not null,
    actual_delivery_date      timestamp,
    is_delivered              boolean not null,
    primary key (package_id)
);

-- creating type table
create table types
(
    type_id    varchar(8),
    package_id varchar(8),
    item_type  varchar(20),
    wight      double precision not null,
    dimensions varchar(20),
    primary key (type_id),
    foreign key (package_id) references packages
        on delete cascade
);

-- creating international shipment table
create table international_shipments
(
    shipment_id         varchar(8),
    package_id          varchar(8),
    country_name        varchar(20) not null,
    international_stamp varchar(20),
    creation_date       timestamp not null,
    primary key (shipment_id),
    foreign key (package_id) references packages
        on delete set null
);

-- creating declaration table
create table declarations
(
    declaration_id  varchar(8),
    shipment_id     varchar(8),
    title           varchar(20) not null,
    package_content varchar(52),
    price           double precision check ( price > 0.0 ),
    primary key (declaration_id),
    foreign key (shipment_id) references international_shipments
        on delete cascade
);

/* Customer side */

-- creating customer table
create table customers
(
    customer_id  varchar(8),
    first_name   varchar(20) not null,
    last_name    varchar(20),
    city         varchar(20),
    street       varchar(20),
    apartment    varchar(20),
    phone_number varchar(14) not null,
    email        varchar(20),
    is_received  boolean not null,
    primary key (customer_id)
);

-- creating order table
create table orders
(
    order_id      varchar(8),
    package_id    varchar(8),
    customer_id   varchar(8),
    title         varchar(20) not null,
    receiver_name varchar(20),
    price         double precision check ( price > 0.0 ),
    creation_date timestamp,
    primary key (order_id, package_id),
    foreign key (customer_id) references customers
        on delete cascade,
    foreign key (package_id) references packages
        on delete cascade
);


-- creating invoice table
create table invoices
(
    invoice_id    varchar(8),
    customer_id   varchar(8),
    order_id      varchar(8),
    invoice_date  timestamp not null,
    billed_taxes  double precision check ( billed_taxes >= 0.0 ),
    billed_amount double precision check ( billed_amount >= 0.0 ),
    primary key (invoice_id),
    foreign key (customer_id) references customers
        on delete cascade
);

-- creating debt table
create table debts
(
    debt_id        varchar(8),
    invoice_id     varchar(8),
    debt_type      varchar(8) not null,
    generated_date timestamp not null,
    due_date       timestamp,
    finished_time  timestamp check ( finished_time > debts.generated_date ),
    primary key (debt_id),
    foreign key (invoice_id) references invoices
        on delete cascade
);

-- creating contract table
create table contracts
(
    contract_id     varchar(8),
    debt_id         varchar(8),
    title           varchar(20),
    subject         varchar(20),
    expiration_date timestamp,
    primary key (contract_id),
    foreign key (debt_id) references debts
        on delete cascade
);

/* Location side */
-- creating location table
create table locations
(
    location_id    varchar(8),
    package_id     varchar(8),
    latitude       double precision,
    longitude      double precision,
    status         varchar(20) not null,
    date_in_time   timestamp,
    truck_id       varchar(8),
    plan_id        varchar(8),
    warehouse_code varchar(8),
    primary key (location_id),
    foreign key (package_id) references packages
        on delete cascade
);