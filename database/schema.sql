-- =====================================================
-- Old Notes and Books Management System - Database Schema
-- =====================================================

-- Create Database
CREATE DATABASE IF NOT EXISTS old_books_notes_db;
USE old_books_notes_db;

-- =====================================================
-- 1. USER TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address TEXT,
    contact_email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('admin', 'buyer', 'seller') DEFAULT 'buyer',
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (contact_email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 2. CATEGORY TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category_name (category_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 3. BOOK TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    edition VARCHAR(50),
    `condition` ENUM('new', 'like-new', 'good', 'fair', 'poor', 'excellent') DEFAULT 'good',
    price DECIMAL(10,2) NOT NULL,
    quantity INT DEFAULT 1,
    category_id INT,
    seller_id INT NOT NULL,
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_title (title),
    INDEX idx_author (author),
    INDEX idx_category (category_id),
    INDEX idx_seller (seller_id),
    INDEX idx_price (price),
    FULLTEXT idx_search (title, author, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 4. NOTE TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS notes (
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_subject (subject),
    INDEX idx_topic (topic),
    INDEX idx_category (category_id),
    INDEX idx_seller (seller_id),
    INDEX idx_price (price),
    FULLTEXT idx_search (subject, topic, summary)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 5. REVIEW TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    comment TEXT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    item_id INT NOT NULL,
    item_type ENUM('book', 'note') NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_item (item_type, item_id),
    INDEX idx_user (user_id),
    INDEX idx_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 6. IMAGE TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS images (
    img_url VARCHAR(500) PRIMARY KEY,
    is_primary BOOLEAN DEFAULT FALSE,
    uploaded_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    item_id INT NOT NULL,
    item_type ENUM('book', 'note') NOT NULL,
    INDEX idx_item (item_type, item_id),
    INDEX idx_primary (is_primary)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 7. TRANSACTION TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS transactions (
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_buyer (buyer_id),
    INDEX idx_seller (seller_id),
    INDEX idx_status (status),
    INDEX idx_item (item_type, item_id),
    INDEX idx_date (transaction_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 8. PAYMENT TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    gateway_ref VARCHAR(255),
    payment_method ENUM('card', 'upi', 'netbanking', 'wallet', 'cod') DEFAULT 'card',
    transaction_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE,
    INDEX idx_transaction (transaction_id),
    INDEX idx_status (payment_status),
    INDEX idx_gateway_ref (gateway_ref)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- USEFUL VIEWS FOR REPORTING
-- =====================================================

-- View for available books with category and seller info
CREATE OR REPLACE VIEW available_books_view AS
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
    (SELECT AVG(rating) FROM reviews WHERE item_type = 'book' AND item_id = b.book_id) AS avg_rating,
    (SELECT COUNT(*) FROM reviews WHERE item_type = 'book' AND item_id = b.book_id) AS review_count,
    b.created_at
FROM books b
LEFT JOIN categories c ON b.category_id = c.category_id
LEFT JOIN users u ON b.seller_id = u.user_id
WHERE b.is_available = TRUE AND b.quantity > 0;

-- View for available notes with category and seller info
CREATE OR REPLACE VIEW available_notes_view AS
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
    (SELECT AVG(rating) FROM reviews WHERE item_type = 'note' AND item_id = n.note_id) AS avg_rating,
    (SELECT COUNT(*) FROM reviews WHERE item_type = 'note' AND item_id = n.note_id) AS review_count,
    n.created_at
FROM notes n
LEFT JOIN categories c ON n.category_id = c.category_id
LEFT JOIN users u ON n.seller_id = u.user_id
WHERE n.is_available = TRUE AND n.note_quantity > 0;

-- View for transaction details
CREATE OR REPLACE VIEW transaction_details_view AS
SELECT 
    t.transaction_id,
    t.transaction_date,
    t.total_amount,
    t.status,
    t.item_type,
    t.item_id,
    t.quantity,
    buyer.name AS buyer_name,
    buyer.contact_email AS buyer_email,
    seller.name AS seller_name,
    seller.contact_email AS seller_email,
    CASE 
        WHEN t.item_type = 'book' THEN b.title
        WHEN t.item_type = 'note' THEN n.topic
    END AS item_title,
    p.payment_status,
    p.payment_method,
    p.payment_date
FROM transactions t
LEFT JOIN users buyer ON t.buyer_id = buyer.user_id
LEFT JOIN users seller ON t.seller_id = seller.user_id
LEFT JOIN books b ON t.item_type = 'book' AND t.item_id = b.book_id
LEFT JOIN notes n ON t.item_type = 'note' AND t.item_id = n.note_id
LEFT JOIN payments p ON t.transaction_id = p.transaction_id;

-- View for dashboard statistics
CREATE OR REPLACE VIEW dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM users WHERE is_active = TRUE) AS total_users,
    (SELECT COUNT(*) FROM users WHERE role = 'seller' AND is_active = TRUE) AS total_sellers,
    (SELECT COUNT(*) FROM users WHERE role = 'buyer' AND is_active = TRUE) AS total_buyers,
    (SELECT COUNT(*) FROM books WHERE is_available = TRUE) AS available_books,
    (SELECT COUNT(*) FROM notes WHERE is_available = TRUE) AS available_notes,
    (SELECT COUNT(*) FROM transactions WHERE status = 'completed') AS completed_transactions,
    (SELECT COUNT(*) FROM transactions WHERE status = 'pending') AS pending_transactions,
    (SELECT COALESCE(SUM(total_amount), 0) FROM transactions WHERE status = 'completed') AS total_revenue,
    (SELECT COALESCE(SUM(total_amount), 0) FROM transactions WHERE status = 'completed' AND DATE(transaction_date) = CURDATE()) AS today_revenue,
    (SELECT COUNT(*) FROM reviews) AS total_reviews;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

DELIMITER //

-- Procedure to add a new book
CREATE PROCEDURE AddBook(
    IN p_title VARCHAR(255),
    IN p_author VARCHAR(100),
    IN p_isbn VARCHAR(20),
    IN p_edition VARCHAR(50),
    IN p_condition VARCHAR(20),
    IN p_price DECIMAL(10,2),
    IN p_quantity INT,
    IN p_category_id INT,
    IN p_seller_id INT,
    IN p_description TEXT
)
BEGIN
    INSERT INTO books (title, author, isbn, edition, `condition`, price, quantity, category_id, seller_id, description)
    VALUES (p_title, p_author, p_isbn, p_edition, p_condition, p_price, p_quantity, p_category_id, p_seller_id, p_description);
    SELECT LAST_INSERT_ID() AS book_id;
END //

-- Procedure to add a new note
CREATE PROCEDURE AddNote(
    IN p_subject VARCHAR(100),
    IN p_topic VARCHAR(255),
    IN p_format VARCHAR(20),
    IN p_summary TEXT,
    IN p_price DECIMAL(10,2),
    IN p_note_quantity INT,
    IN p_category_id INT,
    IN p_seller_id INT
)
BEGIN
    INSERT INTO notes (subject, topic, format, summary, price, note_quantity, category_id, seller_id)
    VALUES (p_subject, p_topic, p_format, p_summary, p_price, p_note_quantity, p_category_id, p_seller_id);
    SELECT LAST_INSERT_ID() AS note_id;
END //

-- Procedure to create a transaction
CREATE PROCEDURE CreateTransaction(
    IN p_item_type VARCHAR(10),
    IN p_item_id INT,
    IN p_quantity INT,
    IN p_buyer_id INT,
    OUT p_transaction_id INT,
    OUT p_total_amount DECIMAL(10,2),
    OUT p_seller_id INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_available_qty INT;
    
    -- Get item details
    IF p_item_type = 'book' THEN
        SELECT price, quantity, seller_id INTO v_price, v_available_qty, p_seller_id
        FROM books WHERE book_id = p_item_id AND is_available = TRUE;
    ELSEIF p_item_type = 'note' THEN
        SELECT price, note_quantity, seller_id INTO v_price, v_available_qty, p_seller_id
        FROM notes WHERE note_id = p_item_id AND is_available = TRUE;
    END IF;
    
    -- Check availability
    IF v_available_qty >= p_quantity THEN
        SET p_total_amount = v_price * p_quantity;
        
        -- Create transaction
        INSERT INTO transactions (item_type, item_id, quantity, total_amount, buyer_id, seller_id)
        VALUES (p_item_type, p_item_id, p_quantity, p_total_amount, p_buyer_id, p_seller_id);
        
        SET p_transaction_id = LAST_INSERT_ID();
        
        -- Update quantity
        IF p_item_type = 'book' THEN
            UPDATE books SET quantity = quantity - p_quantity WHERE book_id = p_item_id;
        ELSEIF p_item_type = 'note' THEN
            UPDATE notes SET note_quantity = note_quantity - p_quantity WHERE note_id = p_item_id;
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient quantity available';
    END IF;
END //

-- Procedure to process payment
CREATE PROCEDURE ProcessPayment(
    IN p_transaction_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_payment_method VARCHAR(20),
    IN p_gateway_ref VARCHAR(255)
)
BEGIN
    DECLARE v_transaction_amount DECIMAL(10,2);
    
    -- Verify transaction amount
    SELECT total_amount INTO v_transaction_amount 
    FROM transactions WHERE transaction_id = p_transaction_id;
    
    IF v_transaction_amount = p_amount THEN
        -- Insert payment record
        INSERT INTO payments (amount, payment_method, gateway_ref, transaction_id, payment_status)
        VALUES (p_amount, p_payment_method, p_gateway_ref, p_transaction_id, 'completed');
        
        -- Update transaction status
        UPDATE transactions SET status = 'completed' WHERE transaction_id = p_transaction_id;
        
        SELECT LAST_INSERT_ID() AS payment_id, 'Payment successful' AS message;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment amount mismatch';
    END IF;
END //

DELIMITER ;

-- =====================================================
-- TRIGGERS
-- =====================================================

DELIMITER //

-- Trigger to update book availability
CREATE TRIGGER update_book_availability 
AFTER UPDATE ON books
FOR EACH ROW
BEGIN
    IF NEW.quantity = 0 THEN
        UPDATE books SET is_available = FALSE WHERE book_id = NEW.book_id;
    ELSEIF NEW.quantity > 0 AND OLD.quantity = 0 THEN
        UPDATE books SET is_available = TRUE WHERE book_id = NEW.book_id;
    END IF;
END //

-- Trigger to update note availability
CREATE TRIGGER update_note_availability 
AFTER UPDATE ON notes
FOR EACH ROW
BEGIN
    IF NEW.note_quantity = 0 THEN
        UPDATE notes SET is_available = FALSE WHERE note_id = NEW.note_id;
    ELSEIF NEW.note_quantity > 0 AND OLD.note_quantity = 0 THEN
        UPDATE notes SET is_available = TRUE WHERE note_id = NEW.note_id;
    END IF;
END //

-- Trigger to ensure only one primary image per item




-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Additional composite indexes
CREATE INDEX idx_book_category_price ON books(category_id, price);
CREATE INDEX idx_note_category_price ON notes(category_id, price);
CREATE INDEX idx_transaction_buyer_status ON transactions(buyer_id, status);
CREATE INDEX idx_transaction_seller_status ON transactions(seller_id, status);

-- =====================================================
-- END OF SCHEMA
-- =====================================================
