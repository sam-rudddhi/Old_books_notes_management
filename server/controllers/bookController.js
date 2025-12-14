import { Book, Category, User, Review, Image } from '../models/index.js';
import { Op } from 'sequelize';
import sequelize from '../config/database.js';

// @desc    Get all books
// @route   GET /api/books
// @access  Public
export const getBooks = async (req, res, next) => {
    try {
        const {
            category,
            condition,
            minPrice,
            maxPrice,
            search,
            sortBy = 'created_at',
            order = 'DESC',
            page = 1,
            limit = 12
        } = req.query;

        const offset = (page - 1) * limit;
        const where = { is_available: true };

        // Filters
        if (category) where.category_id = category;
        if (condition) where.condition = condition;
        if (minPrice || maxPrice) {
            where.price = {};
            if (minPrice) where.price[Op.gte] = minPrice;
            if (maxPrice) where.price[Op.lte] = maxPrice;
        }
        if (search) {
            where[Op.or] = [
                { title: { [Op.like]: `%${search}%` } },
                { author: { [Op.like]: `%${search}%` } },
                { description: { [Op.like]: `%${search}%` } }
            ];
        }

        const { count, rows: books } = await Book.findAndCountAll({
            where,
            include: [
                { model: Category, as: 'category', attributes: ['category_id', 'category_name'] },
                { model: User, as: 'seller', attributes: ['user_id', 'name', 'contact_email'] },
                { model: Image, as: 'images', where: { is_primary: true }, required: false },
                {
                    model: Review,
                    as: 'reviews',
                    attributes: [],
                    required: false
                }
            ],
            attributes: {
                include: [
                    [sequelize.fn('AVG', sequelize.col('reviews.rating')), 'avg_rating'],
                    [sequelize.fn('COUNT', sequelize.col('reviews.review_id')), 'review_count']
                ]
            },
            group: ['books.book_id'],
            order: [[sortBy, order]],
            limit: parseInt(limit),
            offset: parseInt(offset),
            subQuery: false
        });

        res.json({
            success: true,
            count,
            totalPages: Math.ceil(count / limit),
            currentPage: parseInt(page),
            data: books
        });
    } catch (error) {
        next(error);
    }
};

// @desc    Get single book
// @route   GET /api/books/:id
// @access  Public
export const getBook = async (req, res, next) => {
    try {
        const book = await Book.findByPk(req.params.id, {
            include: [
                { model: Category, as: 'category' },
                { model: User, as: 'seller', attributes: ['user_id', 'name', 'contact_email', 'phone'] },
                { model: Image, as: 'images' },
                {
                    model: Review,
                    as: 'reviews',
                    include: [{ model: User, as: 'user', attributes: ['user_id', 'name'] }]
                }
            ]
        });

        if (!book) {
            return res.status(404).json({
                success: false,
                message: 'Book not found'
            });
        }

        res.json({
            success: true,
            data: book
        });
    } catch (error) {
        next(error);
    }
};

// @desc    Create new book
// @route   POST /api/books
// @access  Private (Seller/Admin)
export const createBook = async (req, res, next) => {
    try {
        const { title, author, isbn, edition, condition, price, quantity, category_id, description } = req.body;

        // Verify user is seller or admin
        if (req.user.role !== 'seller' && req.user.role !== 'admin') {
            return res.status(403).json({
                success: false,
                message: 'Only sellers can add books'
            });
        }

        const book = await Book.create({
            title,
            author,
            isbn,
            edition,
            condition,
            price,
            quantity,
            category_id,
            seller_id: req.user.user_id,
            description
        });

        res.status(201).json({
            success: true,
            message: 'Book created successfully',
            data: book
        });
    } catch (error) {
        next(error);
    }
};

// @desc    Update book
// @route   PUT /api/books/:id
// @access  Private (Owner/Admin)
export const updateBook = async (req, res, next) => {
    try {
        const book = await Book.findByPk(req.params.id);

        if (!book) {
            return res.status(404).json({
                success: false,
                message: 'Book not found'
            });
        }

        // Check ownership or admin
        if (book.seller_id !== req.user.user_id && req.user.role !== 'admin') {
            return res.status(403).json({
                success: false,
                message: 'Not authorized to update this book'
            });
        }

        const { title, author, isbn, edition, condition, price, quantity, category_id, description, is_available } = req.body;

        if (title) book.title = title;
        if (author) book.author = author;
        if (isbn) book.isbn = isbn;
        if (edition) book.edition = edition;
        if (condition) book.condition = condition;
        if (price) book.price = price;
        if (quantity !== undefined) book.quantity = quantity;
        if (category_id) book.category_id = category_id;
        if (description !== undefined) book.description = description;
        if (is_available !== undefined) book.is_available = is_available;

        await book.save();

        res.json({
            success: true,
            message: 'Book updated successfully',
            data: book
        });
    } catch (error) {
        next(error);
    }
};

// @desc    Delete book
// @route   DELETE /api/books/:id
// @access  Private (Owner/Admin)
export const deleteBook = async (req, res, next) => {
    try {
        const book = await Book.findByPk(req.params.id);

        if (!book) {
            return res.status(404).json({
                success: false,
                message: 'Book not found'
            });
        }

        // Check ownership or admin
        if (book.seller_id !== req.user.user_id && req.user.role !== 'admin') {
            return res.status(403).json({
                success: false,
                message: 'Not authorized to delete this book'
            });
        }

        await book.destroy();

        res.json({
            success: true,
            message: 'Book deleted successfully'
        });
    } catch (error) {
        next(error);
    }
};

// @desc    Get seller's books
// @route   GET /api/books/seller/my-books
// @access  Private (Seller)
export const getMyBooks = async (req, res, next) => {
    try {
        const books = await Book.findAll({
            where: { seller_id: req.user.user_id },
            include: [
                { model: Category, as: 'category' },
                { model: Image, as: 'images', where: { is_primary: true }, required: false }
            ],
            order: [['created_at', 'DESC']]
        });

        res.json({
            success: true,
            count: books.length,
            data: books
        });
    } catch (error) {
        next(error);
    }
};

export default {
    getBooks,
    getBook,
    createBook,
    updateBook,
    deleteBook,
    getMyBooks
};
