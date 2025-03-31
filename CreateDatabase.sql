-- Create Database (Optional - if you don't have one already)
CREATE DATABASE OnlineStoreDB;
GO

USE OnlineStoreDB;
GO

-- Drop tables if they exist (for easy re-running)
DROP TABLE IF EXISTS orderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Items_to_Order; -- For Trigger practical
DROP TABLE IF EXISTS Employee; -- For Trigger practical Part 2
DROP TABLE IF EXISTS Department; -- For Trigger practical Part 2
GO

-- Create Tables based on Practical Examples

-- Online Store Schema (Functions Practical)
CREATE TABLE Customers (
    cid CHAR(4) PRIMARY KEY,
    name VARCHAR(50),
    phone CHAR(10),
    country VARCHAR(20)
);

-- Employee/Department Schema (Triggers Practical Part 2)
CREATE TABLE Department (
    did VARCHAR(5) PRIMARY KEY,
    dname VARCHAR(20),
    budget MONEY,
    mgrid CHAR(4) -- Initially NULL, FK added later
);

CREATE TABLE Employees ( 
    eid CHAR(4) PRIMARY KEY,
    ename VARCHAR(50),
    phone CHAR(10),
    birthdate DATE,
    salary MONEY,
    did VARCHAR(5),
    supervld CHAR(4), -- Supervisor ID,
    CONSTRAINT employees_fk1 FOREIGN KEY (did) REFERENCES Department(did),
    CONSTRAINT employees_fk2 FOREIGN KEY (supervld) REFERENCES Employees(eid) -- Self-referencing FK
);

CREATE TABLE Products (
    productId CHAR(4) PRIMARY KEY,
    productName VARCHAR(50), -- Increased size from 15
    unitPrice REAL,
    unitInStock INT,
    ROL INT -- Re-Order Level
);

CREATE TABLE Orders (
    oid INT PRIMARY KEY,
    eid CHAR(4) REFERENCES Employees(eid),
    cid CHAR(4) REFERENCES Customers(cid),
    orderDate DATE,
    requiredDate DATE,
    shippedDate DATE,
    cost REAL -- Note: This might be calculated, the functions practical calculates it.
);

CREATE TABLE orderDetails (
    oid INT REFERENCES Orders(oid),
    productId CHAR(4) REFERENCES Products(productId),
    quantity INT,
    discount REAL,
    CONSTRAINT orderDetails_pk PRIMARY KEY (oid, productId)
);

-- Table for Trigger Practical Part 1a
CREATE TABLE Items_to_Order (
    NoticeNo INT IDENTITY(1,1) PRIMARY KEY, -- Auto-incrementing primary key
    ProductId CHAR(4),
    DateNotified DATETIME DEFAULT GETDATE(), -- Record when the notice was generated
    FOREIGN KEY (ProductId) REFERENCES Products(productId)
);

-- Add the Manager Foreign Key constraint to Department after Employee table is created
ALTER TABLE Department ADD CONSTRAINT department_fk FOREIGN KEY (mgrid) REFERENCES Employees(eid);
GO

-- Insert Sample Data

-- Online Store Data
INSERT INTO Customers (cid, name, phone, country) VALUES
('C001', 'Saman', '0772446552', 'Sri Lanka'),
('C002', 'John', '0987665446', 'USA'),
('C003', 'Mashato', '0927665334', 'Japan');

-- Employee/Department Data
INSERT INTO Department (did, dname, budget, mgrid) VALUES
('d001', 'HR', 250000.00, NULL),
('d002', 'Sales', 340000.00, NULL),
('d003', 'Accounts', 560000.00, NULL),
('d004', 'IT', 590000.00, NULL);

INSERT INTO Employees (eid, ename, phone, birthdate, salary, did, supervld) VALUES
('E001', 'Kasun Weerasekara', '0702994459', '1997-04-07', 70000.00, NULL, NULL),
('E002', 'Sathira Wijerathna', '0760510056', '1996-02-05', 60000.00, NULL, NULL),
('E003', 'Saman Perera', '0711234567', '2000-01-01', 70000.00, 'D001', NULL),
('E004', 'Kamal Silva', '0779876543', '1992-01-01', 34000.00, 'D001', 'E003'),
('E005', 'Nipun Fernando', '0762468013', '2001-01-01', 56000.00, 'D003', 'E003'),
('E006', 'Kasun Bandara', '0710001111', '2000-01-01', 54000.00, 'D002', 'E003'),
('E007', 'Heshan Perera', '0770002222', '1992-01-01', 60000.00, 'D002', 'E003'),
('E008', 'Aruni Wijesinghe', '0760003333', '1998-01-01', 47000.00, 'D004', 'E005'),
('E009', 'Sachini Gunawardana', '0710004444', '2002-01-01', 32000.00, 'D002', 'E006');

INSERT INTO Products (productId, productName, unitPrice, unitInStock, ROL) VALUES
('P001', 'Hard Disk', 12000, 80, 50),
('P002', 'Flash Drive', 3200, 60, 20),
('P003', 'LCD Monitor', 24000, 35, 15),
('P004', 'Keyboard', 4500, 15, 20); -- Added another product for trigger demo

INSERT INTO Orders (oid, eid, cid, orderDate, requiredDate, shippedDate, cost) VALUES
(1, 'E001', 'C001', '2020-09-01', '2020-09-09', '2020-09-02', NULL); -- Cost might be calculated

INSERT INTO orderDetails (oid, productId, quantity, discount) VALUES
(1, 'P001', 3, 0.1),
(1, 'P002', 5, 0.15),
(1, 'P003', 2, 0.15);



-- Update Department Managers now that Employees exist
UPDATE Department SET mgrid = 'e002' WHERE did = 'd001';
UPDATE Department SET mgrid = 'e001' WHERE did = 'd002';
UPDATE Department SET mgrid = 'e001' WHERE did = 'd003';
UPDATE Department SET mgrid = 'e003' WHERE did = 'd004';
GO

PRINT 'Database Setup Complete!';