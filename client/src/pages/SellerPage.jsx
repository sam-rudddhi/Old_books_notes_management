import React, { useEffect, useState } from 'react';
import { api } from '../api';

const SellerPage = () => {
    const [books, setBooks] = useState([]);
    const [categories, setCategories] = useState([]);
    const [showForm, setShowForm] = useState(false);
    const [message, setMessage] = useState('');

    const [formData, setFormData] = useState({
        title: '',
        author: '',
        category_id: null,     // ✅ safe default
        condition: 'new',      // ✅ backend expects this
        price: 0,
        quantity: 1,
        description: ''
    });

    const fetchBooks = async () => {
        try {
            const res = await api.getBooks();
            console.log('BOOKS RESPONSE:', res);


            // Backend returns { success, data }
            if (res && Array.isArray(res.data)) {
                setBooks(res.data);
            } else {
                setBooks([]);
            }
        } catch (e) {
            console.error(e);
            setBooks([]);
        }

        
    };


    const fetchCategories = async () => {
        try {
            if (!api.getCategories) return;
            const res = await api.getCategories();
            setCategories(res?.data || []);
        } catch {
            setCategories([]);
        }
    };

    useEffect(() => {
        fetchBooks();
        fetchCategories();
    }, []);

    const handleSubmit = async (e) => {
        e.preventDefault();
        setMessage('');

        const payload = {
            ...formData,
            category_id: categories.length ? formData.category_id : null
        };

        try {
            await api.addBook(payload);
            setMessage('Book added successfully');
            setShowForm(false);
            fetchBooks();
        } catch (e) {
            setMessage(`Error: ${e.message}`);
        }
    };

    return (
        <div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
                <h1>My Inventory (Seller)</h1>
                <button
                    style={{ width: 'auto' }}
                    onClick={() => setShowForm(!showForm)}
                >
                    {showForm ? 'Cancel' : '+ Add Book'}
                </button>
            </div>

            {message && (
                <div style={{ padding: '10px', background: '#dcfce7', color: 'green', marginBottom: '10px' }}>
                    {message}
                </div>
            )}

            {showForm && (
                <div className="card" style={{ marginBottom: '20px' }}>
                    <h3>Add New Book</h3>

                    <form
                        onSubmit={handleSubmit}
                        style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '15px' }}
                    >
                        <div>
                            <label>Title</label>
                            <input
                                required
                                onChange={e => setFormData({ ...formData, title: e.target.value })}
                            />
                        </div>

                        <div>
                            <label>Author</label>
                            <input
                                required
                                onChange={e => setFormData({ ...formData, author: e.target.value })}
                            />
                        </div>

                        {/* Only show category if data exists */}
                        {categories.length > 0 && (
                            <div>
                                <label>Category</label>
                                <select
                                    onChange={e => setFormData({
                                        ...formData,
                                        category_id: Number(e.target.value)
                                    })}
                                >
                                    <option value="">Select category</option>
                                    {categories.map(cat => (
                                        <option key={cat.category_id} value={cat.category_id}>
                                            {cat.category_name}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        )}

                        <div>
                            <label>Price</label>
                            <input
                                type="number"
                                required
                                onChange={e => setFormData({ ...formData, price: Number(e.target.value) })}
                            />
                        </div>

                        <div>
                            <label>Quantity</label>
                            <input
                                type="number"
                                required
                                onChange={e => setFormData({ ...formData, quantity: Number(e.target.value) })}
                            />
                        </div>

                        <div style={{ gridColumn: '1/-1' }}>
                            <button type="submit">Add Book</button>
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
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default SellerPage;
