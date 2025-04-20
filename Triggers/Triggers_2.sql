-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! AFTER INSERT TRIGGER: Inventory Management
--* Purpose: Automatically updates product stock levels when order details are created
--* This trigger demonstrates real-time inventory management in a transactional system

CREATE TRIGGER TR_OrderDetails_UpdateStock
ON orderDetails 
AFTER INSERT 
AS
BEGIN
    SET NOCOUNT ON;

    --* Step 1: Update product inventory by subtracting ordered quantities
    UPDATE P
    SET P.unitInStock = P.unitInStock - i.quantity
    FROM Products P
    INNER JOIN inserted i ON P.productId = i.productId;

    --! Step 2: Prevent negative inventory with validation
    IF EXISTS (SELECT 1 FROM Products P JOIN inserted i ON P.productId = i.productId WHERE P.unitInStock < 0)
    BEGIN
        --? Business rule: We don't allow orders that exceed available inventory
        RAISERROR ('Stock cannot go below zero. Transaction rolled back.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    --? Optional enhancement: Auto-generate reorder notices
    --? This could be redundant if TR_Products_CheckROL exists
    /*
    INSERT INTO Items_to_Order (ProductId, DateNotified)
    SELECT i.productId, GETDATE()
    FROM inserted i
    JOIN Products P ON i.productId = P.productId
    WHERE P.unitInStock < P.ROL
      AND (P.unitInStock + i.quantity) >= P.ROL; -- Only if this order pushed it below ROL
    */
END;
GO

--! TEST SCRIPT: Verify Stock Update Functionality

--* Step 1: Check current inventory level
PRINT 'Before Insert:';
SELECT productId, unitInStock FROM Products WHERE productId = 'P001';

--* Step 2: Create a new order detail that should reduce stock
PRINT 'Inserting into Order 2...';
INSERT INTO orderDetails (oid, productId, quantity, discount)
VALUES (2, 'P001', 5, 0.1); -- Sell 5 units of P001

--* Step 3: Verify inventory was reduced
PRINT 'After Insert:';
SELECT productId, unitInStock FROM Products WHERE productId = 'P001'; -- Should be reduced by 5
SELECT * FROM orderDetails WHERE oid = 2;

--TODO: Add batch order processing capability with pre-validation