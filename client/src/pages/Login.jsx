import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { api } from '../api';

const Login = ({ setUser }) => {
    const [isLogin, setIsLogin] = useState(true);

    // Form fields
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [name, setName] = useState('');
    const [phone, setPhone] = useState('');
    const [selectedRole, setSelectedRole] = useState('buyer');

    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');

        try {
            let responseData;

            if (isLogin) {
                // LOGIN
                responseData = await api.login({
                    contact_email: email,
                    password
                });
            } else {
                // REGISTER
                const res = await fetch('http://localhost:5000/api/auth/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        contact_email: email,
                        password,
                        name,
                        phone,
                        address: 'Campus',
                        roles: [selectedRole]   // ✅ single role wrapped in array
                    })
                });

                responseData = await res.json();

                if (!res.ok) {
                    throw new Error(responseData.message || 'Registration failed');
                }
            }

            // Extract user + token
            const userData = responseData.data?.user || responseData.user;
            const token = responseData.data?.token || responseData.token;

            if (!userData || !token) {
                throw new Error('Invalid response from server');
            }

            // Normalize roles
            const roles =
                responseData.data?.roles ||
                (userData.role ? userData.role.split(',').map(r => r.trim()) : []);

            const userWithRoles = { ...userData, roles };

            // Save auth
            localStorage.setItem('token', token);
            localStorage.setItem('user', JSON.stringify(userWithRoles));
            setUser(userWithRoles);

            // ✅ Role-based redirect
            if (roles.includes('seller')) {
                navigate('/seller');
            } else {
                navigate('/books');
            }

        } catch (err) {
            console.error('Auth Error:', err);
            setError(err.message || 'Authentication failed');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="auth-container">
            <h2 style={{ textAlign: 'center', marginBottom: 20 }}>
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
                            />
                        </div>

                        <div className="form-group">
                            <label>Phone Number *</label>
                            <input
                                type="text"
                                required
                                value={phone}
                                onChange={(e) => setPhone(e.target.value)}
                                pattern="[0-9]{10,15}"
                            />
                        </div>

                        <div className="form-group">
                            <label>I want to be a: *</label>
                            <div style={{ display: 'flex', gap: 20 }}>
                                <label>
                                    <input
                                        type="radio"
                                        name="role"
                                        value="buyer"
                                        checked={selectedRole === 'buyer'}
                                        onChange={(e) => setSelectedRole(e.target.value)}
                                    /> Buyer
                                </label>

                                <label>
                                    <input
                                        type="radio"
                                        name="role"
                                        value="seller"
                                        checked={selectedRole === 'seller'}
                                        onChange={(e) => setSelectedRole(e.target.value)}
                                    /> Seller
                                </label>
                            </div>
                        </div>
                    </>
                )}

                <div className="form-group">
                    <label>Email *</label>
                    <input
                        type="email"
                        required
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                    />
                </div>

                <div className="form-group">
                    <label>Password *</label>
                    <input
                        type="password"
                        required
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                    />
                </div>

                <button type="submit" disabled={loading}>
                    {loading ? 'Processing…' : isLogin ? 'Login' : 'Register'}
                </button>
            </form>

            <div style={{ marginTop: 20, textAlign: 'center' }}>
                <button
                    type="button"
                    onClick={() => {
                        setIsLogin(!isLogin);
                        setError('');
                    }}
                    style={{ background: 'none', border: 'none', color: '#2563eb' }}
                >
                    {isLogin ? 'Create New Account' : 'Back to Login'}
                </button>
            </div>
        </div>
    );
};

export default Login;
