import jwt from 'jsonwebtoken';
import { User } from '../models/index.js';

// Protect routes - verify JWT token
export const protect = async (req, res, next) => {
    try {
        let token;

        // Check for token in Authorization header
        if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
            token = req.headers.authorization.split(' ')[1];
        }

        // Check if token exists
        if (!token) {
            return res.status(401).json({
                success: false,
                message: 'Not authorized to access this route. Please login.'
            });
        }

        try {
            // Verify token
            const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback_secret_key_123');

            // Get user from token
            req.user = await User.findByPk(decoded.id);

            if (!req.user || !req.user.is_active) {
                return res.status(401).json({
                    success: false,
                    message: 'User not found or inactive'
                });
            }

            next();
        } catch (error) {
            return res.status(401).json({
                success: false,
                message: 'Invalid or expired token'
            });
        }
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: 'Server error in authentication'
        });
    }
};

// Authorize specific roles
export const authorize = (...allowedRoles) => {
    return (req, res, next) => {
        const userRoles = req.user.getRoles(); // Returns array ['buyer', 'seller']

        // Check if user has ANY of the allowed roles
        const hasrole = userRoles.some(role => allowedRoles.includes(role));

        if (!hasrole) {
            return res.status(403).json({
                success: false,
                message: `User roles '[${userRoles.join(', ')}]' are not authorized to access this route`
            });
        }
        next();
    };
};

// Optional authentication (doesn't fail if no token)
export const optionalAuth = async (req, res, next) => {
    try {
        let token;

        if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
            token = req.headers.authorization.split(' ')[1];
        }

        if (token) {
            try {
                const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback_secret_key_123');
                req.user = await User.findByPk(decoded.id);
            } catch (error) {
                // Token invalid, but continue without user
                req.user = null;
            }
        }

        next();
    } catch (error) {
        next();
    }
};

export default { protect, authorize, optionalAuth };
