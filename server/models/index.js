import User from './User.js';
import Category from './Category.js';
import Book from './Book.js';
import Note from './Note.js';
import Review from './Review.js';
import Image from './Image.js';
import Transaction from './Transaction.js';
import Payment from './Payment.js';

// =====================================================
// DEFINE ASSOCIATIONS
// =====================================================

// User associations
User.hasMany(Book, { foreignKey: 'seller_id', as: 'books' });
User.hasMany(Note, { foreignKey: 'seller_id', as: 'notes' });
User.hasMany(Review, { foreignKey: 'user_id', as: 'reviews' });
User.hasMany(Transaction, { foreignKey: 'buyer_id', as: 'purchases' });
User.hasMany(Transaction, { foreignKey: 'seller_id', as: 'sales' });

// Category associations
Category.hasMany(Book, { foreignKey: 'category_id', as: 'books' });
Category.hasMany(Note, { foreignKey: 'category_id', as: 'notes' });

// Book associations
Book.belongsTo(User, { foreignKey: 'seller_id', as: 'seller' });
Book.belongsTo(Category, { foreignKey: 'category_id', as: 'category' });
Book.hasMany(Review, {
    foreignKey: 'item_id',
    constraints: false,
    scope: { item_type: 'book' },
    as: 'reviews'
});
Book.hasMany(Image, {
    foreignKey: 'item_id',
    constraints: false,
    scope: { item_type: 'book' },
    as: 'images'
});
Book.hasMany(Transaction, {
    foreignKey: 'item_id',
    constraints: false,
    scope: { item_type: 'book' },
    as: 'transactions'
});

// Note associations
Note.belongsTo(User, { foreignKey: 'seller_id', as: 'seller' });
Note.belongsTo(Category, { foreignKey: 'category_id', as: 'category' });
Note.hasMany(Review, {
    foreignKey: 'item_id',
    constraints: false,
    scope: { item_type: 'note' },
    as: 'reviews'
});
Note.hasMany(Image, {
    foreignKey: 'item_id',
    constraints: false,
    scope: { item_type: 'note' },
    as: 'images'
});
Note.hasMany(Transaction, {
    foreignKey: 'item_id',
    constraints: false,
    scope: { item_type: 'note' },
    as: 'transactions'
});

// Review associations
Review.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

// Transaction associations
Transaction.belongsTo(User, { foreignKey: 'buyer_id', as: 'buyer' });
Transaction.belongsTo(User, { foreignKey: 'seller_id', as: 'seller' });
Transaction.hasOne(Payment, { foreignKey: 'transaction_id', as: 'payment' });

// Payment associations
Payment.belongsTo(Transaction, { foreignKey: 'transaction_id', as: 'transaction' });

// Export all models
export {
    User,
    Category,
    Book,
    Note,
    Review,
    Image,
    Transaction,
    Payment
};
