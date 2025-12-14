const API_URL = 'http://localhost:5000/api';

const getHeaders = () => {
    const token = localStorage.getItem('token');
    return {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {})
    };
};

export const api = {
    // Auth
    login: async (credentials) => {
        // credentials should be { contact_email, password }
        const res = await fetch(`${API_URL}/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(credentials)
        });
        const data = await res.json();
        if (!res.ok) throw new Error(data.message || 'Login failed');
        return data;
    },

    // Books
    getBooks: async () => {
        const res = await fetch(`${API_URL}/books`, { headers: getHeaders() });
        return res.json();
    },

    addBook: async (bookData) => {
        // This calls the API which should use Stored Procedure sp_add_book
        const res = await fetch(`${API_URL}/books`, {
            method: 'POST',
            headers: getHeaders(),
            body: JSON.stringify(bookData)
        });
        const data = await res.json();
        if (!res.ok) throw new Error(data.message || 'Add book failed');
        return data;
    },

    // Notes
    getNotes: async () => {
        const res = await fetch(`${API_URL}/notes`, { headers: getHeaders() });
        return res.json();
    },

    // Stats
    getStats: async () => {
        try {
            const [books, notes] = await Promise.all([
                fetch(`${API_URL}/books`, { headers: getHeaders() }).then(r => r.json()),
                fetch(`${API_URL}/notes`, { headers: getHeaders() }).then(r => r.json())
            ]);
            return {
                totalBooks: Array.isArray(books) ? books.length : 0,
                totalNotes: Array.isArray(notes) ? notes.length : 0,
                activeUsers: 1,
                recentAdditions: (Array.isArray(books) ? books.length : 0) + (Array.isArray(notes) ? notes.length : 0)
            };
        } catch (e) {
            console.error("Error fetching stats", e);
            return { totalBooks: 0, totalNotes: 0, activeUsers: 0, recentAdditions: 0 };
        }
    }
};
