# 📚 Old Notes and Books Management System

> A comprehensive **full-stack web application** for buying and selling old books and notes with user authentication, reviews, transactions, and payment processing.

![Status](https://img.shields.io/badge/Status-In%20Development-yellow)
![Backend](https://img.shields.io/badge/Backend-60%25-green)
![Frontend](https://img.shields.io/badge/Frontend-10%25-red)
![Database](https://img.shields.io/badge/Database-100%25-brightgreen)

---

## 🎯 Project Overview

This is a **DBMS mini project** implementing a complete marketplace system with **8 database entities**, a RESTful API backend, and a React frontend.

The system allows users to **buy and sell old books and notes** with features like reviews, ratings, transactions, and payment processing.

### ✨ Key Features

* ✅ User management (Admin, Buyer, Seller)
* ✅ Book & notes management with categories & images
* ✅ Review & rating system (1–5 stars)
* ✅ Secure authentication using JWT
* ✅ Transaction & payment workflow
* ✅ Advanced search & filtering
* ✅ Image upload with primary image support

---

## 📊 Database Entities

```
USER ───▶ BOOK ───▶ REVIEW
 │          │
 │          ▼
 │        IMAGE
 │
 ├──▶ NOTE ───▶ TRANSACTION ───▶ PAYMENT
 │
 └──▶ CATEGORY
```

---

## 🛠️ Tech Stack

### Backend

* **Runtime:** Node.js 18+
* **Framework:** Express.js
* **Database:** MySQL 8
* **ORM:** Sequelize
* **Authentication:** JWT + Bcrypt
* **File Upload:** Multer
* **Validation:** Express Validator

### Frontend

* **Library:** React 18
* **Build Tool:** Vite
* **Routing:** React Router v6
* **HTTP Client:** Axios
* **State Management:** React Context / Hooks

### Database

* **RDBMS:** MySQL 8
* **Features:** Foreign Keys, Indexes, Views, Triggers

---

## 🚀 Quick Start

### Prerequisites

* Node.js 18+
* MySQL 8+
* npm

### 1️⃣ Database Setup

```sql
CREATE DATABASE old_books_notes_db;
```

```bash
mysql -u root -p old_books_notes_db < database/schema.sql
mysql -u root -p old_books_notes_db < database/seed.sql
```

---

### 2️⃣ Backend Setup

```bash
cd server
npm install
cp .env.example .env
npm run dev
```

---

### 3️⃣ Frontend Setup

```bash
cd client
npm install
npm install axios react-router-dom react-toastify
npm run dev
```

---

### 4️⃣ Access Application

* **Frontend:** [http://localhost:5173](http://localhost:5173)
* **Backend API:** [http://localhost:5000/api](http://localhost:5000/api)
* **Health Check:** [http://localhost:5000/api/health](http://localhost:5000/api/health)

---

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

---

## 🔑 API Overview

### Authentication

* `POST /api/auth/register`
* `POST /api/auth/login`
* `GET /api/auth/me`

### Books

* `GET /api/books`
* `POST /api/books`
* `GET /api/books/:id`

### Categories

* `GET /api/categories`
* `POST /api/categories`

---

## 🔐 Default Credentials

```
Admin
Email: admin@example.com
Password: password123

Seller
Email: rajesh.seller@example.com
Password: password123

Buyer
Email: amit.buyer@example.com
Password: password123
```

---

## 📈 Project Progress

| Component    | Status     | Completion |
| ------------ | ---------- | ---------- |
| Database     | ✅ Complete | 100%       |
| Backend APIs | ✅ Partial  | 60%        |
| Frontend     | ⏳ Initial  | 10%        |

---

## 🎯 Next Steps

### Backend

* Notes API
* Reviews API
* Transactions API
* Payments API

### Frontend

* Auth pages
* Book listing & details
* Add/Edit forms
* Payment UI
* Responsive styling

---

## 🐛 Troubleshooting

**Database error:**

```
Access denied for user 'root'
```

➡️ Update DB credentials in `.env`

**Port already in use:**

```
PORT 5000 busy
```

➡️ Change port in `.env`

---

## 🎓 Learning Outcomes

* Database design & normalization
* REST API development
* Sequelize ORM
* Authentication & authorization
* Full-stack architecture

---

## 👨‍💻 Authors

**SAMRUDDHI JADHAV**  
FYMCA Sem 1 - DBMS ISE2  
UCID: 2025510025

**Anshika Jaiswal**  
FYMCA Sem 1 – DBMS ISE2  
UCID: 2025510026  

**Gaurav Jha**  
FYMCA Sem 1 – DBMS ISE2   
UCID: 2025510027  
[GitHub](https://github.com/grvx-github) | [LinkedIn](https://www.linkedin.com/in/grvx)

---

## 🚀 Quick Commands

```bash
# Start backend
cd server && npm start

# Start frontend
cd client && npm run dev

# Run database scripts
mysql -u root -p old_books_notes_db < database/schema.sql
mysql -u root -p old_books_notes_db < database/seed.sql
```

---

**Made with ❤️ for learning DBMS concepts**



