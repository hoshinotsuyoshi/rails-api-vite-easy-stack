import { useEffect, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { useMutation } from '@apollo/client'
import { VERIFY_EMAIL_ADDRESS_MUTATION } from '../graphql/mutations'
import type { MutationVerifyEmailAddressArgs, User } from '../generated/graphql'

const VerifyEmailAddress = () => {
  const location = useLocation()
  const navigate = useNavigate()
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)

  const queryParams = new URLSearchParams(location.search)
  const signedId = queryParams.get('signed_id')

  const [verifyEmailAddress] = useMutation<
    { verifyEmailAddress?: User },
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

          if (response.data?.verifyEmailAddress) {
            setSuccess(true)
            setTimeout(() => {
              navigate('/login')
            }, 2000)
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
        <p>Email verification successful! Redirecting to login...</p>
      ) : (
        !error && <p>Verifying your email...</p>
      )}
    </div>
  )
}

export default VerifyEmailAddress
