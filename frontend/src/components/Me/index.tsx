import React, { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useMeQuery } from '../../generated/graphql'
import { ROUTES } from '../../routes'
import { LogoutButton } from './LogoutButton'

export const Me = () => {
  const { data, loading } = useMeQuery()
  const email = data?.me?.emailAddress
  const navigate = useNavigate()

  useEffect(() => {
    if (!email && !loading) {
      navigate(ROUTES.LOGIN)
    }
  }, [email, loading, navigate])

  return (
    <>
      {loading && <div>Loading...</div>}
      {email && <div>user: {email}</div>}
      {email && <div>hello, It's me!</div>}
      <div>
        <LogoutButton />
      </div>
    </>
  )
}
