import React, { useState, useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import Layout from './components/Layout';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Books from './pages/Books';
import Notes from './pages/Notes';
import SellerPage from './pages/SellerPage';
import BookDetails from './pages/BookDetails';

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check for existing session
    const token = localStorage.getItem('token');
    const storedUser = localStorage.getItem('user');

    if (token && storedUser) {
      try {
        setUser(JSON.parse(storedUser));
      } catch (e) {
        localStorage.clear();
      }
    }
    setLoading(false);
  }, []);

  if (loading) {
    return <div className="min-h-screen bg-[#030712] text-white flex items-center justify-center">Loading...</div>;
  }

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={!user ? <Login setUser={setUser} /> : <Navigate to="/" />} />

        <Route element={<Layout user={user} setUser={setUser} />}>
          <Route path="/" element={<Books />} />
          {/* <Route path="/books" element={} /> */}
          <Route path="/books/:id" element={<BookDetails />} />
          <Route path="/seller" element={<SellerPage />} />
          <Route path="/notes" element={<Notes />} />
        </Route>

        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
