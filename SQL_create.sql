CREATE DATABASE IF NOT EXISTS sales;
USE sales;
CREATE TABLE sales 
(
purchase_number INT auto_increment,
date_of_purchase DATE,
customer_id INT,
item_code VARCHAR(10),
PRIMARY KEY (purchase_number)
);

ALTER TABLE sales 
ADD foreign key (customer_id) REFERENCES customers (customer_id) ON DELETE CASCADE;

ALTER TABLE sales
DROP FOREIGN KEY sales_ibfk_1;

use sales;
drop table sales;
drop table customers;
drop table items;
drop table companies;

CREATE TABLE customers (
customer_id INT auto_increment,
first_name VARCHAR(255),
last_name VARCHAR(255),
email_address VARCHAR (255),
number_of_complaints INT,
PRIMARY KEY (customer_id)
);

ALTER TABLE customers
ADD UNIQUE KEY (email_address);

ALTER table customers
DROP INDEX email_address;

ALTER TABLE customers
ADD COLUMN gender ENUM('M','F') AFTER last_name;

INSERT INTO customers(first_name, last_name, gender, email_address, number_of_complaints)
VALUES( 'John', 'Mackinley', 'M', 'john.mckinley@365careers.com', '0');

ALTER TABLE customers
CHANGE COLUMN number_of_complaints number_of_complaints INT DEFAULT '0';

ALTER TABLE customers
ALTER COLUMN number_of_complaints DROP DEFAULT;

INSERT INTO customers(first_name, last_name, gender)
VALUES( 'Peter', 'Figaro', 'M');

SELECT * FROM customers;

CREATE TABLE companies
(
company_id VARCHAR(255),
company_name VARCHAR(255) DEFAULT 'X',
headquarters_phone_number VARCHAR(255),
PRIMARY KEY (company_id),
UNIQUE KEY (headquarters_phone_number)
);

DROP TABLE companies;

CREATE TABLE companies
(
company_id INT auto_increment,
headquarters_phone_number VARCHAR(255),
company_name VARCHAR(255) NOT NULL,
PRIMARY KEY (company_id)
);

ALTER TABLE companies
MODIFY company_name VARCHAR(255) NULL;

ALTER TABLE companies
CHANGE COLUMN company_name company_name VARCHAR(255) NOT NULL;

INSERT INTO companies ( headquarters_phone_number, company_name)
VALUES ('+1 (202) 555-0196', 'company A');

SELECT * FROM companies;

ALTER TABLE companies
CHANGE COLUMN headquarters_phone_number headquarters_phone_number VARCHAR(255) NOT NULL;

ALTER TABLE companies
MODIFY headquarters_phone_number VARCHAR(255) NULL;

