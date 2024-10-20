import React from 'react'
import { Route, Routes } from 'react-router-dom'
import { css } from '../styled-system/css'
import { Login } from './components/Login'
import { Me } from './components/Me'
import { SetPassword } from './components/SetPassword'
import { Signup } from './components/Signup'
import { VerifyEmailAddress } from './components/VerifyEmailAddress'
import { ROUTES } from './routes'

function App() {
  return (
    <>
      <div className={css({ fontSize: '2xl', fontWeight: 'bold' })}>
        Hello 🐼!
      </div>

      <Routes>
        <Route path={ROUTES.LOGIN} element={<Login />} />
        <Route path={ROUTES.ME} element={<Me />} />
        <Route path={ROUTES.SET_PASSWORD} element={<SetPassword />} />
        <Route path={ROUTES.SIGNUP} element={<Signup />} />
        <Route path={ROUTES.VERIFY_EMAIL} element={<VerifyEmailAddress />} />
      </Routes>
    </>
  )
}

export default App
