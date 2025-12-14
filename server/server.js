import dotenv from 'dotenv';  

// Load environment variables
dotenv.config();


import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import path from 'path';
import { fileURLToPath } from 'url';

// Import routes
import authRoutes from './routes/auth.js';
import userRoutes from './routes/users.js';
import categoryRoutes from './routes/categories.js';
import bookRoutes from './routes/books.js';
import noteRoutes from './routes/notes.js';
import reviewRoutes from './routes/reviews.js';
import transactionRoutes from './routes/transactions.js';
import paymentRoutes from './routes/payments.js';

// Import database
import sequelize from './config/database.js';
import './models/index.js'; // Initialize models and associations

// Import error handler
import errorHandler from './middleware/errorHandler.js';

// Get __dirname equivalent in ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


// Initialize Express app
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors()); // Allow all origins for simple development
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// Serve static files (uploaded images)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/books', bookRoutes);
app.use('/api/notes', noteRoutes);
app.use('/api/reviews', reviewRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/payments', paymentRoutes);

// Health check route
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'Server is running',
    timestamp: new Date().toISOString()
  });
});

// Root route
app.get('/', (req, res) => {
  res.json({
    message: 'Old Books & Notes Management System API',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      users: '/api/users',
      categories: '/api/categories',
      books: '/api/books',
      notes: '/api/notes',
      reviews: '/api/reviews',
      transactions: '/api/transactions',
      payments: '/api/payments'
    }
  });
});

// Error handling middleware (must be last)
app.use(errorHandler);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

// Database connection and server start
const startServer = async () => {
  try {
    // Test database connection
    await sequelize.authenticate();
    console.log('✅ Database connection established successfully.');

    // Sync database (create tables if they don't exist)
    // Use { force: true } to drop and recreate tables (WARNING: deletes all data)
    // Use { alter: true } to update tables to match models
    await sequelize.sync({ alter: false });
    console.log('✅ Database synchronized successfully.');

    // Start server
    app.listen(PORT, () => {
      console.log(`🚀 Server is running on port ${PORT}`);
      console.log(`📍 API URL: http://localhost:${PORT}/api`);
      console.log(`🌐 Environment: ${process.env.NODE_ENV || 'development'}`);
    });
  } catch (error) {
    console.error('❌ Unable to start server:', error);
    process.exit(1);
  }
};

// Handle unhandled promise rejections
process.on('unhandledRejection', (err) => {
  console.error('❌ Unhandled Promise Rejection:', err);
  process.exit(1);
});

// Start the server
startServer();

export default app;
