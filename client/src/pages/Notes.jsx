import React, { useEffect, useState } from 'react';
import { api } from '../api';

const Notes = () => {
    const [notes, setNotes] = useState([]);

    useEffect(() => {
        api.getNotes().then(data => setNotes(Array.isArray(data) ? data : []));
    }, []);

    return (
        <div>
            <h1>Notes Management</h1>
            <p style={{ color: '#666', marginBottom: '20px' }}>
                Demonstrates reading from <code>notes</code> table.
            </p>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Subject</th>
                        <th>Price</th>
                        <th>Type</th>
                    </tr>
                </thead>
                <tbody>
                    {notes.map(note => (
                        <tr key={note.note_id}>
                            <td>{note.note_id}</td>
                            <td>{note.title}</td>
                            <td>{note.subject}</td>
                            <td>${note.price}</td>
                            <td>{note.type}</td>
                        </tr>
                    ))}
                    {notes.length === 0 && <tr><td colSpan="5" style={{ textAlign: 'center' }}>No notes found.</td></tr>}
                </tbody>
            </table>
        </div>
    );
};

export default Notes;
