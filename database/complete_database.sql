-- =====================================================
-- OLD NOTES AND BOOKS MANAGEMENT SYSTEM
-- Complete Database with PL/SQL Features
-- For MySQL Workbench / phpMyAdmin
-- =====================================================

-- Drop database if exists and create fresh
DROP DATABASE IF EXISTS old_books_notes_db;
CREATE DATABASE old_books_notes_db;
USE old_books_notes_db;

-- =====================================================
-- TABLE DEFINITIONS
-- =====================================================

-- 1. USER TABLE
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address TEXT,
    contact_email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('admin', 'buyer', 'seller') DEFAULT 'buyer',
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (contact_email),
    INDEX idx_role (role)
) ENGINE=InnoDB;

-- 2. CATEGORY TABLE
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category_name (category_name)
) ENGINE=InnoDB;

-- 3. BOOK TABLE
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    edition VARCHAR(50),
    `condition` ENUM('new', 'like-new', 'good', 'fair', 'poor') DEFAULT 'good',
    price DECIMAL(10,2) NOT NULL,
    quantity INT DEFAULT 1,
    category_id INT,
    seller_id INT NOT NULL,
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_title (title),
    INDEX idx_author (author),
    INDEX idx_category (category_id),
    INDEX idx_seller (seller_id),
    INDEX idx_price (price)
) ENGINE=InnoDB;

-- 4. NOTE TABLE
CREATE TABLE notes (
    note_id INT PRIMARY KEY AUTO_INCREMENT,
    subject VARCHAR(100) NOT NULL,
    topic VARCHAR(255) NOT NULL,
    format ENUM('pdf', 'handwritten', 'printed', 'digital') DEFAULT 'digital',
    summary TEXT,
    price DECIMAL(10,2) NOT NULL,
    note_quantity INT DEFAULT 1,
    category_id INT,
    seller_id INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_subject (subject),
    INDEX idx_topic (topic),
    INDEX idx_category (category_id),
    INDEX idx_seller (seller_id)
) ENGINE=InnoDB;

-- 5. REVIEW TABLE
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    comment TEXT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    item_id INT NOT NULL,
    item_type ENUM('book', 'note') NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_item (item_type, item_id),
    INDEX idx_user (user_id),
    INDEX idx_rating (rating)
) ENGINE=InnoDB;

-- 6. IMAGE TABLE
CREATE TABLE images (
    img_url VARCHAR(500) PRIMARY KEY,
    is_primary BOOLEAN DEFAULT FALSE,
    uploaded_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    item_id INT NOT NULL,
    item_type ENUM('book', 'note') NOT NULL,
    INDEX idx_item (item_type, item_id)
) ENGINE=InnoDB;

-- 7. TRANSACTION TABLE
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'completed', 'cancelled', 'refunded') DEFAULT 'pending',
    item_type ENUM('book', 'note') NOT NULL,
    item_id INT NOT NULL,
    quantity INT DEFAULT 1,
    buyer_id INT NOT NULL,
    seller_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_buyer (buyer_id),
    INDEX idx_seller (seller_id),
    INDEX idx_status (status),
    INDEX idx_item (item_type, item_id)
) ENGINE=InnoDB;

-- 8. PAYMENT TABLE
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    gateway_ref VARCHAR(255),
    payment_method ENUM('card', 'upi', 'netbanking', 'wallet', 'cod') DEFAULT 'card',
    transaction_id INT NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE,
    INDEX idx_transaction (transaction_id),
    INDEX idx_status (payment_status)
) ENGINE=InnoDB;

-- =====================================================
-- AUDIT/LOG TABLES FOR TRIGGERS
-- =====================================================

-- Audit log for tracking changes
CREATE TABLE audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    record_id INT NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_by INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_table (table_name),
    INDEX idx_operation (operation)
) ENGINE=InnoDB;

-- Inventory log for tracking stock changes
CREATE TABLE inventory_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    item_type ENUM('book', 'note') NOT NULL,
    item_id INT NOT NULL,
    old_quantity INT,
    new_quantity INT,
    change_reason VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_item (item_type, item_id)
) ENGINE=InnoDB;

-- =====================================================
-- VIEWS
-- =====================================================

-- View: Available Books with Details
CREATE OR REPLACE VIEW v_available_books AS
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.isbn,
    b.edition,
    b.condition,
    b.price,
    b.quantity,
    c.category_name,
    u.name AS seller_name,
    u.contact_email AS seller_email,
    u.phone AS seller_phone,
    COALESCE(AVG(r.rating), 0) AS avg_rating,
    COUNT(DISTINCT r.review_id) AS review_count,
    b.created_at
FROM books b
LEFT JOIN categories c ON b.category_id = c.category_id
LEFT JOIN users u ON b.seller_id = u.user_id
LEFT JOIN reviews r ON r.item_type = 'book' AND r.item_id = b.book_id
WHERE b.is_available = TRUE AND b.quantity > 0
GROUP BY b.book_id;

-- View: Available Notes with Details
CREATE OR REPLACE VIEW v_available_notes AS
SELECT 
    n.note_id,
    n.subject,
    n.topic,
    n.format,
    n.summary,
    n.price,
    n.note_quantity,
    c.category_name,
    u.name AS seller_name,
    u.contact_email AS seller_email,
    COALESCE(AVG(r.rating), 0) AS avg_rating,
    COUNT(DISTINCT r.review_id) AS review_count,
    n.created_at
FROM notes n
LEFT JOIN categories c ON n.category_id = c.category_id
LEFT JOIN users u ON n.seller_id = u.user_id
LEFT JOIN reviews r ON r.item_type = 'note' AND r.item_id = n.note_id
WHERE n.is_available = TRUE AND n.note_quantity > 0
GROUP BY n.note_id;

-- View: Transaction Summary
CREATE OR REPLACE VIEW v_transaction_summary AS
SELECT 
    t.transaction_id,
    t.transaction_date,
    t.total_amount,
    t.status,
    t.item_type,
    t.quantity,
    buyer.name AS buyer_name,
    buyer.contact_email AS buyer_email,
    seller.name AS seller_name,
    seller.contact_email AS seller_email,
    CASE 
        WHEN t.item_type = 'book' THEN b.title
        WHEN t.item_type = 'note' THEN n.topic
    END AS item_name,
    p.payment_status,
    p.payment_method,
    p.payment_date
FROM transactions t
LEFT JOIN users buyer ON t.buyer_id = buyer.user_id
LEFT JOIN users seller ON t.seller_id = seller.user_id
LEFT JOIN books b ON t.item_type = 'book' AND t.item_id = b.book_id
LEFT JOIN notes n ON t.item_type = 'note' AND t.item_id = n.note_id
LEFT JOIN payments p ON t.transaction_id = p.transaction_id;

-- View: Dashboard Statistics
CREATE OR REPLACE VIEW v_dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM users WHERE is_active = TRUE) AS total_active_users,
    (SELECT COUNT(*) FROM users WHERE role = 'seller') AS total_sellers,
    (SELECT COUNT(*) FROM users WHERE role = 'buyer') AS total_buyers,
    (SELECT COUNT(*) FROM books WHERE is_available = TRUE) AS available_books,
    (SELECT COUNT(*) FROM notes WHERE is_available = TRUE) AS available_notes,
    (SELECT COUNT(*) FROM transactions WHERE status = 'completed') AS completed_transactions,
    (SELECT COUNT(*) FROM transactions WHERE status = 'pending') AS pending_transactions,
    (SELECT COALESCE(SUM(total_amount), 0) FROM transactions WHERE status = 'completed') AS total_revenue,
    (SELECT COUNT(*) FROM reviews) AS total_reviews,
    (SELECT COALESCE(AVG(rating), 0) FROM reviews) AS average_rating;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

DELIMITER //

-- Procedure 1: Add New Book
CREATE PROCEDURE sp_add_book(
    IN p_title VARCHAR(255),
    IN p_author VARCHAR(100),
    IN p_isbn VARCHAR(20),
    IN p_edition VARCHAR(50),
    IN p_condition VARCHAR(20),
    IN p_price DECIMAL(10,2),
    IN p_quantity INT,
    IN p_category_id INT,
    IN p_seller_id INT,
    IN p_description TEXT,
    OUT p_book_id INT,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_message = 'Error: Unable to add book';
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    -- Insert book
    INSERT INTO books (title, author, isbn, edition, `condition`, price, quantity, category_id, seller_id, description)
    VALUES (p_title, p_author, p_isbn, p_edition, p_condition, p_price, p_quantity, p_category_id, p_seller_id, p_description);
    
    SET p_book_id = LAST_INSERT_ID();
    SET p_message = CONCAT('Book added successfully with ID: ', p_book_id);
    
    COMMIT;
END //

-- Procedure 2: Add New Note
CREATE PROCEDURE sp_add_note(
    IN p_subject VARCHAR(100),
    IN p_topic VARCHAR(255),
    IN p_format VARCHAR(20),
    IN p_summary TEXT,
    IN p_price DECIMAL(10,2),
    IN p_note_quantity INT,
    IN p_category_id INT,
    IN p_seller_id INT,
    OUT p_note_id INT,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_message = 'Error: Unable to add note';
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO notes (subject, topic, format, summary, price, note_quantity, category_id, seller_id)
    VALUES (p_subject, p_topic, p_format, p_summary, p_price, p_note_quantity, p_category_id, p_seller_id);
    
    SET p_note_id = LAST_INSERT_ID();
    SET p_message = CONCAT('Note added successfully with ID: ', p_note_id);
    
    COMMIT;
END //

-- Procedure 3: Create Transaction and Update Inventory
CREATE PROCEDURE sp_create_transaction(
    IN p_item_type VARCHAR(10),
    IN p_item_id INT,
    IN p_quantity INT,
    IN p_buyer_id INT,
    OUT p_transaction_id INT,
    OUT p_total_amount DECIMAL(10,2),
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_available_qty INT;
    DECLARE v_seller_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_message = 'Error: Transaction failed';
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    -- Get item details
    IF p_item_type = 'book' THEN
        SELECT price, quantity, seller_id INTO v_price, v_available_qty, v_seller_id
        FROM books WHERE book_id = p_item_id AND is_available = TRUE;
    ELSEIF p_item_type = 'note' THEN
        SELECT price, note_quantity, seller_id INTO v_price, v_available_qty, v_seller_id
        FROM notes WHERE note_id = p_item_id AND is_available = TRUE;
    END IF;
    
    -- Check availability
    IF v_available_qty IS NULL THEN
        SET p_message = 'Error: Item not found or not available';
        ROLLBACK;
    ELSEIF v_available_qty < p_quantity THEN
        SET p_message = CONCAT('Error: Only ', v_available_qty, ' items available');
        ROLLBACK;
    ELSE
        -- Calculate total
        SET p_total_amount = v_price * p_quantity;
        
        -- Create transaction
        INSERT INTO transactions (item_type, item_id, quantity, total_amount, buyer_id, seller_id)
        VALUES (p_item_type, p_item_id, p_quantity, p_total_amount, p_buyer_id, v_seller_id);
        
        SET p_transaction_id = LAST_INSERT_ID();
        
        -- Update quantity
        IF p_item_type = 'book' THEN
            UPDATE books SET quantity = quantity - p_quantity WHERE book_id = p_item_id;
        ELSEIF p_item_type = 'note' THEN
            UPDATE notes SET note_quantity = note_quantity - p_quantity WHERE note_id = p_item_id;
        END IF;
        
        SET p_message = CONCAT('Transaction created successfully. ID: ', p_transaction_id);
        COMMIT;
    END IF;
END //

-- Procedure 4: Process Payment
CREATE PROCEDURE sp_process_payment(
    IN p_transaction_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_payment_method VARCHAR(20),
    IN p_gateway_ref VARCHAR(255),
    OUT p_payment_id INT,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_transaction_amount DECIMAL(10,2);
    DECLARE v_transaction_status VARCHAR(20);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_message = 'Error: Payment processing failed';
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    -- Verify transaction
    SELECT total_amount, status INTO v_transaction_amount, v_transaction_status
    FROM transactions WHERE transaction_id = p_transaction_id;
    
    IF v_transaction_amount IS NULL THEN
        SET p_message = 'Error: Transaction not found';
        ROLLBACK;
    ELSEIF v_transaction_status != 'pending' THEN
        SET p_message = 'Error: Transaction already processed';
        ROLLBACK;
    ELSEIF v_transaction_amount != p_amount THEN
        SET p_message = 'Error: Payment amount mismatch';
        ROLLBACK;
    ELSE
        -- Insert payment
        INSERT INTO payments (amount, payment_method, gateway_ref, transaction_id, payment_status)
        VALUES (p_amount, p_payment_method, p_gateway_ref, p_transaction_id, 'completed');
        
        SET p_payment_id = LAST_INSERT_ID();
        
        -- Update transaction status
        UPDATE transactions SET status = 'completed' WHERE transaction_id = p_transaction_id;
        
        SET p_message = CONCAT('Payment processed successfully. Payment ID: ', p_payment_id);
        COMMIT;
    END IF;
END //

-- Procedure 5: Get User Statistics
CREATE PROCEDURE sp_get_user_stats(
    IN p_user_id INT,
    OUT p_total_purchases INT,
    OUT p_total_sales INT,
    OUT p_total_spent DECIMAL(10,2),
    OUT p_total_earned DECIMAL(10,2)
)
BEGIN
    -- Get purchase statistics
    SELECT COUNT(*), COALESCE(SUM(total_amount), 0)
    INTO p_total_purchases, p_total_spent
    FROM transactions
    WHERE buyer_id = p_user_id AND status = 'completed';
    
    -- Get sales statistics
    SELECT COUNT(*), COALESCE(SUM(total_amount), 0)
    INTO p_total_sales, p_total_earned
    FROM transactions
    WHERE seller_id = p_user_id AND status = 'completed';
END //

-- Procedure 6: Add Image with Primary Image Enforcement
-- This replaces the removed trg_primary_image_before_insert trigger
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


-- =====================================================
-- STORED FUNCTIONS
-- =====================================================

DELIMITER //

-- Function 1: Calculate Average Rating for an Item
CREATE FUNCTION fn_get_average_rating(
    p_item_type VARCHAR(10),
    p_item_id INT
) RETURNS DECIMAL(3,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_avg_rating DECIMAL(3,2);
    
    SELECT COALESCE(AVG(rating), 0) INTO v_avg_rating
    FROM reviews
    WHERE item_type = p_item_type AND item_id = p_item_id;
    
    RETURN v_avg_rating;
END //

-- Function 2: Check Item Availability
CREATE FUNCTION fn_check_availability(
    p_item_type VARCHAR(10),
    p_item_id INT,
    p_required_qty INT
) RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_available_qty INT;
    DECLARE v_is_available BOOLEAN;
    
    IF p_item_type = 'book' THEN
        SELECT quantity, is_available INTO v_available_qty, v_is_available
        FROM books WHERE book_id = p_item_id;
    ELSEIF p_item_type = 'note' THEN
        SELECT note_quantity, is_available INTO v_available_qty, v_is_available
        FROM notes WHERE note_id = p_item_id;
    END IF;
    
    IF v_is_available = TRUE AND v_available_qty >= p_required_qty THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //

-- Function 3: Calculate Total Revenue for Seller
CREATE FUNCTION fn_seller_revenue(
    p_seller_id INT
) RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_revenue DECIMAL(10,2);
    
    SELECT COALESCE(SUM(total_amount), 0) INTO v_revenue
    FROM transactions
    WHERE seller_id = p_seller_id AND status = 'completed';
    
    RETURN v_revenue;
END //

-- Function 4: Get Item Price
CREATE FUNCTION fn_get_item_price(
    p_item_type VARCHAR(10),
    p_item_id INT
) RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_price DECIMAL(10,2);
    
    IF p_item_type = 'book' THEN
        SELECT price INTO v_price FROM books WHERE book_id = p_item_id;
    ELSEIF p_item_type = 'note' THEN
        SELECT price INTO v_price FROM notes WHERE note_id = p_item_id;
    END IF;
    
    RETURN COALESCE(v_price, 0);
END //

DELIMITER ;

-- =====================================================
-- TRIGGERS
-- =====================================================

DELIMITER //

-- Trigger 1: Auto-update book availability when quantity changes
CREATE TRIGGER trg_book_availability_update
AFTER UPDATE ON books
FOR EACH ROW
BEGIN
    IF NEW.quantity = 0 AND OLD.quantity > 0 THEN
        UPDATE books SET is_available = FALSE WHERE book_id = NEW.book_id;
        
        INSERT INTO inventory_log (item_type, item_id, old_quantity, new_quantity, change_reason)
        VALUES ('book', NEW.book_id, OLD.quantity, NEW.quantity, 'Out of stock');
    ELSEIF NEW.quantity > 0 AND OLD.quantity = 0 THEN
        UPDATE books SET is_available = TRUE WHERE book_id = NEW.book_id;
        
        INSERT INTO inventory_log (item_type, item_id, old_quantity, new_quantity, change_reason)
        VALUES ('book', NEW.book_id, OLD.quantity, NEW.quantity, 'Back in stock');
    ELSEIF NEW.quantity != OLD.quantity THEN
        INSERT INTO inventory_log (item_type, item_id, old_quantity, new_quantity, change_reason)
        VALUES ('book', NEW.book_id, OLD.quantity, NEW.quantity, 'Quantity updated');
    END IF;
END //

-- Trigger 2: Auto-update note availability when quantity changes
CREATE TRIGGER trg_note_availability_update
AFTER UPDATE ON notes
FOR EACH ROW
BEGIN
    IF NEW.note_quantity = 0 AND OLD.note_quantity > 0 THEN
        UPDATE notes SET is_available = FALSE WHERE note_id = NEW.note_id;
        
        INSERT INTO inventory_log (item_type, item_id, old_quantity, new_quantity, change_reason)
        VALUES ('note', NEW.note_id, OLD.note_quantity, NEW.note_quantity, 'Out of stock');
    ELSEIF NEW.note_quantity > 0 AND OLD.note_quantity = 0 THEN
        UPDATE notes SET is_available = TRUE WHERE note_id = NEW.note_id;
        
        INSERT INTO inventory_log (item_type, item_id, old_quantity, new_quantity, change_reason)
        VALUES ('note', NEW.note_id, OLD.note_quantity, NEW.note_quantity, 'Back in stock');
    ELSEIF NEW.note_quantity != OLD.note_quantity THEN
        INSERT INTO inventory_log (item_type, item_id, old_quantity, new_quantity, change_reason)
        VALUES ('note', NEW.note_id, OLD.note_quantity, NEW.note_quantity, 'Quantity updated');
    END IF;
END //

-- Trigger 3: PRIMARY IMAGE ENFORCEMENT - REMOVED
-- This trigger was causing MySQL Error #1442 because it tried to UPDATE
-- the images table while an INSERT was in progress on the same table.
-- Solution: Use the sp_add_image stored procedure instead (see below)
-- Or handle primary image logic in your application code.


-- Trigger 4: Audit log for book updates
CREATE TRIGGER trg_book_audit_update
AFTER UPDATE ON books
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, operation, record_id, old_value, new_value)
    VALUES (
        'books',
        'UPDATE',
        NEW.book_id,
        CONCAT('Price: ', OLD.price, ', Qty: ', OLD.quantity),
        CONCAT('Price: ', NEW.price, ', Qty: ', NEW.quantity)
    );
END //

-- Trigger 5: Audit log for book deletion
CREATE TRIGGER trg_book_audit_delete
BEFORE DELETE ON books
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, operation, record_id, old_value, new_value)
    VALUES (
        'books',
        'DELETE',
        OLD.book_id,
        CONCAT('Title: ', OLD.title, ', Price: ', OLD.price),
        NULL
    );
END //

-- Trigger 6: Validate review rating
CREATE TRIGGER trg_review_validate_rating
BEFORE INSERT ON reviews
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END //

-- Trigger 7: Auto-update transaction status when payment is completed
CREATE TRIGGER trg_payment_update_transaction
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    IF NEW.payment_status = 'completed' THEN
        UPDATE transactions 
        SET status = 'completed' 
        WHERE transaction_id = NEW.transaction_id;
    END IF;
END //

DELIMITER ;

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Insert Users (password: password123)
INSERT INTO users (name, phone, address, contact_email, role, password_hash) VALUES
('Admin User', '9876543210', '123 Admin Street, Mumbai', 'admin@example.com', 'admin', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Rajesh Kumar', '9876543211', '45 MG Road, Bangalore', 'rajesh@example.com', 'seller', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Priya Sharma', '9876543212', '78 Park Street, Kolkata', 'priya@example.com', 'seller', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Amit Patel', '9876543213', '12 Civil Lines, Delhi', 'amit@example.com', 'buyer', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Sneha Reddy', '9876543214', '34 Banjara Hills, Hyderabad', 'sneha@example.com', 'buyer', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y');

-- Insert Categories
INSERT INTO categories (category_name, description) VALUES
('Computer Science', 'Books and notes related to computer science and programming'),
('Mathematics', 'Mathematical books and study guides'),
('Physics', 'Physics textbooks and reference materials'),
('Chemistry', 'Chemistry books and laboratory notes'),
('Engineering', 'Engineering books across various disciplines');

-- Insert Books
INSERT INTO books (title, author, isbn, edition, `condition`, price, quantity, category_id, seller_id, description) VALUES
('Introduction to Algorithms', 'Thomas H. Cormen', '978-0262033848', '3rd Edition', 'good', 450.00, 5, 1, 2, 'Comprehensive textbook on algorithms'),
('Clean Code', 'Robert C. Martin', '978-0132350884', '1st Edition', 'like-new', 350.00, 3, 1, 2, 'A handbook of agile software craftsmanship'),
('Database System Concepts', 'Abraham Silberschatz', '978-0073523323', '7th Edition', 'good', 500.00, 4, 1, 3, 'Comprehensive database textbook'),
('Calculus', 'James Stewart', '978-1285741550', '8th Edition', 'fair', 400.00, 2, 2, 2, 'Classic calculus textbook'),
('Physics for Engineers', 'H.C. Verma', '978-8177091878', 'Vol 1', 'excellent', 350.00, 6, 3, 3, 'Popular physics textbook');

-- Insert Notes
INSERT INTO notes (subject, topic, format, summary, price, note_quantity, category_id, seller_id) VALUES
('Data Structures', 'Complete DSA Notes', 'pdf', 'Comprehensive notes on data structures and algorithms', 150.00, 10, 1, 2),
('DBMS', 'Database Management', 'digital', 'Full semester DBMS notes with examples', 120.00, 8, 1, 3),
('Calculus', 'Differential Calculus', 'handwritten', 'Handwritten calculus notes with solutions', 100.00, 5, 2, 2),
('Quantum Physics', 'Introduction to Quantum Mechanics', 'pdf', 'Quantum physics fundamentals', 140.00, 7, 3, 3);

-- Insert Reviews
INSERT INTO reviews (comment, rating, item_id, item_type, user_id) VALUES
('Excellent book! Very helpful.', 5, 1, 'book', 4),
('Good condition and fast delivery.', 4, 1, 'book', 5),
('Great notes! Helped me in exams.', 5, 1, 'note', 4),
('Very detailed and well organized.', 5, 2, 'note', 5);

-- Insert Images
INSERT INTO images (img_url, is_primary, item_id, item_type) VALUES
('/uploads/books/algorithms_cover.jpg', TRUE, 1, 'book'),
('/uploads/books/clean_code_cover.jpg', TRUE, 2, 'book'),
('/uploads/notes/dsa_notes.jpg', TRUE, 1, 'note'),
('/uploads/notes/dbms_notes.jpg', TRUE, 2, 'note');

-- =====================================================
-- DISPLAY SUMMARY
-- =====================================================

SELECT 'Database created successfully!' AS message;
SELECT COUNT(*) AS total_users FROM users;
SELECT COUNT(*) AS total_categories FROM categories;
SELECT COUNT(*) AS total_books FROM books;
SELECT COUNT(*) AS total_notes FROM notes;
SELECT COUNT(*) AS total_reviews FROM reviews;

-- Show all triggers
SHOW TRIGGERS;

-- Show all procedures
SHOW PROCEDURE STATUS WHERE Db = 'old_books_notes_db';

-- Show all functions
SHOW FUNCTION STATUS WHERE Db = 'old_books_notes_db';

-- =====================================================
-- END OF SCRIPT
-- =====================================================
