import { useQuery } from '@apollo/client'
import React from 'react'
import type { User } from '../generated/graphql'
import { ME } from '../graphql/queries'

export const Me = () => {
  const me = useQuery<{ me?: User }>(ME)
  const email = me.data?.me?.emailAddress
  return (
    <>
      {email && <div>user: {email}</div>}
      <div>hello, It's me!</div>
    </>
  )
}
