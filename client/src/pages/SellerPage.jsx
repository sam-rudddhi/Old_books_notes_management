import React, { useEffect, useState } from 'react';
import { api } from '../api';

const SellerPage = () => {
    const [books, setBooks] = useState([]);
    const [categories, setCategories] = useState([]);
    const [showForm, setShowForm] = useState(false);
    const [message, setMessage] = useState('');
    const [editingBookId, setEditingBookId] = useState(null);

    const initialFormState = {
        title: '',
        author: '',
        category_id: '',
        condition: 'new',
        price: 0,
        quantity: 1,
        description: ''
    };

    const [formData, setFormData] = useState(initialFormState);

    // ------------------ FETCH DATA ------------------

    const fetchBooks = async () => {
        try {
            const data = await api.getMyBooks();
            setBooks(Array.isArray(data) ? data : []);
        } catch (e) {
            console.error(e);
            setBooks([]);
        }
    };

    const fetchCategories = async () => {
        try {
            const data = await api.getCategories();
            setCategories(Array.isArray(data) ? data : []);
        } catch {
            setCategories([]);
        }
    };

    useEffect(() => {
        fetchBooks();
        fetchCategories();
    }, []);

    // ------------------ HANDLERS ------------------

    const handleEdit = (book) => {
        setFormData({
            title: book.title,
            author: book.author,
            category_id: book.category_id || '',
            condition: book.condition,
            price: book.price,
            quantity: book.quantity,
            description: book.description || ''
        });

        setEditingBookId(book.book_id);
        setShowForm(true);
    };

    const handleDelete = async (bookId) => {
        if (!window.confirm('Are you sure you want to delete this book?')) return;

        try {
            await api.deleteBook(bookId);
            setMessage('Book deleted successfully');
            fetchBooks();
        } catch (e) {
            setMessage(`Error: ${e.message}`);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setMessage('');

        const payload = {
            ...formData,
            category_id: formData.category_id || null
        };

        try {
            if (editingBookId) {
                await api.updateBook(editingBookId, payload);
                setMessage('Book updated successfully');
            } else {
                await api.addBook(payload);
                setMessage('Book added successfully');
            }

            setShowForm(false);
            setEditingBookId(null);
            setFormData(initialFormState);
            fetchBooks();
        } catch (e) {
            setMessage(`Error: ${e.message}`);
        }
    };

    const handleCancel = () => {
        setShowForm(false);
        setEditingBookId(null);
        setFormData(initialFormState);
    };

    // ------------------ UI ------------------

    return (
        <div>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 20 , alignItems: 'center'}}>
                <h1>My Inventory (Seller)</h1>
                <button onClick={() => setShowForm(true)} style={{width: 'fit-content', height: 'fit-content'}}>
                    + Add Book
                </button>
            </div>

            {message && (
                <div style={{ padding: 10, background: '#dcfce7', color: 'green', marginBottom: 10 }}>
                    {message}
                </div>
            )}

            {showForm && (
                <div className="card" style={{ marginBottom: 20 }}>
                    <h3>{editingBookId ? 'Edit Book' : 'Add New Book'}</h3>

                    <form
                        onSubmit={handleSubmit}
                        style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 15 }}
                    >
                        <div>
                            <label>Title</label>
                            <input
                                required
                                value={formData.title}
                                onChange={e => setFormData({ ...formData, title: e.target.value })}
                            />
                        </div>

                        <div>
                            <label>Author</label>
                            <input
                                required
                                value={formData.author}
                                onChange={e => setFormData({ ...formData, author: e.target.value })}
                            />
                        </div>

                        <div>
                            <label>Category</label>
                            <select
                                value={formData.category_id}
                                onChange={e => setFormData({ ...formData, category_id: e.target.value })}
                            >
                                <option value="">Select category</option>
                                {categories.map(cat => (
                                    <option key={cat.category_id} value={cat.category_id}>
                                        {cat.category_name}
                                    </option>
                                ))}
                            </select>
                        </div>

                        <div>
                            <label>Price</label>
                            <input
                                type="number"
                                required
                                value={formData.price}
                                onChange={e => setFormData({ ...formData, price: Number(e.target.value) })}
                            />
                        </div>

                        <div>
                            <label>Quantity</label>
                            <input
                                type="number"
                                required
                                value={formData.quantity}
                                onChange={e => setFormData({ ...formData, quantity: Number(e.target.value) })}
                            />
                        </div>

                        <div style={{ gridColumn: '1 / -1', display: 'flex', gap: 10 }}>
                            <button type="submit">
                                {editingBookId ? 'Confirm Edit' : 'Add Book'}
                            </button>
                            <button type="button" onClick={handleCancel}>
                                Cancel
                            </button>
                        </div>
                    </form>
                </div>
            )}

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Price</th>
                        <th>Qty</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                    {books.map(book => (
                        <tr key={book.book_id}>
                            <td>{book.book_id}</td>
                            <td>{book.title}</td>
                            <td>{book.author}</td>
                            <td>₹{book.price}</td>
                            <td>{book.quantity}</td>
                            <td>{book.quantity > 0 ? 'In Stock' : 'Out of Stock'}</td>
                            <td style={{display : 'flex' }}>
                                <button
                                    onClick={() => handleEdit(book)}
                                    style={{ marginRight: 8 }}
                                >
                                    Edit
                                </button>
                                <button
                                    onClick={() => handleDelete(book.book_id)}
                                    style={{ background: '#dc2626', color: '#fff' }}
                                >
                                    Delete
                                </button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default SellerPage;
