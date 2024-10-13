import { useMutation } from '@apollo/client'
import React, { type FormEvent, useState } from 'react'
import { css } from '../../../styled-system/css'
import type { MutationSignupArgs, SignupPayload } from '../../generated/graphql'
import { SIGNUP_MUTATION } from './SIGNUP_MUTATION'

export const Signup = () => {
  const [email, setEmail] = useState('')
  const [businessLogicError, setBusinessLogicError] = useState('')
  const [inviting, setInviting] = useState(false)

  const [signup, { loading, error }] = useMutation<
    { signup: SignupPayload },
    MutationSignupArgs
  >(SIGNUP_MUTATION)

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault()

    try {
      const { data, errors } = await signup({
        variables: {
          input: {
            emailAddress: email,
          },
        },
      })

      if (data?.signup?.user) {
        setInviting(true)
        console.log('successful', data.signup.user)
      } else if (data?.signup?.errors[0].__typename === 'Taken') {
        setBusinessLogicError('Email address is already taken')
        console.log('already taken')
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
        Signup
      </h2>
      {inviting || (
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
            {loading ? 'Sending...' : 'Sign up'}
          </button>
        </form>
      )}
      {inviting && <p> Inviting. Check your mail box.</p>}
      {error && <p style={{ color: 'red' }}>Signup failed: {error.message}</p>}
      {businessLogicError.length > 0 && (
        <p style={{ color: 'red' }}>Signup failed: {businessLogicError}</p>
      )}
    </div>
  )
}
