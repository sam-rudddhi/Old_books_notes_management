# Fix for MySQL Error #1442 - Images Table Trigger

## Problem
Error: **#1442 - Can't update table 'images' in stored function/trigger because it is already used by statement which invoked this stored function/trigger**

This error occurs in the `trg_primary_image_before_insert` trigger because it tries to UPDATE the `images` table while an INSERT operation on the same table is in progress.

## Root Cause
The trigger at lines 612-620 in `complete_database.sql`:

```sql
CREATE TRIGGER trg_primary_image_before_insert
BEFORE INSERT ON images
FOR EACH ROW
BEGIN
    IF NEW.is_primary = TRUE THEN
        UPDATE images SET is_primary = FALSE 
        WHERE item_type = NEW.item_type AND item_id = NEW.item_id;
    END IF;
END //
```

MySQL doesn't allow a trigger to modify the same table that invoked it.

## Solution Options

### Option 1: Remove the Trigger (Simplest)
If you don't strictly need automatic primary image enforcement, you can drop this trigger:

```sql
DROP TRIGGER IF EXISTS trg_primary_image_before_insert;
```

Then handle primary image logic in your application code.

### Option 2: Use Application-Level Logic (Recommended)
Handle the primary image enforcement in your application:

1. Drop the trigger:
```sql
DROP TRIGGER IF EXISTS trg_primary_image_before_insert;
```

2. Before inserting a new primary image, manually update existing ones:
```sql
-- First, unset other primary images
UPDATE images SET is_primary = FALSE 
WHERE item_type = 'book' AND item_id = 1;

-- Then insert the new primary image
INSERT INTO images (img_url, is_primary, item_id, item_type)
VALUES ('/uploads/books/new_primary.jpg', TRUE, 1, 'book');
```

### Option 3: Use a Stored Procedure (Best Practice)
Create a stored procedure to handle image insertion with primary image logic:

```sql
DELIMITER //

CREATE PROCEDURE sp_add_image(
    IN p_img_url VARCHAR(500),
    IN p_is_primary BOOLEAN,
    IN p_item_id INT,
    IN p_item_type VARCHAR(10),
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_message = 'Error: Unable to add image';
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    -- If this is a primary image, unset others first
    IF p_is_primary = TRUE THEN
        UPDATE images SET is_primary = FALSE 
        WHERE item_type = p_item_type AND item_id = p_item_id;
    END IF;
    
    -- Insert the new image
    INSERT INTO images (img_url, is_primary, item_id, item_type)
    VALUES (p_img_url, p_is_primary, p_item_id, p_item_type);
    
    SET p_message = 'Image added successfully';
    COMMIT;
END //

DELIMITER ;
```

Then use it like this:
```sql
CALL sp_add_image('/uploads/books/new_primary.jpg', TRUE, 1, 'book', @msg);
SELECT @msg;
```

## Quick Fix Steps

### Step 1: Drop the Problematic Trigger
```sql
USE old_books_notes_db;
DROP TRIGGER IF EXISTS trg_primary_image_before_insert;
```

### Step 2: Add the Stored Procedure (Optional but Recommended)
Run the stored procedure code from Option 3 above.

### Step 3: Update Your Code
When inserting images, either:
- Use the stored procedure: `CALL sp_add_image(...)`
- Or manually handle the logic in your application

## Testing After Fix

Test that you can now insert images without errors:

```sql
-- This should work now
INSERT INTO images (img_url, is_primary, item_id, item_type)
VALUES ('/uploads/books/test_image.jpg', TRUE, 1, 'book');

-- Verify
SELECT * FROM images WHERE item_type = 'book' AND item_id = 1;
```

## Why This Happens

MySQL has a restriction that prevents triggers from modifying the same table that invoked them. This is to prevent:
- Infinite loops
- Unpredictable behavior
- Performance issues

The solution is to move the logic outside the trigger, either to:
- Application code
- Stored procedures
- AFTER triggers on different tables (not applicable here)

## Summary

**Recommended approach:** Drop the trigger and use the stored procedure `sp_add_image` for inserting images. This gives you:
- ✅ No trigger conflicts
- ✅ Better control and error handling
- ✅ Transaction safety
- ✅ Cleaner separation of concerns
