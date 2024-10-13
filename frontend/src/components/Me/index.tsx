import { useQuery } from '@apollo/client'
import React from 'react'
import { useNavigate } from 'react-router-dom'
import type { User } from '../../generated/graphql'
import { ROUTES } from '../../routes'
import { ME } from './ME_QUERY'

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
