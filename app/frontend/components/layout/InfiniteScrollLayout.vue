<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { router } from '@inertiajs/vue3'
import SkeletonSessionCard from '@/components/common/cards/SkeletonSessionCard.vue';

const props = defineProps({
  elements: {
    type: [Array, Object],
    required: true
  },
  pagy: {
    type: Object,
    required: true
  },
  // Optional: filters to preserve during infinite scroll
  filters: {
    type: Object,
    default: () => ({})
  }
})

// State management
const allElements = ref([...props.elements])
const currentPage = ref(props.pagy.page)
const isLoading = ref(false)
const loadTrigger = ref(null)
let observer = null

const hasReachedEnd = computed(() => {
  return currentPage.value >= props.pagy.last && !isLoading.value
})

const canLoadMore = computed(() => {
  return currentPage.value < props.pagy.last && !isLoading.value
})

const loadMore = async () => {
  if (!canLoadMore.value || isLoading.value) return

  isLoading.value = true
  const nextPage = currentPage.value + 1

  try {
    const url = new URL(window.location.href)
    const params = new URLSearchParams(url.search)

    params.set('page', nextPage)

    // Build URL with filters preserved
    // // Preserve any existing filters
    // Object.entries(props.filters).forEach(([key, value]) => {
    //   if (value) {
    //     params.set(key, value)
    //   }
    // })

    // set searchQuery if present

    const newUrl = url.pathname + '?' + params.toString()

    router.visit(newUrl, {
      method: 'get',
      only: ['elements', 'pagy'],
      preserveState: true,
      preserveScroll: true,
      replace: true,
      onSuccess: (page) => {
        const newElements = page.props.elements || []

        allElements.value = newElements

        currentPage.value = page.props.pagy.page
        isLoading.value = false
      },
      onError: () => {
        isLoading.value = false
        console.error('Failed to load more content')
      }
    })
  } catch (error) {
    isLoading.value = false
    console.error('Error loading more content:', error)
  }
}

// Intersection Observer for automatic loading
const setupIntersectionObserver = () => {
  if (!loadTrigger.value) return

  const options = {
    root: null,
    rootMargin: '100px',
    threshold: 0.1
  }

  observer = new IntersectionObserver((entries) => {
    const entry = entries[0]
    if (entry.isIntersecting && canLoadMore.value) {
      loadMore()
    }
  }, options)

  observer.observe(loadTrigger.value)
}

const resetInfiniteScroll = () => {
  allElements.value = [...props.elements]
  currentPage.value = props.pagy.page
  isLoading.value = false
}

watch(() => props.elements, (newElements) => {
  if (props.pagy.page === 1) {
    resetInfiniteScroll()
  }
}, { deep: true })

onMounted(() => {
  setupIntersectionObserver()
})

onUnmounted(() => {
  if (observer) {
    observer.disconnect()
  }
})
</script>

<template>
  <div class="infinite-scroll-container space-y-600">
    <!-- Your existing content -->
    <slot
      name="content"
      :allElements="allElements"
    />
    <!-- DEFAULT -->
    <div
      v-if="isLoading"
    >
      <SkeletonSessionCard />
    </div>

    <div
      v-else-if="hasReachedEnd"
      class="text-center py-8 text-gray-500"
    >
      <!-- TODO: trocar texto -->
      <p>Não há sessões disponíveis.</p>
    </div>

    <div
      ref="loadTrigger"
      class="h-4"
    ></div>
  </div>
</template>

<style scoped>
.infinite-scroll-container {
  position: relative;
}
</style>
