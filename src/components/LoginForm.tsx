import React, { useState } from 'react'
import { css } from '../../styled-system/css'

const LoginForm = () => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    // ログイン処理（例：APIリクエストなど）をここで行います
    console.log('Email:', email, 'Password:', password)
  };

  return (
    <div className={css({ maxWidth: '400px', margin: '0 auto', padding: '20px', borderRadius: '8px', backgroundColor: 'white', boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)' })}>
      <h2 className={css({ fontSize: '24px', textAlign: 'center', marginBottom: '20px' })}>Login</h2>
      <form onSubmit={handleSubmit}>
        <div className={css({ marginBottom: '15px' })}>
          <label className={css({ display: 'block', marginBottom: '5px', fontSize: '16px' })}>Email:</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            className={css({ width: '100%', padding: '10px', fontSize: '16px', borderRadius: '4px', border: '1px solid #ccc' })}
          />
        </div>
        <div className={css({ marginBottom: '15px' })}>
          <label className={css({ display: 'block', marginBottom: '5px', fontSize: '16px' })}>Password:</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            className={css({ width: '100%', padding: '10px', fontSize: '16px', borderRadius: '4px', border: '1px solid #ccc' })}
          />
        </div>
        <button
          type="submit"
          className={css({ width: '100%', padding: '10px', fontSize: '16px', borderRadius: '4px', backgroundColor: '#4CAF50', color: 'white', border: 'none', cursor: 'pointer', transition: 'background-color 0.3s' })}
          onMouseOver={(e) => (e.currentTarget.style.backgroundColor = '#45a049')}
          onMouseOut={(e) => (e.currentTarget.style.backgroundColor = '#4CAF50')}
        >
          Login
        </button>
      </form>
    </div>
  )
}

export default LoginForm
