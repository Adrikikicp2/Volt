import type { AppProps } from 'next/app'
import './login.css'

 
export default function App({ Component, pageProps }: AppProps) {
  return <Component {...pageProps} />
}