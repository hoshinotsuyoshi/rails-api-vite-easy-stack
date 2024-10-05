import { gql } from '@apollo/client'

export const LOGIN_MUTATION = gql`
  mutation Login($input: LoginInput!) {
    login(input: $input) {
      id
      emailAddress
    }
  }
`
export const SIGNUP_MUTATION = gql`
  mutation Signup($input: SignupInput!) {
    signup(input: $input) {
      user {
        __typename
      }
      errors {
        __typename
      }
    }
  }
`

export const VERIFY_EMAIL_ADDRESS_MUTATION = gql`
  mutation VerifyEmailAddress($input: VerifyEmailAddressInput!) {
    verifyEmailAddress(input: $input) {
      id
      emailAddress
    }
  }
`
