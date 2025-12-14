import React, { useEffect, useState } from 'react';
import { api } from '../api';
import {useNavigate} from 'react-router-dom'

const Books = () => {
    const [books, setBooks] = useState([]);

    useEffect(() => {
        api.getBooks().then(data => setBooks(Array.isArray(data) ? data : []));
    }, []);

    const navigate = useNavigate();
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
                        <div className="div" style={{display: 'flex', flexDirection: 'column', justifyContent: 'space-between'}}>
                            <h3>{book.title}</h3>
                            <div>{book.category_name}</div>
                            </div>
                        <p style={{ color: '#64748b', fontSize: '0.9em' }}>by {book.author}</p>

                        <div style={{ margin: '15px 0', flexGrow: 1 }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                                <span>Price:</span>
                                <strong>₹{book.price}</strong>
                            </div>
                            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '5px' }}>
                                <span>Status:</span>
                                <span style={{ color: book.quantity > 0 ? 'green' : 'red' }}>
                                    {book.quantity > 0 ? 'In Stock' : 'Out of Stock'}
                                </span>
                            </div>
                        </div>

                         <button
                            onClick={() => navigate(`/books/${book.book_id}`)}
                        >
                            View Details
                        </button>
                    </div>
                ))}
            </div>

            {books.length === 0 && <p>No books available.</p>}
        </div>
    );
};

export default Books;
