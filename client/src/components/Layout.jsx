import React, { useEffect } from 'react';
import { Outlet, useNavigate } from 'react-router-dom';
import Navbar from './Navbar';

const Layout = ({ user, setUser }) => {
    const navigate = useNavigate();

    useEffect(() => {
        if (!user && !localStorage.getItem('token')) {
            navigate('/login');
        }
    }, [user, navigate]);

    if (!user) return null;

    return (
        <div>
            <Navbar user={user} setUser={setUser} />
            <main className="container">
                <Outlet />
            </main>
        </div>
    );
};

export default Layout;
