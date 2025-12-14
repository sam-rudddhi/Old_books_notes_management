# Quick Start Guide - Old Notes and Books Management System

## 🚀 Quick Setup (5 Minutes)

### Prerequisites Check
- [ ] MySQL installed and running
- [ ] Node.js 18+ installed
- [ ] Git installed (optional)

### Step 1: Database Setup (2 minutes)

```bash
# Open MySQL Command Line or MySQL Workbench

# Create database
CREATE DATABASE old_books_notes_db;

# Exit MySQL
exit;

# Navigate to database folder
cd "c:/Users/SAMRUDDHI JADHAV/OneDrive/Documents/Desktop/fymca sem1/dbms ISE2/database"

# Run schema (Windows Command Prompt)
mysql -u root -p old_books_notes_db < schema.sql

# Seed sample data
mysql -u root -p old_books_notes_db < seed.sql
```

### Step 2: Backend Setup (2 minutes)

```bash
# Navigate to server folder
cd "c:/Users/SAMRUDDHI JADHAV/OneDrive/Documents/Desktop/fymca sem1/dbms ISE2/server"

# Install dependencies
npm install

# Copy environment file
copy .env.example .env

# IMPORTANT: Edit .env file and update:
# - DB_PASSWORD=your_mysql_password
# - JWT_SECRET=any_random_string

# Start server
npm run dev
```

**Expected Output:**
```
✅ Database connection established successfully.
✅ Database synchronized successfully.
🚀 Server is running on port 5000
```

### Step 3: Frontend Setup (1 minute)

```bash
# Open NEW terminal
cd "c:/Users/SAMRUDDHI JADHAV/OneDrive/Documents/Desktop/fymca sem1/dbms ISE2/client"

# Install dependencies
npm install

# Install additional packages
npm install axios react-router-dom react-toastify

# Start development server
npm run dev
```

**Expected Output:**
```
VITE ready in xxx ms
➜  Local:   http://localhost:5173/
```

## 🎮 Test the API

### Using Browser
Open: `http://localhost:5000/api/health`

Should see:
```json
{
  "success": true,
  "message": "Server is running",
  "timestamp": "2025-12-12T..."
}
```

### Test Endpoints

**Get all books:**
```
http://localhost:5000/api/books
```

**Get all categories:**
```
http://localhost:5000/api/categories
```

### Test Authentication

**Register a new user:**
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Test User\",\"phone\":\"9876543210\",\"contact_email\":\"test@example.com\",\"password\":\"password123\",\"role\":\"buyer\"}"
```

**Login:**
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"contact_email\":\"admin@example.com\",\"password\":\"password123\"}"
```

## 📊 Sample Data Available

After seeding, you have:
- **8 Users** (1 admin, 3 sellers, 4 buyers)
- **10 Categories** (Computer Science, Math, Physics, etc.)
- **15 Books** (Algorithms, Clean Code, etc.)
- **15 Notes** (DSA, DBMS, Calculus, etc.)
- **15 Reviews**
- **10 Transactions**
- **10 Payments**

## 🔐 Login Credentials

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

## 🐛 Common Issues & Solutions

### Issue: "Access denied for user"
**Solution:** Update `DB_PASSWORD` in `server/.env` with your MySQL password

### Issue: "Database doesn't exist"
**Solution:** Run `CREATE DATABASE old_books_notes_db;` in MySQL

### Issue: "Port 5000 already in use"
**Solution:** Change `PORT=5001` in `server/.env`

### Issue: "Module not found"
**Solution:** Run `npm install` in server and client folders

### Issue: "Cannot connect to database"
**Solution:** 
1. Check if MySQL is running
2. Verify credentials in .env
3. Test connection: `mysql -u root -p`

## 📁 Project URLs

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:5000/api
- **API Health**: http://localhost:5000/api/health
- **API Docs**: http://localhost:5000/ (shows endpoints)

## ✅ Verification Checklist

- [ ] MySQL running
- [ ] Database created
- [ ] Schema loaded
- [ ] Sample data loaded
- [ ] Backend dependencies installed
- [ ] .env file configured
- [ ] Backend server running (port 5000)
- [ ] Frontend dependencies installed
- [ ] Frontend server running (port 5173)
- [ ] Can access http://localhost:5000/api/health
- [ ] Can access http://localhost:5173

## 🎯 Next Steps

1. **Test API Endpoints** using Postman or Thunder Client
2. **Build React Components** for the frontend
3. **Implement remaining controllers** (notes, reviews, transactions, payments)
4. **Add styling** to the frontend
5. **Test complete workflow** (register → login → browse → purchase)

## 📚 Documentation

- **Setup Guide**: SETUP_GUIDE.md (detailed instructions)
- **Project Plan**: PROJECT_PLAN.md (architecture & design)
- **Project Summary**: PROJECT_SUMMARY.md (current status)
- **Database Schema**: database/schema.sql
- **Sample Data**: database/seed.sql

## 🤝 Need Help?

1. Check error messages in terminal
2. Review SETUP_GUIDE.md
3. Check MySQL connection
4. Verify .env configuration
5. Ensure all dependencies installed

---

**Happy Coding! 🚀**

If everything is working, you should see:
- ✅ Backend running on port 5000
- ✅ Frontend running on port 5173
- ✅ Database connected
- ✅ Sample data loaded

You're ready to start building! 🎉
