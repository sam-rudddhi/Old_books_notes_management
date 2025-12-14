import React, { useEffect, useState } from 'react';
import { api } from '../api';

const SellerPage = () => {
    const [books, setBooks] = useState([]);
    const [showForm, setShowForm] = useState(false);
    const [formData, setFormData] = useState({
        title: '', author: '', category_id: 1, publication_year: 2023,
        condition_rating: 'new', price: 0, quantity: 1,
        seller_id: 1, type_id: 1, description: ''
    });
    const [message, setMessage] = useState('');

    useEffect(() => {
        fetchBooks();
    }, []);

    const fetchBooks = async () => {
        try {
            const data = await api.getBooks();
            setBooks(Array.isArray(data) ? data : []);
        } catch (e) {
            console.error(e);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await api.addBook(formData);
            setMessage('Book added successfully via Stored Procedure!');
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

            {message && <div style={{ padding: '10px', background: '#dcfce7', color: 'green', marginBottom: '10px' }}>{message}</div>}

            {showForm && (
                <div className="card" style={{ marginBottom: '20px' }}>
                    <h3>Add New Book (Calls sp_add_book)</h3>
                    <form onSubmit={handleSubmit} style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '15px' }}>
                        <div>
                            <label>Title</label>
                            <input required onChange={e => setFormData({ ...formData, title: e.target.value })} />
                        </div>
                        <div>
                            <label>Author</label>
                            <input required onChange={e => setFormData({ ...formData, author: e.target.value })} />
                        </div>
                        <div>
                            <label>Price</label>
                            <input type="number" required onChange={e => setFormData({ ...formData, price: e.target.value })} />
                        </div>
                        <div>
                            <label>Quantity</label>
                            <input type="number" required onChange={e => setFormData({ ...formData, quantity: e.target.value })} />
                        </div>
                        <div style={{ gridColumn: '1/-1' }}>
                            <button type="submit">Execute Stored Procedure</button>
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
                            <td>${book.price}</td>
                            <td>{book.quantity}</td>
                            <td>
                                <span className={`status-badge ${book.quantity > 0 ? 'available' : 'out'}`}>
                                    {book.quantity > 0 ? 'In Stock' : 'Out of Stock'}
                                </span>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default SellerPage;
