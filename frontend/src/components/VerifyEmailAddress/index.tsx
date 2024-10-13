import { useMutation } from '@apollo/client'
import { useEffect, useState } from 'react'
import React from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import type {
  MutationVerifyEmailAddressArgs,
  VerifyEmailAddressPayload,
} from '../../generated/graphql'
import { ROUTES } from '../../routes'
import { VERIFY_EMAIL_ADDRESS_MUTATION } from './VERIFY_EMAIL_ADDRESS_MUTATION'

export const VerifyEmailAddress = () => {
  const location = useLocation()
  const navigate = useNavigate()
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)

  const queryParams = new URLSearchParams(location.search)
  const signedId = queryParams.get('signed_id')

  const [verifyEmailAddress] = useMutation<
    { verifyEmailAddress?: VerifyEmailAddressPayload },
    MutationVerifyEmailAddressArgs
  >(VERIFY_EMAIL_ADDRESS_MUTATION)

  useEffect(() => {
    const verifyEmail = async () => {
      if (signedId) {
        try {
          const response = await verifyEmailAddress({
            variables: {
              input: {
                signedId,
              },
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
          console.error(err)
          setError('Email verification failed. Please try again.')
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
