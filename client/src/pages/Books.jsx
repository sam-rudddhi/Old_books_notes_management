import React, { useEffect, useState } from 'react';
import { api } from '../api';

const Books = () => {
    const [books, setBooks] = useState([]);

    useEffect(() => {
        api.getBooks().then(data => setBooks(Array.isArray(data) ? data : []));
    }, []);

    const handleBuy = (book) => {
        if (book.quantity <= 0) {
            alert('Out of stock!');
            return;
        }
        alert(`Purchase simulated for "${book.title}". Transaction procedure would be called here.`);
    };

    return (
        <div>
            <h1>Browse Books (Marketplace)</h1>
            <p style={{ color: '#666', marginBottom: '20px' }}>
                Select books to purchase.
            </p>

            <div className="card-grid" style={{ gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))' }}>
                {books.map(book => (
                    <div key={book.book_id} className="card" style={{ display: 'flex', flexDirection: 'column' }}>
                        <h3>{book.title}</h3>
                        <p style={{ color: '#64748b', fontSize: '0.9em' }}>by {book.author}</p>

                        <div style={{ margin: '15px 0', flexGrow: 1 }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                                <span>Price:</span>
                                <strong>${book.price}</strong>
                            </div>
                            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '5px' }}>
                                <span>Status:</span>
                                <span style={{ color: book.quantity > 0 ? 'green' : 'red' }}>
                                    {book.quantity > 0 ? 'In Stock' : 'Out of Stock'}
                                </span>
                            </div>
                        </div>

                        <button
                            onClick={() => handleBuy(book)}
                            disabled={book.quantity <= 0}
                            style={{
                                marginTop: 'auto',
                                background: book.quantity > 0 ? '#2563eb' : '#cbd5e1',
                                cursor: book.quantity > 0 ? 'pointer' : 'not-allowed'
                            }}
                        >
                            {book.quantity > 0 ? 'Buy Now' : 'Sold Out'}
                        </button>
                    </div>
                ))}
            </div>

            {books.length === 0 && <p>No books available.</p>}
        </div>
    );
};

export default Books;
