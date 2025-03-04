import { useRouter } from 'next/router'
import { useState } from 'react'

import { createClient } from '@/utils/supabase/component'

export default function Login(){
    const router = useRouter()
    const supabase = createClient()
  
    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')
  
    async function logIn() {
      const { error } = await supabase.auth.signInWithPassword({ email, password })
      if (error) {
        console.error(error)
      }
      router.push('/')
    }
  
    async function signUp() {
      const { error } = await supabase.auth.signUp({ email, password })
      if (error) {
        console.error(error)
      }
      router.push('/')
    }

    return (
       <main >
        <form className="login-app">
            <label className="commonLabel">Please enter your email.</label><br/>
            <input className="commonForm" id="email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} /><br/>
            <label className="commonLabel">Please enter your password.</label><br/>
            <input className="commonForm" id="password" type="password" value={password} onChange={(e) => setPassword(e.target.value)}/><br/>
            <button type="button" className="bg-amber-200 hover:bg-amber-400 transition-all ease-in-out"onClick={logIn}><br/>
          Log in
        </button>
        <button type="button" className="bg-amber-200 hover:bg-amber-400 transition-all ease-in-out" onClick={signUp}>
          Sign up
        </button>
        </form>
       </main>
    )
}

