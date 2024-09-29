import { Routes, Route } from 'react-router-dom';
import { css } from '../styled-system/css'
import LoginForm from './components/LoginForm'
import SignupForm from './components/SignupForm'
 
function App() {
  return (
    <>
      <div className={css({ fontSize: "2xl", fontWeight: 'bold' })}>Hello 🐼!</div>

      <Routes>
        <Route path="/login" element={<LoginForm />} />
        <Route path="/signup" element={<SignupForm />} />
      </Routes>
    </>
  )
}
 
export default App
