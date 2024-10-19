import { useMutation } from '@apollo/client'
import React, { type FC, useCallback } from 'react'
import { LogoutDocument, LogoutInputSchema } from '../../generated/graphql'
import { ROUTES } from '../../routes'

const useConfirm = (message: string, onConfirm: () => void) =>
  useCallback(() => {
    const result = window.confirm(message)
    if (result) onConfirm()
  }, [message, onConfirm])

export const LogoutButton: FC = () => {
  const [logout] = useMutation(LogoutDocument)
  const validationResult = LogoutInputSchema().safeParse({})
  if (!validationResult.success) {
    console.error(validationResult.error)
    return
  }

  const handleClick = useConfirm('Logout?', async () => {
    try {
      const { data, errors } = await logout({
        variables: {
          input: validationResult.data,
        },
      })

      if (data?.logout?.logout) {
        console.log('successful', data.logout.logout)
        location.href = ROUTES.LOGIN
      } else {
        console.log('failed')
      }
    } catch (e) {
      console.error('error', e)
    }
  })

  return (
    <button type="button" onClick={handleClick}>
      Logout
    </button>
  )
}
