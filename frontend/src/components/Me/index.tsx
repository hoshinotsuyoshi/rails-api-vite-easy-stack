import { useQuery } from '@apollo/client'
import React from 'react'
import { useNavigate } from 'react-router-dom'
import { MeDocument } from '../../generated/graphql'
import { ROUTES } from '../../routes'

export const Me = () => {
  const { data } = useQuery(MeDocument)
  const email = data?.me?.emailAddress
  const navigate = useNavigate()

  if (!email) {
    navigate(ROUTES.LOGIN)
  }

  return (
    <>
      {email && <div>user: {email}</div>}
      <div>hello, It's me!</div>
    </>
  )
}
