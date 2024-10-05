import type React from 'react'
import { useState } from 'react'
import { css } from '../../styled-system/css'
import { useMutation } from '@apollo/client'
import { LOGIN_MUTATION } from '../graphql/mutations'
import type { MutationLoginArgs, User } from '../generated/graphql'

const LoginForm = () => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const [login, { loading, error }] = useMutation<
    { login: User },
    MutationLoginArgs
  >(LOGIN_MUTATION)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    try {
      const response = await login({
        variables: {
          input: {
            emailAddress: email,
            password: password,
          },
        },
      })

      if (response.data?.login) {
        console.log('Login successful', response.data.login)
      } else {
        console.log('Login failed')
      }
    } catch (e) {
      console.error('Login error', e)
    }
  }

  return (
    <div
      className={css({
        maxWidth: '400px',
        margin: '0 auto',
        padding: '20px',
        borderRadius: '8px',
        backgroundColor: 'white',
        boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)',
      })}
    >
      <h2
        className={css({
          fontSize: '24px',
          textAlign: 'center',
          marginBottom: '20px',
        })}
      >
        Login
      </h2>
      <form onSubmit={handleSubmit}>
        <div className={css({ marginBottom: '15px' })}>
          <label
            className={css({
              display: 'block',
              marginBottom: '5px',
              fontSize: '16px',
            })}
            htmlFor="email"
          >
            Email:
          </label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            className={css({
              width: '100%',
              padding: '10px',
              fontSize: '16px',
              borderRadius: '4px',
              border: '1px solid #ccc',
            })}
          />
        </div>
        <div className={css({ marginBottom: '15px' })}>
          <label
            className={css({
              display: 'block',
              marginBottom: '5px',
              fontSize: '16px',
            })}
            htmlFor="password"
          >
            Password:
          </label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            className={css({
              width: '100%',
              padding: '10px',
              fontSize: '16px',
              borderRadius: '4px',
              border: '1px solid #ccc',
            })}
          />
        </div>
        <button
          type="submit"
          className={css({
            width: '100%',
            padding: '10px',
            fontSize: '16px',
            borderRadius: '4px',
            backgroundColor: '#4CAF50',
            color: 'white',
            border: 'none',
            cursor: 'pointer',
            transition: 'background-color 0.3s',
          })}
        >
          {loading ? 'Logging in...' : 'Login'}
        </button>
      </form>
      {error && <p style={{ color: 'red' }}>Login failed: {error.message}</p>}
    </div>
  )
}

export default LoginForm
