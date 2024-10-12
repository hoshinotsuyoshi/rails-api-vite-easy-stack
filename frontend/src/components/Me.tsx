import { useQuery } from '@apollo/client'
import React from 'react'
import { useNavigate } from 'react-router-dom'
import type { User } from '../generated/graphql'
import { ME } from '../graphql/queries'
import { ROUTES } from '../routes'

export const Me = () => {
  const me = useQuery<{ me?: User }>(ME)
  const email = me.data?.me?.emailAddress
  const navigate = useNavigate()
  email || navigate(ROUTES.LOGIN)
  return (
    <>
      {email && <div>user: {email}</div>}
      <div>hello, It's me!</div>
    </>
  )
}
