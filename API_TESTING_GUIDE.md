# API Testing Guide - Old Notes and Books Management System

## 🧪 Testing Tools

You can use any of these tools:
- **Thunder Client** (VS Code Extension) - Recommended
- **Postman** (Desktop App)
- **cURL** (Command Line)
- **Browser** (for GET requests)

## 🔑 Authentication Flow

### 1. Register a New User

**Endpoint:** `POST http://localhost:5000/api/auth/register`

**Headers:**
```
Content-Type: application/json
```

**Body:**
```json
{
  "name": "John Doe",
  "phone": "9876543210",
  "address": "123 Main Street, Mumbai",
  "contact_email": "john@example.com",
  "password": "password123",
  "role": "buyer"
}
```

**Expected Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "user_id": 9,
      "name": "John Doe",
      "contact_email": "john@example.com",
      "role": "buyer"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Save the token!** You'll need it for protected routes.

### 2. Login

**Endpoint:** `POST http://localhost:5000/api/auth/login`

**Body:**
```json
{
  "contact_email": "admin@example.com",
  "password": "password123"
}
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### 3. Get Current User

**Endpoint:** `GET http://localhost:5000/api/auth/me`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "user_id": 1,
    "name": "Admin User",
    "contact_email": "admin@example.com",
    "role": "admin"
  }
}
```

## 📚 Books API

### 1. Get All Books

**Endpoint:** `GET http://localhost:5000/api/books`

**Query Parameters (Optional):**
- `category` - Filter by category ID
- `condition` - Filter by condition (new, like-new, good, fair, poor)
- `minPrice` - Minimum price
- `maxPrice` - Maximum price
- `search` - Search in title, author, description
- `page` - Page number (default: 1)
- `limit` - Items per page (default: 12)
- `sortBy` - Sort field (default: created_at)
- `order` - Sort order (ASC/DESC, default: DESC)

**Examples:**
```
# Get all books
GET http://localhost:5000/api/books

# Search for "algorithm"
GET http://localhost:5000/api/books?search=algorithm

# Filter by category
GET http://localhost:5000/api/books?category=1

# Filter by price range
GET http://localhost:5000/api/books?minPrice=100&maxPrice=500

# Pagination
GET http://localhost:5000/api/books?page=2&limit=10

# Sort by price
GET http://localhost:5000/api/books?sortBy=price&order=ASC
```

**Expected Response:**
```json
{
  "success": true,
  "count": 15,
  "totalPages": 2,
  "currentPage": 1,
  "data": [
    {
      "book_id": 1,
      "title": "Introduction to Algorithms",
      "author": "Thomas H. Cormen",
      "price": "450.00",
      "condition": "good",
      "quantity": 3,
      "category": {
        "category_id": 1,
        "category_name": "Computer Science"
      },
      "seller": {
        "user_id": 2,
        "name": "Rajesh Kumar"
      },
      "avg_rating": "4.5",
      "review_count": "2"
    }
  ]
}
```

### 2. Get Single Book

**Endpoint:** `GET http://localhost:5000/api/books/:id`

**Example:**
```
GET http://localhost:5000/api/books/1
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "book_id": 1,
    "title": "Introduction to Algorithms",
    "author": "Thomas H. Cormen",
    "isbn": "978-0262033848",
    "edition": "3rd Edition",
    "condition": "good",
    "price": "450.00",
    "quantity": 3,
    "description": "Comprehensive textbook...",
    "category": { ... },
    "seller": { ... },
    "images": [ ... ],
    "reviews": [ ... ]
  }
}
```

### 3. Create Book (Seller/Admin Only)

**Endpoint:** `POST http://localhost:5000/api/books`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
Content-Type: application/json
```

**Body:**
```json
{
  "title": "Design Patterns",
  "author": "Gang of Four",
  "isbn": "978-0201633610",
  "edition": "1st Edition",
  "condition": "good",
  "price": 420.00,
  "quantity": 2,
  "category_id": 1,
  "description": "Classic book on software design patterns"
}
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Book created successfully",
  "data": {
    "book_id": 16,
    "title": "Design Patterns",
    ...
  }
}
```

### 4. Update Book

**Endpoint:** `PUT http://localhost:5000/api/books/:id`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
Content-Type: application/json
```

**Body:**
```json
{
  "price": 400.00,
  "quantity": 5
}
```

### 5. Delete Book

**Endpoint:** `DELETE http://localhost:5000/api/books/:id`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
```

### 6. Get My Books (Seller)

**Endpoint:** `GET http://localhost:5000/api/books/seller/my-books`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
```

## 📂 Categories API

### 1. Get All Categories

**Endpoint:** `GET http://localhost:5000/api/categories`

**Expected Response:**
```json
{
  "success": true,
  "count": 10,
  "data": [
    {
      "category_id": 1,
      "category_name": "Computer Science",
      "description": "Books and notes related to computer science..."
    }
  ]
}
```

### 2. Create Category (Admin Only)

**Endpoint:** `POST http://localhost:5000/api/categories`

**Headers:**
```
Authorization: Bearer ADMIN_TOKEN_HERE
Content-Type: application/json
```

**Body:**
```json
{
  "category_name": "Psychology",
  "description": "Psychology books and study materials"
}
```

## 🧪 Complete Testing Workflow

### Scenario 1: User Registration and Browse Books

1. **Register as Buyer**
   ```
   POST /api/auth/register
   Body: { name, email, password, role: "buyer" }
   ```

2. **Login**
   ```
   POST /api/auth/login
   Body: { email, password }
   Save token!
   ```

3. **Browse Books**
   ```
   GET /api/books
   ```

4. **View Book Details**
   ```
   GET /api/books/1
   ```

### Scenario 2: Seller Adds a Book

1. **Login as Seller**
   ```
   POST /api/auth/login
   Body: { contact_email: "rajesh.seller@example.com", password: "password123" }
   ```

2. **Create Book**
   ```
   POST /api/books
   Headers: Authorization: Bearer TOKEN
   Body: { title, author, price, ... }
   ```

3. **View My Books**
   ```
   GET /api/books/seller/my-books
   Headers: Authorization: Bearer TOKEN
   ```

4. **Update Book**
   ```
   PUT /api/books/16
   Headers: Authorization: Bearer TOKEN
   Body: { price: 350.00 }
   ```

### Scenario 3: Admin Manages Categories

1. **Login as Admin**
   ```
   POST /api/auth/login
   Body: { contact_email: "admin@example.com", password: "password123" }
   ```

2. **Create Category**
   ```
   POST /api/categories
   Headers: Authorization: Bearer ADMIN_TOKEN
   Body: { category_name: "New Category", description: "..." }
   ```

3. **Update Category**
   ```
   PUT /api/categories/11
   Headers: Authorization: Bearer ADMIN_TOKEN
   Body: { description: "Updated description" }
   ```

## 🔍 Testing Checklist

### Authentication
- [ ] Register new user (buyer)
- [ ] Register new user (seller)
- [ ] Login with valid credentials
- [ ] Login with invalid credentials (should fail)
- [ ] Get current user (with token)
- [ ] Get current user (without token - should fail)
- [ ] Update profile
- [ ] Change password

### Books
- [ ] Get all books (no auth required)
- [ ] Get single book (no auth required)
- [ ] Search books by keyword
- [ ] Filter books by category
- [ ] Filter books by price range
- [ ] Create book as seller (with token)
- [ ] Create book as buyer (should fail)
- [ ] Update own book
- [ ] Update other's book (should fail)
- [ ] Delete own book
- [ ] Delete other's book (should fail)

### Categories
- [ ] Get all categories
- [ ] Get single category
- [ ] Create category as admin
- [ ] Create category as user (should fail)
- [ ] Update category as admin
- [ ] Delete category as admin

## 📊 Expected HTTP Status Codes

- `200` - Success (GET, PUT)
- `201` - Created (POST)
- `400` - Bad Request (validation error)
- `401` - Unauthorized (no token or invalid token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found (resource doesn't exist)
- `500` - Server Error

## 🐛 Common Errors

### Error: "Not authorized to access this route"
**Cause:** Missing or invalid token  
**Solution:** Include `Authorization: Bearer TOKEN` header

### Error: "User role 'buyer' is not authorized"
**Cause:** Insufficient permissions  
**Solution:** Login with appropriate role (seller/admin)

### Error: "Duplicate field value entered"
**Cause:** Email or ISBN already exists  
**Solution:** Use unique values

### Error: "Validation error"
**Cause:** Missing required fields or invalid data  
**Solution:** Check request body matches schema

## 📝 Thunder Client Collection

Create a collection with these requests:

**Auth**
- Register Buyer
- Register Seller
- Login Admin
- Login Seller
- Login Buyer
- Get Me
- Update Profile

**Books**
- Get All Books
- Get Book by ID
- Search Books
- Create Book
- Update Book
- Delete Book
- Get My Books

**Categories**
- Get All Categories
- Get Category by ID
- Create Category (Admin)
- Update Category (Admin)
- Delete Category (Admin)

## 🎯 Pro Tips

1. **Save tokens** in Thunder Client environment variables
2. **Use collections** to organize requests
3. **Test error cases** not just success cases
4. **Check response times** for performance
5. **Validate response structure** matches documentation
6. **Test pagination** with different page sizes
7. **Test edge cases** (empty results, invalid IDs, etc.)

---

**Happy Testing! 🧪**

Once all tests pass, you're ready to integrate with the frontend!
