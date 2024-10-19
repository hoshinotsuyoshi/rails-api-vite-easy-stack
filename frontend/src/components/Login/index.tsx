import { useMutation } from '@apollo/client'
import React, { type FormEvent, useId, useState } from 'react'
import { Link } from 'react-router-dom'
import { css } from '../../../styled-system/css'
import { LoginInputSchema } from '../../generated/graphql'
import { LoginDocument } from '../../generated/graphql'
import { ROUTES } from '../../routes'

export const Login = () => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [businessLogicError, setBusinessLogicError] = useState('')

  const [login, { loading, error }] = useMutation(LoginDocument)
  const emailId = useId()
  const passwordId = useId()

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault()

    const validationResult = LoginInputSchema().safeParse({
      emailAddress: email,
      password: password,
    })

    if (!validationResult.success) {
      setBusinessLogicError('Invalid input. Please check your data.')
      console.error(validationResult.error)
      return
    }

    try {
      const { data, errors } = await login({
        variables: {
          input: validationResult.data,
        },
      })

      if (data?.login?.success) {
        console.log('successful')
        location.href = ROUTES.ME // NOTE: Ideally, we would like to use useNavigate, but it's unstable timing-wise
      } else if (errors?.length) {
        console.log('GraphQL failed', errors[0].message)
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
            htmlFor={emailId}
          >
            Email:
          </label>
          <input
            type="email"
            value={email}
            id={emailId}
            name="email"
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
            htmlFor={passwordId}
          >
            Password:
          </label>
          <input
            type="password"
            value={password}
            id={passwordId}
            name="password"
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
            padding: '12px',
            fontSize: '16px',
            borderRadius: '4px',
            backgroundColor: '#223344',
            color: 'white',
            border: 'none',
            cursor: 'pointer',
            transition: 'background-color 0.3s',
            marginBottom: '15px',
          })}
        >
          {loading ? 'Logging in...' : 'Login'}
        </button>
      </form>
      {error && <p style={{ color: 'red' }}>Login failed: {error.message}</p>}
      {businessLogicError.length > 0 && (
        <p style={{ color: 'red' }}>Login failed: {businessLogicError}</p>
      )}
      <span>Don't have an account? </span>
      <Link
        to={ROUTES.SIGNUP}
        className={css({
          color: 'blue',
          textDecoration: 'underline',
          cursor: 'pointer',
        })}
      >
        Create an account
      </Link>
    </div>
  )
}
