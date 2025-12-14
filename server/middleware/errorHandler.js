const errorHandler = (err, req, res, next) => {
    let error = { ...err };
    error.message = err.message;

    // Log error for debugging
    console.error('Error:', err);

    // Sequelize validation error
    if (err.name === 'SequelizeValidationError') {
        const message = err.errors.map(e => e.message).join(', ');
        error.message = message;
        error.statusCode = 400;
    }

    // Sequelize unique constraint error
    if (err.name === 'SequelizeUniqueConstraintError') {
        const message = 'Duplicate field value entered';
        error.message = message;
        error.statusCode = 400;
    }

    // Sequelize foreign key constraint error
    if (err.name === 'SequelizeForeignKeyConstraintError') {
        const message = 'Invalid reference to related resource';
        error.message = message;
        error.statusCode = 400;
    }

    // Sequelize database error
    if (err.name === 'SequelizeDatabaseError') {
        const message = 'Database error occurred';
        error.message = message;
        error.statusCode = 500;
    }

    // JWT errors
    if (err.name === 'JsonWebTokenError') {
        const message = 'Invalid token';
        error.message = message;
        error.statusCode = 401;
    }

    if (err.name === 'TokenExpiredError') {
        const message = 'Token expired';
        error.message = message;
        error.statusCode = 401;
    }

    // Multer file upload errors
    if (err.name === 'MulterError') {
        if (err.code === 'LIMIT_FILE_SIZE') {
            error.message = 'File size too large';
            error.statusCode = 400;
        } else if (err.code === 'LIMIT_UNEXPECTED_FILE') {
            error.message = 'Unexpected file field';
            error.statusCode = 400;
        }
    }

    res.status(error.statusCode || 500).json({
        success: false,
        error: error.message || 'Server Error',
        ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    });
};

export default errorHandler;
