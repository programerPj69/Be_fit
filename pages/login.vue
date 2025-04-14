<template>
  <div class="min-h-screen bg-gray-100 flex items-center justify-center">
    <div class="max-w-md w-full bg-white rounded-lg shadow-md p-8">
      <h2 class="text-2xl font-bold text-center mb-6">Login to Your Account</h2>
      
      <!-- Error Alert -->
      <div v-if="errorMessage" class="mb-4 p-4 text-sm rounded-lg" :class="errorType === 'auth' ? 'bg-red-100 text-red-700' : 'bg-yellow-100 text-yellow-700'">
        {{ errorMessage }}
      </div>

      <form @submit.prevent="handleLogin">
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700">Email</label>
          <input
            v-model="email"
            type="email"
            required
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          />
        </div>
        <div class="mb-6">
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
          :disabled="isLoading"
          class="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {{ isLoading ? 'Logging in...' : 'Login' }}
        </button>
      </form>
      <p class="mt-4 text-center text-sm text-gray-600">
        Don't have an account?
        <NuxtLink to="/signup" class="text-indigo-600 hover:text-indigo-500">
          Sign up
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
const errorMessage = ref('')
const errorType = ref('')
const isLoading = ref(false)

const handleLogin = async () => {
  try {
    errorMessage.value = '' // Clear any previous errors
    errorType.value = ''
    isLoading.value = true

    const { error } = await client.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    })

    if (error) {
      errorType.value = 'auth'
      switch (error.message) {
        case 'Invalid login credentials':
          errorMessage.value = 'The email or password you entered is incorrect. Please try again.'
          break
        case 'Email not confirmed':
          errorMessage.value = 'Please verify your email address before logging in.'
          break
        default:
          errorMessage.value = 'An error occurred during login. Please try again.'
      }
      throw error
    }

    // If successful, navigate to dashboard
    navigateTo('/dashboard')
  } catch (error) {
    console.error('Login error:', error.message)
    
    if (!errorMessage.value) {
      errorType.value = 'network'
      errorMessage.value = 'Unable to connect to the authentication service. Please check your internet connection and try again.'
    }
  } finally {
    isLoading.value = false
  }
}

// Redirect if already logged in
watchEffect(() => {
  if (user.value) {
    navigateTo('/dashboard')
  }
})
</script>