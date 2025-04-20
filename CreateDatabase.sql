/*************************************************************************
 *! ONLINE STORE DATABASE SETUP
 * A comprehensive database for demonstrating SQL concepts including:
 * - Joins, Views, Functions, Stored Procedures, and Triggers
 * Last Updated: April 2025
 *************************************************************************/

-- Create Database (Optional - if you don't have one already)
CREATE DATABASE OnlineStoreDB;
GO

USE OnlineStoreDB;
GO

--! CLEANUP: Drop existing tables in correct order (for easy re-running)
--* Tables must be dropped in order that respects foreign key constraints
DROP TABLE IF EXISTS orderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Items_to_Order; -- For Trigger practical
DROP TABLE IF EXISTS Department; -- For Trigger practical Part 2
GO

--! DATABASE SCHEMA
--* 1. Customer-Related Tables
--* ----------------------------

--* Customer table holds information about customers who place orders
CREATE TABLE Customers (
    cid CHAR(4) PRIMARY KEY,            -- Customer ID (e.g., C001)
    name VARCHAR(50),                    -- Customer name
    phone CHAR(10),                      -- Contact number
    country VARCHAR(20)                  -- Country for geographical analysis
);

--* 2. Employee/Department Tables  
--* -----------------------------

--* Department table organizes employees into functional units
CREATE TABLE Department (
    did VARCHAR(5) PRIMARY KEY,          -- Department ID
    dname VARCHAR(20),                   -- Department name
    budget MONEY,                        -- Department budget allocation
    mgrid CHAR(4)                        -- Manager ID reference (FK added later)
);

--* Employees table with self-referential relationship for supervisors
CREATE TABLE Employees ( 
    eid CHAR(4) PRIMARY KEY,             -- Employee ID (always uppercase)
    ename VARCHAR(50),                   -- Employee name
    phone CHAR(10),                      -- Contact number
    birthdate DATE,                      -- Date of birth (used for age calculation)
    salary MONEY,                        -- Employee salary 
    did VARCHAR(5),                      -- Department reference
    supervld CHAR(4),                    -- Supervisor ID reference (self-referencing)
    CONSTRAINT employees_fk1 FOREIGN KEY (did) REFERENCES Department(did),
    CONSTRAINT employees_fk2 FOREIGN KEY (supervld) REFERENCES Employees(eid)
);

--* 3. Product and Order Tables
--* ---------------------------

--* Products available for sale
CREATE TABLE Products (
    productId CHAR(4) PRIMARY KEY,       -- Product ID (e.g., P001)
    productName VARCHAR(50),             -- Product name
    unitPrice REAL,                      -- Price per unit
    unitInStock INT,                     -- Current inventory level
    ROL INT                              -- Re-Order Level threshold
);

--* Orders placed by customers
CREATE TABLE Orders (
    oid INT PRIMARY KEY,                 -- Order ID
    eid CHAR(4) REFERENCES Employees(eid), -- Employee who processed order
    cid CHAR(4) REFERENCES Customers(cid), -- Customer who placed order
    orderDate DATE,                      -- Date order was placed
    requiredDate DATE,                   -- Requested delivery date
    shippedDate DATE,                    -- Actual shipping date
    cost REAL                            -- Order total (calculated by Function)
);

--* Order line items (many-to-many relationship)
CREATE TABLE orderDetails (
    oid INT REFERENCES Orders(oid),      -- Order reference
    productId CHAR(4) REFERENCES Products(productId), -- Product reference
    quantity INT,                        -- Quantity ordered
    discount REAL,                       -- Discount applied (percentage)
    CONSTRAINT orderDetails_pk PRIMARY KEY (oid, productId)
);

--* 4. System Tables
--* ----------------

--* Table for re-order notifications (used in Trigger demos)
CREATE TABLE Items_to_Order (
    NoticeNo INT IDENTITY(1,1) PRIMARY KEY, -- Auto-incrementing notice number
    ProductId CHAR(4),                      -- Product that needs reordering
    DateNotified DATETIME DEFAULT GETDATE(), -- Timestamp of notification
    FOREIGN KEY (ProductId) REFERENCES Products(productId)
);

--? Add Manager FK constraint after tables are created to avoid circular references
ALTER TABLE Department ADD CONSTRAINT department_fk FOREIGN KEY (mgrid) REFERENCES Employees(eid);
GO

--! SAMPLE DATA
--* Sample data for testing and demonstration

--* 1. Customer data
INSERT INTO Customers (cid, name, phone, country) VALUES
('C001', 'Saman', '0772446552', 'Sri Lanka'),
('C002', 'John', '0987665446', 'USA'),
('C003', 'Mashato', '0927665334', 'Japan');

--* 2. Department data (initially without managers)
INSERT INTO Department (did, dname, budget, mgrid) VALUES
('d001', 'HR', 250000.00, NULL),
('d002', 'Sales', 340000.00, NULL),
('d003', 'Accounts', 560000.00, NULL), 
('d004', 'IT', 590000.00, NULL);

--* 3. Employee data with supervision hierarchy
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

--* 4. Product inventory data
INSERT INTO Products (productId, productName, unitPrice, unitInStock, ROL) VALUES
('P001', 'Hard Disk', 12000, 80, 50),
('P002', 'Flash Drive', 3200, 60, 20),
('P003', 'LCD Monitor', 24000, 35, 15),
('P004', 'Keyboard', 4500, 15, 20); --? Stock below ROL to test triggers

--* 5. Sample order with multiple items
INSERT INTO Orders (oid, eid, cid, orderDate, requiredDate, shippedDate, cost) VALUES
(1, 'E001', 'C001', '2020-09-01', '2020-09-09', '2020-09-02', NULL); --? Cost calculated by function

INSERT INTO orderDetails (oid, productId, quantity, discount) VALUES
(1, 'P001', 3, 0.1),  -- 3 Hard Disks with 10% discount
(1, 'P002', 5, 0.15), -- 5 Flash Drives with 15% discount
(1, 'P003', 2, 0.15); -- 2 LCD Monitors with 15% discount

--* 6. Assign department managers (circular reference resolved)
UPDATE Department SET mgrid = 'E002' WHERE did = 'd001';
UPDATE Department SET mgrid = 'E001' WHERE did = 'd002';
UPDATE Department SET mgrid = 'E001' WHERE did = 'd003';
UPDATE Department SET mgrid = 'E003' WHERE did = 'd004';
GO

--TODO: Consider adding more diverse test data for advanced query demonstrations

PRINT 'Database Setup Complete!';