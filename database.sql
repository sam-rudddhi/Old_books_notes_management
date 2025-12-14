-- =====================================================
-- Old Books & Notes Management System - SQL Database
-- =====================================================

-- Create Database
CREATE DATABASE IF NOT EXISTS library_management;
USE library_management;

-- =====================================================
-- USERS TABLE
-- =====================================================
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    email VARCHAR(100),
    phone VARCHAR(20),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL
);

-- =====================================================
-- BOOKS TABLE
-- =====================================================
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20),
    category ENUM('fiction', 'non-fiction', 'textbook', 'reference') NOT NULL,
    publication_year INT NOT NULL,
    publisher VARCHAR(100),
    pages INT,
    language VARCHAR(20) DEFAULT 'English',
    condition ENUM('excellent', 'good', 'fair', 'poor') NOT NULL,
    status ENUM('available', 'borrowed', 'reserved', 'maintenance') DEFAULT 'available',
    description TEXT,
    location VARCHAR(50), -- Shelf location
    purchase_date DATE,
    purchase_price DECIMAL(10,2),
    added_by INT,
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (added_by) REFERENCES users(user_id)
);

-- =====================================================
-- NOTES TABLE
-- =====================================================
CREATE TABLE notes (
    note_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    type ENUM('lecture-notes', 'study-guide', 'assignment', 'reference-notes', 'exam-prep') NOT NULL,
    grade_level ENUM('high-school', 'undergraduate', 'graduate', 'professional') NOT NULL,
    pages INT NOT NULL,
    condition ENUM('excellent', 'good', 'fair', 'poor') NOT NULL,
    content_summary TEXT,
    keywords VARCHAR(500),
    difficulty_level ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'intermediate',
    subject_code VARCHAR(20),
    semester VARCHAR(10),
    year INT,
    added_by INT,
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (added_by) REFERENCES users(user_id)
);

-- =====================================================
-- BORROWING TRANSACTIONS TABLE
-- =====================================================
CREATE TABLE borrowing_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    item_type ENUM('book', 'note') NOT NULL,
    item_id INT NOT NULL,
    borrow_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date TIMESTAMP NOT NULL,
    return_date TIMESTAMP NULL,
    status ENUM('borrowed', 'returned', 'overdue', 'lost') DEFAULT 'borrowed',
    fine_amount DECIMAL(8,2) DEFAULT 0.00,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =====================================================
-- RESERVATIONS TABLE
-- =====================================================
CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    item_type ENUM('book', 'note') NOT NULL,
    item_id INT NOT NULL,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'cancelled', 'fulfilled') DEFAULT 'active',
    expiry_date TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =====================================================
-- SEARCH LOGS TABLE (for analytics)
-- =====================================================
CREATE TABLE search_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    search_query VARCHAR(255) NOT NULL,
    search_type ENUM('books', 'notes', 'both') DEFAULT 'both',
    filters JSON,
    results_count INT,
    search_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert sample users
INSERT INTO users (username, password, full_name, role, email) VALUES
('admin', 'admin123', 'System Administrator', 'admin', 'admin@library.com'),
('user', 'user123', 'John Doe', 'user', 'john.doe@email.com'),
('librarian', 'lib123', 'Jane Smith', 'admin', 'jane.smith@library.com'),
('student1', 'pass123', 'Alice Johnson', 'user', 'alice@student.edu'),
('student2', 'pass456', 'Bob Wilson', 'user', 'bob@student.edu');

-- Insert sample books
INSERT INTO books (title, author, category, publication_year, publisher, pages, condition, status, description, location, added_by) VALUES
('To Kill a Mockingbird', 'Harper Lee', 'fiction', 1960, 'J.B. Lippincott & Co.', 281, 'good', 'available', 'Classic American literature masterpiece about racial injustice in the Deep South.', 'A-12-03', 1),
('Introduction to Algorithms', 'Thomas H. Cormen', 'textbook', 2009, 'MIT Press', 1312, 'excellent', 'borrowed', 'Comprehensive computer science textbook covering algorithms and data structures.', 'T-05-01', 1),
('The Great Gatsby', 'F. Scott Fitzgerald', 'fiction', 1925, 'Charles Scribner''s Sons', 180, 'fair', 'available', 'American classic novel about the Jazz Age and the American Dream.', 'A-08-02', 1),
('Clean Code', 'Robert C. Martin', 'reference', 2008, 'Prentice Hall', 464, 'excellent', 'available', 'A handbook of agile software craftsmanship for writing clean, maintainable code.', 'R-03-04', 1),
('Database System Concepts', 'Abraham Silberschatz', 'textbook', 2010, 'McGraw-Hill', 1136, 'good', 'reserved', 'Comprehensive textbook covering database systems design and implementation.', 'T-07-02', 1),
('Pride and Prejudice', 'Jane Austen', 'fiction', 1813, 'T. Egerton', 432, 'fair', 'available', 'Classic romantic novel about Elizabeth Bennet and Mr. Darcy.', 'A-15-01', 1),
('Operating System Concepts', 'Abraham Silberschatz', 'textbook', 2012, 'Wiley', 976, 'good', 'available', 'Fundamental concepts of operating systems design and implementation.', 'T-02-03', 1),
('The Catcher in the Rye', 'J.D. Salinger', 'fiction', 1951, 'Little, Brown and Company', 277, 'poor', 'available', 'Controversial novel about teenage rebellion and alienation.', 'A-20-04', 1);

-- Insert sample notes
INSERT INTO notes (title, subject, type, grade_level, pages, condition, content_summary, keywords, subject_code, semester, year, added_by) VALUES
('Database Systems Lecture Notes', 'Database Management', 'lecture-notes', 'undergraduate', 45, 'good', 'Comprehensive notes covering SQL, normalization, ER diagrams, and relational algebra concepts.', 'SQL, ER diagrams, normalization, relational algebra', 'CS301', 'Fall', 2023, 2),
('Calculus Study Guide', 'Mathematics', 'study-guide', 'high-school', 32, 'excellent', 'Derivatives, integrals, limit concepts, and applications with solved examples.', 'derivatives, integrals, limits, calculus applications', 'MATH101', 'Spring', 2023, 2),
('Programming Assignment Solutions', 'Computer Science', 'assignment', 'undergraduate', 28, 'fair', 'Java and Python programming solutions with detailed explanations and code comments.', 'Java, Python, OOP, programming assignments', 'CS201', 'Fall', 2023, 2),
('Operating Systems Notes', 'Computer Science', 'lecture-notes', 'undergraduate', 52, 'good', 'Process management, memory management, file systems, and synchronization concepts.', 'processes, threads, memory management, file systems', 'CS401', 'Spring', 2023, 2),
('English Literature Essay Guide', 'English', 'study-guide', 'high-school', 24, 'excellent', 'How to write analytical essays, literary analysis techniques, and essay structure.', 'literary analysis, essay writing, poetry analysis', 'ENG201', 'Fall', 2023, 2),
('Data Structures Cheat Sheet', 'Computer Science', 'reference-notes', 'undergraduate', 16, 'good', 'Quick reference for arrays, linked lists, trees, graphs, and sorting algorithms.', 'data structures, algorithms, trees, graphs, sorting', 'CS202', 'Spring', 2023, 2),
('Physics Formula Reference', 'Physics', 'reference-notes', 'high-school', 20, 'fair', 'Essential physics formulas for mechanics, thermodynamics, and electromagnetism.', 'physics formulas, mechanics, thermodynamics, electromagnetism', 'PHY101', 'Fall', 2023, 2),
('History Timeline Notes', 'History', 'study-guide', 'high-school', 38, 'good', 'Important historical events, dates, and their significance in world history.', 'world history, timeline, historical events, dates', 'HIS201', 'Spring', 2023, 2);

-- Insert sample borrowing transactions
INSERT INTO borrowing_transactions (user_id, item_type, item_id, due_date, return_date, status) VALUES
(4, 'book', 2, DATE_ADD(NOW(), INTERVAL 14 DAY), NULL, 'borrowed'),
(5, 'book', 5, DATE_ADD(NOW(), INTERVAL 7 DAY), NULL, 'reserved'),
(4, 'book', 1, DATE_ADD(NOW(), INTERVAL -5 DAY), NULL, 'overdue');

-- Insert sample reservations
INSERT INTO reservations (user_id, item_type, item_id, expiry_date) VALUES
(5, 'book', 5, DATE_ADD(NOW(), INTERVAL 3 DAY));

-- Insert sample search logs
INSERT INTO search_logs (user_id, search_query, search_type, results_count) VALUES
(2, 'algorithms', 'books', 1),
(2, 'database', 'both', 2),
(4, 'programming', 'notes', 1),
(NULL, 'fiction', 'books', 3);

-- =====================================================
-- USEFUL VIEWS FOR REPORTING
-- =====================================================

-- View for available books
CREATE VIEW available_books AS
SELECT 
    book_id,
    title,
    author,
    category,
    publication_year,
    location,
    condition,
    date_added
FROM books 
WHERE status = 'available'
ORDER BY title;

-- View for borrowed items with user details
CREATE VIEW borrowed_items AS
SELECT 
    bt.transaction_id,
    bt.item_type,
    u.full_name as borrower_name,
    u.username as borrower_username,
    CASE 
        WHEN bt.item_type = 'book' THEN b.title
        WHEN bt.item_type = 'note' THEN n.title
    END as item_title,
    bt.borrow_date,
    bt.due_date,
    bt.return_date,
    bt.status,
    DATEDIFF(bt.due_date, NOW()) as days_until_due,
    bt.fine_amount
FROM borrowing_transactions bt
JOIN users u ON bt.user_id = u.user_id
LEFT JOIN books b ON bt.item_type = 'book' AND bt.item_id = b.book_id
LEFT JOIN notes n ON bt.item_type = 'note' AND bt.item_id = n.note_id
WHERE bt.status IN ('borrowed', 'overdue')
ORDER BY bt.due_date;

-- View for statistics dashboard
CREATE VIEW library_statistics AS
SELECT 
    (SELECT COUNT(*) FROM books) as total_books,
    (SELECT COUNT(*) FROM notes) as total_notes,
    (SELECT COUNT(*) FROM users WHERE is_active = TRUE) as active_users,
    (SELECT COUNT(*) FROM borrowing_transactions WHERE status = 'borrowed') as currently_borrowed,
    (SELECT COUNT(*) FROM books WHERE status = 'available') as available_books,
    (SELECT COUNT(*) FROM notes WHERE condition = 'excellent') as excellent_condition_items,
    (SELECT COUNT(*) FROM borrowing_transactions WHERE status = 'overdue') as overdue_items,
    (SELECT COUNT(*) FROM borrowing_transactions WHERE DATE(borrow_date) = CURDATE()) as today_borrowings;

-- =====================================================
-- STORED PROCEDURES FOR COMMON OPERATIONS
-- =====================================================

DELIMITER //

-- Procedure to add a new book
CREATE PROCEDURE AddNewBook(
    IN p_title VARCHAR(255),
    IN p_author VARCHAR(100),
    IN p_category VARCHAR(20),
    IN p_publication_year INT,
    IN p_condition VARCHAR(20),
    IN p_description TEXT,
    IN p_added_by INT
)
BEGIN
    INSERT INTO books (title, author, category, publication_year, condition, description, added_by)
    VALUES (p_title, p_author, p_category, p_publication_year, p_condition, p_description, p_added_by);
    SELECT LAST_INSERT_ID() as new_book_id;
END //

-- Procedure to add a new note
CREATE PROCEDURE AddNewNote(
    IN p_title VARCHAR(255),
    IN p_subject VARCHAR(100),
    IN p_type VARCHAR(20),
    IN p_grade_level VARCHAR(20),
    IN p_pages INT,
    IN p_condition VARCHAR(20),
    IN p_content_summary TEXT,
    IN p_added_by INT
)
BEGIN
    INSERT INTO notes (title, subject, type, grade_level, pages, condition, content_summary, added_by)
    VALUES (p_title, p_subject, p_type, p_grade_level, p_pages, p_condition, p_content_summary, p_added_by);
    SELECT LAST_INSERT_ID() as new_note_id;
END //

-- Procedure to borrow an item
CREATE PROCEDURE BorrowItem(
    IN p_user_id INT,
    IN p_item_type VARCHAR(10),
    IN p_item_id INT,
    IN p_due_days INT
)
BEGIN
    DECLARE item_exists INT DEFAULT 0;
    DECLARE item_available INT DEFAULT 0;
    
    -- Check if item exists and is available
    IF p_item_type = 'book' THEN
        SELECT COUNT(*) INTO item_exists FROM books WHERE book_id = p_item_id AND status = 'available';
    ELSEIF p_item_type = 'note' THEN
        SELECT COUNT(*) INTO item_exists FROM notes WHERE note_id = p_item_id;
    END IF;
    
    IF item_exists > 0 THEN
        -- Insert borrowing transaction
        INSERT INTO borrowing_transactions (user_id, item_type, item_id, due_date)
        VALUES (p_user_id, p_item_type, p_item_id, DATE_ADD(NOW(), INTERVAL p_due_days DAY));
        
        -- Update item status if it's a book
        IF p_item_type = 'book' THEN
            UPDATE books SET status = 'borrowed' WHERE book_id = p_item_id;
        END IF;
        
        SELECT 'Item borrowed successfully' as message, LAST_INSERT_ID() as transaction_id;
    ELSE
        SELECT 'Item not available' as message, 0 as transaction_id;
    END IF;
END //

-- Procedure to return an item
CREATE PROCEDURE ReturnItem(
    IN p_transaction_id INT
)
BEGIN
    DECLARE v_item_type VARCHAR(10);
    DECLARE v_item_id INT;
    DECLARE v_user_id INT;
    
    -- Get transaction details
    SELECT item_type, item_id, user_id INTO v_item_type, v_item_id, v_user_id
    FROM borrowing_transactions 
    WHERE transaction_id = p_transaction_id AND status = 'borrowed';
    
    IF v_item_type IS NOT NULL THEN
        -- Update transaction status
        UPDATE borrowing_transactions 
        SET status = 'returned', return_date = NOW()
        WHERE transaction_id = p_transaction_id;
        
        -- Update item status if it's a book
        IF v_item_type = 'book' THEN
            UPDATE books SET status = 'available' WHERE book_id = v_item_id;
        END IF;
        
        SELECT 'Item returned successfully' as message;
    ELSE
        SELECT 'Invalid transaction or item already returned' as message;
    END IF;
END //

DELIMITER ;

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Indexes for books table
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_books_category ON books(category);
CREATE INDEX idx_books_status ON books(status);
CREATE INDEX idx_books_condition ON books(condition);

-- Indexes for notes table
CREATE INDEX idx_notes_title ON notes(title);
CREATE INDEX idx_notes_subject ON notes(subject);
CREATE INDEX idx_notes_type ON notes(type);
CREATE INDEX idx_notes_grade_level ON notes(grade_level);
CREATE INDEX idx_notes_condition ON notes(condition);

-- Indexes for borrowing transactions
CREATE INDEX idx_borrowing_user ON borrowing_transactions(user_id);
CREATE INDEX idx_borrowing_status ON borrowing_transactions(status);
CREATE INDEX idx_borrowing_due_date ON borrowing_transactions(due_date);

-- Full-text indexes for search functionality
ALTER TABLE books ADD FULLTEXT(title, author, description);
ALTER TABLE notes ADD FULLTEXT(title, subject, content_summary);

-- =====================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- =====================================================

DELIMITER //

-- Trigger to update last_modified timestamp
CREATE TRIGGER update_books_modtime 
    BEFORE UPDATE ON books
    FOR EACH ROW
BEGIN
    SET NEW.last_modified = CURRENT_TIMESTAMP;
END //

CREATE TRIGGER update_notes_modtime 
    BEFORE UPDATE ON notes
    FOR EACH ROW
BEGIN
    SET NEW.last_modified = CURRENT_TIMESTAMP;
END //

DELIMITER ;

-- =====================================================
-- SAMPLE QUERIES FOR TESTING
-- =====================================================

-- Query 1: Get all available books by category
-- SELECT * FROM available_books WHERE category = 'fiction';

-- Query 2: Get overdue items
-- SELECT * FROM borrowed_items WHERE days_until_due < 0;

-- Query 3: Search for books using full-text search
-- SELECT * FROM books WHERE MATCH(title, author, description) AGAINST('database algorithms' IN NATURAL LANGUAGE MODE);

-- Query 4: Get library statistics
-- SELECT * FROM library_statistics;

-- Query 5: Get recent additions (last 30 days)
-- SELECT * FROM books WHERE date_added >= DATE_SUB(NOW(), INTERVAL 30 DAY)
-- UNION ALL
-- SELECT book_id as id, title, author, 'book' as type, category, publication_year, NULL as pages, condition, status, description, NULL as content_summary, date_added
-- FROM books WHERE date_added >= DATE_SUB(NOW(), INTERVAL 30 DAY)
-- ORDER BY date_added DESC;

-- =====================================================
-- BACKUP AND MAINTENANCE COMMANDS
-- =====================================================

-- Backup command (run from command line):
-- mysqldump -u username -p library_management > backup_YYYY_MM_DD.sql

-- To restore:
-- mysql -u username -p library_management < backup_YYYY_MM_DD.sql

-- Analyze and optimize tables monthly:
-- ANALYZE TABLE books, notes, users, borrowing_transactions;
-- OPTIMIZE TABLE books, notes, users, borrowing_transactions;
