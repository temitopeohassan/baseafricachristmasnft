/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'puredelightfoods.com',
      },
    ],
  },
}

module.exports = nextConfig 