-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

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