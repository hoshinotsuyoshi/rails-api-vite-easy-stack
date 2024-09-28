import { css } from '../styled-system/css'
import LoginForm from './components/LoginForm'
 
function App() {
  return (
    <>
      <div className={css({ fontSize: "2xl", fontWeight: 'bold' })}>Hello 🐼!</div>
      <div>
        <LoginForm />
      </div>
    </>
  )
}
 
export default App
