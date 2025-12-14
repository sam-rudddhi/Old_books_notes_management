# MySQL Workbench & phpMyAdmin Guide
## Old Notes and Books Management System

## 📋 Table of Contents
1. [Using MySQL Workbench](#using-mysql-workbench)
2. [Using phpMyAdmin](#using-phpmyadmin)
3. [Testing Triggers](#testing-triggers)
4. [Testing Stored Procedures](#testing-stored-procedures)
5. [Testing Functions](#testing-functions)
6. [CRUD Operations](#crud-operations)

---

## 🔧 Using MySQL Workbench

### Step 1: Import the Database

1. **Open MySQL Workbench**
2. **Connect to your MySQL Server**
   - Click on your local connection (usually `Local instance MySQL80`)
   - Enter your root password

3. **Import the SQL File**
   - Go to `File` → `Open SQL Script`
   - Navigate to: `database/complete_database.sql`
   - Click `Open`

4. **Execute the Script**
   - Click the ⚡ **Execute** button (or press `Ctrl+Shift+Enter`)
   - Wait for execution to complete
   - Check the **Output** panel for success messages

5. **Refresh the Schema**
   - In the left sidebar under **SCHEMAS**, click the refresh icon 🔄
   - You should see `old_books_notes_db`

### Step 2: Explore the Database

1. **View Tables**
   - Expand `old_books_notes_db` → `Tables`
   - You'll see all 10 tables (8 main + 2 audit tables)

2. **View Data**
   - Right-click on any table (e.g., `books`)
   - Select `Select Rows - Limit 1000`
   - Data will appear in the result grid

3. **View Triggers**
   - Expand `old_books_notes_db` → `Tables` → `books`
   - Expand `Triggers`
   - You'll see all triggers for that table

4. **View Stored Procedures**
   - Expand `old_books_notes_db` → `Stored Procedures`
   - You'll see all 5 procedures

5. **View Functions**
   - Expand `old_books_notes_db` → `Functions`
   - You'll see all 4 functions

### Step 3: Execute Queries

**Open a new query tab:**
- Click the 📄 icon or press `Ctrl+T`

**Run queries:**
```sql
-- View all books
SELECT * FROM books;

-- View available books (using view)
SELECT * FROM v_available_books;

-- View dashboard statistics
SELECT * FROM v_dashboard_stats;
```

---

## 🌐 Using phpMyAdmin

### Step 1: Access phpMyAdmin

1. **Start XAMPP/WAMP/MAMP**
   - Start Apache and MySQL services

2. **Open phpMyAdmin**
   - Open browser
   - Go to: `http://localhost/phpmyadmin`

3. **Login**
   - Username: `root`
   - Password: (usually blank or your MySQL password)

### Step 2: Import Database

1. **Click on "Import" tab** at the top

2. **Choose File**
   - Click `Choose File`
   - Select `database/complete_database.sql`

3. **Import Settings**
   - Format: `SQL`
   - Character set: `utf8mb4_unicode_ci`
   - Leave other settings as default

4. **Execute**
   - Scroll down and click `Go`
   - Wait for import to complete

5. **Verify**
   - Click on `old_books_notes_db` in the left sidebar
   - You should see all tables

### Step 3: Explore Database

1. **View Tables**
   - Click on database name in left sidebar
   - All tables will be listed

2. **Browse Data**
   - Click on any table name (e.g., `books`)
   - Click `Browse` tab to see data

3. **View Structure**
   - Click on table name
   - Click `Structure` tab to see columns

4. **View Triggers**
   - Click on table name
   - Click `Triggers` tab

5. **View Procedures/Functions**
   - Click on database name
   - Click `Routines` tab
   - You'll see all procedures and functions

### Step 4: Run SQL Queries

1. **Click on "SQL" tab** at the top

2. **Enter your query:**
```sql
SELECT * FROM v_available_books;
```

3. **Click "Go"** to execute

---

## 🔥 Testing Triggers

### Trigger 1: Book Availability Auto-Update

**Purpose:** Automatically sets `is_available = FALSE` when quantity reaches 0

**Test in MySQL Workbench/phpMyAdmin:**

```sql
-- Check current book quantity
SELECT book_id, title, quantity, is_available FROM books WHERE book_id = 1;

-- Update quantity to 0
UPDATE books SET quantity = 0 WHERE book_id = 1;

-- Check if is_available changed to FALSE (trigger activated)
SELECT book_id, title, quantity, is_available FROM books WHERE book_id = 1;

-- Check inventory log (trigger also logs the change)
SELECT * FROM inventory_log WHERE item_type = 'book' AND item_id = 1;

-- Restore quantity
UPDATE books SET quantity = 5 WHERE book_id = 1;

-- Check if is_available changed back to TRUE
SELECT book_id, title, quantity, is_available FROM books WHERE book_id = 1;
```

**Expected Result:**
- When quantity = 0, `is_available` becomes FALSE
- When quantity > 0, `is_available` becomes TRUE
- Each change is logged in `inventory_log`

### Trigger 2: Primary Image Enforcement

**Purpose:** ~~Ensures only one image is marked as primary per item~~ 

**⚠️ IMPORTANT:** This trigger has been **REMOVED** due to MySQL Error #1442. It was trying to update the `images` table while an INSERT was in progress on the same table, which MySQL doesn't allow.

**New Solution:** Use the `sp_add_image` stored procedure instead.

**Test:**

```sql
-- OLD METHOD (will cause error #1442):
-- INSERT INTO images (img_url, is_primary, item_id, item_type)
-- VALUES ('/uploads/books/new_primary.jpg', TRUE, 1, 'book');

-- NEW METHOD (use stored procedure):
CALL sp_add_image(
    '/uploads/books/new_primary.jpg',  -- img_url
    TRUE,                               -- is_primary
    1,                                  -- item_id
    'book',                             -- item_type
    @message                            -- OUT: message
);

-- View result
SELECT @message;

-- Check - only new image should be primary
SELECT * FROM images WHERE item_type = 'book' AND item_id = 1;
```


### Trigger 3: Audit Log for Book Updates

**Purpose:** Logs all book updates to audit_log table

**Test:**

```sql
-- Update a book
UPDATE books SET price = 475.00 WHERE book_id = 1;

-- Check audit log
SELECT * FROM audit_log WHERE table_name = 'books' AND record_id = 1 ORDER BY changed_at DESC;
```

### Trigger 4: Review Rating Validation

**Purpose:** Ensures rating is between 1 and 5

**Test:**

```sql
-- Try to insert invalid rating (should fail)
INSERT INTO reviews (comment, rating, item_id, item_type, user_id)
VALUES ('Test review', 6, 1, 'book', 4);
-- This should give error: "Rating must be between 1 and 5"

-- Insert valid rating (should succeed)
INSERT INTO reviews (comment, rating, item_id, item_type, user_id)
VALUES ('Great book!', 5, 1, 'book', 4);
```

---

## ⚙️ Testing Stored Procedures

### Procedure 1: Add New Book

```sql
-- Call the procedure
CALL sp_add_book(
    'Design Patterns',              -- title
    'Gang of Four',                 -- author
    '978-0201633610',              -- isbn
    '1st Edition',                  -- edition
    'good',                         -- condition
    420.00,                         -- price
    3,                              -- quantity
    1,                              -- category_id
    2,                              -- seller_id
    'Classic software design book', -- description
    @book_id,                       -- OUT: book_id
    @message                        -- OUT: message
);

-- View the output
SELECT @book_id AS new_book_id, @message AS result_message;

-- Verify the book was added
SELECT * FROM books WHERE book_id = @book_id;
```

### Procedure 2: Create Transaction

```sql
-- Create a transaction for buying a book
CALL sp_create_transaction(
    'book',           -- item_type
    1,                -- item_id (book_id)
    2,                -- quantity
    4,                -- buyer_id
    @trans_id,        -- OUT: transaction_id
    @total,           -- OUT: total_amount
    @msg              -- OUT: message
);

-- View results
SELECT @trans_id AS transaction_id, @total AS total_amount, @msg AS message;

-- Check the transaction
SELECT * FROM transactions WHERE transaction_id = @trans_id;

-- Check if book quantity was reduced
SELECT book_id, title, quantity FROM books WHERE book_id = 1;
```

### Procedure 3: Process Payment

```sql
-- Process payment for the transaction
CALL sp_process_payment(
    @trans_id,                      -- transaction_id from previous procedure
    @total,                         -- amount (must match transaction total)
    'upi',                          -- payment_method
    'PAY_TEST_12345',              -- gateway_ref
    @payment_id,                    -- OUT: payment_id
    @pay_msg                        -- OUT: message
);

-- View results
SELECT @payment_id AS payment_id, @pay_msg AS message;

-- Check payment record
SELECT * FROM payments WHERE payment_id = @payment_id;

-- Check if transaction status changed to 'completed'
SELECT * FROM transactions WHERE transaction_id = @trans_id;
```

### Procedure 4: Get User Statistics

```sql
-- Get statistics for a user
CALL sp_get_user_stats(
    4,                  -- user_id
    @purchases,         -- OUT: total_purchases
    @sales,             -- OUT: total_sales
    @spent,             -- OUT: total_spent
    @earned             -- OUT: total_earned
);

-- View results
SELECT 
    @purchases AS total_purchases,
    @sales AS total_sales,
    @spent AS total_spent,
    @earned AS total_earned;
```

---

## 📊 Testing Functions

### Function 1: Get Average Rating

```sql
-- Get average rating for a book
SELECT fn_get_average_rating('book', 1) AS average_rating;

-- Use in a query
SELECT 
    book_id,
    title,
    fn_get_average_rating('book', book_id) AS avg_rating
FROM books
LIMIT 5;
```

### Function 2: Check Availability

```sql
-- Check if 3 units of book 1 are available
SELECT fn_check_availability('book', 1, 3) AS is_available;

-- Check if 100 units are available (should return 0/FALSE)
SELECT fn_check_availability('book', 1, 100) AS is_available;
```

### Function 3: Calculate Seller Revenue

```sql
-- Get total revenue for seller 2
SELECT fn_seller_revenue(2) AS total_revenue;

-- Get revenue for all sellers
SELECT 
    user_id,
    name,
    fn_seller_revenue(user_id) AS total_revenue
FROM users
WHERE role = 'seller';
```

### Function 4: Get Item Price

```sql
-- Get price of a book
SELECT fn_get_item_price('book', 1) AS book_price;

-- Get price of a note
SELECT fn_get_item_price('note', 1) AS note_price;
```

---

## 📝 CRUD Operations

### CREATE Operations

**Add a Book:**
```sql
INSERT INTO books (title, author, isbn, edition, `condition`, price, quantity, category_id, seller_id, description)
VALUES ('New Book Title', 'Author Name', '978-1234567890', '1st Edition', 'new', 299.99, 5, 1, 2, 'Book description');
```

**Add a Note:**
```sql
INSERT INTO notes (subject, topic, format, summary, price, note_quantity, category_id, seller_id)
VALUES ('Mathematics', 'Linear Algebra', 'pdf', 'Complete notes on linear algebra', 150.00, 10, 2, 2);
```

**Add a Review:**
```sql
INSERT INTO reviews (comment, rating, item_id, item_type, user_id)
VALUES ('Excellent book!', 5, 1, 'book', 4);
```

**Add a Category:**
```sql
INSERT INTO categories (category_name, description)
VALUES ('Biology', 'Biology books and study materials');
```

### READ Operations

**Get All Books:**
```sql
SELECT * FROM books;
```

**Get Available Books (using view):**
```sql
SELECT * FROM v_available_books;
```

**Get Books by Category:**
```sql
SELECT * FROM books WHERE category_id = 1;
```

**Get Books with Reviews:**
```sql
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.price,
    COUNT(r.review_id) AS review_count,
    AVG(r.rating) AS avg_rating
FROM books b
LEFT JOIN reviews r ON r.item_type = 'book' AND r.item_id = b.book_id
GROUP BY b.book_id;
```

**Search Books:**
```sql
SELECT * FROM books 
WHERE title LIKE '%algorithm%' 
   OR author LIKE '%algorithm%';
```

**Get Transaction Summary:**
```sql
SELECT * FROM v_transaction_summary;
```

**Get Dashboard Stats:**
```sql
SELECT * FROM v_dashboard_stats;
```

### UPDATE Operations

**Update Book Price:**
```sql
UPDATE books 
SET price = 425.00 
WHERE book_id = 1;
```

**Update Book Quantity:**
```sql
UPDATE books 
SET quantity = quantity - 1 
WHERE book_id = 1;
```

**Update User Profile:**
```sql
UPDATE users 
SET phone = '9999999999', address = 'New Address' 
WHERE user_id = 4;
```

**Update Transaction Status:**
```sql
UPDATE transactions 
SET status = 'completed' 
WHERE transaction_id = 1;
```

### DELETE Operations

**Delete a Book:**
```sql
DELETE FROM books WHERE book_id = 10;
```

**Delete a Review:**
```sql
DELETE FROM reviews WHERE review_id = 5;
```

**Delete a Category (will set category_id to NULL in books/notes):**
```sql
DELETE FROM categories WHERE category_id = 10;
```

---

## 🎯 Complete Testing Workflow

### Scenario 1: Add Book and Test Triggers

```sql
-- 1. Add a new book
INSERT INTO books (title, author, price, quantity, category_id, seller_id)
VALUES ('Test Book', 'Test Author', 299.00, 5, 1, 2);

SET @new_book_id = LAST_INSERT_ID();

-- 2. Check audit log
SELECT * FROM audit_log WHERE table_name = 'books' AND record_id = @new_book_id;

-- 3. Update quantity to 0 (trigger will set is_available = FALSE)
UPDATE books SET quantity = 0 WHERE book_id = @new_book_id;

-- 4. Check if trigger worked
SELECT book_id, title, quantity, is_available FROM books WHERE book_id = @new_book_id;

-- 5. Check inventory log
SELECT * FROM inventory_log WHERE item_type = 'book' AND item_id = @new_book_id;
```

### Scenario 2: Complete Purchase Flow

```sql
-- 1. Create transaction using procedure
CALL sp_create_transaction('book', 1, 2, 4, @trans_id, @amount, @msg);
SELECT @trans_id, @amount, @msg;

-- 2. Process payment using procedure
CALL sp_process_payment(@trans_id, @amount, 'upi', 'PAY_123', @pay_id, @pay_msg);
SELECT @pay_id, @pay_msg;

-- 3. View complete transaction
SELECT * FROM v_transaction_summary WHERE transaction_id = @trans_id;

-- 4. Check user statistics
CALL sp_get_user_stats(4, @purchases, @sales, @spent, @earned);
SELECT @purchases, @sales, @spent, @earned;
```

---

## 📌 Quick Reference

### View All Triggers
```sql
SHOW TRIGGERS FROM old_books_notes_db;
```

### View All Procedures
```sql
SHOW PROCEDURE STATUS WHERE Db = 'old_books_notes_db';
```

### View All Functions
```sql
SHOW FUNCTION STATUS WHERE Db = 'old_books_notes_db';
```

### View Procedure/Function Code
```sql
SHOW CREATE PROCEDURE sp_add_book;
SHOW CREATE FUNCTION fn_get_average_rating;
```

### View All Views
```sql
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

---

## 🎓 Summary of PL/SQL Features

### ✅ **6 Triggers** (Updated - Primary Image Trigger Removed)
1. Book availability auto-update
2. Note availability auto-update
3. ~~Primary image enforcement~~ (REMOVED - replaced with stored procedure)
4. Book update audit log
5. Book deletion audit log
6. Review rating validation
7. Payment auto-update transaction

### ✅ **6 Stored Procedures** (Updated - Added sp_add_image)
1. `sp_add_book` - Add new book
2. `sp_add_note` - Add new note
3. `sp_create_transaction` - Create transaction with inventory update
4. `sp_process_payment` - Process payment and update status
5. `sp_get_user_stats` - Get user purchase/sales statistics
6. `sp_add_image` - Add image with primary image enforcement (replaces trigger)


### ✅ **4 Functions**
1. `fn_get_average_rating` - Calculate average rating
2. `fn_check_availability` - Check item availability
3. `fn_seller_revenue` - Calculate seller revenue
4. `fn_get_item_price` - Get item price

### ✅ **4 Views**
1. `v_available_books` - Available books with details
2. `v_available_notes` - Available notes with details
3. `v_transaction_summary` - Complete transaction details
4. `v_dashboard_stats` - Dashboard statistics

---

**Perfect for DBMS Project Demonstration!** 🎉

This database showcases all major PL/SQL concepts:
- ✅ Triggers (BEFORE/AFTER, INSERT/UPDATE/DELETE)
- ✅ Stored Procedures (with IN/OUT parameters)
- ✅ Functions (DETERMINISTIC, READS SQL DATA)
- ✅ Views (Simple and Complex)
- ✅ Transactions (COMMIT/ROLLBACK)
- ✅ Error Handling (SIGNAL, EXIT HANDLER)
- ✅ Audit Logging
- ✅ Referential Integrity
