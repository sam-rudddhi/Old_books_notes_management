# Old Notes and Books Management System - React Full Stack Project

## 📋 Project Overview
A comprehensive full-stack web application for managing old books and notes with user authentication, reviews, transactions, and payment processing.

## 🎯 Entities & Database Schema

### 1. USER
- `user_id` (PK, Auto Increment)
- `name` (VARCHAR 100)
- `phone` (VARCHAR 15)
- `address` (TEXT)
- `contact_email` (VARCHAR 100, UNIQUE)
- `role` (ENUM: 'admin', 'buyer', 'seller')
- `password_hash` (VARCHAR 255)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

### 2. CATEGORY
- `category_id` (PK, Auto Increment)
- `category_name` (VARCHAR 100, UNIQUE)
- `description` (TEXT)
- `created_at` (TIMESTAMP)

### 3. BOOK
- `book_id` (PK, Auto Increment)
- `title` (VARCHAR 255)
- `author` (VARCHAR 100)
- `isbn` (VARCHAR 20, UNIQUE)
- `edition` (VARCHAR 50)
- `condition` (ENUM: 'new', 'like-new', 'good', 'fair', 'poor')
- `price` (DECIMAL 10,2)
- `quantity` (INT)
- `category_id` (FK → CATEGORY)
- `seller_id` (FK → USER)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

### 4. NOTE
- `note_id` (PK, Auto Increment)
- `subject` (VARCHAR 100)
- `topic` (VARCHAR 255)
- `format` (ENUM: 'pdf', 'handwritten', 'printed', 'digital')
- `summary` (TEXT)
- `price` (DECIMAL 10,2)
- `note_quantity` (INT)
- `category_id` (FK → CATEGORY)
- `seller_id` (FK → USER)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

### 5. REVIEW
- `review_id` (PK, Auto Increment)
- `comment` (TEXT)
- `rating` (INT, 1-5)
- `review_date` (TIMESTAMP)
- `item_id` (INT)
- `item_type` (ENUM: 'book', 'note')
- `user_id` (FK → USER)
- `created_at` (TIMESTAMP)

### 6. IMAGE
- `img_url` (PK, VARCHAR 500)
- `is_primary` (BOOLEAN)
- `uploaded_date` (TIMESTAMP)
- `item_id` (INT)
- `item_type` (ENUM: 'book', 'note')

### 7. TRANSACTION
- `transaction_id` (PK, Auto Increment)
- `transaction_date` (TIMESTAMP)
- `total_amount` (DECIMAL 10,2)
- `status` (ENUM: 'pending', 'completed', 'cancelled', 'refunded')
- `item_type` (ENUM: 'book', 'note')
- `item_id` (INT)
- `quantity` (INT)
- `buyer_id` (FK → USER)
- `seller_id` (FK → USER)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

### 8. PAYMENT
- `payment_id` (PK, Auto Increment)
- `amount` (DECIMAL 10,2)
- `payment_status` (ENUM: 'pending', 'completed', 'failed', 'refunded')
- `payment_date` (TIMESTAMP)
- `gateway_ref` (VARCHAR 255)
- `payment_method` (ENUM: 'card', 'upi', 'netbanking', 'wallet')
- `transaction_id` (FK → TRANSACTION)
- `created_at` (TIMESTAMP)

## 🏗️ Tech Stack

### Frontend
- **React 18** - UI Library
- **Vite** - Build tool and dev server
- **React Router v6** - Client-side routing
- **Axios** - HTTP client
- **React Query (TanStack Query)** - Server state management
- **React Hook Form** - Form handling
- **Yup** - Form validation
- **CSS Modules** - Component-scoped styling
- **Font Awesome** - Icons
- **React Toastify** - Notifications

### Backend
- **Node.js 18+** - Runtime
- **Express.js** - Web framework
- **MySQL 8** - Database
- **Sequelize** - ORM
- **JWT (jsonwebtoken)** - Authentication
- **Bcrypt** - Password hashing
- **Multer** - File uploads
- **Cors** - Cross-origin resource sharing
- **Dotenv** - Environment variables
- **Express Validator** - Input validation

### Development Tools
- **Nodemon** - Auto-restart server
- **ESLint** - Code linting
- **Prettier** - Code formatting

## 📁 Project Structure

```
old-notes-books-system/
├── client/                          # React Frontend
│   ├── public/
│   │   └── uploads/                 # Uploaded images
│   ├── src/
│   │   ├── assets/                  # Static assets
│   │   ├── components/              # Reusable components
│   │   │   ├── common/
│   │   │   │   ├── Navbar.jsx
│   │   │   │   ├── Footer.jsx
│   │   │   │   ├── Loader.jsx
│   │   │   │   └── ErrorBoundary.jsx
│   │   │   ├── auth/
│   │   │   │   ├── Login.jsx
│   │   │   │   ├── Register.jsx
│   │   │   │   └── ProtectedRoute.jsx
│   │   │   ├── books/
│   │   │   │   ├── BookList.jsx
│   │   │   │   ├── BookCard.jsx
│   │   │   │   ├── BookDetail.jsx
│   │   │   │   └── BookForm.jsx
│   │   │   ├── notes/
│   │   │   │   ├── NoteList.jsx
│   │   │   │   ├── NoteCard.jsx
│   │   │   │   ├── NoteDetail.jsx
│   │   │   │   └── NoteForm.jsx
│   │   │   ├── reviews/
│   │   │   │   ├── ReviewList.jsx
│   │   │   │   └── ReviewForm.jsx
│   │   │   ├── transactions/
│   │   │   │   ├── TransactionList.jsx
│   │   │   │   └── TransactionDetail.jsx
│   │   │   └── payment/
│   │   │       └── PaymentForm.jsx
│   │   ├── pages/
│   │   │   ├── Home.jsx
│   │   │   ├── Dashboard.jsx
│   │   │   ├── Books.jsx
│   │   │   ├── Notes.jsx
│   │   │   ├── Profile.jsx
│   │   │   └── NotFound.jsx
│   │   ├── services/                # API services
│   │   │   ├── api.js
│   │   │   ├── authService.js
│   │   │   ├── bookService.js
│   │   │   ├── noteService.js
│   │   │   ├── reviewService.js
│   │   │   ├── transactionService.js
│   │   │   └── paymentService.js
│   │   ├── context/                 # React Context
│   │   │   └── AuthContext.jsx
│   │   ├── hooks/                   # Custom hooks
│   │   │   └── useAuth.js
│   │   ├── utils/                   # Utility functions
│   │   │   ├── validators.js
│   │   │   └── helpers.js
│   │   ├── styles/                  # Global styles
│   │   │   ├── index.css
│   │   │   └── variables.css
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── package.json
│   └── vite.config.js
│
├── server/                          # Express Backend
│   ├── config/
│   │   ├── database.js              # Database connection
│   │   └── config.js                # App configuration
│   ├── models/                      # Sequelize models
│   │   ├── index.js
│   │   ├── User.js
│   │   ├── Category.js
│   │   ├── Book.js
│   │   ├── Note.js
│   │   ├── Review.js
│   │   ├── Image.js
│   │   ├── Transaction.js
│   │   └── Payment.js
│   ├── controllers/                 # Route controllers
│   │   ├── authController.js
│   │   ├── userController.js
│   │   ├── categoryController.js
│   │   ├── bookController.js
│   │   ├── noteController.js
│   │   ├── reviewController.js
│   │   ├── transactionController.js
│   │   └── paymentController.js
│   ├── routes/                      # API routes
│   │   ├── auth.js
│   │   ├── users.js
│   │   ├── categories.js
│   │   ├── books.js
│   │   ├── notes.js
│   │   ├── reviews.js
│   │   ├── transactions.js
│   │   └── payments.js
│   ├── middleware/
│   │   ├── auth.js                  # JWT authentication
│   │   ├── upload.js                # File upload
│   │   ├── errorHandler.js
│   │   └── validators.js
│   ├── utils/
│   │   ├── jwt.js
│   │   └── helpers.js
│   ├── uploads/                     # Uploaded files
│   ├── server.js                    # Entry point
│   └── package.json
│
├── database/
│   ├── schema.sql                   # Database schema
│   └── seed.sql                     # Sample data
│
├── .env.example
├── .gitignore
└── README.md
```

## 🔑 Key Features

### User Features
1. **Authentication & Authorization**
   - User registration with role selection
   - Login/Logout with JWT tokens
   - Role-based access control (Admin, Buyer, Seller)

2. **Book Management**
   - Browse books by category
   - Search and filter books
   - View book details with images
   - Add/Edit/Delete books (Sellers only)
   - Check availability and quantity

3. **Notes Management**
   - Browse notes by subject/topic
   - Search and filter notes
   - View note details with preview
   - Add/Edit/Delete notes (Sellers only)
   - Multiple format support

4. **Review System**
   - Rate and review books/notes
   - View average ratings
   - Read user reviews
   - Edit/Delete own reviews

5. **Transaction Management**
   - Add items to cart
   - Checkout process
   - View transaction history
   - Track order status
   - Cancel pending orders

6. **Payment Processing**
   - Multiple payment methods
   - Secure payment gateway integration
   - Payment status tracking
   - Transaction receipts

7. **Image Management**
   - Upload multiple images per item
   - Set primary image
   - Image preview and gallery
   - Automatic image optimization

### Admin Features
- User management
- Category management
- Transaction monitoring
- Payment verification
- System analytics and reports

## 🚀 Installation & Setup

### Prerequisites
- Node.js 18+ and npm
- MySQL 8+
- Git

### Backend Setup
```bash
# Navigate to server directory
cd server

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Configure database in .env
# DB_HOST=localhost
# DB_USER=root
# DB_PASSWORD=your_password
# DB_NAME=old_books_notes_db
# JWT_SECRET=your_secret_key

# Create database
mysql -u root -p
CREATE DATABASE old_books_notes_db;

# Run migrations (Sequelize will create tables)
npm run migrate

# Seed database with sample data
npm run seed

# Start development server
npm run dev
```

### Frontend Setup
```bash
# Navigate to client directory
cd client

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Configure API URL in .env
# VITE_API_URL=http://localhost:5000/api

# Start development server
npm run dev
```

### Access the Application
- Frontend: http://localhost:5173
- Backend API: http://localhost:5000/api

## 🔐 Default Credentials
```
Admin:
Email: admin@example.com
Password: admin123

Seller:
Email: seller@example.com
Password: seller123

Buyer:
Email: buyer@example.com
Password: buyer123
```

## 📊 API Endpoints

### Authentication
- POST `/api/auth/register` - Register new user
- POST `/api/auth/login` - User login
- GET `/api/auth/me` - Get current user
- POST `/api/auth/logout` - User logout

### Users
- GET `/api/users` - Get all users (Admin)
- GET `/api/users/:id` - Get user by ID
- PUT `/api/users/:id` - Update user
- DELETE `/api/users/:id` - Delete user (Admin)

### Categories
- GET `/api/categories` - Get all categories
- POST `/api/categories` - Create category (Admin)
- PUT `/api/categories/:id` - Update category (Admin)
- DELETE `/api/categories/:id` - Delete category (Admin)

### Books
- GET `/api/books` - Get all books
- GET `/api/books/:id` - Get book by ID
- POST `/api/books` - Create book (Seller)
- PUT `/api/books/:id` - Update book (Seller/Admin)
- DELETE `/api/books/:id` - Delete book (Seller/Admin)

### Notes
- GET `/api/notes` - Get all notes
- GET `/api/notes/:id` - Get note by ID
- POST `/api/notes` - Create note (Seller)
- PUT `/api/notes/:id` - Update note (Seller/Admin)
- DELETE `/api/notes/:id` - Delete note (Seller/Admin)

### Reviews
- GET `/api/reviews/item/:itemType/:itemId` - Get reviews for item
- POST `/api/reviews` - Create review
- PUT `/api/reviews/:id` - Update review
- DELETE `/api/reviews/:id` - Delete review

### Transactions
- GET `/api/transactions` - Get user transactions
- GET `/api/transactions/:id` - Get transaction by ID
- POST `/api/transactions` - Create transaction
- PUT `/api/transactions/:id` - Update transaction status

### Payments
- POST `/api/payments` - Process payment
- GET `/api/payments/:id` - Get payment details
- PUT `/api/payments/:id/verify` - Verify payment

## 🎨 UI/UX Features
- Responsive design for all devices
- Modern, clean interface
- Smooth animations and transitions
- Loading states and error handling
- Toast notifications
- Image galleries
- Search with autocomplete
- Filtering and sorting
- Pagination

## 🔒 Security Features
- JWT-based authentication
- Password hashing with bcrypt
- Input validation and sanitization
- SQL injection prevention (Sequelize ORM)
- XSS protection
- CORS configuration
- Rate limiting
- Secure file uploads

## 📈 Future Enhancements
- Real-time chat between buyers and sellers
- Wishlist functionality
- Advanced search with filters
- Email notifications
- SMS notifications
- Social media integration
- Analytics dashboard
- Export reports (PDF, Excel)
- Multi-language support
- Dark mode

## 📝 License
Educational project for DBMS ISE2

---
**Created by:** SAMRUDDHI JADHAV
**Date:** December 2025
