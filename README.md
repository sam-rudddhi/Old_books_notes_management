# 📚 Old Notes and Books Management System

> A comprehensive full-stack web application for buying and selling old books and notes with user authentication, reviews, transactions, and payment processing.

![Status](https://img.shields.io/badge/Status-In%20Development-yellow)
![Backend](https://img.shields.io/badge/Backend-60%25-green)
![Frontend](https://img.shields.io/badge/Frontend-10%25-red)
![Database](https://img.shields.io/badge/Database-100%25-brightgreen)

## 🎯 Project Overview

This is a **DBMS mini project** implementing a complete marketplace system with 8 database entities, RESTful API backend, and React frontend. The system allows users to buy and sell old books and notes with features like reviews, ratings, transactions, and payment processing.

### Key Features

- ✅ **User Management** - Registration, login, role-based access (Admin, Buyer, Seller)
- ✅ **Book & Notes Management** - CRUD operations with categories, images, and reviews
- ✅ **Review System** - Rate and review books/notes (1-5 stars)
- ✅ **Transaction Management** - Complete purchase workflow
- ✅ **Payment Processing** - Multiple payment methods (UPI, Card, Net Banking, Wallet)
- ✅ **Image Upload** - Multiple images per item with primary image selection
- ✅ **Search & Filter** - Advanced search with multiple filters
- ✅ **Authentication** - JWT-based secure authentication

## 📊 Database Entities

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│    USER     │────▶│     BOOK     │────▶│   REVIEW    │
│  (8 users)  │     │  (15 books)  │     │ (15 reviews)│
└─────────────┘     └──────────────┘     └─────────────┘
       │                    │                     
       │                    ▼                     
       │            ┌──────────────┐              
       │            │    IMAGE     │              
       │            │  (20 images) │              
       │            └──────────────┘              
       │                                          
       ├────────────┐                             
       │            │                             
       ▼            ▼                             
┌─────────────┐ ┌──────────────┐                 
│    NOTE     │ │  CATEGORY    │                 
│  (15 notes) │ │(10 categories)│                 
└─────────────┘ └──────────────┘                 
       │                                          
       ▼                                          
┌──────────────┐     ┌──────────────┐            
│ TRANSACTION  │────▶│   PAYMENT    │            
│(10 trans.)   │     │ (10 payments)│            
└──────────────┘     └──────────────┘            
```

## 🛠️ Tech Stack

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: MySQL 8
- **ORM**: Sequelize
- **Authentication**: JWT + Bcrypt
- **File Upload**: Multer
- **Validation**: Express Validator

### Frontend
- **Library**: React 18
- **Build Tool**: Vite
- **Routing**: React Router v6 (to be installed)
- **HTTP Client**: Axios (to be installed)
- **State Management**: React Context/Hooks

### Database
- **RDBMS**: MySQL 8
- **Features**: Foreign Keys, Indexes, Views, Stored Procedures, Triggers

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm
- MySQL 8+
- Git (optional)

### 1. Clone/Download Project
```bash
cd "c:/Users/SAMRUDDHI JADHAV/OneDrive/Documents/Desktop/fymca sem1/dbms ISE2"
```

### 2. Database Setup
```bash
# Create database in MySQL
mysql -u root -p
CREATE DATABASE old_books_notes_db;
exit;

# Run schema
mysql -u root -p old_books_notes_db < database/schema.sql

# Seed sample data
mysql -u root -p old_books_notes_db < database/seed.sql
```

### 3. Backend Setup
```bash
cd server
npm install
copy .env.example .env
# Edit .env with your MySQL password
npm run dev
```

### 4. Frontend Setup
```bash
cd client
npm install
npm install axios react-router-dom react-toastify
npm run dev
```

### 5. Access Application
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:5000/api
- **API Health**: http://localhost:5000/api/health

## 📁 Project Structure

```
dbms ISE2/
├── 📂 database/
│   ├── schema.sql              # Database schema with all tables
│   └── seed.sql                # Sample data
│
├── 📂 server/                  # Express Backend
│   ├── 📂 config/
│   │   └── database.js         # Sequelize configuration
│   ├── 📂 models/              # 8 Sequelize models
│   │   ├── User.js
│   │   ├── Category.js
│   │   ├── Book.js
│   │   ├── Note.js
│   │   ├── Review.js
│   │   ├── Image.js
│   │   ├── Transaction.js
│   │   ├── Payment.js
│   │   └── index.js            # Model associations
│   ├── 📂 controllers/         # Business logic
│   │   ├── authController.js   ✅ Complete
│   │   ├── bookController.js   ✅ Complete
│   │   └── categoryController.js ✅ Complete
│   ├── 📂 routes/              # API routes
│   │   ├── auth.js             ✅ Complete
│   │   ├── books.js            ✅ Complete
│   │   ├── categories.js       ✅ Complete
│   │   ├── notes.js            ⏳ Placeholder
│   │   ├── reviews.js          ⏳ Placeholder
│   │   ├── transactions.js     ⏳ Placeholder
│   │   ├── payments.js         ⏳ Placeholder
│   │   └── users.js            ⏳ Placeholder
│   ├── 📂 middleware/
│   │   ├── auth.js             # JWT authentication
│   │   ├── errorHandler.js     # Error handling
│   │   └── upload.js           # File upload
│   ├── server.js               # Entry point
│   └── package.json
│
├── 📂 client/                  # React Frontend
│   ├── 📂 src/
│   │   ├── 📂 components/      ⏳ To be created
│   │   ├── 📂 pages/           ⏳ To be created
│   │   ├── 📂 services/        ⏳ To be created
│   │   ├── 📂 context/         ⏳ To be created
│   │   ├── App.jsx
│   │   └── main.jsx
│   └── package.json
│
├── 📄 QUICK_START.md           # Quick setup guide
├── 📄 SETUP_GUIDE.md           # Detailed setup instructions
├── 📄 API_TESTING_GUIDE.md     # API testing examples
├── 📄 PROJECT_PLAN.md          # Architecture & design
├── 📄 PROJECT_SUMMARY.md       # Current status
└── 📄 README.md                # This file
```

## 🔑 API Endpoints

### Authentication (`/api/auth`)
- `POST /register` - Register new user
- `POST /login` - User login
- `GET /me` - Get current user (Protected)
- `PUT /profile` - Update profile (Protected)
- `PUT /change-password` - Change password (Protected)

### Books (`/api/books`)
- `GET /` - Get all books (with filters & search)
- `GET /:id` - Get single book
- `POST /` - Create book (Seller/Admin)
- `PUT /:id` - Update book (Owner/Admin)
- `DELETE /:id` - Delete book (Owner/Admin)
- `GET /seller/my-books` - Get seller's books (Seller)

### Categories (`/api/categories`)
- `GET /` - Get all categories
- `GET /:id` - Get single category
- `POST /` - Create category (Admin)
- `PUT /:id` - Update category (Admin)
- `DELETE /:id` - Delete category (Admin)

### Notes, Reviews, Transactions, Payments
- Similar endpoints (to be implemented)

## 🔐 Default Credentials

After seeding the database:

```
Admin:
Email: admin@example.com
Password: password123

Seller:
Email: rajesh.seller@example.com
Password: password123

Buyer:
Email: amit.buyer@example.com
Password: password123
```

## 📊 Sample Data

The seed file includes:
- **8 Users** (1 admin, 3 sellers, 4 buyers)
- **10 Categories** (Computer Science, Mathematics, Physics, etc.)
- **15 Books** (Algorithms, Clean Code, Database Concepts, etc.)
- **15 Notes** (DSA, DBMS, Calculus, etc.)
- **15 Reviews** with ratings
- **20 Images** for books and notes
- **10 Transactions** (completed and pending)
- **10 Payments** (various methods)

## 🧪 Testing the API

### Using Thunder Client (VS Code Extension)

1. Install Thunder Client extension
2. Import the API collection
3. Set environment variable: `baseUrl = http://localhost:5000/api`
4. Test endpoints

### Example Requests

**Register:**
```bash
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "name": "Test User",
  "phone": "9876543210",
  "contact_email": "test@example.com",
  "password": "password123",
  "role": "buyer"
}
```

**Get Books:**
```bash
GET http://localhost:5000/api/books?search=algorithm&category=1
```

**Create Book (Seller):**
```bash
POST http://localhost:5000/api/books
Authorization: Bearer YOUR_TOKEN
Content-Type: application/json

{
  "title": "New Book",
  "author": "Author Name",
  "price": 299.00,
  "quantity": 5,
  "category_id": 1,
  "condition": "good"
}
```

See **API_TESTING_GUIDE.md** for complete testing examples.

## 📈 Project Progress

| Component | Status | Completion |
|-----------|--------|------------|
| Database Schema | ✅ Complete | 100% |
| Sample Data | ✅ Complete | 100% |
| Backend Models | ✅ Complete | 100% |
| Authentication API | ✅ Complete | 100% |
| Books API | ✅ Complete | 100% |
| Categories API | ✅ Complete | 100% |
| Notes API | ⏳ Placeholder | 30% |
| Reviews API | ⏳ Placeholder | 30% |
| Transactions API | ⏳ Placeholder | 30% |
| Payments API | ⏳ Placeholder | 30% |
| Frontend | ⏳ Scaffold | 10% |

**Overall: ~60% Complete**

## 🎯 Next Steps

### Backend (Remaining 40%)
1. Implement Notes controller (similar to Books)
2. Implement Reviews controller
3. Implement Transactions controller
4. Implement Payments controller
5. Implement Users controller
6. Add image upload functionality
7. Add input validation
8. Write unit tests

### Frontend (90% Remaining)
1. Install dependencies (axios, react-router-dom, etc.)
2. Create folder structure
3. Implement authentication pages (Login, Register)
4. Create navigation components (Navbar, Sidebar)
5. Build book/note listing pages
6. Create detail pages
7. Implement forms (Add/Edit)
8. Add review system UI
9. Create transaction/payment flow
10. Add styling (CSS/Tailwind)
11. Make responsive
12. Add error handling
13. Implement loading states

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Get started in 5 minutes
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed setup instructions
- **[API_TESTING_GUIDE.md](API_TESTING_GUIDE.md)** - API testing examples
- **[PROJECT_PLAN.md](PROJECT_PLAN.md)** - Architecture & design
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Current status & progress

## 🐛 Troubleshooting

### Database Connection Error
```
Error: Access denied for user 'root'@'localhost'
```
**Solution:** Update `DB_PASSWORD` in `server/.env`

### Port Already in Use
```
Error: Port 5000 is already in use
```
**Solution:** Change `PORT=5001` in `server/.env`

### Module Not Found
```
Error: Cannot find module 'express'
```
**Solution:** Run `npm install` in server directory

See **SETUP_GUIDE.md** for more troubleshooting tips.

## 🎓 Learning Outcomes

This project demonstrates:
- ✅ Database design and normalization
- ✅ Entity-Relationship modeling
- ✅ SQL programming (DDL, DML, DCL, TCL)
- ✅ RESTful API design
- ✅ Authentication & Authorization
- ✅ ORM usage (Sequelize)
- ✅ MVC architecture
- ⏳ Full-stack development
- ⏳ React component development
- ⏳ State management

## 🤝 Contributing

This is an educational project. To extend it:
1. Implement remaining controllers
2. Build frontend components
3. Add more features (wishlist, notifications, etc.)
4. Improve UI/UX
5. Add unit tests
6. Deploy to production

## 📄 License

Educational project for DBMS ISE2 - FYMCA Sem 1

## 👨‍💻 Author

**SAMRUDDHI JADHAV**  
FYMCA Sem 1 - DBMS ISE2  
December 2025

---

## 🚀 Quick Commands

```bash
# Start backend
cd server && npm run dev

# Start frontend
cd client && npm run dev

# Run database schema
mysql -u root -p old_books_notes_db < database/schema.sql

# Seed database
mysql -u root -p old_books_notes_db < database/seed.sql

# Test API
curl http://localhost:5000/api/health
```

---

**Made with ❤️ for learning DBMS concepts**

For detailed instructions, see [QUICK_START.md](QUICK_START.md)
#   O l d _ b o o k s _ n o t e s _ m a n a g e m e n t  
 