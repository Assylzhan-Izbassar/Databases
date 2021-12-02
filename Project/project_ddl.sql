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
    company_id varchar(8),
    name varchar,
    description varchar,
    address address,
    primary key (company_id)
);

-- creating package table
create table package
(
    package_id varchar(8),
    destination varchar(56),
    address address,
    final_delivery_date timestamp,
    sent_time timestamp,
    primary key(package_id)
);

-- creating delivery status table
create table delivery_status
(
    package_id varchar(8),
    description varchar(20),
    updated_time timestamp,
    is_delivered boolean,
    primary key (package_id, description)
);

-- creating type table