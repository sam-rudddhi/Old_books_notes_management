import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Review = sequelize.define('reviews', {
    review_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    comment: {
        type: DataTypes.TEXT,
        allowNull: true
    },
    rating: {
        type: DataTypes.INTEGER,
        allowNull: false,
        validate: {
            min: 1,
            max: 5,
            isInt: true
        }
    },
    review_date: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    item_id: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    item_type: {
        type: DataTypes.ENUM('book', 'note'),
        allowNull: false
    },
    user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'users',
            key: 'user_id'
        }
    }
}, {
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false
});

export default Review;
