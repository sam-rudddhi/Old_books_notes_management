import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Payment = sequelize.define('payments', {
    payment_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    amount: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false,
        validate: {
            min: 0,
            isDecimal: true
        }
    },
    payment_status: {
        type: DataTypes.ENUM('pending', 'completed', 'failed', 'refunded'),
        defaultValue: 'pending',
        allowNull: false
    },
    payment_date: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    gateway_ref: {
        type: DataTypes.STRING(255),
        allowNull: true
    },
    payment_method: {
        type: DataTypes.ENUM('card', 'upi', 'netbanking', 'wallet', 'cod'),
        defaultValue: 'card',
        allowNull: false
    },
    transaction_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'transactions',
            key: 'transaction_id'
        }
    }
}, {
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false
});

export default Payment;
