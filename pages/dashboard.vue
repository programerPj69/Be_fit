<template>
  <div class="min-h-screen bg-gray-100">
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center">
            <h1 class="text-xl font-bold">Fitness Tracker</h1>
          </div>
          <div class="flex items-center">
            <button
              @click="handleLogout"
              class="ml-4 px-4 py-2 text-sm text-red-600 hover:text-red-700"
            >
              Logout
            </button>
          </div>
        </div>
      </div>
    </nav>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <div class="px-4 py-6 sm:px-0">
        <div class="flex justify-between items-center mb-6">
          <h2 class="text-2xl font-bold">Your Workouts</h2>
          <button
            @click="showNewWorkoutModal = true"
            class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
          >
            Add Workout
          </button>
        </div>

        <!-- Workouts List -->
        <div class="bg-white shadow rounded-lg divide-y divide-gray-200">
          <div v-for="workout in workouts" :key="workout.id" class="p-6">
            <div class="flex justify-between items-start">
              <div>
                <h3 class="text-lg font-medium">{{ workout.name }}</h3>
                <p class="text-sm text-gray-500">{{ formatDate(workout.date) }}</p>
              </div>
              <button
                @click="deleteWorkout(workout.id)"
                class="text-red-600 hover:text-red-700"
              >
                Delete
              </button>
            </div>
            <div class="mt-4">
              <h4 class="font-medium mb-2">Exercises:</h4>
              <ul class="space-y-2">
                <li v-for="exercise in workout.exercises" :key="exercise.id" class="text-sm">
                  {{ exercise.name }} - {{ exercise.sets }}x{{ exercise.reps }} @ {{ exercise.weight }}kg
                </li>
              </ul>
            </div>
            <p v-if="workout.notes" class="mt-4 text-sm text-gray-600">
              {{ workout.notes }}
            </p>
          </div>
        </div>

        <!-- New Workout Modal -->
        <div v-if="showNewWorkoutModal" class="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center">
          <div class="bg-white rounded-lg p-6 max-w-md w-full">
            <h3 class="text-lg font-medium mb-4">Add New Workout</h3>
            <form @submit.prevent="createWorkout" class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700">Workout Name</label>
                <input
                  v-model="newWorkout.name"
                  type="text"
                  required
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700">Date</label>
                <input
                  v-model="newWorkout.date"
                  type="date"
                  required
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700">Notes</label>
                <textarea
                  v-model="newWorkout.notes"
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                ></textarea>
              </div>
              
              <!-- Exercises -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Exercises</label>
                <div v-for="(exercise, index) in newWorkout.exercises" :key="index" class="space-y-2">
                  <div class="flex gap-2">
                    <input
                      v-model="exercise.name"
                      placeholder="Exercise name"
                      class="flex-1 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    <input
                      v-model.number="exercise.sets"
                      type="number"
                      placeholder="Sets"
                      class="w-20 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    <input
                      v-model.number="exercise.reps"
                      type="number"
                      placeholder="Reps"
                      class="w-20 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    <input
                      v-model.number="exercise.weight"
                      type="number"
                      step="0.5"
                      placeholder="Weight"
                      class="w-24 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    <button
                      type="button"
                      @click="removeExercise(index)"
                      class="text-red-600 hover:text-red-700"
                    >
                      Remove
                    </button>
                  </div>
                </div>
                <button
                  type="button"
                  @click="addExercise"
                  class="mt-2 text-sm text-indigo-600 hover:text-indigo-500"
                >
                  Add Exercise
                </button>
              </div>

              <div class="flex justify-end gap-2">
                <button
                  type="button"
                  @click="showNewWorkoutModal = false"
                  class="px-4 py-2 text-sm text-gray-700 hover:text-gray-800"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  class="px-4 py-2 text-sm bg-indigo-600 text-white rounded-md hover:bg-indigo-700"
                >
                  Save Workout
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()

// Redirect if not logged in
watchEffect(() => {
  if (!user.value) {
    navigateTo('/login')
  }
})

const workouts = ref([])
const showNewWorkoutModal = ref(false)
const newWorkout = ref({
  name: '',
  date: new Date().toISOString().split('T')[0],
  notes: '',
  exercises: []
})

// Format date for display
const formatDate = (date) => {
  return new Date(date).toLocaleDateString()
}

// Add new exercise to form
const addExercise = () => {
  newWorkout.value.exercises.push({
    name: '',
    sets: 3,
    reps: 10,
    weight: 0
  })
}

// Remove exercise from form
const removeExercise = (index) => {
  newWorkout.value.exercises.splice(index, 1)
}

// Create new workout
const createWorkout = async () => {
  try {
    // Insert workout
    const { data: workout, error: workoutError } = await client
      .from('workouts')
      .insert({
        name: newWorkout.value.name,
        date: newWorkout.value.date,
        notes: newWorkout.value.notes,
        user_id: user.value.id
      })
      .select()
      .single()

    if (workoutError) throw workoutError

    // Insert exercises
    if (newWorkout.value.exercises.length > 0) {
      const { error: exercisesError } = await client
        .from('exercises')
        .insert(
          newWorkout.value.exercises.map(exercise => ({
            ...exercise,
            workout_id: workout.id
          }))
        )

      if (exercisesError) throw exercisesError
    }

    // Reset form and close modal
    newWorkout.value = {
      name: '',
      date: new Date().toISOString().split('T')[0],
      notes: '',
      exercises: []
    }
    showNewWorkoutModal.value = false

    // Refresh workouts list
    await fetchWorkouts()
  } catch (error) {
    console.error('Error creating workout:', error)
  }
}

// Delete workout
const deleteWorkout = async (workoutId) => {
  try {
    const { error } = await client
      .from('workouts')
      .delete()
      .eq('id', workoutId)

    if (error) throw error

    // Refresh workouts list
    await fetchWorkouts()
  } catch (error) {
    console.error('Error deleting workout:', error)
  }
}

// Fetch workouts with exercises
const fetchWorkouts = async () => {
  try {
    const { data: workoutsData, error: workoutsError } = await client
      .from('workouts')
      .select('*')
      .order('date', { ascending: false })

    if (workoutsError) throw workoutsError

    // Fetch exercises for each workout
    const workoutsWithExercises = await Promise.all(
      workoutsData.map(async (workout) => {
        const { data: exercises, error: exercisesError } = await client
          .from('exercises')
          .select('*')
          .eq('workout_id', workout.id)

        if (exercisesError) throw exercisesError

        return {
          ...workout,
          exercises
        }
      })
    )

    workouts.value = workoutsWithExercises
  } catch (error) {
    console.error('Error fetching workouts:', error)
  }
}

// Fetch workouts on mount
onMounted(() => {
  fetchWorkouts()
})

const handleLogout = async () => {
  try {
    const { error } = await client.auth.signOut()
    if (error) throw error
    navigateTo('/login')
  } catch (error) {
    console.error('Error:', error.message)
  }
}
</script>