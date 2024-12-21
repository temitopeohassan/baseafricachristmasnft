import ConnectButton from './ConnectButton'

import Link from 'next/link'

export default function Header() {
  return (
    <header className="border-b">
    <div className="container mx-auto px-4">
      <div className="flex h-16 items-center justify-between">
        <div className="flex items-center gap-8">

       
        </div>

        <div className="flex items-center gap-4">
          <ConnectButton />            
        </div>
      </div>
    </div>
  </header>
  )
}
