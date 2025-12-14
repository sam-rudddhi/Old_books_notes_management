# 📚 Old Notes and Books Management System - Complete Setup Guide

A full-stack MERN application for managing old books and notes with user authentication, reviews, transactions, and payment processing.

## 🎯 Project Overview

This is a comprehensive mini project implementing a complete marketplace for buying and selling old books and notes with the following features:

- **User Management**: Registration, login, role-based access (Admin, Buyer, Seller)
- **Book & Notes Management**: CRUD operations with categories, images, and reviews
- **Review System**: Rate and review books/notes
- **Transaction Management**: Complete purchase workflow
- **Payment Processing**: Multiple payment methods support
- **Image Upload**: Multiple images per item with primary image selection

## 📋 Database Entities

1. **USER** - User accounts with roles
2. **CATEGORY** - Categories for books and notes
3. **BOOK** - Book inventory with details
4. **NOTE** - Notes inventory with details
5. **REVIEW** - Reviews and ratings for items
6. **IMAGE** - Images for books and notes
7. **TRANSACTION** - Purchase transactions
8. **PAYMENT** - Payment details and status

## 🛠️ Tech Stack

### Frontend
- React 18
- Vite (Build tool)
- React Router v6
- Axios
- CSS Modules

### Backend
- Node.js & Express.js
- MySQL 8
- Sequelize ORM
- JWT Authentication
- Bcrypt (Password hashing)
- Multer (File uploads)

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v18 or higher) - [Download](https://nodejs.org/)
- **MySQL** (v8 or higher) - [Download](https://dev.mysql.com/downloads/)
- **Git** - [Download](https://git-scm.com/)
- **npm** or **yarn** (comes with Node.js)

## 🚀 Installation Steps

### Step 1: Database Setup

1. **Start MySQL Server**
   ```bash
   # Windows: Start MySQL service from Services
   # Or use MySQL Workbench
   ```

2. **Create Database**
   ```sql
   -- Open MySQL command line or Workbench
   CREATE DATABASE old_books_notes_db;
   ```

3. **Run Schema**
   ```bash
   # Navigate to database folder
   cd "c:/Users/SAMRUDDHI JADHAV/OneDrive/Documents/Desktop/fymca sem1/dbms ISE2/database"
   
   # Run schema
   mysql -u root -p old_books_notes_db < schema.sql
   ```

4. **Seed Sample Data** (Optional but recommended)
   ```bash
   mysql -u root -p old_books_notes_db < seed.sql
   ```

### Step 2: Backend Setup

1. **Navigate to server directory**
   ```bash
   cd "c:/Users/SAMRUDDHI JADHAV/OneDrive/Documents/Desktop/fymca sem1/dbms ISE2/server"
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   ```bash
   # Copy the example env file
   copy .env.example .env
   
   # Edit .env file with your settings
   ```

4. **Update .env file** with your MySQL credentials:
   ```env
   NODE_ENV=development
   PORT=5000
   
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_mysql_password
   DB_NAME=old_books_notes_db
   DB_PORT=3306
   
   JWT_SECRET=your_secret_key_here_change_in_production
   JWT_EXPIRE=7d
   
   MAX_FILE_SIZE=5242880
   UPLOAD_PATH=./uploads
   
   CLIENT_URL=http://localhost:5173
   ```

5. **Start the backend server**
   ```bash
   npm run dev
   ```

   You should see:
   ```
   ✅ Database connection established successfully.
   ✅ Database synchronized successfully.
   🚀 Server is running on port 5000
   📍 API URL: http://localhost:5000/api
   ```

### Step 3: Frontend Setup

1. **Open a new terminal** and navigate to client directory
   ```bash
   cd "c:/Users/SAMRUDDHI JADHAV/OneDrive/Documents/Desktop/fymca sem1/dbms ISE2/client"
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Install additional required packages**
   ```bash
   npm install axios react-router-dom react-toastify
   ```

4. **Create environment file**
   ```bash
   # Create .env file in client folder
   echo VITE_API_URL=http://localhost:5000/api > .env
   ```

5. **Start the development server**
   ```bash
   npm run dev
   ```

   You should see:
   ```
   VITE v5.x.x  ready in xxx ms
   
   ➜  Local:   http://localhost:5173/
   ➜  Network: use --host to expose
   ```

## 🎮 Usage

### Access the Application

1. **Frontend**: Open browser and go to `http://localhost:5173`
2. **Backend API**: `http://localhost:5000/api`

### Default Login Credentials

After running the seed script, you can login with:

**Admin Account:**
- Email: `admin@example.com`
- Password: `password123`

**Seller Account:**
- Email: `rajesh.seller@example.com`
- Password: `password123`

**Buyer Account:**
- Email: `amit.buyer@example.com`
- Password: `password123`

## 📁 Project Structure

```
dbms ISE2/
├── client/                 # React Frontend
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── pages/         # Page components
│   │   ├── services/      # API services
│   │   ├── context/       # React context
│   │   └── App.jsx
│   └── package.json
│
├── server/                # Express Backend
│   ├── config/           # Configuration files
│   ├── models/           # Sequelize models
│   ├── controllers/      # Route controllers
│   ├── routes/           # API routes
│   ├── middleware/       # Custom middleware
│   ├── uploads/          # Uploaded files
│   └── server.js
│
└── database/             # SQL files
    ├── schema.sql        # Database schema
    └── seed.sql          # Sample data
```

## 🔑 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user

### Books
- `GET /api/books` - Get all books
- `GET /api/books/:id` - Get book by ID
- `POST /api/books` - Create book (Seller only)
- `PUT /api/books/:id` - Update book
- `DELETE /api/books/:id` - Delete book

### Notes
- `GET /api/notes` - Get all notes
- `GET /api/notes/:id` - Get note by ID
- `POST /api/notes` - Create note (Seller only)
- `PUT /api/notes/:id` - Update note
- `DELETE /api/notes/:id` - Delete note

### Reviews
- `GET /api/reviews/item/:type/:id` - Get reviews for item
- `POST /api/reviews` - Create review
- `PUT /api/reviews/:id` - Update review
- `DELETE /api/reviews/:id` - Delete review

### Transactions
- `GET /api/transactions` - Get user transactions
- `POST /api/transactions` - Create transaction
- `PUT /api/transactions/:id` - Update transaction

### Payments
- `POST /api/payments` - Process payment
- `GET /api/payments/:id` - Get payment details

## 🧪 Testing the Application

### Test Database Connection
```bash
# In server directory
node -e "import('./config/database.js').then(m => m.default.authenticate().then(() => console.log('✅ Connected')).catch(e => console.log('❌ Error:', e)))"
```

### Test API Endpoints
```bash
# Health check
curl http://localhost:5000/api/health

# Get all books
curl http://localhost:5000/api/books

# Get all categories
curl http://localhost:5000/api/categories
```

## 🐛 Troubleshooting

### Database Connection Issues
```bash
# Check if MySQL is running
# Windows: Check Services for MySQL
# Or use MySQL Workbench to connect

# Verify credentials in .env file
# Make sure DB_PASSWORD matches your MySQL root password
```

### Port Already in Use
```bash
# If port 5000 is busy, change PORT in server/.env
# If port 5173 is busy, Vite will automatically use next available port
```

### Module Not Found Errors
```bash
# Reinstall dependencies
cd server
npm install

cd ../client
npm install
```

## 📊 Database Schema Highlights

- **8 Main Tables**: users, categories, books, notes, reviews, images, transactions, payments
- **Foreign Key Relationships**: Proper referential integrity
- **Indexes**: Optimized for search and filtering
- **Views**: Pre-built views for common queries
- **Stored Procedures**: For complex operations
- **Triggers**: Automatic updates for availability

## 🎨 Features to Implement (Frontend)

The backend is complete. You need to build React components for:

1. **Authentication Pages**
   - Login page
   - Registration page
   - Protected routes

2. **Main Pages**
   - Home/Dashboard
   - Books listing
   - Notes listing
   - Book/Note details
   - User profile

3. **Forms**
   - Add/Edit book
   - Add/Edit note
   - Review form
   - Checkout form

4. **Components**
   - Navbar
   - Footer
   - Book/Note cards
   - Review list
   - Transaction history

## 📝 Next Steps

1. ✅ Database schema created
2. ✅ Backend API complete
3. ✅ Authentication system ready
4. ⏳ Build React frontend components
5. ⏳ Implement routing
6. ⏳ Create forms and validation
7. ⏳ Add styling (CSS/Tailwind)
8. ⏳ Test all features
9. ⏳ Deploy application

## 🤝 Support

If you encounter any issues:
1. Check the console for error messages
2. Verify all environment variables are set correctly
3. Ensure MySQL is running
4. Check that all dependencies are installed

## 📄 License

Educational project for DBMS ISE2 - FYMCA Sem 1

---

**Author**: SAMRUDDHI JADHAV  
**Date**: December 2025  
**Project**: Old Notes and Books Management System
