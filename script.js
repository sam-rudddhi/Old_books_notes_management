// Database Management System for Old Books & Notes
class DatabaseManager {
    constructor() {
        this.initDatabase();
    }

    // Initialize mock database with sample data
    initDatabase() {
        if (!localStorage.getItem('books')) {
            const sampleBooks = [
                {
                    id: 1,
                    title: "To Kill a Mockingbird",
                    author: "Harper Lee",
                    category: "fiction",
                    publication_year: 1960,
                    condition: "good",
                    status: "available",
                    description: "Classic American literature masterpiece",
                    date_added: new Date().toISOString()
                },
                {
                    id: 2,
                    title: "Introduction to Algorithms",
                    author: "Thomas H. Cormen",
                    category: "textbook",
                    publication_year: 2009,
                    condition: "excellent",
                    status: "borrowed",
                    description: "Comprehensive computer science textbook",
                    date_added: new Date().toISOString()
                },
                {
                    id: 3,
                    title: "The Great Gatsby",
                    author: "F. Scott Fitzgerald",
                    category: "fiction",
                    publication_year: 1925,
                    condition: "fair",
                    status: "available",
                    description: "American classic novel",
                    date_added: new Date().toISOString()
                }
            ];
            localStorage.setItem('books', JSON.stringify(sampleBooks));
        }

        if (!localStorage.getItem('notes')) {
            const sampleNotes = [
                {
                    id: 1,
                    title: "Database Systems Lecture Notes",
                    subject: "Database Management",
                    type: "lecture-notes",
                    grade_level: "undergraduate",
                    pages: 45,
                    condition: "good",
                    content: "Comprehensive notes covering SQL, normalization, and ER diagrams",
                    date_added: new Date().toISOString()
                },
                {
                    id: 2,
                    title: "Calculus Study Guide",
                    subject: "Mathematics",
                    type: "study-guide",
                    grade_level: "high-school",
                    pages: 32,
                    condition: "excellent",
                    content: "Derivatives, integrals, and limit concepts",
                    date_added: new Date().toISOString()
                },
                {
                    id: 3,
                    title: "Programming Assignment Solutions",
                    subject: "Computer Science",
                    type: "assignment",
                    grade_level: "undergraduate",
                    pages: 28,
                    condition: "fair",
                    content: "Java and Python programming solutions",
                    date_added: new Date().toISOString()
                }
            ];
            localStorage.setItem('notes', JSON.stringify(sampleNotes));
        }

        if (!localStorage.getItem('users')) {
            const sampleUsers = [
                {
                    id: 1,
                    username: "admin",
                    password: "admin123",
                    role: "admin",
                    fullName: "Administrator"
                },
                {
                    id: 2,
                    username: "user",
                    password: "user123",
                    role: "user",
                    fullName: "Regular User"
                }
            ];
            localStorage.setItem('users', JSON.stringify(sampleUsers));
        }
    }

    // Generate next ID for new records
    getNextId(table) {
        const data = this.getAll(table);
        if (data.length === 0) return 1;
        return Math.max(...data.map(item => item.id)) + 1;
    }

    // CRUD Operations for Books
    getAllBooks() {
        return JSON.parse(localStorage.getItem('books')) || [];
    }

    getBook(id) {
        const books = this.getAllBooks();
        return books.find(book => book.id === parseInt(id));
    }

    addBook(book) {
        const books = this.getAllBooks();
        book.id = this.getNextId('books');
        book.date_added = new Date().toISOString();
        books.push(book);
        localStorage.setItem('books', JSON.stringify(books));
        return book;
    }

    updateBook(id, updatedBook) {
        const books = this.getAllBooks();
        const index = books.findIndex(book => book.id === parseInt(id));
        if (index !== -1) {
            books[index] = { ...books[index], ...updatedBook };
            localStorage.setItem('books', JSON.stringify(books));
            return true;
        }
        return false;
    }

    deleteBook(id) {
        const books = this.getAllBooks();
        const filteredBooks = books.filter(book => book.id !== parseInt(id));
        localStorage.setItem('books', JSON.stringify(filteredBooks));
        return filteredBooks.length !== books.length;
    }

    // CRUD Operations for Notes
    getAllNotes() {
        return JSON.parse(localStorage.getItem('notes')) || [];
    }

    getNote(id) {
        const notes = this.getAllNotes();
        return notes.find(note => note.id === parseInt(id));
    }

    addNote(note) {
        const notes = this.getAllNotes();
        note.id = this.getNextId('notes');
        note.date_added = new Date().toISOString();
        notes.push(note);
        localStorage.setItem('notes', JSON.stringify(notes));
        return note;
    }

    updateNote(id, updatedNote) {
        const notes = this.getAllNotes();
        const index = notes.findIndex(note => note.id === parseInt(id));
        if (index !== -1) {
            notes[index] = { ...notes[index], ...updatedNote };
            localStorage.setItem('notes', JSON.stringify(notes));
            return true;
        }
        return false;
    }

    deleteNote(id) {
        const notes = this.getAllNotes();
        const filteredNotes = notes.filter(note => note.id !== parseInt(id));
        localStorage.setItem('notes', JSON.stringify(filteredNotes));
        return filteredNotes.length !== notes.length;
    }

    // Search functionality
    search(query, category = '', type = '') {
        const books = this.getAllBooks();
        const notes = this.getAllNotes();
        let results = [];

        // Search books
        if (type === '' || type === 'book') {
            const bookResults = books.filter(book => {
                const matchesQuery = query === '' || 
                    book.title.toLowerCase().includes(query.toLowerCase()) ||
                    book.author.toLowerCase().includes(query.toLowerCase()) ||
                    book.description.toLowerCase().includes(query.toLowerCase());
                
                const matchesCategory = category === '' || book.category === category;
                
                return matchesQuery && matchesCategory;
            }).map(book => ({ ...book, type: 'book' }));
            results = results.concat(bookResults);
        }

        // Search notes
        if (type === '' || type === 'notes') {
            const noteResults = notes.filter(note => {
                const matchesQuery = query === '' || 
                    note.title.toLowerCase().includes(query.toLowerCase()) ||
                    note.subject.toLowerCase().includes(query.toLowerCase()) ||
                    note.content.toLowerCase().includes(query.toLowerCase());
                
                const matchesCategory = category === '' || note.subject.toLowerCase().includes(category.toLowerCase());
                
                return matchesQuery && matchesCategory;
            }).map(note => ({ ...note, type: 'notes' }));
            results = results.concat(noteResults);
        }

        return results;
    }

    // Get statistics for dashboard
    getStatistics() {
        const books = this.getAllBooks();
        const notes = this.getAllNotes();
        const users = JSON.parse(localStorage.getItem('users')) || [];
        
        const now = new Date();
        const lastWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        
        const recentBooks = books.filter(book => new Date(book.date_added) > lastWeek);
        const recentNotes = notes.filter(note => new Date(note.date_added) > lastWeek);
        
        return {
            totalBooks: books.length,
            totalNotes: notes.length,
            activeUsers: users.length,
            recentAdditions: recentBooks.length + recentNotes.length
        };
    }

    // Authentication
    authenticate(username, password) {
        const users = JSON.parse(localStorage.getItem('users')) || [];
        return users.find(user => user.username === username && user.password === password);
    }

    getAll(table) {
        return JSON.parse(localStorage.getItem(table)) || [];
    }
}

// Application Controller
class LibraryManagementApp {
    constructor() {
        this.db = new DatabaseManager();
        this.currentUser = null;
        this.currentEditId = null;
        this.currentEditType = null;
        
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.checkLoginStatus();
    }

    setupEventListeners() {
        // Login form
        document.getElementById('loginForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleLogin();
        });

        // Logout button
        document.getElementById('logoutBtn').addEventListener('click', () => {
            this.handleLogout();
        });

        // Navigation
        document.querySelectorAll('.nav-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.switchSection(e.target.dataset.section);
            });
        });

        // Add buttons
        document.getElementById('addBookBtn').addEventListener('click', () => {
            this.showModal('book', null);
        });

        document.getElementById('addNoteBtn').addEventListener('click', () => {
            this.showModal('note', null);
        });

        // Forms
        document.getElementById('bookForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleBookSubmit();
        });

        document.getElementById('noteForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleNoteSubmit();
        });

        // Modal close buttons
        document.querySelectorAll('.close, .btn-cancel').forEach(btn => {
            btn.addEventListener('click', () => {
                this.hideModals();
            });
        });

        // Search
        document.getElementById('searchBtn').addEventListener('click', () => {
            this.performSearch();
        });

        document.getElementById('searchInput').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.performSearch();
            }
        });

        // Filter changes
        document.getElementById('categoryFilter').addEventListener('change', () => {
            this.performSearch();
        });

        document.getElementById('typeFilter').addEventListener('change', () => {
            this.performSearch();
        });

        // Close modals when clicking outside
        window.addEventListener('click', (e) => {
            if (e.target.classList.contains('modal')) {
                this.hideModals();
            }
        });
    }

    checkLoginStatus() {
        const savedUser = sessionStorage.getItem('currentUser');
        if (savedUser) {
            this.currentUser = JSON.parse(savedUser);
            this.showMainApp();
        } else {
            this.showLoginPage();
        }
    }

    handleLogin() {
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        const user = this.db.authenticate(username, password);
        
        if (user) {
            this.currentUser = user;
            sessionStorage.setItem('currentUser', JSON.stringify(user));
            this.showMainApp();
            this.showNotification('Login successful!', 'success');
        } else {
            this.showNotification('Invalid username or password!', 'error');
        }
    }

    handleLogout() {
        this.currentUser = null;
        sessionStorage.removeItem('currentUser');
        this.showLoginPage();
        this.showNotification('Logged out successfully!', 'success');
    }

    showLoginPage() {
        document.getElementById('loginPage').classList.add('active');
        document.getElementById('mainApp').classList.remove('active');
    }

    showMainApp() {
        document.getElementById('loginPage').classList.remove('active');
        document.getElementById('mainApp').classList.add('active');
        
        document.getElementById('currentUser').textContent = `Welcome, ${this.currentUser.fullName}!`;
        
        this.loadDashboard();
        this.loadBooks();
        this.loadNotes();
    }

    switchSection(sectionName) {
        // Update navigation
        document.querySelectorAll('.nav-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector(`[data-section="${sectionName}"]`).classList.add('active');

        // Update content
        document.querySelectorAll('.content-section').forEach(section => {
            section.classList.remove('active');
        });
        document.getElementById(`${sectionName}Section`).classList.add('active');

        // Load section data
        if (sectionName === 'dashboard') {
            this.loadDashboard();
        } else if (sectionName === 'search') {
            this.performSearch();
        }
    }

    loadDashboard() {
        const stats = this.db.getStatistics();
        document.getElementById('totalBooks').textContent = stats.totalBooks;
        document.getElementById('totalNotes').textContent = stats.totalNotes;
        document.getElementById('activeUsers').textContent = stats.activeUsers;
        document.getElementById('recentAdditions').textContent = stats.recentAdditions;
    }

    loadBooks() {
        const books = this.db.getAllBooks();
        const tbody = document.getElementById('booksTableBody');
        
        tbody.innerHTML = books.map(book => `
            <tr>
                <td>${book.id}</td>
                <td>${book.title}</td>
                <td>${book.author}</td>
                <td>${this.capitalizeFirst(book.category)}</td>
                <td>${book.publication_year}</td>
                <td><span class="status-${book.condition}">${this.capitalizeFirst(book.condition)}</span></td>
                <td><span class="status-${book.status}">${this.capitalizeFirst(book.status)}</span></td>
                <td>
                    <button class="btn-edit" onclick="app.editBook(${book.id})">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                    <button class="btn-delete" onclick="app.deleteBook(${book.id})">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </td>
            </tr>
        `).join('');
    }

    loadNotes() {
        const notes = this.db.getAllNotes();
        const tbody = document.getElementById('notesTableBody');
        
        tbody.innerHTML = notes.map(note => `
            <tr>
                <td>${note.id}</td>
                <td>${note.title}</td>
                <td>${note.subject}</td>
                <td>${this.capitalizeFirst(note.type.replace('-', ' '))}</td>
                <td>${this.capitalizeFirst(note.grade_level.replace('-', ' '))}</td>
                <td>${note.pages}</td>
                <td><span class="status-${note.condition}">${this.capitalizeFirst(note.condition)}</span></td>
                <td>
                    <button class="btn-edit" onclick="app.editNote(${note.id})">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                    <button class="btn-delete" onclick="app.deleteNote(${note.id})">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </td>
            </tr>
        `).join('');
    }

    showModal(type, id) {
        this.currentEditId = id;
        this.currentEditType = type;
        
        const modal = document.getElementById(`${type}Modal`);
        const title = document.getElementById(`${type}ModalTitle`);
        
        if (id) {
            // Edit mode
            title.textContent = `Edit ${type === 'book' ? 'Book' : 'Note'}`;
            this.populateForm(type, id);
        } else {
            // Add mode
            title.textContent = `Add New ${type === 'book' ? 'Book' : 'Note'}`;
            this.clearForm(type);
        }
        
        modal.classList.add('active');
    }

    hideModals() {
        document.querySelectorAll('.modal').forEach(modal => {
            modal.classList.remove('active');
        });
        this.currentEditId = null;
        this.currentEditType = null;
    }

    populateForm(type, id) {
        const data = type === 'book' ? this.db.getBook(id) : this.db.getNote(id);
        
        if (type === 'book') {
            document.getElementById('bookTitle').value = data.title;
            document.getElementById('bookAuthor').value = data.author;
            document.getElementById('bookCategory').value = data.category;
            document.getElementById('bookYear').value = data.publication_year;
            document.getElementById('bookCondition').value = data.condition;
            document.getElementById('bookStatus').value = data.status;
            document.getElementById('bookDescription').value = data.description || '';
        } else {
            document.getElementById('noteTitle').value = data.title;
            document.getElementById('noteSubject').value = data.subject;
            document.getElementById('noteType').value = data.type;
            document.getElementById('noteGrade').value = data.grade_level;
            document.getElementById('notePages').value = data.pages;
            document.getElementById('noteCondition').value = data.condition;
            document.getElementById('noteContent').value = data.content || '';
        }
    }

    clearForm(type) {
        const form = document.getElementById(`${type}Form`);
        form.reset();
    }

    handleBookSubmit() {
        const formData = {
            title: document.getElementById('bookTitle').value,
            author: document.getElementById('bookAuthor').value,
            category: document.getElementById('bookCategory').value,
            publication_year: parseInt(document.getElementById('bookYear').value),
            condition: document.getElementById('bookCondition').value,
            status: document.getElementById('bookStatus').value,
            description: document.getElementById('bookDescription').value
        };

        if (this.currentEditId) {
            // Update existing book
            if (this.db.updateBook(this.currentEditId, formData)) {
                this.showNotification('Book updated successfully!', 'success');
                this.loadBooks();
                this.loadDashboard();
            } else {
                this.showNotification('Failed to update book!', 'error');
            }
        } else {
            // Add new book
            this.db.addBook(formData);
            this.showNotification('Book added successfully!', 'success');
            this.loadBooks();
            this.loadDashboard();
        }

        this.hideModals();
    }

    handleNoteSubmit() {
        const formData = {
            title: document.getElementById('noteTitle').value,
            subject: document.getElementById('noteSubject').value,
            type: document.getElementById('noteType').value,
            grade_level: document.getElementById('noteGrade').value,
            pages: parseInt(document.getElementById('notePages').value),
            condition: document.getElementById('noteCondition').value,
            content: document.getElementById('noteContent').value
        };

        if (this.currentEditId) {
            // Update existing note
            if (this.db.updateNote(this.currentEditId, formData)) {
                this.showNotification('Note updated successfully!', 'success');
                this.loadNotes();
                this.loadDashboard();
            } else {
                this.showNotification('Failed to update note!', 'error');
            }
        } else {
            // Add new note
            this.db.addNote(formData);
            this.showNotification('Note added successfully!', 'success');
            this.loadNotes();
            this.loadDashboard();
        }

        this.hideModals();
    }

    editBook(id) {
        this.showModal('book', id);
    }

    editNote(id) {
        this.showModal('note', id);
    }

    deleteBook(id) {
        if (confirm('Are you sure you want to delete this book?')) {
            if (this.db.deleteBook(id)) {
                this.showNotification('Book deleted successfully!', 'success');
                this.loadBooks();
                this.loadDashboard();
            } else {
                this.showNotification('Failed to delete book!', 'error');
            }
        }
    }

    deleteNote(id) {
        if (confirm('Are you sure you want to delete this note?')) {
            if (this.db.deleteNote(id)) {
                this.showNotification('Note deleted successfully!', 'success');
                this.loadNotes();
                this.loadDashboard();
            } else {
                this.showNotification('Failed to delete note!', 'error');
            }
        }
    }

    performSearch() {
        const query = document.getElementById('searchInput').value;
        const category = document.getElementById('categoryFilter').value;
        const type = document.getElementById('typeFilter').value;

        const results = this.db.search(query, category, type);
        this.displaySearchResults(results);
    }

    displaySearchResults(results) {
        const container = document.getElementById('searchResults');
        
        if (results.length === 0) {
            container.innerHTML = '<p style="text-align: center; color: #666; padding: 40px;">No results found.</p>';
            return;
        }

        container.innerHTML = results.map(item => `
            <div class="search-result-item" style="padding: 20px; border-bottom: 1px solid #e2e8f0; transition: background 0.3s ease;" 
                 onmouseover="this.style.background='#f7fafc'" 
                 onmouseout="this.style.background='white'">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div>
                        <h4 style="color: #4a5568; margin-bottom: 8px; font-size: 16px;">
                            ${item.type === 'book' ? '📚' : '📝'} ${item.title}
                        </h4>
                        <p style="color: #666; margin-bottom: 4px;">
                            ${item.type === 'book' ? `Author: ${item.author} | Category: ${this.capitalizeFirst(item.category)}` : 
                                                    `Subject: ${item.subject} | Type: ${this.capitalizeFirst(item.type.replace('-', ' '))}`}
                        </p>
                        <p style="color: #888; font-size: 14px;">
                            ${item.type === 'book' ? item.description : item.content}
                        </p>
                    </div>
                    <div style="text-align: right;">
                        <span class="status-${item.condition}" style="display: inline-block; margin-bottom: 5px;">
                            ${this.capitalizeFirst(item.condition)}
                        </span>
                        <br>
                        <small style="color: #888;">ID: ${item.id}</small>
                    </div>
                </div>
            </div>
        `).join('');
    }

    capitalizeFirst(str) {
        return str.charAt(0).toUpperCase() + str.slice(1).replace(/-/g, ' ');
    }

    showNotification(message, type) {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${type === 'success' ? '#48bb78' : '#e53e3e'};
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            z-index: 10000;
            animation: slideInRight 0.3s ease-out;
            font-weight: 500;
        `;
        notification.textContent = message;

        // Add animation keyframes
        if (!document.getElementById('notificationStyles')) {
            const style = document.createElement('style');
            style.id = 'notificationStyles';
            style.textContent = `
                @keyframes slideInRight {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }
                @keyframes slideOutRight {
                    from {
                        transform: translateX(0);
                        opacity: 1;
                    }
                    to {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
        }

        document.body.appendChild(notification);

        // Remove notification after 3 seconds
        setTimeout(() => {
            notification.style.animation = 'slideOutRight 0.3s ease-out';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }, 3000);
    }
}

// Initialize the application
const app = new LibraryManagementApp();

// Make app globally available for onclick handlers
window.app = app;
