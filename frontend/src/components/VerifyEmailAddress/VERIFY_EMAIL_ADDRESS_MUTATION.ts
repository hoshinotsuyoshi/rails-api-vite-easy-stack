import { gql } from '@apollo/client'

export const VERIFY_EMAIL_ADDRESS_MUTATION = gql`
  mutation VerifyEmailAddress($input: VerifyEmailAddressInput!) {
    verifyEmailAddress(input: $input) {
      user {
        id
        __typename
      }
    }
  }
`
