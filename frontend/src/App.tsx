import React from 'react'
import { Route, Routes } from 'react-router-dom'
import { css } from '../styled-system/css'
import LoginForm from './components/LoginForm'
import SignupForm from './components/SignupForm'
import VerifyEmailAddress from './components/VerifyEmailAddress'

function App() {
  return (
    <>
      <div className={css({ fontSize: '2xl', fontWeight: 'bold' })}>
        Hello 🐼!
      </div>

      <Routes>
        <Route path="/login" element={<LoginForm />} />
        <Route path="/signup" element={<SignupForm />} />
        <Route
          path="/onboarding/verify_email_address"
          element={<VerifyEmailAddress />}
        />
      </Routes>
    </>
  )
}

export default App
