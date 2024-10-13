import { useMutation } from '@apollo/client'
import { useEffect, useState } from 'react'
import React from 'react'
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

  const [verifyEmailAddress] = useMutation(VerifyEmailAddressDocument)

  useEffect(() => {
    const verifyEmail = async () => {
      if (signedId) {
        try {
          const validatedInput = VerifyEmailAddressInputSchema().parse({
            signedId,
          })

          const response = await verifyEmailAddress({
            variables: {
              input: validatedInput,
            },
          })

          if (response.data?.verifyEmailAddress?.user) {
            setSuccess(true)
            setTimeout(() => {
              navigate(ROUTES.ME)
            }, 1000)
          } else {
            setError('Failed to verify email. Please try again.')
          }
        } catch (err) {
          if (err instanceof Error) {
            setError(err.message)
          } else {
            setError('Email verification failed. Please try again.')
          }
          console.error(err)
        }
      } else {
        setError('Invalid request. No signed ID provided.')
      }
    }

    verifyEmail()
  }, [signedId, verifyEmailAddress, navigate])

  return (
    <div style={{ textAlign: 'center', marginTop: '50px' }}>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {success ? (
        <p>Email verification successful! Redirecting to {ROUTES.ME}...</p>
      ) : (
        !error && <p>Verifying your email...</p>
      )}
    </div>
  )
}
