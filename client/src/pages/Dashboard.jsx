import React, { useEffect, useState } from 'react';
import { api } from '../api';

const Dashboard = ({ user }) => {
    const [stats, setStats] = useState({
        totalBooks: 0,
        totalNotes: 0,
    });

    useEffect(() => {
        api.getStats().then(setStats);
    }, []);

    const isAdmin = user?.roles?.includes('admin');

    if (!isAdmin) {
        return (
            <div style={{ textAlign: 'center', marginTop: '50px' }}>
                <h1>Welcome, {user?.name || 'User'}!</h1>
                <p style={{ fontSize: '18px', color: '#666', marginTop: '10px' }}>
                    DBMS Project: Old Books & Notes Management System
                </p>
                <p style={{ color: '#888', marginBottom: '30px' }}>
                    Please select an action below based on your role.
                </p>

                <div style={{ display: 'flex', gap: '20px', justifyContent: 'center', marginTop: '30px' }}>
                    {(user?.roles?.includes('buyer') || user?.roles?.includes('admin')) && (
                        <a href="/books" style={{ padding: '15px 30px', background: '#2563eb', color: 'white', borderRadius: '8px', textDecoration: 'none', fontWeight: 'bold' }}>
                            Browse Marketplace (Buy)
                        </a>
                    )}
                    {(user?.roles?.includes('seller') || user?.roles?.includes('admin')) && (
                        <a href="/seller" style={{ padding: '15px 30px', background: '#475569', color: 'white', borderRadius: '8px', textDecoration: 'none', fontWeight: 'bold' }}>
                            Manage Inventory (Sell)
                        </a>
                    )}
                </div>
            </div>
        );
    }

    return (
        <div>
            <h1 style={{ marginBottom: '20px' }}>Admin Dashboard</h1>

            <div className="card-grid">
                <div className="card">
                    <h3>Total Books</h3>
                    <div className="value">{stats.totalBooks}</div>
                    <p>Inventory Count</p>
                </div>
                <div className="card">
                    <h3>Total Notes</h3>
                    <div className="value">{stats.totalNotes}</div>
                    <p>Study Materials</p>
                </div>
                <div className="card">
                    <h3>Active Users</h3>
                    <div className="value">{stats.activeUsers || 1}</div>
                    <p>System Users</p>
                </div>
            </div>

            <div style={{ marginTop: '40px' }}>
                <h2>Database Operations Demo</h2>
                <div className="card-grid">
                    <div className="card">
                        <h3>Test Stored Procedure</h3>
                        <p>Go to <strong>Inventory</strong> page to test <code>sp_add_book</code>.</p>
                    </div>
                    <div className="card">
                        <h3>Test Trigger</h3>
                        <p>Edit a book quantity to 0 and watch the status automatically update via <code>trg_book_availability_update</code>.</p>
                    </div>
                </div>
            </div>

            <div style={{ marginTop: '20px', padding: '15px', background: '#fff', border: '1px solid #eee', borderRadius: '8px' }}>
                <h3>System Status</h3>
                <p>Database Connection: <strong style={{ color: 'green' }}>Active</strong></p>
                <p>Current User: {user?.email} (Roles: {user?.roles?.join(', ')})</p>
            </div>
        </div>
    );
};

export default Dashboard;
