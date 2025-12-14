import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { api } from '../api';

const Login = ({ setUser }) => {
    const [isLogin, setIsLogin] = useState(true);
    // Form Fields
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [name, setName] = useState('');
    const [phone, setPhone] = useState('');
    const [selectedRoles, setSelectedRoles] = useState(['buyer']); // Default buyer

    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    const handleRoleChange = (role) => {
        if (selectedRoles.includes(role)) {
            setSelectedRoles(selectedRoles.filter(r => r !== role));
        } else {
            setSelectedRoles([...selectedRoles, role]);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');
        try {
            let responseData;
            if (isLogin) {
                // LOGIN
                responseData = await api.login({ contact_email: email, password });
            } else {
                // REGISTER
                if (selectedRoles.length === 0) {
                    throw new Error('Please select at least one role (Buyer or Seller).');
                }
                const res = await fetch('http://localhost:5000/api/auth/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        contact_email: email,
                        password,
                        name: name,
                        phone: phone,
                        address: 'Campus',
                        roles: selectedRoles // Send array of roles
                    })
                });
                responseData = await res.json();
                if (!res.ok) {
                    throw new Error(responseData.message || JSON.stringify(responseData));
                }
            }

            // Success handling
            const userData = responseData.data?.user || responseData.user;
            const token = responseData.data?.token || responseData.token;
            // Extract roles from response data
            const userRoles = responseData.data?.roles || (userData.role ? userData.role.split(',') : []);

            if (!token || !userData) {
                throw new Error('Invalid response from server');
            }

            // Merge roles into user object
            const userWithRoles = { ...userData, roles: userRoles };

            localStorage.setItem('token', token);
            localStorage.setItem('user', JSON.stringify(userWithRoles));
            setUser(userWithRoles);
            navigate('/');

        } catch (err) {
            console.error("Auth Error:", err);
            setError(err.message || 'Operation failed');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="auth-container">
            <h2 style={{ marginBottom: '20px', textAlign: 'center' }}>
                {isLogin ? 'Login to Dashboard' : 'Create Account'}
            </h2>

            {error && <div className="error-msg">{error}</div>}

            <form onSubmit={handleSubmit}>
                {!isLogin && (
                    <>
                        <div className="form-group">
                            <label>Full Name *</label>
                            <input
                                type="text"
                                required
                                value={name}
                                onChange={(e) => setName(e.target.value)}
                                placeholder="Enter your name"
                            />
                        </div>
                        <div className="form-group">
                            <label>Phone Number * (10 digits)</label>
                            <input
                                type="text"
                                required
                                value={phone}
                                onChange={(e) => setPhone(e.target.value)}
                                placeholder="9999999999"
                                pattern="[0-9]{10,15}"
                                title="Please enter a valid phone number"
                            />
                        </div>
                        <div className="form-group">
                            <label>I want to be a: *</label>
                            <div style={{ display: 'flex', gap: '20px', marginTop: '5px' }}>
                                <label style={{ fontWeight: 'normal' }}>
                                    <input
                                        type="checkbox"
                                        checked={selectedRoles.includes('buyer')}
                                        onChange={() => handleRoleChange('buyer')}
                                    /> Buyer
                                </label>
                                <label style={{ fontWeight: 'normal' }}>
                                    <input
                                        type="checkbox"
                                        checked={selectedRoles.includes('seller')}
                                        onChange={() => handleRoleChange('seller')}
                                    /> Seller
                                </label>
                            </div>
                        </div>
                    </>
                )}

                <div className="form-group">
                    <label>Email Address *</label>
                    <input
                        type="email"
                        required
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        placeholder="email@example.com"
                    />
                </div>

                <div className="form-group">
                    <label>Password *</label>
                    <input
                        type="password"
                        required
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        placeholder="******"
                    />
                </div>

                <button type="submit" disabled={loading}>
                    {loading ? 'Processing...' : (isLogin ? 'Login' : 'Register')}
                </button>
            </form>

            <div style={{ marginTop: '20px', textAlign: 'center', borderTop: '1px solid #eee', paddingTop: '15px' }}>
                <p style={{ marginBottom: '10px' }}>{isLogin ? "Don't have an account?" : "Already have an account?"}</p>
                <button
                    type="button"
                    onClick={() => {
                        setIsLogin(!isLogin);
                        setError('');
                    }}
                    style={{ background: '#f8fafc', color: '#2563eb', border: '1px solid #e2e8f0' }}
                >
                    {isLogin ? 'Create New Account' : 'Back to Login'}
                </button>
            </div>
        </div>
    );
};
export default Login;
