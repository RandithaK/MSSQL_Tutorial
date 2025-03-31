## Repository Contents
# Database Management Systems - SQL Examples

This repository contains SQL scripts and examples to help you learn and practice various aspects of Database Management Systems using Microsoft SQL Server (MSSQL).

## Repository Contents

This collection includes SQL scripts demonstrating:

- **SQL Joins** - INNER, LEFT, RIGHT, FULL OUTER, CROSS, and Self joins
- **SQL Views** - Simple, Complex, and With Check Option views for data abstraction
- **SQL Functions** - Scalar and Table-Valued Functions for code reusability
- **SQL Stored Procedures** - For encapsulating business logic and improving performance
- **SQL Triggers** - AFTER INSERT/UPDATE and INSTEAD OF triggers for data integrity
- **Comprehensive MSSQL Tutorial** - A detailed guide explaining all concepts

## Directory Structure

```
.
├── CreateDatabase.sql         # Base database creation script with sample data
├── Joins/                     # SQL Join examples
│   ├── Joins_1.sql            # INNER JOIN with Orders and Customers
│   ├── Joins_2.sql            # INNER JOIN with OrderDetails and Products
│   ├── Joins_3.sql            # LEFT JOIN with Customers and Orders
│   ├── Joins_4.sql            # LEFT JOIN with Employees and Departments
│   ├── Joins_5.sql            # RIGHT JOIN example
│   ├── Joins_6.sql            # RIGHT JOIN for finding products never ordered
│   ├── Joins_7.sql            # FULL OUTER JOIN example
│   ├── Joins_8.sql            # CROSS JOIN example
│   └── Joins_9.sql            # Self JOIN with Employees and Supervisors
├── Views/                     # SQL View examples
│   ├── Views_1.sql            # Simple view for Sri Lankan customers
│   ├── Views_2.sql            # Complex view for detailed order info
│   ├── Views_3.sql            # View with CHECK OPTION
│   └── Views_4.sql            # View joining Department and Employee
├── Functions/                 # SQL Function examples
│   ├── Functions_1.sql        # Scalar function to calculate order cost
│   ├── Functions_2.sql        # Table-valued function for products in order
│   ├── Functions_3.sql        # Modified function with filtering
│   ├── Functions_4.sql        # Function for detailed order information
│   └── Functions_5.sql        # Conditional discount function
├── Stored Procedures/         # SQL Stored Procedure examples
│   ├── StoredProcedures_1.sql # Simple procedure to get product info
│   ├── StoredProcedures_2.sql # Procedure with OUTPUT parameter
│   ├── StoredProcedures_3.sql # Procedure with validation
│   └── StoredProcedures_4.sql # Transactional procedure for order creation
├── Triggers/                  # SQL Trigger examples
│   ├── Triggers_1.sql         # AFTER UPDATE trigger for reorder level
│   ├── Triggers_2.sql         # AFTER INSERT trigger for updating stock
│   ├── Triggers_3.sql         # Trigger for salary check against supervisor
│   └── Triggers_4.sql         # INSTEAD OF trigger for view insertions
└── MSSQL Tutorial.md          # Comprehensive tutorial document
```

## Getting Started

### Prerequisites

- Microsoft SQL Server (any recent version)
- SQL Server Management Studio or VSCode with SQL Server extension

### Setup Instructions

1. Clone this repository
2. Open SQL Server Management Studio or your preferred SQL client
3. Execute the `CreateDatabase.sql` script first to set up the OnlineStoreDB and sample data
4. Run individual example scripts as needed

## Usage Examples

Each script is self-contained with:
- SQL code implementing the specific database feature
- Detailed comments explaining the implementation and concepts
- Test cases to demonstrate functionality in action
- Output examples where relevant

### Example: Running a Join Script

1. Execute `CreateDatabase.sql` to create the database structure
2. Run `Joins/Joins_1.sql` to see how INNER JOINs work between Orders and Customers
3. Examine the results and comments to understand the JOIN operation

### Example: Running a Function Script

1. Execute `CreateDatabase.sql` to create the database structure
2. Run `Functions/Functions_1.sql` to create a scalar function for order cost calculation
3. Test the function using the provided examples at the end of the script

## Learning Path

Suggested learning order:

1. Basic SQL (prerequisite)
2. SQL Joins (start with Joins_1.sql) - Fundamental for understanding relational data
3. SQL Views (start with Views_1.sql) - Building on joins to create virtual tables
4. SQL Functions (start with Functions_1.sql) - Creating reusable code modules
5. SQL Stored Procedures (start with StoredProcedures_1.sql) - Encapsulating logic
6. SQL Triggers (start with Triggers_1.sql) - Adding automated behaviors

---

*Read the comprehensive MSSQL Tutorial.md for detailed explanations of all concepts. This collection includes SQL scripts demonstrating*