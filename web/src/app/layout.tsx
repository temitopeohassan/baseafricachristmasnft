'use client'

import { Inter } from 'next/font/google'
import '@rainbow-me/rainbowkit/styles.css'
import { getDefaultWallets, RainbowKitProvider } from '@rainbow-me/rainbowkit'
import { createConfig, WagmiProvider, http } from 'wagmi'
import { baseSepolia } from 'wagmi/chains'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { Theme } from '@radix-ui/themes'
import '@radix-ui/themes/styles.css'

const inter = Inter({ subsets: ['latin'] })

const projectId = 'YOUR_WALLETCONNECT_PROJECT_ID' // Get this from WalletConnect

const { connectors } = getDefaultWallets({
  appName: 'Base Africa Christmas NFT',
  projectId,
})

const config = createConfig({
  chains: [baseSepolia],
  transports: {
    [baseSepolia.id]: http(),
  },
  connectors,
})

const queryClient = new QueryClient()

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <WagmiProvider config={config}>
          <QueryClientProvider client={queryClient}>
            <RainbowKitProvider>
              <Theme>
                {children}
              </Theme>
            </RainbowKitProvider>
          </QueryClientProvider>
        </WagmiProvider>
      </body>
    </html>
  )
}
