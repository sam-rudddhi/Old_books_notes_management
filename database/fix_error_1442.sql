-- =====================================================
-- FIX FOR MySQL ERROR #1442
-- Can't update table 'images' in stored function/trigger
-- =====================================================
-- Run this script if you already have the database installed
-- and are encountering the error #1442

USE old_books_notes_db;

-- Step 1: Drop the problematic trigger
DROP TRIGGER IF EXISTS trg_primary_image_before_insert;

-- Step 2: Add the replacement stored procedure
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

-- Step 3: Test the fix
-- Try adding a new image using the stored procedure
CALL sp_add_image(
    '/uploads/books/test_fix.jpg',
    TRUE,
    1,
    'book',
    @result
);

-- Check the result
SELECT @result AS message;

-- Verify the image was added
SELECT * FROM images WHERE item_type = 'book' AND item_id = 1;

-- =====================================================
-- USAGE EXAMPLES
-- =====================================================

-- Example 1: Add a primary image for a book
CALL sp_add_image('/uploads/books/book1_cover.jpg', TRUE, 1, 'book', @msg);
SELECT @msg;

-- Example 2: Add a non-primary image for a book
CALL sp_add_image('/uploads/books/book1_back.jpg', FALSE, 1, 'book', @msg);
SELECT @msg;

-- Example 3: Add a primary image for a note
CALL sp_add_image('/uploads/notes/note1_preview.jpg', TRUE, 1, 'note', @msg);
SELECT @msg;

-- =====================================================
-- VERIFICATION
-- =====================================================

-- Check all triggers (should not see trg_primary_image_before_insert)
SHOW TRIGGERS FROM old_books_notes_db;

-- Check all procedures (should see sp_add_image)
SHOW PROCEDURE STATUS WHERE Db = 'old_books_notes_db';

SELECT 'Fix applied successfully! Use sp_add_image to add images.' AS status;
