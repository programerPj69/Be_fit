<template>
  <div class="min-h-screen bg-gray-100 flex items-center justify-center">
    <div class="max-w-md w-full bg-white rounded-lg shadow-md p-8">
      <h2 class="text-2xl font-bold text-center mb-6">Create an Account</h2>
      <form @submit.prevent="handleSignup" class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700">Email</label>
          <input
            v-model="email"
            type="email"
            required
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Password</label>
          <input
            v-model="password"
            type="password"
            required
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          />
        </div>
        <button
          type="submit"
          class="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
        >
          Sign Up
        </button>
      </form>
      <p class="mt-4 text-center text-sm text-gray-600">
        Already have an account?
        <NuxtLink to="/login" class="text-indigo-600 hover:text-indigo-500">
          Login
        </NuxtLink>
      </p>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()

const email = ref('')
const password = ref('')

const handleSignup = async () => {
  try {
    const { error } = await client.auth.signUp({
      email: email.value,
      password: password.value,
    })
    if (error) throw error
    navigateTo('/dashboard')
  } catch (error) {
    console.error('Error:', error.message)
  }
}

// Redirect if already logged in
watchEffect(() => {
  if (user.value) {
    navigateTo('/dashboard')
  }
})
</script>