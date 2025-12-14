import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { api } from '../api';

const BookDetails = () => {
    const { id } = useParams();
    const [book, setBook] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        api.getBookById(id)
            .then(data => {
                setBook(data);
                setLoading(false);
            })
            .catch(err => {
                console.error(err);
                setLoading(false);
            });
    }, [id]);

    const handleBuy = (book) => {
        if (book.quantity <= 0) {
            alert('Out of stock!');
            return;
        }
        alert(`Purchase simulated for "${book.title}". Transaction procedure would be called here.`);
    };

    if (loading) return <p>Loading...</p>;
    if (!book) return <p>Book not found</p>;

    return (
        <div style={{ maxWidth: '800px', margin: '0 auto' }}>
            <h1>{book.title}</h1>
            <p style={{ color: '#666' }}>by {book.author}</p>

            <hr />

            <p><strong>Price:</strong> ₹{book.price}</p>
            <p>
                <strong>Status:</strong>{' '}
                <span style={{ color: book.quantity > 0 ? 'green' : 'red' }}>
                    {book.quantity > 0 ? 'In Stock' : 'Out of Stock'}
                </span>
            </p>

            <p><strong>Description:</strong></p>
            <p>{book.description}</p>

            <button
                onClick={() => handleBuy(book)}
                disabled={book.quantity <= 0}
                style={{
                    background: book.quantity > 0 ? '#2563eb' : '#cbd5e1',
                    color: '#fff',
                    padding: '10px 20px',
                    marginTop: '20px',
                    cursor: book.quantity > 0 ? 'pointer' : 'not-allowed'
                }}
            >
                Buy Now
            </button>
        </div>
    );
};

export default BookDetails;
