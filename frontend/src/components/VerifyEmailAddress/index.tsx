import { useMutation } from '@apollo/client'
import React, { useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { VerifyEmailAddressDocument } from '../../generated/graphql'
import { VerifyEmailAddressInputSchema } from '../../generated/graphql'
import { ROUTES } from '../../routes'

export const VerifyEmailAddress = () => {
  const location = useLocation()
  const navigate = useNavigate()
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)

  const queryParams = new URLSearchParams(location.search)
  const signedId = queryParams.get('signed_id')

  const [verifyEmailAddress, { loading }] = useMutation(
    VerifyEmailAddressDocument,
  )

  const verifyEmail = async () => {
    try {
      const validatedInput = VerifyEmailAddressInputSchema().parse({
        signedId,
      })

      const { data } = await verifyEmailAddress({
        variables: {
          input: validatedInput,
        },
      })

      if (data?.verifyEmailAddress?.success) {
        setSuccess(true)
        setTimeout(() => {
          navigate(ROUTES.SET_PASSWORD)
        }, 1000)
      } else {
        loading || setError('Failed to verify email. Please try again.')
      }
    } catch (err) {
      if (err instanceof Error) {
        setError(err.message)
      } else {
        setError('Email verification failed. Please try again.')
      }
      console.error(err)
    }
  }

  if (!success && !error) {
    verifyEmail()
  }

  return (
    <div style={{ textAlign: 'center', marginTop: '50px' }}>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {success ? (
        <p>
          Email verification successful! Redirecting to {ROUTES.SET_PASSWORD}...
        </p>
      ) : (
        !error && <p>Verifying your email...</p>
      )}
    </div>
  )
}
