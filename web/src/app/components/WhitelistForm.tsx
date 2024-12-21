'use client'

import { Button, Text, Flex, Card } from '@radix-ui/themes'
import { useAccount, useWriteContract, useWaitForTransactionReceipt, useReadContract } from 'wagmi'
import { useState } from 'react'

const WHITELIST_ADDRESS = '0x589AB24Cd45cBE5F6Eb4ff93bD87f1c9Fbb0dE27'
const WHITELIST_ABI = [
  {
    name: 'addAddressToWhitelist',
    type: 'function',
    stateMutability: 'nonpayable',
    inputs: [],
    outputs: [],
  },
  {
    name: 'whitelistedAddresses',
    type: 'function',
    stateMutability: 'view',
    inputs: [{ name: '', type: 'address' }],
    outputs: [{ name: '', type: 'bool' }],
  }
] as const

export default function WhitelistForm() {
  const { address } = useAccount()
  const [error, setError] = useState<string>('')

  const { writeContract, data: hash } = useWriteContract()

  const { data: isWhitelisted } = useReadContract({
    address: WHITELIST_ADDRESS,
    abi: WHITELIST_ABI,
    functionName: 'whitelistedAddresses',
    args: address ? [address] : undefined,
  })

  const { isLoading, isSuccess } = useWaitForTransactionReceipt({
    hash,
  })

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setError('')

    if (!address) {
      setError('Please connect your wallet first')
      return
    }

    if (isWhitelisted) {
      setError('Address is already whitelisted')
      return
    }

    try {
      writeContract({
        address: WHITELIST_ADDRESS,
        abi: WHITELIST_ABI,
        functionName: 'addAddressToWhitelist',
      })
    } catch (err) {
      setError('Failed to add address to whitelist')
      console.error(err)
    }
  }

  return (
    <Card size="2">
      <form onSubmit={handleSubmit}>
        <Flex direction="column" gap="3">
          <Text size="2">
            {isWhitelisted 
              ? 'Your wallet is already whitelisted!'
              : 'Click below to add your connected wallet to the whitelist'
            }
          </Text>
          {error && (
            <Text size="2" color="red">
              {error}
            </Text>
          )}
          {isSuccess && (
            <Text size="2" color="green">
              Successfully added to whitelist!
            </Text>
          )}
          <Button 
            type="submit" 
            size="3" 
            disabled={!address || isLoading || isWhitelisted}
            color={isWhitelisted ? "green" : undefined}
          >
            {isLoading 
              ? 'Adding...' 
              : isWhitelisted 
                ? '✓ Wallet Whitelisted' 
                : 'Add to Whitelist'
            }
          </Button>
        </Flex>
      </form>
    </Card>
  )
}

