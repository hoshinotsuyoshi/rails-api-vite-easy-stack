import { useMutation } from '@apollo/client'
import React, { type FormEvent, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { css } from '../../../styled-system/css'
import { SetPasswordInputSchema } from '../../generated/graphql'
import { SetPasswordDocument } from '../../generated/graphql'
import { ROUTES } from '../../routes'

export const SetPassword = () => {
  const navigate = useNavigate()
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [businessLogicError, setBusinessLogicError] = useState('')
  const [passwordSet, setPasswordSet] = useState(false)

  const [setPasswordMutation, { loading, error }] =
    useMutation(SetPasswordDocument)

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault()

    if (password !== confirmPassword) {
      setBusinessLogicError('Passwords do not match.')
      return
    }

    const validationResult = SetPasswordInputSchema().safeParse({
      password,
    })

    if (!validationResult.success) {
      setBusinessLogicError('Invalid input. Please check your data.')
      console.error(validationResult.error)
      return
    }

    try {
      const { data, errors } = await setPasswordMutation({
        variables: {
          input: validationResult.data,
        },
      })

      if (data?.setPassword?.user) {
        setPasswordSet(true)
        console.log('Password set successfully')
        navigate(ROUTES.ME)
      } else if (data?.setPassword?.errors[0].__typename === 'SomeError') {
        setBusinessLogicError('Error setting password.')
        console.log('Password set error')
      } else if (errors?.length) {
        console.log('GraphQL failed', errors[0].message)
      } else {
        console.log('failed')
      }
    } catch (e) {
      console.error('error', e)
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
        Set Password
      </h2>
      {passwordSet || (
        <form onSubmit={handleSubmit}>
          <div className={css({ marginBottom: '15px' })}>
            <label
              className={css({
                display: 'block',
                marginBottom: '5px',
                fontSize: '16px',
              })}
              htmlFor="password"
            >
              New Password:
            </label>
            <input
              type="password"
              value={password}
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
          <div className={css({ marginBottom: '15px' })}>
            <label
              className={css({
                display: 'block',
                marginBottom: '5px',
                fontSize: '16px',
              })}
              htmlFor="confirmPassword"
            >
              Confirm Password:
            </label>
            <input
              type="password"
              value={confirmPassword}
              name="confirmPassword"
              onChange={(e) => setConfirmPassword(e.target.value)}
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
              backgroundColor: '#223344',
              color: 'white',
              border: 'none',
              cursor: 'pointer',
              transition: 'background-color 0.3s',
            })}
          >
            {loading ? 'Setting Password...' : 'Set Password'}
          </button>
        </form>
      )}
      {passwordSet && <p>Password set successfully!</p>}
      {error && <p style={{ color: 'red' }}>Error: {error.message}</p>}
      {businessLogicError.length > 0 && (
        <p style={{ color: 'red' }}>Error: {businessLogicError}</p>
      )}
    </div>
  )
}
