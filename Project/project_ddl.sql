create database package_delivery_company;

-- creating address as composite type
create type address as
(
    country   varchar,
    city      varchar,
    street    varchar,
    apartment varchar
);

-- creating company table
create table company
(
    company_id  varchar(8),
    name        varchar,
    description varchar,
    address     address,
    primary key (company_id)
);

/* Package side */
-- creating package table
create table package
(
    package_id          varchar(8),
    destination         varchar(56),
    address             address,
    final_delivery_date timestamp,
    sent_time           timestamp,
    primary key (package_id)
);

-- creating delivery status table
create table delivery_status
(
    package_id   varchar(8),
    description  varchar(20),
    updated_time timestamp,
    is_delivered boolean,
    primary key (package_id, description)
);

-- creating type table
create table type
(
    type_id    varchar(8),
    package_id varchar(8),
    item_type  varchar(20),
    wight      double precision,
    dimensions varchar, -- needs to be modified
    primary key (type_id),
    foreign key (package_id) references package
        on delete cascade
);

-- creating international shipment table
create table international_shipment
(
    shipment_id varchar(8),
    package_id varchar(8),
    international_stamp varchar(20),
    creation_date timestamp,
    primary key (shipment_id),
    foreign key (package_id) references package
        on delete set null
);

-- creating declaration table
create table declaration
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
-- creating name as composite type
create type name as
(
    first_name varchar(16),
    last_name varchar(16)
);

-- creating customer table
create table customers
(
    customer_id varchar(8),
    order_id varchar(8),
    name name,
    address address,
    phone_number varchar(14),
    email varchar(20),
    is_receiver boolean,
    is_sender boolean,
    primary key (customer_id),
    foreign key (order_id) references orders
        on delete set null
);

-- creating customer status table
create table customer_status
(
    status_id varchar(8),
    customer_id varchar(8),
    is_received boolean,
    rating int, -- needed to modified
    primary key (status_id),
    foreign key (customer_id) references customers
        on delete cascade
);

/* Order side */
-- creating order table
create table orders
(
    order_id varchar(8),
    package_id varchar(8),
    title varchar(20),
    description varchar(200),
    price double precision,
    creation_date timestamp,
    primary key (order_id, package_id)
);

-- creating invoice table
create table invoice
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
create table debt
(
    debt_id varchar(8),
    invoice_id varchar(8),
    debt_type varchar(8),
    generated_date timestamp,
    due_date timestamp,
    finished_in int
        generated always as (due_date - generated_date) stored
);

-- creating contract table
create table contract
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
create table location
(
    savepoint_id varchar(8),
    package_id varchar(8),
    description varchar,
    truck_id varchar(8),
    plan_id varchar(8),
    warehouse_code varchar(8),
    primary key (savepoint_id, package_id)
);

-- creating savepoint table
create table savepoint
(
    savepoint_id varchar(8),
    latitude double precision,
    longitude double precision,
    date_in_time timestamp,
    primary key (savepoint_id)
);

-- creating truck table
create table truck
(
    track_id varchar(8),
    license_num varchar(12),
    primary key (track_id)
);

-- creating plane table
create table plane
(
    plane_id varchar(8),
    plane_name varchar(12),
    primary key (plane_id)
);

-- creating warehouse table
create table warehouse
(
    warehouse_code varchar(8),
    address address,
    phone_number varchar(12),
    primary key (warehouse_code)
);