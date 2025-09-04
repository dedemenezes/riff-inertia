<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { router } from '@inertiajs/vue3'
import IndexArticleCard from '@/components/common/cards/IndexArticleCard.vue';

const props = defineProps({
  items: {
    type: Array,
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
const allItems = ref([...props.items])
const currentPage = ref(props.pagy.page)
const isLoading = ref(false)
const loadTrigger = ref(null)
let observer = null

// Computed properties
const hasReachedEnd = computed(() => {
  console.log(currentPage.value);

  console.log(props.pagy.last);
  return currentPage.value >= props.pagy.last && !isLoading.value
})

const canLoadMore = computed(() => {
  return currentPage.value < props.pagy.last && !isLoading.value
})

// Load more function
const loadMore = async () => {
  if (!canLoadMore.value || isLoading.value) return

  isLoading.value = true
  const nextPage = currentPage.value + 1

  try {
    // Build URL with filters preserved
    const url = new URL(window.location.href)
    const params = new URLSearchParams(url.search)

    params.set('page', nextPage)

    // // Preserve any existing filters
    // Object.entries(props.filters).forEach(([key, value]) => {
    //   if (value) {
    //     params.set(key, value)
    //   }
    // })

    // set searchQuery if present

    const newUrl = url.pathname + '?' + params.toString()

    // Use Inertia to fetch only the data we need
    router.visit(newUrl, {
      method: 'get',
      only: ['items', 'pagy'], // Only refresh these props
      preserveState: true,
      preserveScroll: true,
      replace: true, // Don't add to browser history
      onSuccess: (page) => {
        // Append new items to existing ones
        const newItems = page.props.items || []
        // console.log(newItems);

        allItems.value.push(...newItems)
        // Update pagination info
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
    rootMargin: '100px', // Start loading when trigger is 100px from viewport
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

// Reset function for when filters change
const resetInfiniteScroll = () => {
  allItems.value = [...props.items]
  currentPage.value = props.pagy.page
  isLoading.value = false
}

// Watchers
watch(() => props.items, (newItems) => {
  // If we're on page 1, it means filters changed or initial load
  if (props.pagy.page === 1) {
    resetInfiniteScroll()
  }
}, { deep: true })

// watch(() => props.filters, () => {
//   // Reset when filters change
//   resetInfiniteScroll()
// }, { deep: true })

// Lifecycle
onMounted(() => {
  setupIntersectionObserver()
})

onUnmounted(() => {
  if (observer) {
    observer.disconnect()
  }
})

// Expose methods for parent component if needed
// defineExpose({
//   loadMore,
//   resetInfiniteScroll
// })
</script>

<template>
  <div class="infinite-scroll-container">
    <!-- Your existing content -->
      <div class="flex flex-col gap-800">
        {{ console.log("PagyPagination.vue") }}
        {{ console.log(props.items) }}
        <IndexArticleCard
          v-for="article in allItems"
          :key="article.id"
          :title="article.titulo"
          :permalink="article.permalink"
          :chamada="article.chamada"
          :imagem="article.imagem"
          :category="article.caderno_nome"
          :date="article.display_date"
        />
      </div>
    <!-- Loading indicator -->
    <div
      v-if="isLoading"
      class="flex justify-center items-center py-8"
    >
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
      <span class="ml-3 text-gray-600">Carregando mais notícias...</span>
    </div>

    <!-- End of content message -->
    <div
      v-else-if="hasReachedEnd"
      class="text-center py-8 text-gray-500"
    >
      <p>Você viu todas as notícias disponíveis.</p>
    </div>

    <!-- Invisible trigger element for intersection observer -->
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
