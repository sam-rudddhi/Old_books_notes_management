import jwt from 'jsonwebtoken';
import { User } from '../models/index.js';

// Generate JWT Token
const generateToken = (user) => {
    return jwt.sign({
        id: user.user_id,
        roles: user.getRoles()
    }, process.env.JWT_SECRET || 'fallback_secret_key_123', {
        expiresIn: process.env.JWT_EXPIRE || '7d'
    });
};

// @desc    Register new user
// @route   POST /api/auth/register
// @access  Public
export const register = async (req, res, next) => {
    try {
        const { name, phone, address, contact_email, role, roles, password } = req.body;

        // Check if user already exists
        const existingUser = await User.findOne({ where: { contact_email } });
        if (existingUser) {
            return res.status(400).json({
                success: false,
                message: 'User with this email already exists'
            });
        }

        // Handle roles: accept 'role' or 'roles', default to 'buyer'
        // If it's an array, join it. If it's a string, keep it.
        let assignedRole = 'buyer';
        if (roles && Array.isArray(roles)) {
            assignedRole = roles.join(',');
        } else if (role) {
            assignedRole = role;
        }

        // Create user
        const user = await User.create({
            name,
            phone,
            address,
            contact_email,
            role: assignedRole,
            password_hash: password // Will be hashed by model hook
        });

        // Generate token
        const token = generateToken(user);

        res.status(201).json({
            success: true,
            message: 'User registered successfully',
            data: {
                user: user.toJSON(),
                token,
                roles: user.getRoles()
            }
        });
    } catch (error) {
        next(error);
    }
};

// @desc    Login user
// @route   POST /api/auth/login
// @access  Public
export const login = async (req, res, next) => {
    try {
        const { contact_email, password } = req.body;

        // Validate input
        if (!contact_email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Please provide email and password'
            });
        }

        // Find user (include password for comparison)
        const user = await User.findOne({
            where: { contact_email },
            attributes: { include: ['password_hash'] }
        });

        if (!user) {
            return res.status(401).json({
                success: false,
                message: 'Invalid credentials'
            });
        }

        // Check if user is active
        if (!user.is_active) {
            return res.status(401).json({
                success: false,
                message: 'Account is deactivated. Please contact support.'
            });
        }

        // Check password
        const isPasswordValid = await user.comparePassword(password);
        if (!isPasswordValid) {
            return res.status(401).json({
                success: false,
                message: 'Invalid credentials'
            });
        }

        // Generate token
        const token = generateToken(user);

        res.json({
            success: true,
            message: 'Login successful',
            data: {
                user: user.toJSON(),
                token,
                roles: user.getRoles()
            }
        });
    } catch (error) {
        next(error);
    }
};

// @desc    Get current logged in user
// @route   GET /api/auth/me
// @access  Private
export const getMe = async (req, res, next) => {
    try {
        const user = await User.findByPk(req.user.user_id, {
            attributes: { exclude: ['password_hash'] }
        });

        res.json({
            success: true,
            data: user
        });
    } catch (error) {
        next(error);
    }
};

// @desc    Update user profile
// @route   PUT /api/auth/profile
// @access  Private
export const updateProfile = async (req, res, next) => {
    try {
        const { name, phone, address } = req.body;

        const user = await User.findByPk(req.user.user_id);

        if (name) user.name = name;
        if (phone) user.phone = phone;
        if (address !== undefined) user.address = address;

        await user.save();

        res.json({
            success: true,
            message: 'Profile updated successfully',
            data: user.toJSON()
        });
    } catch (error) {
        next(error);
    }
};

// @desc    Change password
// @route   PUT /api/auth/change-password
// @access  Private
export const changePassword = async (req, res, next) => {
    try {
        const { currentPassword, newPassword } = req.body;

        if (!currentPassword || !newPassword) {
            return res.status(400).json({
                success: false,
                message: 'Please provide current and new password'
            });
        }

        const user = await User.findByPk(req.user.user_id, {
            attributes: { include: ['password_hash'] }
        });

        // Verify current password
        const isPasswordValid = await user.comparePassword(currentPassword);
        if (!isPasswordValid) {
            return res.status(401).json({
                success: false,
                message: 'Current password is incorrect'
            });
        }

        // Update password
        user.password_hash = newPassword; // Will be hashed by hook
        await user.save();

        res.json({
            success: true,
            message: 'Password changed successfully'
        });
    } catch (error) {
        next(error);
    }
};

export default {
    register,
    login,
    getMe,
    updateProfile,
    changePassword
};
