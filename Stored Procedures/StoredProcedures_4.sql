-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! TRANSACTIONAL STORED PROCEDURE: New Order Creation
--* Purpose: Demonstrates transaction handling for atomic multi-table operations
--* This procedure inserts a new order header and detail line as a single transaction

CREATE PROCEDURE AddNewOrder
    --* Order Header Parameters
    @orderId INT,           -- Primary key for new order
    @empId CHAR(4),         -- Employee handling the order
    @custId CHAR(4),        -- Customer placing the order
    @orderDt DATE,          -- Date order was placed
    @requiredDt DATE,       -- Requested delivery date
    --* Order Detail Parameters
    @prodId CHAR(4),        -- Product being ordered
    @qty INT,               -- Quantity ordered
    @discount REAL          -- Discount applied (0-1 range)
AS
BEGIN
    SET NOCOUNT ON;

    --! Input Validation (defensive programming)
    --? Checking for existing order ID
    IF EXISTS (SELECT 1 FROM Orders WHERE oid = @orderId)
    BEGIN
        PRINT 'Error: Order ID ' + CAST(@orderId AS VARCHAR) + ' already exists.';
        RETURN;
    END
    
    --? Validating quantity is positive
    IF @qty <= 0
    BEGIN
        PRINT 'Error: Quantity must be positive.';
        RETURN;
    END

    --! TRANSACTION HANDLING
    --* Begin transaction to ensure data consistency across tables
    BEGIN TRANSACTION;

    BEGIN TRY
        --* Step 1: Create order header record
        INSERT INTO Orders (oid, eid, cid, orderDate, requiredDate, shippedDate, cost)
        VALUES (@orderId, @empId, @custId, @orderDt, @requiredDt, NULL, NULL);

        --* Step 2: Create order detail record
        INSERT INTO orderDetails (oid, productId, quantity, discount)
        VALUES (@orderId, @prodId, @qty, @discount);

        --* Commit transaction if both operations succeed
        COMMIT TRANSACTION;
        PRINT 'Order ' + CAST(@orderId AS VARCHAR) + ' added successfully.';

    END TRY
    BEGIN CATCH
        --! Error handling - rollback on any failure
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        --* Provide meaningful error information
        PRINT 'Error adding order: ' + ERROR_MESSAGE();
        
        --? For production systems, consider logging the error details:
        --? - ERROR_NUMBER() - Error number
        --? - ERROR_SEVERITY() - Error severity
        --? - ERROR_STATE() - Error state
        --? - ERROR_LINE() - Line number where error occurred
        
        RETURN;
    END CATCH;
END;
GO

--! TEST SCRIPT: Verify Order Creation

--* Scenario 1: Create a new order successfully
EXEC AddNewOrder
    @orderId = 2,
    @empId = 'E002',
    @custId = 'C003',
    @orderDt = '2023-10-27',
    @requiredDt = '2023-11-10',
    @prodId = 'P004',
    @qty = 10,
    @discount = 0.05;

--* Verification queries
SELECT * FROM Orders WHERE oid = 2;
SELECT * FROM orderDetails WHERE oid = 2;

--? Additional test scenarios (commented out to prevent execution)
--? Test duplicate order ID (should fail):
-- EXEC AddNewOrder @orderId = 1, @empId = 'E001', @custId = 'C001', 
--   @orderDt = '2023-10-28', @requiredDt = '2023-11-05', 
--   @prodId = 'P001', @qty = 1, @discount = 0;

--TODO: Enhance procedure to support multiple order details in a single transaction