import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Image = sequelize.define('images', {
    img_url: {
        type: DataTypes.STRING(500),
        primaryKey: true,
        allowNull: false
    },
    is_primary: {
        type: DataTypes.BOOLEAN,
        defaultValue: false
    },
    uploaded_date: {
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
    }
}, {
    timestamps: false
});

export default Image;
