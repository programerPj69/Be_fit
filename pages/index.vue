<template>
  <div class="min-h-screen bg-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="text-center">
        <h1 class="text-4xl font-bold text-gray-900 mb-4">
          Track Your Fitness Journey
        </h1>
        <p class="text-lg text-gray-600 mb-8">
          Log your workouts, track your progress, and achieve your fitness goals.
        </p>
        <div class="space-x-4">
          <NuxtLink
            to="/login"
            class="inline-block bg-indigo-600 text-white px-6 py-3 rounded-md hover:bg-indigo-700"
          >
            Login
          </NuxtLink>
          <NuxtLink
            to="/signup"
            class="inline-block bg-white text-indigo-600 px-6 py-3 rounded-md border border-indigo-600 hover:bg-indigo-50"
          >
            Sign Up
          </NuxtLink>
        </div>
      </div>

      <div class="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8">
        <div class="bg-white p-6 rounded-lg shadow-md">
          <h2 class="text-xl font-semibold mb-4">Track Workouts</h2>
          <p class="text-gray-600">
            Log your exercises, sets, reps, and weights to keep a detailed record of your training.
          </p>
        </div>
        <div class="bg-white p-6 rounded-lg shadow-md">
          <h2 class="text-xl font-semibold mb-4">Monitor Progress</h2>
          <p class="text-gray-600">
            See your improvement over time with detailed workout history and progress tracking.
          </p>
        </div>
        <div class="bg-white p-6 rounded-lg shadow-md">
          <h2 class="text-xl font-semibold mb-4">Stay Motivated</h2>
          <p class="text-gray-600">
            Keep yourself accountable and motivated by maintaining a consistent workout log.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>