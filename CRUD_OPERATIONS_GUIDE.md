# 📝 Simple CRUD Operations Guide
## Old Notes and Books Management System

This guide shows basic **CREATE, READ, UPDATE, DELETE** operations for your DBMS project.

---

## 🎯 Quick Setup

### Import Database in MySQL Workbench:
1. Open MySQL Workbench
2. File → Open SQL Script → Select `database/complete_database.sql`
3. Click Execute (⚡)
4. Refresh schemas (🔄)

### Import Database in phpMyAdmin:
1. Open `http://localhost/phpmyadmin`
2. Click "Import" tab
3. Choose `database/complete_database.sql`
4. Click "Go"

---

## 📚 CRUD Operations for BOOKS

### ✅ CREATE - Add New Book

```sql
-- Simple insert
INSERT INTO books (title, author, price, quantity, category_id, seller_id)
VALUES ('Python Programming', 'John Doe', 399.00, 5, 1, 2);

-- Using stored procedure (recommended)
CALL sp_add_book(
    'Java Programming',     -- title
    'Jane Smith',           -- author
    '978-1234567890',      -- isbn
    '2nd Edition',          -- edition
    'new',                  -- condition
    450.00,                 -- price
    3,                      -- quantity
    1,                      -- category_id
    2,                      -- seller_id
    'Complete Java guide',  -- description
    @book_id,               -- OUT: new book_id
    @message                -- OUT: message
);

-- See the result
SELECT @book_id AS new_book_id, @message AS result;
SELECT * FROM books WHERE book_id = @book_id;
```

### 📖 READ - View Books

```sql
-- Get all books
SELECT * FROM books;

-- Get available books only
SELECT * FROM books WHERE is_available = TRUE;

-- Get books by category
SELECT * FROM books WHERE category_id = 1;

-- Search books by title or author
SELECT * FROM books 
WHERE title LIKE '%programming%' 
   OR author LIKE '%programming%';

-- Get books with price range
SELECT * FROM books 
WHERE price BETWEEN 200 AND 500;

-- Get books with reviews (using view)
SELECT * FROM v_available_books;

-- Get specific book details
SELECT 
    b.*,
    c.category_name,
    u.name AS seller_name,
    u.contact_email AS seller_email
FROM books b
LEFT JOIN categories c ON b.category_id = c.category_id
LEFT JOIN users u ON b.seller_id = u.user_id
WHERE b.book_id = 1;
```

### ✏️ UPDATE - Modify Book

```sql
-- Update price
UPDATE books SET price = 425.00 WHERE book_id = 1;

-- Update quantity
UPDATE books SET quantity = 10 WHERE book_id = 1;

-- Update multiple fields
UPDATE books 
SET price = 475.00, 
    quantity = 8,
    `condition` = 'like-new'
WHERE book_id = 1;

-- Update and check trigger (quantity to 0)
UPDATE books SET quantity = 0 WHERE book_id = 1;
-- Check if is_available changed to FALSE
SELECT book_id, quantity, is_available FROM books WHERE book_id = 1;

-- Check inventory log (created by trigger)
SELECT * FROM inventory_log WHERE item_type = 'book' AND item_id = 1;
```

### ❌ DELETE - Remove Book

```sql
-- Delete a specific book
DELETE FROM books WHERE book_id = 10;

-- Check audit log (created by trigger)
SELECT * FROM audit_log WHERE table_name = 'books' AND operation = 'DELETE';

-- Soft delete (mark as unavailable instead of deleting)
UPDATE books SET is_available = FALSE WHERE book_id = 5;
```

---

## 📝 CRUD Operations for NOTES

### ✅ CREATE - Add New Note

```sql
-- Simple insert
INSERT INTO notes (subject, topic, format, summary, price, note_quantity, category_id, seller_id)
VALUES ('Python', 'Python Basics', 'pdf', 'Complete Python notes', 120.00, 10, 1, 2);

-- Using stored procedure
CALL sp_add_note(
    'Data Science',             -- subject
    'Machine Learning Basics',  -- topic
    'digital',                  -- format
    'ML fundamentals',          -- summary
    180.00,                     -- price
    15,                         -- note_quantity
    1,                          -- category_id
    2,                          -- seller_id
    @note_id,                   -- OUT: note_id
    @message                    -- OUT: message
);

SELECT @note_id, @message;
```

### 📖 READ - View Notes

```sql
-- Get all notes
SELECT * FROM notes;

-- Get available notes
SELECT * FROM notes WHERE is_available = TRUE;

-- Get notes by subject
SELECT * FROM notes WHERE subject = 'Data Structures';

-- Get notes with reviews (using view)
SELECT * FROM v_available_notes;

-- Search notes
SELECT * FROM notes 
WHERE topic LIKE '%algorithm%' 
   OR summary LIKE '%algorithm%';
```

### ✏️ UPDATE - Modify Note

```sql
-- Update price
UPDATE notes SET price = 150.00 WHERE note_id = 1;

-- Update quantity
UPDATE notes SET note_quantity = 20 WHERE note_id = 1;

-- Update multiple fields
UPDATE notes 
SET price = 140.00,
    note_quantity = 25,
    format = 'pdf'
WHERE note_id = 1;
```

### ❌ DELETE - Remove Note

```sql
-- Delete a note
DELETE FROM notes WHERE note_id = 10;
```

---

## 👥 CRUD Operations for USERS

### ✅ CREATE - Add New User

```sql
INSERT INTO users (name, phone, address, contact_email, role, password_hash)
VALUES (
    'New User',
    '9876543220',
    '123 Street, City',
    'newuser@example.com',
    'buyer',
    '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'
);
```

### 📖 READ - View Users

```sql
-- Get all users
SELECT user_id, name, contact_email, role, phone FROM users;

-- Get users by role
SELECT * FROM users WHERE role = 'seller';

-- Get active users only
SELECT * FROM users WHERE is_active = TRUE;
```

### ✏️ UPDATE - Modify User

```sql
-- Update user details
UPDATE users 
SET phone = '9999999999',
    address = 'New Address'
WHERE user_id = 4;

-- Deactivate user
UPDATE users SET is_active = FALSE WHERE user_id = 5;
```

### ❌ DELETE - Remove User

```sql
-- Delete user (will cascade delete their books, notes, transactions)
DELETE FROM users WHERE user_id = 10;
```

---

## 📂 CRUD Operations for CATEGORIES

### ✅ CREATE - Add Category

```sql
INSERT INTO categories (category_name, description)
VALUES ('Biology', 'Biology books and study materials');
```

### 📖 READ - View Categories

```sql
-- Get all categories
SELECT * FROM categories;

-- Get category with book count
SELECT 
    c.category_id,
    c.category_name,
    COUNT(b.book_id) AS book_count
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id;
```

### ✏️ UPDATE - Modify Category

```sql
UPDATE categories 
SET description = 'Updated description'
WHERE category_id = 1;
```

### ❌ DELETE - Remove Category

```sql
-- Delete category (books/notes will have NULL category_id)
DELETE FROM categories WHERE category_id = 10;
```

---

## ⭐ CRUD Operations for REVIEWS

### ✅ CREATE - Add Review

```sql
-- Add review for a book
INSERT INTO reviews (comment, rating, item_id, item_type, user_id)
VALUES ('Excellent book! Highly recommended.', 5, 1, 'book', 4);

-- Add review for a note
INSERT INTO reviews (comment, rating, item_id, item_type, user_id)
VALUES ('Very helpful notes!', 4, 1, 'note', 5);

-- Try invalid rating (trigger will prevent this)
INSERT INTO reviews (comment, rating, item_id, item_type, user_id)
VALUES ('Test', 6, 1, 'book', 4);
-- Error: Rating must be between 1 and 5
```

### 📖 READ - View Reviews

```sql
-- Get all reviews
SELECT * FROM reviews;

-- Get reviews for a specific book
SELECT 
    r.*,
    u.name AS reviewer_name
FROM reviews r
JOIN users u ON r.user_id = u.user_id
WHERE r.item_type = 'book' AND r.item_id = 1;

-- Get average rating for a book (using function)
SELECT fn_get_average_rating('book', 1) AS avg_rating;

-- Get books with their average ratings
SELECT 
    b.book_id,
    b.title,
    fn_get_average_rating('book', b.book_id) AS avg_rating,
    COUNT(r.review_id) AS review_count
FROM books b
LEFT JOIN reviews r ON r.item_type = 'book' AND r.item_id = b.book_id
GROUP BY b.book_id;
```

### ✏️ UPDATE - Modify Review

```sql
UPDATE reviews 
SET comment = 'Updated review comment',
    rating = 4
WHERE review_id = 1;
```

### ❌ DELETE - Remove Review

```sql
DELETE FROM reviews WHERE review_id = 5;
```

---

## 💰 CRUD Operations for TRANSACTIONS

### ✅ CREATE - Create Transaction

```sql
-- Using stored procedure (recommended)
CALL sp_create_transaction(
    'book',         -- item_type
    1,              -- item_id
    2,              -- quantity
    4,              -- buyer_id
    @trans_id,      -- OUT: transaction_id
    @amount,        -- OUT: total_amount
    @message        -- OUT: message
);

SELECT @trans_id AS transaction_id, @amount AS total, @message AS result;

-- Check the transaction
SELECT * FROM transactions WHERE transaction_id = @trans_id;

-- Check if book quantity was reduced
SELECT book_id, title, quantity FROM books WHERE book_id = 1;
```

### 📖 READ - View Transactions

```sql
-- Get all transactions
SELECT * FROM transactions;

-- Get transactions by buyer
SELECT * FROM transactions WHERE buyer_id = 4;

-- Get transactions by seller
SELECT * FROM transactions WHERE seller_id = 2;

-- Get completed transactions
SELECT * FROM transactions WHERE status = 'completed';

-- Get transaction summary (using view)
SELECT * FROM v_transaction_summary;

-- Get user statistics (using procedure)
CALL sp_get_user_stats(4, @purchases, @sales, @spent, @earned);
SELECT @purchases, @sales, @spent, @earned;
```

### ✏️ UPDATE - Modify Transaction

```sql
-- Update transaction status
UPDATE transactions SET status = 'completed' WHERE transaction_id = 1;

-- Cancel transaction
UPDATE transactions SET status = 'cancelled' WHERE transaction_id = 2;
```

### ❌ DELETE - Remove Transaction

```sql
-- Delete transaction (will also delete associated payment)
DELETE FROM transactions WHERE transaction_id = 10;
```

---

## 💳 CRUD Operations for PAYMENTS

### ✅ CREATE - Process Payment

```sql
-- Using stored procedure (recommended)
CALL sp_process_payment(
    1,                      -- transaction_id
    900.00,                 -- amount
    'upi',                  -- payment_method
    'PAY_123456789',       -- gateway_ref
    @payment_id,            -- OUT: payment_id
    @message                -- OUT: message
);

SELECT @payment_id, @message;

-- Check payment
SELECT * FROM payments WHERE payment_id = @payment_id;

-- Check if transaction status updated to 'completed'
SELECT * FROM transactions WHERE transaction_id = 1;
```

### 📖 READ - View Payments

```sql
-- Get all payments
SELECT * FROM payments;

-- Get payments by status
SELECT * FROM payments WHERE payment_status = 'completed';

-- Get payments by method
SELECT * FROM payments WHERE payment_method = 'upi';

-- Get payment with transaction details
SELECT 
    p.*,
    t.total_amount,
    t.status AS transaction_status
FROM payments p
JOIN transactions t ON p.transaction_id = t.transaction_id;
```

### ✏️ UPDATE - Modify Payment

```sql
-- Update payment status
UPDATE payments SET payment_status = 'completed' WHERE payment_id = 1;

-- Update gateway reference
UPDATE payments SET gateway_ref = 'PAY_NEW_REF' WHERE payment_id = 1;
```

### ❌ DELETE - Remove Payment

```sql
DELETE FROM payments WHERE payment_id = 10;
```

---

## 📊 Using Views for Easy Queries

### View Available Books
```sql
SELECT * FROM v_available_books;
```

### View Available Notes
```sql
SELECT * FROM v_available_notes;
```

### View Transaction Summary
```sql
SELECT * FROM v_transaction_summary;
```

### View Dashboard Statistics
```sql
SELECT * FROM v_dashboard_stats;
```

---

## 🎯 Complete Example Workflow

### Scenario: User Buys a Book

```sql
-- Step 1: Browse available books
SELECT * FROM v_available_books WHERE category_name = 'Computer Science';

-- Step 2: Check if book is available (using function)
SELECT fn_check_availability('book', 1, 2) AS can_buy;

-- Step 3: Create transaction
CALL sp_create_transaction('book', 1, 2, 4, @trans_id, @amount, @msg);
SELECT @trans_id, @amount, @msg;

-- Step 4: Process payment
CALL sp_process_payment(@trans_id, @amount, 'upi', 'PAY_123', @pay_id, @pay_msg);
SELECT @pay_id, @pay_msg;

-- Step 5: View complete transaction
SELECT * FROM v_transaction_summary WHERE transaction_id = @trans_id;

-- Step 6: Add review
INSERT INTO reviews (comment, rating, item_id, item_type, user_id)
VALUES ('Great book!', 5, 1, 'book', 4);

-- Step 7: Check updated statistics
SELECT * FROM v_dashboard_stats;
```

---

## ✅ Summary

This database provides:
- **8 Main Tables** for complete CRUD operations
- **7 Triggers** for automatic data management
- **5 Stored Procedures** for complex operations
- **4 Functions** for calculations
- **4 Views** for easy querying

**Perfect for DBMS Project!** 🎉

All operations are logged and validated automatically through triggers and procedures.
