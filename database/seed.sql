-- =====================================================
-- Sample Data for Old Notes and Books Management System
-- =====================================================

USE old_books_notes_db;

-- =====================================================
-- SAMPLE USERS
-- =====================================================
-- Password for all users: password123 (hashed with bcrypt)
INSERT INTO users (name, phone, address, contact_email, role, password_hash) VALUES
('Admin User', '9876543210', '123 Admin Street, Mumbai, Maharashtra', 'admin@example.com', 'admin', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Rajesh Kumar', '9876543211', '45 MG Road, Bangalore, Karnataka', 'rajesh.seller@example.com', 'seller', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Priya Sharma', '9876543212', '78 Park Street, Kolkata, West Bengal', 'priya.seller@example.com', 'seller', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Amit Patel', '9876543213', '12 Civil Lines, Delhi', 'amit.buyer@example.com', 'buyer', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Sneha Reddy', '9876543214', '34 Banjara Hills, Hyderabad, Telangana', 'sneha.buyer@example.com', 'buyer', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Vikram Singh', '9876543215', '56 Marine Drive, Mumbai, Maharashtra', 'vikram.seller@example.com', 'seller', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Ananya Iyer', '9876543216', '89 Anna Nagar, Chennai, Tamil Nadu', 'ananya.buyer@example.com', 'buyer', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y'),
('Karan Mehta', '9876543217', '23 SG Highway, Ahmedabad, Gujarat', 'karan.buyer@example.com', 'buyer', '$2b$10$rKvVJKxZ8qH5YqGqxH5YqOxH5YqGqxH5YqGqxH5YqGqxH5YqGqxH5Y');

-- =====================================================
-- SAMPLE CATEGORIES
-- =====================================================
INSERT INTO categories (category_name, description) VALUES
('Computer Science', 'Books and notes related to computer science, programming, and IT'),
('Mathematics', 'Mathematical books, study guides, and notes'),
('Physics', 'Physics textbooks, reference materials, and notes'),
('Chemistry', 'Chemistry books and laboratory notes'),
('Biology', 'Biology textbooks and study materials'),
('Engineering', 'Engineering books across various disciplines'),
('Business & Management', 'Business, management, and economics books'),
('Literature', 'Fiction, non-fiction, and literary works'),
('History', 'History books and historical references'),
('General Studies', 'General knowledge and competitive exam materials');

-- =====================================================
-- SAMPLE BOOKS
-- =====================================================
INSERT INTO books (title, author, isbn, edition, `condition`, price, quantity, category_id, seller_id, description) VALUES
('Introduction to Algorithms', 'Thomas H. Cormen', '978-0262033848', '3rd Edition', 'good', 450.00, 3, 1, 2, 'Comprehensive textbook on algorithms and data structures. Widely used in computer science courses.'),
('Clean Code', 'Robert C. Martin', '978-0132350884', '1st Edition', 'like-new', 350.00, 2, 1, 2, 'A handbook of agile software craftsmanship. Essential for every programmer.'),
('Database System Concepts', 'Abraham Silberschatz', '978-0073523323', '7th Edition', 'good', 500.00, 4, 1, 3, 'Comprehensive database textbook covering SQL, NoSQL, and database design.'),
('Calculus: Early Transcendentals', 'James Stewart', '978-1285741550', '8th Edition', 'fair', 400.00, 2, 2, 2, 'Classic calculus textbook with detailed explanations and examples.'),
('Linear Algebra and Its Applications', 'Gilbert Strang', '978-0030105678', '4th Edition', 'good', 380.00, 3, 2, 3, 'Comprehensive linear algebra textbook with applications.'),
('Concepts of Physics', 'H.C. Verma', '978-8177091878', 'Vol 1 & 2', 'excellent', 600.00, 5, 3, 6, 'Popular physics textbook for JEE preparation and undergraduate studies.'),
('Organic Chemistry', 'Morrison and Boyd', '978-0136436690', '7th Edition', 'good', 420.00, 2, 4, 2, 'Comprehensive organic chemistry textbook.'),
('Campbell Biology', 'Jane B. Reece', '978-0321558237', '11th Edition', 'like-new', 550.00, 3, 5, 3, 'Comprehensive biology textbook for undergraduate students.'),
('Engineering Mechanics', 'R.S. Khurmi', '978-8121925891', '15th Edition', 'good', 320.00, 4, 6, 6, 'Essential engineering mechanics book for engineering students.'),
('Principles of Management', 'Peter Drucker', '978-0060878979', '1st Edition', 'fair', 280.00, 2, 7, 2, 'Classic management principles and practices.'),
('To Kill a Mockingbird', 'Harper Lee', '978-0061120084', 'Reprint', 'good', 150.00, 3, 8, 3, 'Classic American literature masterpiece.'),
('A Brief History of Time', 'Stephen Hawking', '978-0553380163', '1st Edition', 'like-new', 250.00, 2, 9, 6, 'Popular science book about cosmology and the universe.'),
('The Art of Computer Programming', 'Donald Knuth', '978-0201896831', 'Vol 1-3', 'excellent', 800.00, 1, 1, 2, 'Comprehensive computer programming reference.'),
('Data Structures and Algorithms in Java', 'Robert Lafore', '978-0672324536', '2nd Edition', 'good', 380.00, 3, 1, 3, 'Practical guide to data structures in Java.'),
('Operating System Concepts', 'Silberschatz', '978-1118063330', '9th Edition', 'good', 480.00, 2, 1, 6, 'Comprehensive operating systems textbook.');

-- =====================================================
-- SAMPLE NOTES
-- =====================================================
INSERT INTO notes (subject, topic, format, summary, price, note_quantity, category_id, seller_id) VALUES
('Data Structures', 'Complete DSA Notes with Examples', 'pdf', 'Comprehensive notes covering arrays, linked lists, trees, graphs, sorting, and searching algorithms with code examples in C++ and Java.', 150.00, 10, 1, 2),
('DBMS', 'Database Management Systems - Complete Notes', 'digital', 'Full semester notes covering SQL, normalization, ER diagrams, transactions, and indexing. Includes solved examples and previous year questions.', 120.00, 8, 1, 3),
('Calculus', 'Differential and Integral Calculus Study Guide', 'handwritten', 'Handwritten notes with detailed solutions to calculus problems. Covers limits, derivatives, integrals, and applications.', 100.00, 5, 2, 2),
('Linear Algebra', 'Matrix Theory and Linear Transformations', 'printed', 'Printed notes covering vector spaces, eigenvalues, eigenvectors, and linear transformations with solved problems.', 130.00, 6, 2, 6),
('Quantum Mechanics', 'Introduction to Quantum Physics', 'pdf', 'Comprehensive notes on quantum mechanics fundamentals, wave functions, and Schrödinger equation.', 140.00, 7, 3, 3),
('Thermodynamics', 'Heat and Thermodynamics Notes', 'digital', 'Complete notes on laws of thermodynamics, heat engines, and entropy with numerical problems.', 110.00, 8, 3, 6),
('Organic Chemistry', 'Reaction Mechanisms and Synthesis', 'handwritten', 'Detailed handwritten notes on organic reactions, mechanisms, and synthesis pathways.', 125.00, 4, 4, 2),
('Cell Biology', 'Cell Structure and Function Notes', 'pdf', 'Comprehensive notes on cell biology, organelles, cell division, and molecular biology.', 115.00, 9, 5, 3),
('Machine Design', 'Mechanical Engineering Design Notes', 'printed', 'Complete notes on machine design, stress analysis, and mechanical components.', 135.00, 5, 6, 6),
('Financial Accounting', 'Accounting Principles and Practice', 'digital', 'Notes covering accounting principles, financial statements, and bookkeeping with examples.', 105.00, 10, 7, 2),
('Computer Networks', 'Networking Fundamentals', 'pdf', 'Complete notes on OSI model, TCP/IP, routing protocols, and network security.', 145.00, 6, 1, 3),
('Object Oriented Programming', 'OOP Concepts in Java and C++', 'digital', 'Detailed notes on OOP principles, inheritance, polymorphism, and design patterns.', 130.00, 8, 1, 2),
('Probability and Statistics', 'Statistical Methods and Probability', 'printed', 'Notes covering probability distributions, hypothesis testing, and statistical inference.', 120.00, 7, 2, 6),
('Electromagnetic Theory', 'Maxwell Equations and Applications', 'pdf', 'Comprehensive notes on electromagnetic fields, waves, and Maxwell equations.', 135.00, 5, 3, 3),
('Microeconomics', 'Economic Theory and Applications', 'digital', 'Notes on supply-demand, market structures, and consumer behavior.', 110.00, 9, 7, 2);

-- =====================================================
-- SAMPLE REVIEWS
-- =====================================================
INSERT INTO reviews (comment, rating, item_id, item_type, user_id) VALUES
('Excellent book! Very comprehensive and well-written. Helped me a lot in my algorithms course.', 5, 1, 'book', 4),
('Good condition book. Content is great but a bit advanced for beginners.', 4, 1, 'book', 5),
('Clean Code is a must-read for every developer. This copy is in great condition.', 5, 2, 'book', 7),
('Very helpful notes! Clear explanations and good examples. Highly recommended.', 5, 1, 'note', 4),
('Good notes but could use more examples. Overall helpful for exam preparation.', 4, 1, 'note', 5),
('Excellent DBMS notes! Covers all topics thoroughly. Worth the price.', 5, 2, 'note', 7),
('Great calculus study guide. Handwritten notes are clear and easy to follow.', 5, 3, 'note', 4),
('The book arrived in good condition as described. Very satisfied with the purchase.', 4, 3, 'book', 8),
('Perfect for JEE preparation. HC Verma is the best physics book!', 5, 6, 'book', 5),
('Good quality notes. Helped me score well in my linear algebra exam.', 4, 4, 'note', 7),
('Comprehensive database book. A bit heavy but covers everything you need.', 4, 3, 'book', 4),
('These OOP notes are excellent! Clear concepts and good code examples.', 5, 12, 'note', 5),
('Classic literature at a great price. Book condition is acceptable.', 4, 11, 'book', 8),
('Very detailed computer networks notes. Covers all important protocols.', 5, 11, 'note', 4),
('Good engineering mechanics book. Useful for semester exams.', 4, 9, 'book', 7);

-- =====================================================
-- SAMPLE IMAGES
-- =====================================================
INSERT INTO images (img_url, is_primary, item_id, item_type) VALUES
('/uploads/books/algorithms_cover.jpg', TRUE, 1, 'book'),
('/uploads/books/algorithms_back.jpg', FALSE, 1, 'book'),
('/uploads/books/clean_code_cover.jpg', TRUE, 2, 'book'),
('/uploads/books/database_concepts_cover.jpg', TRUE, 3, 'book'),
('/uploads/books/calculus_cover.jpg', TRUE, 4, 'book'),
('/uploads/books/linear_algebra_cover.jpg', TRUE, 5, 'book'),
('/uploads/books/hc_verma_cover.jpg', TRUE, 6, 'book'),
('/uploads/books/organic_chem_cover.jpg', TRUE, 7, 'book'),
('/uploads/books/campbell_biology_cover.jpg', TRUE, 8, 'book'),
('/uploads/books/engineering_mechanics_cover.jpg', TRUE, 9, 'book'),
('/uploads/notes/dsa_notes_preview.jpg', TRUE, 1, 'note'),
('/uploads/notes/dsa_notes_page1.jpg', FALSE, 1, 'note'),
('/uploads/notes/dbms_notes_preview.jpg', TRUE, 2, 'note'),
('/uploads/notes/calculus_notes_preview.jpg', TRUE, 3, 'note'),
('/uploads/notes/linear_algebra_notes_preview.jpg', TRUE, 4, 'note'),
('/uploads/notes/quantum_mechanics_preview.jpg', TRUE, 5, 'note'),
('/uploads/notes/thermodynamics_preview.jpg', TRUE, 6, 'note'),
('/uploads/notes/organic_chem_notes_preview.jpg', TRUE, 7, 'note'),
('/uploads/notes/cell_biology_preview.jpg', TRUE, 8, 'note'),
('/uploads/notes/machine_design_preview.jpg', TRUE, 9, 'note');

-- =====================================================
-- SAMPLE TRANSACTIONS
-- =====================================================
INSERT INTO transactions (total_amount, status, item_type, item_id, quantity, buyer_id, seller_id, transaction_date) VALUES
(450.00, 'completed', 'book', 1, 1, 4, 2, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(150.00, 'completed', 'note', 1, 1, 4, 2, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(350.00, 'completed', 'book', 2, 1, 5, 2, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(120.00, 'completed', 'note', 2, 1, 5, 3, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(500.00, 'completed', 'book', 3, 1, 7, 3, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(100.00, 'completed', 'note', 3, 1, 7, 2, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(600.00, 'completed', 'book', 6, 1, 5, 6, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(380.00, 'pending', 'book', 5, 1, 8, 3, NOW()),
(145.00, 'pending', 'note', 11, 1, 4, 3, NOW()),
(280.00, 'completed', 'book', 10, 1, 7, 2, DATE_SUB(NOW(), INTERVAL 6 DAY));

-- =====================================================
-- SAMPLE PAYMENTS
-- =====================================================
INSERT INTO payments (amount, payment_status, gateway_ref, payment_method, transaction_id, payment_date) VALUES
(450.00, 'completed', 'PAY_1234567890', 'upi', 1, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(150.00, 'completed', 'PAY_1234567891', 'card', 2, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(350.00, 'completed', 'PAY_1234567892', 'netbanking', 3, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(120.00, 'completed', 'PAY_1234567893', 'upi', 4, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(500.00, 'completed', 'PAY_1234567894', 'card', 5, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(100.00, 'completed', 'PAY_1234567895', 'wallet', 6, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(600.00, 'completed', 'PAY_1234567896', 'upi', 7, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(380.00, 'pending', NULL, 'card', 8, NOW()),
(145.00, 'pending', NULL, 'upi', 9, NOW()),
(280.00, 'completed', 'PAY_1234567897', 'netbanking', 10, DATE_SUB(NOW(), INTERVAL 6 DAY));

-- =====================================================
-- VERIFY DATA
-- =====================================================

-- Display summary
SELECT 'Database seeded successfully!' AS message;
SELECT COUNT(*) AS total_users FROM users;
SELECT COUNT(*) AS total_categories FROM categories;
SELECT COUNT(*) AS total_books FROM books;
SELECT COUNT(*) AS total_notes FROM notes;
SELECT COUNT(*) AS total_reviews FROM reviews;
SELECT COUNT(*) AS total_images FROM images;
SELECT COUNT(*) AS total_transactions FROM transactions;
SELECT COUNT(*) AS total_payments FROM payments;

-- Display dashboard stats
SELECT * FROM dashboard_stats;
