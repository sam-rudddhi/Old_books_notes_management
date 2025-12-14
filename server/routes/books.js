import express from 'express';
import {
    getBooks,
    getBook,
    createBook,
    updateBook,
    deleteBook,
    getMyBooks
} from '../controllers/bookController.js';
import { protect, authorize } from '../middleware/auth.js';

const router = express.Router();

// Public routes
router.get('/', getBooks);
router.get('/:id', getBook);

// Protected routes
router.post('/', protect, authorize('seller', 'admin'), createBook);
router.put('/:id', protect, updateBook);
router.delete('/:id', protect, deleteBook);
router.get('/seller/my-books', protect, authorize('seller', 'admin'), getMyBooks);

export default router;
