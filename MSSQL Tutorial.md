# MSSQL Tutorial

This is a comprehensive tutorial covering SQL basics, Views, Functions, Stored Procedures, and Triggers, using Microsoft SQL Server (MSSQL). This tutorial is designed to be easy to follow and directly references the concepts and examples from your provided practical sheets.

## Welcome to the MSSQL Tutorial!

This tutorial will guide you through some essential intermediate and advanced concepts in SQL using Microsoft SQL Server (MSSQL). We'll build upon your basic SQL knowledge and explore powerful features like Views, Functions, Stored Procedures, and Triggers. These are crucial skills for any IT or AI professional working with databases.

This document is structured to be easy to follow, with clear explanations and examples. Each section will build on the previous one, so you can see how these concepts fit together in real-world scenarios.


**Prerequisites:** Basic understanding of SQL (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE TABLE`, basic `JOIN` concepts). Familiarity with SQL Server Management Studio (SSMS) is helpful. But you can follow with VSCODE as well.

**Let's Get Started!**

---

### Part 0: Setting Up Your Database

First, you need the database tables and some data to work with. We'll use a combination of the schemas provided in your practical documents for an online store and employee management.

Execute the following SQL script in SQL Server Management Studio (SSMS) to create the tables and insert initial data.



```sql
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
DROP TABLE IF EXISTS Employees; -- For Trigger practical Part 2
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

-- Add the Manager Foreign Key constraint to Department after Employees table is created
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
```
Now you have the tables and data ready for the tutorial exercises.

---
## Table of Contents
1.  [SQL Joins](#part-1-sql-joins)
2.  [SQL Views](#part-2-sql-views)
3.  [SQL Functions](#part-3-sql-functions)
4.  [SQL Triggers](#part-4-sql-triggers)
5.  [SQL Stored Procedures](#part-5-sql-stored-procedures)

---

### Part 1: SQL Joins
This is a fundamental concept for working with relational databases, allowing you to combine data from multiple tables based on related columns. We'll use the database schema we set up earlier.

**What is a JOIN?**
In a relational database like the one for our online store or employee management system, data is split into multiple tables to avoid redundancy and improve organization (this is called normalization). For example, we store customer details in `Customers` and order details in `Orders`. But what if you want to see the *name* of the customer who placed a specific order? You need to combine information from both tables. That's where `JOIN` comes in!

**Why use JOINs?**

*   To retrieve data from two or more tables in a single query.
*   To link tables based on related columns (usually primary key - foreign key relationships).
*   To reconstruct meaningful information that is spread across normalized tables.

**Key Concept: The `ON` Clause**

The `JOIN` clause is typically followed by an `ON` clause. The `ON` clause specifies the condition used to link the rows from the different tables. This condition usually compares columns that hold related data, most often the Primary Key (PK) of one table and the Foreign Key (FK) of another.

`SELECT ... FROM tableA JOIN tableB ON tableA.related_column = tableB.related_column;`

Let's explore the different types of JOINs using our database.

**5.1 INNER JOIN (The Most Common)**

*   **Concept:** Returns only the rows where there is a match in **both** tables based on the `ON` condition. If a row in one table doesn't have a corresponding match in the other table, it's excluded from the result.
*   **Think:** The intersection (overlapping part) of two sets.

**Example 1: Get Order Information with Customer Names**

We want to see each order ID and the name of the customer who placed it. The `Orders` table has `cid` (Customer ID), and the `Customers` table links `cid` to `name`.

```sql
SELECT
    O.oid,          -- Order ID from Orders table
    O.orderDate,    -- Order Date from Orders table
    C.name,         -- Customer Name from Customers table
    C.country       -- Customer Country from Customers table
FROM
    Orders AS O     -- Alias 'O' for the Orders table (left table)
INNER JOIN
    Customers AS C  -- Alias 'C' for the Customers table (right table)
ON
    O.cid = C.cid;  -- The join condition: match customer IDs
```

*   **Explanation:**
    *   We select columns from both `Orders` (aliased as `O`) and `Customers` (aliased as `C`). Using aliases makes the query shorter and clearer, especially when joining multiple tables.
    *   `INNER JOIN Customers AS C ON O.cid = C.cid`: This links the two tables where the `cid` in the `Orders` table matches the `cid` in the `Customers` table.
    *   Only orders that have a matching customer ID in the `Customers` table will be shown. In our setup (due to Foreign Key constraints), every order *must* have a valid customer, so `INNER JOIN` works perfectly here.

**Example 2: Get Order Details with Product Names and Prices**

We want to see the items sold in order 1, including the product name and the price *at the time the schema was created* (note: price might change, storing price in `orderDetails` is often better practice for historical accuracy, but we'll use the `Products` table price for this example).

```sql
SELECT
    OD.oid,         -- Order ID from orderDetails
    P.productName,  -- Product Name from Products
    OD.quantity,    -- Quantity from orderDetails
    P.unitPrice,    -- Unit Price from Products
    OD.discount     -- Discount from orderDetails
FROM
    orderDetails AS OD
INNER JOIN
    Products AS P
ON
    OD.productId = P.productId -- Join based on the product ID
WHERE
    OD.oid = 1;     -- Filter for a specific order
```

*   **Explanation:** This query links `orderDetails` and `Products` to show descriptive information about the items within a specific order.

**5.2 LEFT JOIN (or LEFT OUTER JOIN)**

*   **Concept:** Returns **all** rows from the **left** table (the table listed first, before the `JOIN` keyword) and the matching rows from the **right** table (the table listed after the `JOIN` keyword). If there is no match in the right table for a row from the left table, `NULL` values are returned for the columns from the right table.
*   **Think:** All of the left set, plus the overlapping part of the right set.

**Example 1: List ALL Customers and ANY Orders They Placed**

We want a list of all customers, whether they have placed an order or not. If they have placed orders, we want to see the order ID and date.

```sql
-- Add a customer who hasn't placed an order yet
INSERT INTO Customers (cid, name, phone, country)
VALUES ('C004', 'Nayana', '0761112233', 'Sri Lanka');
GO

SELECT
    C.cid,          -- Customer ID
    C.name,         -- Customer Name
    O.oid,          -- Order ID (will be NULL if no order)
    O.orderDate     -- Order Date (will be NULL if no order)
FROM
    Customers AS C  -- Left Table (We want ALL customers)
LEFT JOIN
    Orders AS O     -- Right Table
ON
    C.cid = O.cid   -- Join condition
ORDER BY
    C.cid;
```

*   **Explanation:**
    *   `Customers` is the *left* table. The query will return *every* customer.
    *   `Orders` is the *right* table.
    *   For customers like 'Saman' ('C001') who have placed orders, the corresponding `oid` and `orderDate` will be shown.
    *   For customers like 'Nayana' ('C004') who haven't placed any orders, the `oid` and `orderDate` columns will show `NULL`.
    *   This is useful for finding entities that *don't* have related records (e.g., "Find customers who have never ordered").

**Example 2: List All Employees and Their Assigned Department Name**

Let's use the `Employees` and `Department` tables from the Triggers practical. We want to see all employees and their department name. What if an employee wasn't assigned a department? (Our FK constraint prevents `NULL` `did` in `Employees`, but let's imagine it was allowed).

```sql
SELECT
    E.eid,
    E.ename,
    D.dname -- Department Name (could be NULL if no match)
FROM
    Employees AS E -- Left Table (All Employees)
LEFT JOIN
    Department AS D -- Right Table
ON
    E.did = D.did; -- Join on Department ID
```

*   **Explanation:** This would show all employees. If an employee had a `did` that didn't exist in the `Department` table (or if `E.did` was `NULL`, if allowed), the `dname` column would be `NULL` for that employee.

**5.3 RIGHT JOIN (or RIGHT OUTER JOIN)**

*   **Concept:** Returns **all** rows from the **right** table and the matching rows from the **left** table. If there is no match in the left table for a row from the right table, `NULL` values are returned for the columns from the left table.
*   **Think:** All of the right set, plus the overlapping part of the left set. It's the mirror image of `LEFT JOIN`.

**Example 1: List ALL Orders and the Employee Who Took Them (If Available)**

Imagine an employee record might be deleted, but we still want to see all orders.

```sql
SELECT
    O.oid,
    O.orderDate,
    E.eid,       -- Employee ID (will be NULL if no matching employee)
    E.ename      -- Employee Name (will be NULL if no matching employee)
FROM
    Employees AS E -- Left Table
RIGHT JOIN
    Orders AS O    -- Right Table (We want ALL orders)
ON
    E.eid = O.eid; -- Join condition
```

*   **Explanation:**
    *   `Orders` is the *right* table, so all orders will be listed.
    *   `Employees` is the *left* table.
    *   If an order's `eid` refers to an employee who exists in the `Employees` table, their details (`eid`, `ename`) are shown.
    *   If an order's `eid` doesn't match any employee in the `Employees` table (e.g., if the employee was deleted but the FK constraint wasn't set up to handle it, or if `O.eid` was `NULL`), the `E.eid` and `E.ename` columns would show `NULL`.
*   **Note:** Many developers find `LEFT JOIN` more intuitive and tend to structure their queries to use it instead of `RIGHT JOIN`, but both are functionally available. You could achieve the same result as above by swapping the table order and using `LEFT JOIN`: `FROM Orders O LEFT JOIN Employees E ON O.eid = E.eid`.

**Example 2: List All Products and Any Order Details Associated with Them**

Find products that have never been sold.

```sql
SELECT
    P.productId,
    P.productName,
    OD.oid,         -- Order ID (NULL if never ordered)
    OD.quantity     -- Quantity (NULL if never ordered)
FROM
    orderDetails AS OD -- Left Table
RIGHT JOIN
    Products AS P      -- Right Table (We want ALL Products)
ON
    OD.productId = P.productId
WHERE
    OD.oid IS NULL;   -- Filter for products with no matching order details
```

*   **Explanation:** This query lists all products (`RIGHT JOIN`). Where a product hasn't appeared in any `orderDetails` row, the `OD.oid` and `OD.quantity` will be `NULL`. The `WHERE OD.oid IS NULL` filters the result to show *only* those products that have never been ordered.

**5.4 FULL OUTER JOIN (or FULL JOIN)**

*   **Concept:** Returns **all** rows from **both** the left and right tables.
    *   If there's a match based on the `ON` condition, the rows are combined.
    *   If a row in the left table has no match in the right table, `NULL` values are returned for the columns from the right table.
    *   If a row in the right table has no match in the left table, `NULL` values are returned for the columns from the left table.
*   **Think:** All of the left set AND all of the right set combined.

**Example: List All Customers and All Orders, Matching Them Where Possible**

This shows customers who haven't ordered, orders that might have an invalid customer (if FKs allowed it), and orders matched to customers.

```sql
SELECT
    C.cid,
    C.name,
    O.oid,
    O.orderDate
FROM
    Customers AS C -- Left Table
FULL OUTER JOIN
    Orders AS O    -- Right Table
ON
    C.cid = O.cid  -- Join condition
ORDER BY
    C.cid, O.oid;
```

*   **Explanation:**
    *   You'll see rows for customers with their matched orders (like C001).
    *   You'll see rows for customers with no orders (like C004), where `O.oid` and `O.orderDate` are `NULL`.
    *   If there were an order in the `Orders` table with a `cid` that *didn't* exist in `Customers` (only possible if the Foreign Key constraint was disabled or missing), you would see a row for that order where `C.cid` and `C.name` are `NULL`.

**5.5 CROSS JOIN**

*   **Concept:** Returns the Cartesian product of the two tables. Every row from the first table is combined with every row from the second table. No `ON` clause is needed (or allowed in standard SQL syntax for `CROSS JOIN`).
*   **Think:** Generating all possible combinations.
*   **Use Cases:** Rare. Sometimes used for generating test data or specific scenarios requiring all combinations. Often occurs accidentally if you forget the `ON` clause in an `INNER JOIN` (using the older comma syntax).

**Example: Combine Every Customer with Every Product (Not very meaningful usually)**

```sql
SELECT
    C.name AS CustomerName,
    P.productName AS ProductOffered
FROM
    Customers AS C
CROSS JOIN
    Products AS P;

-- Older (less recommended) syntax that produces the same result:
-- SELECT C.name, P.productName FROM Customers C, Products P;
-- (If you forget a WHERE clause here, you get a CROSS JOIN)
```

*   **Explanation:** If you have 3 customers and 4 products, this query will return 3 * 4 = 12 rows, pairing each customer with each product.

**5.6 Self JOIN**

*   **Concept:** Joining a table to itself. This is used when a table contains references to other rows within the same table, like an employee's supervisor ID referencing another employee's ID in the same table.
*   **Key:** You **must** use table aliases to distinguish between the two instances of the table in the query.

**Example: Find Each Employee and Their Supervisor's Name**

Using the `Employees` table from the Triggers practical, which has `eid` and `supervld` (supervisor's eid).

```sql
SELECT
    Emp.eid AS EmployeeID,
    Emp.ename AS EmployeeName,
    Emp.salary AS EmployeeSalary,
    Sup.eid AS SupervisorID,
    Sup.ename AS SupervisorName,
    Sup.salary AS SupervisorSalary
FROM
    Employees AS Emp  -- Instance 1: Represents the Employee
LEFT JOIN -- Use LEFT JOIN to include employees with NO supervisor (e.g., the CEO)
    Employees AS Sup  -- Instance 2: Represents the Supervisor
ON
    Emp.supervld = Sup.eid; -- Join condition: Employee's supervisor ID matches Supervisor's employee ID
```

*   **Explanation:**
    *   We reference the `Employees` table twice, giving it different aliases: `Emp` for the employee role and `Sup` for the supervisor role.
    *   The `ON Emp.supervld = Sup.eid` condition links an employee row (`Emp`) to their supervisor's row (`Sup`).
    *   We use `LEFT JOIN` so that employees who have `supervld` as `NULL` (like 'Saman', 'e001' in our data) are still included in the results; their supervisor columns (`SupervisorID`, `SupervisorName`, `SupervisorSalary`) will just be `NULL`. If we used `INNER JOIN`, employees without supervisors would be excluded.

---

**JOINs Summary:**

*   **`INNER JOIN`**: Matching rows only.
*   **`LEFT JOIN`**: All rows from the left table, plus matches from the right (or NULLs).
*   **`RIGHT JOIN`**: All rows from the right table, plus matches from the left (or NULLs).
*   **`FULL OUTER JOIN`**: All rows from both tables, with matches where possible (or NULLs).
*   **`CROSS JOIN`**: All possible combinations of rows.
*   **`Self JOIN`**: Joining a table to itself using aliases.

Mastering JOINs is crucial for effectively retrieving and analyzing data stored in relational databases. Practice combining different tables from our schema to answer various questions!

### Part 2: SQL Views

A View is a virtual table based on the result set of a stored SQL query. Think of it as a saved query that you can interact with like a table.

**Why use Views?** (From your Practical 5 notes)

*   **Simplify Complex Queries:** Hide joins and complex logic behind a simple view name.
*   **Limit Data Access (Security):** Show only certain columns or rows to specific users.
*   **Provide Extra Security Layer:** Create read-only views.
*   **Enable Computed Columns:** Display calculated values without storing them physically.
*   **Backward Compatibility:** Maintain old table structures virtually while redesigning the underlying database.

**Disadvantages:**

*   **Performance:** Views, especially complex ones or views based on other views, can be slower than direct table queries.
*   **Table Dependency:** Changes to underlying tables might break the view.

Let's look at examples, drawing from Practical 5 concepts.

**2.1 Simple View: Active Customers in Sri Lanka**

*   **Goal:** Create a view showing only customers from Sri Lanka.

```sql
-- View for Sri Lankan Customers
CREATE VIEW SriLankanCustomers AS
SELECT cid, name, phone
FROM Customers
WHERE country = 'Sri Lanka';
GO

-- How to use it:
SELECT * FROM SriLankanCustomers;

-- Try inserting (will likely work as it's based on one table and includes necessary columns if no defaults)
-- INSERT INTO SriLankanCustomers (cid, name, phone) VALUES ('C004', 'Nimal', '0711234567');
-- SELECT * FROM Customers; -- Verify if C004 was added
```

**2.2 Complex View: Detailed Order Information (Similar to `orderInfo` function)**

*   **Goal:** Create a view that joins multiple tables and includes calculated columns.

```sql
-- View for Detailed Order Info (Mimicking the function)
CREATE VIEW DetailedOrderInfo AS
SELECT
    O.oid,
    O.orderDate,
    C.name AS CustomerName,
    E.ename AS EmployeeName,
    P.productName,
    OD.quantity,
    P.unitPrice,
    (P.unitPrice * OD.quantity) AS TotalProductPrice,
    OD.discount,
    (P.unitPrice * OD.quantity * (1 - OD.discount)) AS PayableProductPrice
FROM Orders O
JOIN Customers C ON O.cid = C.cid
JOIN Employees E ON O.eid = E.eid
JOIN orderDetails OD ON O.oid = OD.oid
JOIN Products P ON OD.productId = P.productId;
GO

-- How to use it:
SELECT * FROM DetailedOrderInfo WHERE oid = 1;

-- Try updating (will likely FAIL because it involves multiple base tables)
-- UPDATE DetailedOrderInfo SET quantity = 4 WHERE oid = 1 AND productName = 'Hard Disk';
-- (This will typically result in an error)
```

*   **Explanation:** Views based on multiple tables are generally *not* updatable directly.

**2.3 View with `WITH CHECK OPTION`** (Practical 5, Example 4.7)

*   **Goal:** Ensure that `INSERT` or `UPDATE` operations through the view adhere to the view's `WHERE` clause.

```sql
-- View for USA Customers with Check Option
CREATE VIEW UsaCustomersView AS
SELECT cid, name, phone, country
FROM Customers
WHERE country = 'USA'
WITH CHECK OPTION; -- Ensures modifications keep country = 'USA'
GO

-- How to use it:
SELECT * FROM UsaCustomersView;

-- This UPDATE should work
UPDATE UsaCustomersView SET phone = '1112223333' WHERE cid = 'C002';

-- This INSERT should work
-- INSERT INTO UsaCustomersView (cid, name, phone, country) VALUES ('C005', 'Peter', '2223334444', 'USA');

-- This UPDATE should FAIL because it violates the WHERE clause
-- UPDATE UsaCustomersView SET country = 'Canada' WHERE cid = 'C002';
-- (Msg 550, Level 16, State 1, Line ...)
-- (The attempted insert or update failed because the target view either specifies WITH CHECK OPTION ...)

-- This INSERT should FAIL
-- INSERT INTO UsaCustomersView (cid, name, phone, country) VALUES ('C006', 'Anil', '077...', 'Sri Lanka');
-- (Msg 550, Level 16, State 1, Line ...)

-- Clean up the test insert if it worked
-- DELETE FROM Customers WHERE cid = 'C005';
```

*   **Explanation:** `WITH CHECK OPTION` prevents modifications through the view that would make the row invisible to the view itself.

**2.4 View `DeptMgr_Details`** (Triggers Practical, Part 2b)

*   **Goal:** Retrieve department details along with the manager's details.

```sql
-- View joining Department and Employees (for manager details)
CREATE VIEW DeptMgr_Details AS
SELECT
    D.did,
    D.dname,
    D.budget,
    D.mgrid,
    E.ename AS mgrname,
    DATEDIFF(YEAR, E.birthdate, GETDATE()) AS MgrAge,  -- Calculate age from birthdate
    E.salary AS MgrSalary,
    E.supervld AS MgrSupervisorId -- Manager's supervisor
FROM Department D
LEFT JOIN Employees E ON D.mgrid = E.eid; -- Use LEFT JOIN if a dept might not have a manager assigned yet
GO

-- How to use it:
SELECT * FROM DeptMgr_Details;
```

---

### Part 3: SQL Functions

Functions in SQL are blocks of code that perform a specific task and return a result. They promote reusability and modularity. MSSQL has two main types of User-Defined Functions (UDFs):

1.  **Scalar Functions:** Return a single value (like `INT`, `VARCHAR`, `DATE`, `REAL`).
2.  **Table-Valued Functions (TVFs):** Return a result set (a table).
    *   **Inline TVFs:** Have a single `SELECT` statement. Often perform better.
    *   **Multi-statement TVFs:** Can contain multiple SQL statements within `BEGIN...END` blocks.

Let's implement the functions from your "Tutorial - Functions" sheet.

**1.1 Scalar Function: `calcCost`** (Functions Q1)

*   **Goal:** Calculate the total cost of an order (sum of `unitPrice * quantity` for all items in that order).
*   **Type:** Scalar (returns a single `REAL` value).

```sql
-- Function to calculate the total cost of a given order
CREATE FUNCTION calcCost (@orderId INT)
RETURNS REAL
AS
BEGIN
    DECLARE @totalCost REAL;

    SELECT @totalCost = SUM(P.unitPrice * OD.quantity)
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId;

    -- Handle cases where the order ID doesn't exist or has no items
    IF @totalCost IS NULL
        SET @totalCost = 0.0;

    RETURN @totalCost;
END;
GO

-- How to use it:
-- Calculate cost for Order ID 1
SELECT dbo.calcCost(1) AS Order1TotalCost;

-- You could even update the Orders table using this function (use with caution)
-- UPDATE Orders
-- SET cost = dbo.calcCost(oid)
-- WHERE oid = 1;
-- SELECT * FROM Orders WHERE oid = 1;
```

*   **Explanation:**
    *   `CREATE FUNCTION calcCost (@orderId INT)`: Defines a function named `calcCost` that accepts one integer input parameter `@orderId`.
    *   `RETURNS REAL`: Specifies that the function will return a single floating-point number.
    *   `BEGIN...END`: Encloses the function's logic.
    *   `DECLARE @totalCost REAL;`: Declares a local variable to hold the calculated cost.
    *   `SELECT @totalCost = SUM(...)`: Calculates the sum of (price * quantity) by joining `orderDetails` and `Products` for the given `@orderId`.
    *   `IF @totalCost IS NULL SET @totalCost = 0.0;`: Ensures we return 0 if the order has no items or doesn't exist, preventing `NULL` return.
    *   `RETURN @totalCost;`: Returns the calculated value.
    *   `dbo.calcCost(1)`: We call scalar functions using `schema_name.function_name(arguments)`. `dbo` is the default schema.

**1.2 Table-Valued Function: `productsOfOrder`** (Functions Q2)

*   **Goal:** Return the names and quantities of all products for a given order ID.
*   **Type:** Inline Table-Valued Function (returns a table).

```sql
-- Function to get product names and quantities for an order
CREATE FUNCTION productsOfOrder (@orderId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT P.productName, OD.quantity
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId
);
GO

-- How to use it:
-- Get products for Order ID 1
SELECT * FROM dbo.productsOfOrder(1);
```

*   **Explanation:**
    *   `RETURNS TABLE`: Specifies this is a TVF.
    *   `AS RETURN (...)`: For inline TVFs, the logic is a single `SELECT` statement within parentheses.
    *   We join `orderDetails` and `Products` and filter by `@orderId`.
    *   `SELECT * FROM dbo.productsOfOrder(1)`: We select from TVFs just like selecting from a regular table.

**1.3 Modifying a Function: `productsOfOrder` for 'disk'** (Functions Q3)

*   **Goal:** Modify the previous function to only return products whose name contains 'disk'.
*   **Action:** Use `ALTER FUNCTION`.

```sql
-- Modify the function to filter by product name
ALTER FUNCTION productsOfOrder (@orderId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT P.productName, OD.quantity
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId AND P.productName LIKE '%Disk%'; -- Added condition
);
GO

-- How to use it:
-- Get 'disk' products for Order ID 1
SELECT * FROM dbo.productsOfOrder(1);
```

*   **Explanation:**
    *   `ALTER FUNCTION`: Used to modify an existing function.
    *   `AND P.productName LIKE '%Disk%'`: We added this condition using the `LIKE` operator and the wildcard `%` to find any product name containing "Disk".

**1.4 Table-Valued Function: `orderInfo`** (Functions Q4)

*   **Goal:** Return detailed information for each item in an order, including calculated amounts.
*   **Type:** Inline Table-Valued Function.

```sql
-- Function to get detailed info for each order item
CREATE FUNCTION orderInfo (@orderId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.productName,
        OD.quantity AS qty,
        P.unitPrice AS unitAmt,
        (P.unitPrice * OD.quantity) AS totAmt,
        -- Calculate discount amount: total amount * discount rate
        (P.unitPrice * OD.quantity * OD.discount) AS discountAmt,
        -- Calculate payable amount: total amount - discount amount
        (P.unitPrice * OD.quantity) - (P.unitPrice * OD.quantity * OD.discount) AS payAmt
        -- Alternative payAmt: (P.unitPrice * OD.quantity * (1 - OD.discount))
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId
);
GO

-- How to use it:
-- Get detailed info for Order ID 1
SELECT * FROM dbo.orderInfo(1);
```

*   **Explanation:**
    *   This function calculates several values based on the `orderDetails` and `Products` tables:
        *   `qty`: Quantity ordered.
        *   `unitAmt`: Unit price of the product.
        *   `totAmt`: Total amount before discount (`unitPrice * quantity`).
        *   `discountAmt`: The actual monetary value of the discount (`totAmt * discount rate`).
        *   `payAmt`: The final amount to be paid (`totAmt - discountAmt`).

**1.5 Modifying `orderInfo` for Conditional Discount** (Functions Q5)

*   **Goal:** Modify `orderInfo` so the discount is only applied if the quantity ordered is *more than 2*.
*   **Action:** Use `ALTER FUNCTION` and a `CASE` statement.

```sql
-- Modify orderInfo to apply discount only if quantity > 2
ALTER FUNCTION orderInfo (@orderId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.productName,
        OD.quantity AS qty,
        P.unitPrice AS unitAmt,
        (P.unitPrice * OD.quantity) AS totAmt,
        -- Apply discount amount conditionally using CASE
        CASE
            WHEN OD.quantity > 2 THEN (P.unitPrice * OD.quantity * OD.discount)
            ELSE 0 -- No discount if quantity is 2 or less
        END AS discountAmt,
        -- Calculate payable amount based on the potentially zero discountAmt
        (P.unitPrice * OD.quantity) -
            (CASE
                WHEN OD.quantity > 2 THEN (P.unitPrice * OD.quantity * OD.discount)
                ELSE 0
            END)
        AS payAmt
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId
);
GO

-- How to use it:
-- Get detailed info for Order ID 1 with conditional discount
SELECT * FROM dbo.orderInfo(1);
```

*   **Explanation:**
    *   We use a `CASE` statement:
        *   `WHEN OD.quantity > 2 THEN ...`: If the condition is true, calculate the discount amount.
        *   `ELSE 0`: If the condition is false (quantity is 0, 1, or 2), the discount amount is 0.
    *   The `payAmt` calculation also uses the same `CASE` logic to ensure it subtracts the correct discount amount (which might be 0).

---


### Part 4: Stored Procedures

Stored Procedures are pre-compiled collections of one or more SQL statements stored in the database.

**Why use Stored Procedures?**

*   **Performance:** Compiled once, executed many times, reducing overhead.
*   **Security:** Grant `EXECUTE` permissions without granting direct table access.
*   **Reduce Network Traffic:** Execute multiple statements with a single call.
*   **Modularity & Reusability:** Encapsulate business logic.
*   **Data Integrity:** Enforce consistent data modification logic.

Let's adapt examples from Practical 6.

**3.1 Simple Procedure: Get Product Info** (Adapted from Practical 6, Q1)

*   **Goal:** Display all information for a specific product.

```sql
-- Procedure to get details for a specific product
CREATE PROCEDURE GetProductInfo
    @prodId CHAR(4) -- Input parameter
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    SELECT *
    FROM Products
    WHERE productId = @prodId;
END;
GO

-- How to use it:
EXEC GetProductInfo @prodId = 'P001';
-- Or positional:
EXEC GetProductInfo 'P002';
```

*   **Explanation:**
    *   `CREATE PROCEDURE GetProductInfo @prodId CHAR(4)`: Defines the procedure and its input parameter `@prodId`.
    *   `AS BEGIN...END`: Contains the procedure's logic.
    *   `SET NOCOUNT ON;`: A common practice in stored procedures to suppress messages like "(1 row affected)".
    *   The `SELECT` statement retrieves data based on the input parameter.
    *   `EXEC`: The command to execute a stored procedure.

**3.2 Procedure with Output Parameter: Get Reorder Level** (Adapted from Practical 6, Q2)

*   **Goal:** Retrieve the Re-Order Level (ROL) for a given product ID and return it via an output parameter.

```sql
-- Procedure to get ROL using an OUTPUT parameter
CREATE PROCEDURE GetProductROL
    @prodId CHAR(4),       -- Input parameter
    @ReorderLevel INT OUTPUT -- Output parameter
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @ReorderLevel = ROL
    FROM Products
    WHERE productId = @prodId;

    -- Handle product not found scenario
    IF @ReorderLevel IS NULL
        PRINT 'Warning: Product ID not found.';
        -- Optionally set a default or error value, e.g., SET @ReorderLevel = -1;

END;
GO

-- How to use it:
DECLARE @rolValue INT; -- Declare a variable to receive the output

EXEC GetProductROL @prodId = 'P003', @ReorderLevel = @rolValue OUTPUT; -- Pass variable with OUTPUT keyword

PRINT 'The Re-Order Level for P003 is: ' + CAST(@rolValue AS VARCHAR);

-- Test with a non-existent product
DECLARE @rolValueNotFound INT;
EXEC GetProductROL @prodId = 'P999', @ReorderLevel = @rolValueNotFound OUTPUT;
PRINT 'The Re-Order Level for P999 is: ' + ISNULL(CAST(@rolValueNotFound AS VARCHAR), 'Not Found');

```

*   **Explanation:**
    *   `@ReorderLevel INT OUTPUT`: Declares `@ReorderLevel` as an integer output parameter.
    *   `SELECT @ReorderLevel = ROL`: Assigns the `ROL` value from the table to the output parameter.
    *   `DECLARE @rolValue INT;`: You need a variable in your script to *receive* the value from the `OUTPUT` parameter.
    *   `EXEC ..., @ReorderLevel = @rolValue OUTPUT;`: When calling, you specify the variable and the `OUTPUT` keyword.

**3.3 Procedure for Updates with Validation** (Adapted from Practical 6, Q4)

*   **Goal:** Update the selling price (`unitPrice`) only if the new price is positive.

```sql
-- Procedure to update unit price with basic validation
CREATE PROCEDURE UpdateProductPrice
    @prodId CHAR(4),
    @newPrice REAL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the product exists
    IF NOT EXISTS (SELECT 1 FROM Products WHERE productId = @prodId)
    BEGIN
        PRINT 'Error: Product ID ' + @prodId + ' not found. Record update terminated.';
        RETURN; -- Exit the procedure
    END;

    -- Check if the new price is valid (e.g., > 0)
    IF @newPrice <= 0
    BEGIN
        PRINT 'Error: Selling price must be greater than 0. Record update terminated.';
        RETURN; -- Exit the procedure
    END;

    -- If checks pass, perform the update
    UPDATE Products
    SET unitPrice = @newPrice
    WHERE productId = @prodId;

    PRINT 'Product ' + @prodId + ' price updated successfully to ' + CAST(@newPrice AS VARCHAR) + '.';

END;
GO

-- How to use it:
-- Successful update
EXEC UpdateProductPrice @prodId = 'P004', @newPrice = 5000.00;
SELECT productId, productName, unitPrice FROM Products WHERE productId = 'P004';

-- Failed update (invalid price)
EXEC UpdateProductPrice @prodId = 'P004', @newPrice = -100.00;

-- Failed update (product not found)
EXEC UpdateProductPrice @prodId = 'P999', @newPrice = 6000.00;
```

*   **Explanation:**
    *   Includes checks (`IF NOT EXISTS`, `IF @newPrice <= 0`) before performing the `UPDATE`.
    *   Uses `PRINT` to give feedback to the user.
    *   Uses `RETURN` to exit the procedure early if validation fails.

**3.4 Procedure for Inserting Order Data** (Adapted from Practical 6, Q6)

*   **Goal:** Insert records into both `Orders` and `orderDetails` tables transactionally.

```sql
-- Procedure to insert a new order with one detail line
CREATE PROCEDURE AddNewOrder
    -- Order Header Info
    @orderId INT,
    @empId CHAR(4),
    @custId CHAR(4),
    @orderDt DATE,
    @requiredDt DATE,
    -- Order Detail Info
    @prodId CHAR(4),
    @qty INT,
    @discount REAL
AS
BEGIN
    SET NOCOUNT ON;

    -- Basic validation (add more as needed - e.g., check if empId, custId, prodId exist)
    IF EXISTS (SELECT 1 FROM Orders WHERE oid = @orderId)
    BEGIN
        PRINT 'Error: Order ID ' + CAST(@orderId AS VARCHAR) + ' already exists.';
        RETURN;
    END
    IF @qty <= 0
    BEGIN
        PRINT 'Error: Quantity must be positive.';
        RETURN;
    END

    -- Use a transaction to ensure both inserts succeed or fail together
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insert into Orders table
        INSERT INTO Orders (oid, eid, cid, orderDate, requiredDate, shippedDate, cost)
        VALUES (@orderId, @empId, @custId, @orderDt, @requiredDt, NULL, NULL); -- Cost is null initially

        -- Insert into orderDetails table
        INSERT INTO orderDetails (oid, productId, quantity, discount)
        VALUES (@orderId, @prodId, @qty, @discount);

        -- If both inserts succeed, commit the transaction
        COMMIT TRANSACTION;
        PRINT 'Order ' + CAST(@orderId AS VARCHAR) + ' added successfully.';

    END TRY
    BEGIN CATCH
        -- If any error occurred, roll back the transaction
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Optional: Log the error or re-throw it
        PRINT 'Error adding order: ' + ERROR_MESSAGE();
        -- THROW; -- Use THROW in newer SQL Server versions to re-raise the error
        RETURN; -- Indicate failure
    END CATCH;
END;
GO

-- How to use it:
-- Add a new order (assuming Order ID 2 doesn't exist)
EXEC AddNewOrder
    @orderId = 2,
    @empId = 'E002',
    @custId = 'C003',
    @orderDt = '2023-10-27',
    @requiredDt = '2023-11-10',
    @prodId = 'P004',
    @qty = 10,
    @discount = 0.05;

-- Verify
SELECT * FROM Orders WHERE oid = 2;
SELECT * FROM orderDetails WHERE oid = 2;

-- Try adding an order that already exists
-- EXEC AddNewOrder @orderId = 1, @empId = 'E001', @custId = 'C001', @orderDt = '2023-10-28', @requiredDt = '2023-11-05', @prodId = 'P001', @qty = 1, @discount = 0;
```

*   **Explanation:**
    *   Takes parameters for both tables.
    *   Uses `BEGIN TRANSACTION`, `COMMIT TRANSACTION`, `ROLLBACK TRANSACTION` with `TRY...CATCH` to ensure atomicity (all or nothing). If the `INSERT` into `orderDetails` fails, the `INSERT` into `Orders` is undone.

---

### Part 5: SQL Triggers

Triggers are special stored procedures that automatically execute (fire) in response to certain events on a table or view. These events are typically `INSERT`, `UPDATE`, or `DELETE` operations.

**Why use Triggers?**

*   **Enforce Complex Business Rules:** Implement logic that constraints cannot handle.
*   **Maintain Data Integrity/Consistency:** Update related data automatically (e.g., audit trails, summary tables).
*   **Automation:** Perform actions automatically when data changes.

**Key Concepts:**

*   **`AFTER` Triggers:** Fire *after* the triggering DML operation (INSERT, UPDATE, DELETE) completes. Good for actions based on the final state, like logging or updating related tables.
*   **`INSTEAD OF` Triggers:** Fire *instead of* the triggering DML operation. Used mainly with Views to provide custom logic for updating underlying base tables.
*   **`inserted` and `deleted` Virtual Tables:** Triggers use these special tables:
    *   `inserted`: Contains the *new* rows being added by `INSERT` or `UPDATE`.
    *   `deleted`: Contains the *old* rows being removed by `DELETE` or updated by `UPDATE`.
    *   An `UPDATE` operation is like a `DELETE` followed by an `INSERT`, so both tables are populated.

Let's implement triggers from Practical 8.

**4.1 `AFTER UPDATE` Trigger: Reorder Level Check** (Practical 8, Part 1a)

*   **Goal:** When the `unitInStock` of a product is updated, if it falls below the `ROL`, insert a record into the `Items_to_Order` table.
*   **Type:** `AFTER UPDATE` on `Products` table.

```sql
-- Trigger to add items to Items_to_Order when stock falls below ROL
CREATE TRIGGER TR_Products_CheckROL
ON Products -- Trigger is on the Products table
AFTER UPDATE -- Fires after an update occurs
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the unitInStock column was actually part of the update
    IF UPDATE(unitInStock)
    BEGIN
        -- Insert into Items_to_Order for products where the new stock is below ROL
        -- and the old stock (if available) was not below ROL (optional, prevents duplicates if stock fluctuates near ROL)
        INSERT INTO Items_to_Order (ProductId, DateNotified)
        SELECT i.productId, GETDATE()
        FROM inserted i -- 'inserted' contains the rows AFTER the update
        WHERE i.unitInStock < i.ROL -- Check if new stock is below Re-Order Level
          AND NOT EXISTS ( -- Optional: Only insert if it wasn't already below ROL before this update
              SELECT 1
              FROM deleted d
              WHERE d.productId = i.productId AND d.unitInStock < d.ROL
          );
          -- Simpler version without checking old stock:
          -- WHERE i.unitInStock < i.ROL;
    END;
END;
GO

-- How to test it:
PRINT 'Before Update:';
SELECT productId, unitInStock, ROL FROM Products WHERE productId = 'P004'; -- Current stock 15, ROL 20 (Should not be in Items_to_Order yet)
SELECT * FROM Items_to_Order;

PRINT 'Updating P004 stock...';
-- Update stock to fall below ROL (e.g., sell 5)
UPDATE Products SET unitInStock = unitInStock - 5 WHERE productId = 'P004'; -- Stock becomes 10, ROL is 20

PRINT 'After Update:';
SELECT productId, unitInStock, ROL FROM Products WHERE productId = 'P004';
SELECT * FROM Items_to_Order; -- Should now contain an entry for P004

-- Update stock but stay above ROL (should not trigger insert)
-- UPDATE Products SET unitInStock = 60 WHERE productId = 'P001'; -- Stock 60, ROL 50
-- SELECT * FROM Items_to_Order;
```

*   **Explanation:**
    *   `ON Products AFTER UPDATE`: Defines the trigger event.
    *   `IF UPDATE(unitInStock)`: Checks if the `unitInStock` column was specifically mentioned in the `UPDATE` statement's `SET` clause. This prevents the trigger logic from running unnecessarily if other columns were updated.
    *   `FROM inserted i`: We query the `inserted` table which holds the state of the rows *after* the update.
    *   `WHERE i.unitInStock < i.ROL`: The core condition to check if reordering is needed.
    *   The `NOT EXISTS` part (optional but good practice) checks the `deleted` table (which holds the state *before* the update) to prevent inserting duplicate notifications if the stock was already below ROL.

**4.2 `AFTER INSERT` Trigger: Update Stock on Sale** (Practical 8, Part 1b)

*   **Goal:** When a new record is inserted into `orderDetails` (representing a sale), decrease the `unitInStock` in the `Products` table accordingly.
*   **Type:** `AFTER INSERT` on `orderDetails` table.

```sql
-- Trigger to update product stock after an order detail is inserted
CREATE TRIGGER TR_OrderDetails_UpdateStock
ON orderDetails -- Trigger is on the orderDetails table
AFTER INSERT -- Fires after an insert occurs
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the Products table by joining with the 'inserted' table
    UPDATE P
    SET P.unitInStock = P.unitInStock - i.quantity
    FROM Products P
    INNER JOIN inserted i ON P.productId = i.productId;

    -- Optional: Add check if stock becomes negative and raise an error/rollback
    IF EXISTS (SELECT 1 FROM Products P JOIN inserted i ON P.productId = i.productId WHERE P.unitInStock < 0)
    BEGIN
        RAISERROR ('Stock cannot go below zero. Transaction rolled back.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Optional: Check if the update caused stock to fall below ROL
    -- This might be redundant if TR_Products_CheckROL exists, but shows how it could be done here.
    /*
    INSERT INTO Items_to_Order (ProductId, DateNotified)
    SELECT i.productId, GETDATE()
    FROM inserted i
    JOIN Products P ON i.productId = P.productId
    WHERE P.unitInStock < P.ROL
      AND (P.unitInStock + i.quantity) >= P.ROL; -- Check if it just crossed the threshold
    */

END;
GO

-- How to test it:
PRINT 'Before Insert:';
SELECT productId, unitInStock FROM Products WHERE productId = 'P001'; -- Current stock 80 (or less if previous trigger ran)

-- Add a new detail line to Order 1 (assuming P001 wasn't already there)
-- If P001 already exists for order 1, this insert will fail due to PK constraint. Let's use Order 2 created earlier.
PRINT 'Inserting into Order 2...';
INSERT INTO orderDetails (oid, productId, quantity, discount)
VALUES (2, 'P001', 5, 0.1); -- Sell 5 units of P001 for Order 2

PRINT 'After Insert:';
SELECT productId, unitInStock FROM Products WHERE productId = 'P001'; -- Stock should be reduced by 5
SELECT * FROM orderDetails WHERE oid = 2;
```

*   **Explanation:**
    *   `ON orderDetails AFTER INSERT`: Defines the trigger event.
    *   `UPDATE P SET P.unitInStock = P.unitInStock - i.quantity ...`: The core logic. It updates the `Products` table (`P`).
    *   `FROM Products P INNER JOIN inserted i ON P.productId = i.productId`: It joins `Products` with the `inserted` table (which contains the newly added `orderDetails` rows) to know *which* products and *how many* (`i.quantity`) were sold. This correctly handles multi-row inserts.
    *   `RAISERROR...ROLLBACK`: Example of adding validation *within* the trigger to prevent invalid states (like negative stock).

**4.3 `AFTER INSERT, UPDATE` Trigger: Salary Check** (Practical 8, Part 2a)

*   **Goal:** Prevent an employee's salary from being set higher than their supervisor's salary during `INSERT` or `UPDATE`.
*   **Type:** `AFTER INSERT, UPDATE` on `Employee` table.

```sql
-- Trigger to check employee salary against supervisor's salary
CREATE TRIGGER TR_Employee_CheckSalary
ON Employees -- Trigger on Employee table (using the schema from Trigger Part 2)
AFTER INSERT, UPDATE -- Fires after INSERT or UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check only if the salary column was potentially affected
    IF UPDATE(salary)
    BEGIN
        -- Check if any inserted/updated employee's salary exceeds their supervisor's
        IF EXISTS (
            SELECT 1
            FROM inserted i -- New/updated employee data
            JOIN Employees supervisor ON i.supervld = supervisor.eid -- Find the supervisor
            WHERE i.salary > supervisor.salary -- The condition to check
              AND i.supervld IS NOT NULL -- Only check if there IS a supervisor
        )
        BEGIN
            -- If the condition is met, raise an error and roll back
            RAISERROR ('Employee salary cannot exceed supervisor''s salary. Transaction rolled back.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
    END;
END;
GO

-- How to test it:
PRINT 'Supervisor (e001) Salary:';
SELECT salary FROM Employees WHERE eid = 'e001'; -- Saman's salary (70000)

PRINT 'Employee (e002) Salary:';
SELECT salary FROM Employees WHERE eid = 'e002'; -- Kamal's salary (34000), supervisor is e001

-- Try updating Kamal's salary to be less than Saman's (should work)
PRINT 'Updating Kamal salary (valid)...';
UPDATE Employees SET salary = 60000.00 WHERE eid = 'e002';
SELECT salary FROM Employees WHERE eid = 'e002'; -- Should show 60000

-- Try updating Kamal's salary to be more than Saman's (should fail and rollback)
PRINT 'Updating Kamal salary (invalid)...';
UPDATE Employees SET salary = 80000.00 WHERE eid = 'e002'; -- This should raise an error

-- Verify Kamal's salary after the failed attempt (should be rolled back to 60000)
SELECT salary FROM Employees WHERE eid = 'e002';

-- Try inserting a new employee with salary > supervisor's (should fail)
PRINT 'Inserting new employee (invalid salary)...';
-- Assuming e001's salary is 70000
-- INSERT INTO Employees (eid, ename, age, salary, did, supervld)
-- VALUES ('e008', 'Test', 25, 90000.00, 'd001', 'e001'); -- This should raise an error
```

*   **Explanation:**
    *   `ON Employees AFTER INSERT, UPDATE`: Fires for both operations.
    *   `IF UPDATE(salary)`: Focuses the check only when the salary might have changed.
    *   `FROM inserted i JOIN Employees supervisor ON i.supervld = supervisor.eid`: Joins the `inserted` table (containing the employee(s) being changed) with the `Employees` table itself (aliased as `supervisor`) to get the supervisor's details based on `i.supervld`.
    *   `WHERE i.salary > supervisor.salary AND i.supervld IS NOT NULL`: Checks the salary condition, making sure to only compare when a supervisor exists.
    *   `RAISERROR...ROLLBACK`: If an invalid salary is detected, an error is shown, and the entire transaction (the `INSERT` or `UPDATE` that fired the trigger) is cancelled.

**4.4 `INSTEAD OF` Trigger: Inserting into a View** (Practical 8, Part 2c)

*   **Goal:** Allow `INSERT` operations on the `DeptMgr_Details` view, translating them into inserts into the underlying `Department` and potentially `Employee` tables (if the manager doesn't exist - this part is complex and often not recommended; we'll simplify). Let's assume the manager *must* exist for this example.
*   **Type:** `INSTEAD OF INSERT` on `DeptMgr_Details` view.

```sql
-- INSTEAD OF trigger on the DeptMgr_Details view for INSERTs
CREATE TRIGGER TR_DeptMgrDetails_InsteadOfInsert
ON DeptMgr_Details -- Trigger is on the VIEW
INSTEAD OF INSERT -- Fires INSTEAD OF the insert operation on the view
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into the base table(s) using data from the 'inserted' virtual table (which matches the view structure)

    -- Validation: Check if required values are provided and if manager exists
    IF EXISTS (SELECT 1 FROM inserted WHERE did IS NULL OR dname IS NULL)
    BEGIN
        RAISERROR('Department ID and Name are required.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM inserted i LEFT JOIN Employees E ON i.mgrid = E.eid WHERE i.mgrid IS NOT NULL AND E.eid IS NULL)
    BEGIN
        RAISERROR('Specified Manager ID (mgrid) does not exist in the Employee table.', 16, 1);
        RETURN;
    END;

    -- Check if department already exists
     IF EXISTS (SELECT 1 FROM Department D JOIN inserted i ON D.did = i.did)
    BEGIN
        RAISERROR('Department ID already exists.', 16, 1);
        RETURN;
    END;


    -- Perform the actual insert into the base table (Department)
    -- We are ONLY inserting into Department here. Inserting into Employee based on view data is tricky.
    INSERT INTO Department (did, dname, budget, mgrid)
    SELECT
        i.did,
        i.dname,
        i.budget, -- Takes budget from the view insert statement
        i.mgrid   -- Takes manager id from the view insert statement
    FROM inserted i;

    PRINT 'Department record(s) inserted successfully via view.';

END;
GO

-- How to test it:
SELECT * FROM DeptMgr_Details ORDER BY did;

-- Try inserting a new Department via the View (Manager e004 exists)
PRINT 'Inserting d005 via view (valid)...';
INSERT INTO DeptMgr_Details (did, dname, budget, mgrid, mgrname, MgrAge, MgrSalary, MgrSupervisorId)
VALUES ('d005', 'Marketing', 450000.00, 'e004', NULL, NULL, NULL, NULL); -- Manager details in the VALUES are ignored by this trigger

-- Verify in base table and view
SELECT * FROM Department WHERE did = 'd005';
SELECT * FROM DeptMgr_Details WHERE did = 'd005';

-- Try inserting with a non-existent manager (should fail)
PRINT 'Inserting d006 via view (invalid manager)...';
-- INSERT INTO DeptMgr_Details (did, dname, budget, mgrid)
-- VALUES ('d006', 'Research', 600000.00, 'e999'); -- e999 does not exist

-- Try inserting a duplicate department ID (should fail)
PRINT 'Inserting d001 again via view (duplicate)...';
-- INSERT INTO DeptMgr_Details (did, dname, budget, mgrid)
-- VALUES ('d001', 'HR New', 300000.00, 'e002');
```

*   **Explanation:**
    *   `ON DeptMgr_Details INSTEAD OF INSERT`: The trigger intercepts `INSERT` statements aimed at the view.
    *   The code *inside* the trigger defines what *should* happen instead – in this case, validating the input (from the `inserted` table which mirrors the view's columns) and performing an `INSERT` into the actual `Department` base table.
    *   Note that columns in the `INSERT` statement targeting the view that *don't* correspond to underlying base table columns (like `mgrname`, `MgrAge` etc. in this view) are available in the `inserted` table but are ignored by our trigger's `INSERT INTO Department` statement unless explicitly used for validation or other logic.
    *   `INSTEAD OF` triggers are powerful but can become complex, especially for views involving multiple tables or aggregations.

---

**Conclusion**

You've now explored several powerful SQL features available in Microsoft SQL Server:

*   **Functions (Scalar and Table-Valued):** For encapsulating calculations and reusable query logic.
*   **Views:** For simplifying queries, controlling access, and providing stable interfaces to changing data.
*   **Stored Procedures:** For performance, security, and modularizing database operations.
*   **Triggers (AFTER and INSTEAD OF):** For automating actions and enforcing complex business rules based on data modifications.

These tools are essential for building robust, efficient, and secure database applications. Remember to practice these concepts using the examples provided and try applying them to different scenarios. The best way to learn is by doing!

Good luck with your future database endeavors! 🏁