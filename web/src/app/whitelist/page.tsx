import WhitelistForm from '../components/WhitelistForm'
import Header from '../components/Header'
import Footer from '../components/Footer'

export default function Whitelist() {
  return (
    <div className="min-h-screen">
      <Header />
      <div className="grid grid-rows-[20px_1fr_20px] items-center justify-items-center min-h-screen p-8 pb-20 gap-16 sm:p-20">
        <main className="flex flex-col gap-8 row-start-2 items-center w-full max-w-md">
          <h1 className="text-3xl font-bold mb-6 text-center">Get Whitelist Access</h1>
          <WhitelistForm />
        </main>
      </div>
      <Footer />
    </div>
  )
}

