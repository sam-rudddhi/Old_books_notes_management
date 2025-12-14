const API_URL = `http://localhost:5000/api`;
console.log(`${API_URL}/books`);

const getHeaders = () => {
    const token = localStorage.getItem('token');
    return {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {})
    };
};

const handleResponse = async (res) => {
    const json = await res.json();
    if (!res.ok) {
        throw new Error(json.message || 'API Error');
    }
    return json.data ?? json;
};

export const api = {
    login: async (credentials) => {
        const res = await fetch(`${API_URL}/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(credentials)
        });
        return handleResponse(res);
    },

    getBooks: async () => {
        const res = await fetch(`${API_URL}/books`, { headers: getHeaders() });

        return handleResponse(res);
    },

    getBookById: async (id) => {
        const res = await fetch(`${API_URL}/books/${id}`);
        const json = await res.json();
        return json.data ?? json;
    },
    getMyBooks: async () => {
        const res = await fetch(`${API_URL}/books/seller/my-books`, {
            headers: getHeaders()
        });
        const json = await res.json();
        if (!res.ok) throw new Error(json.message || 'Failed to fetch seller books');
        return json.data ?? json;
    },


    addBook: async (bookData) => {
        const res = await fetch(`${API_URL}/books`, {
            method: 'POST',
            headers: getHeaders(),
            body: JSON.stringify(bookData)
        });
        return handleResponse(res);
    },

    deleteBook: async (bookId) => {
        const res = await fetch(`${API_URL}/books/${bookId}`, {
            method: 'DELETE',
            headers: getHeaders()
        });

        const json = await res.json();
        if (!res.ok) {
            throw new Error(json.message || 'Failed to delete book');
        }

        return json;
    },
    updateBook: async (bookId, bookData) => {
        const res = await fetch(`${API_URL}/books/${bookId}`, {
            method: 'PUT',
            headers: getHeaders(),
            body: JSON.stringify(bookData)
        });

        const json = await res.json();
        if (!res.ok) {
            throw new Error(json.message || 'Failed to update book');
        }

        return json.data ?? json;
    },

    getNotes: async () => {
        const res = await fetch(`${API_URL}/notes`, { headers: getHeaders() });
        return handleResponse(res);
    },

    getCategories: async () => {
        const res = await fetch(`${API_URL}/categories`, { headers: getHeaders() });
        return handleResponse(res);
    }
};
