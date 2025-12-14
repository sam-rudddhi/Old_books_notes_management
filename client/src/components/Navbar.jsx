import React from 'react';
import { NavLink, useNavigate } from 'react-router-dom';

const Navbar = ({ user, setUser }) => {
    const navigate = useNavigate();

    const handleLogout = () => {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        setUser(null);
        navigate('/login');
    };

    return (
        <nav>
            <div className="container nav-content">
                <div style={{ fontSize: '20px', fontWeight: 'bold', color: '#2563eb' }}>
                    DBMS Project
                </div>

                <div className="nav-links">
                    {/* Admin sees Dashboard */}
                    {user?.roles?.includes('admin') && (
                        <NavLink to="/" className={({ isActive }) => isActive ? 'active' : ''}>Admin Dashboard</NavLink>
                    )}

                    {/* Buyers see Marketplace */}
                    {(user?.roles?.includes('buyer') || user?.roles?.includes('admin')) && (
                        <NavLink to="/books" className={({ isActive }) => isActive ? 'active' : ''}>Browse Books</NavLink>
                    )}

                    {/* Sellers see Inventory */}
                    {(user?.roles?.includes('seller') || user?.roles?.includes('admin')) && (
                        <NavLink to="/seller" className={({ isActive }) => isActive ? 'active' : ''}>My Inventory</NavLink>
                    )}
                </div>

                <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
                    <span style={{ fontSize: '14px', color: '#64748b' }}>
                        {user?.name || user?.email}
                    </span>
                    <button
                        onClick={handleLogout}
                        style={{ width: 'auto', padding: '5px 15px', background: '#f1f5f9', color: '#64748b' }}
                    >
                        Logout
                    </button>
                </div>
            </div>
        </nav>
    );
};

export default Navbar;
