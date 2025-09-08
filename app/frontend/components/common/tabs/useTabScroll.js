import { nextTick, ref, onMounted } from 'vue';
import { router } from '@inertiajs/vue3';

export function useTabScroll(isActive) {
  const tabRef = ref(null)

  onMounted(() => {
    if (isActive) {
      scrollToTab()
    }
  })

  router.on('success', () => {
    if (isActive) {
      scrollToTab()
    }
  })

  const scrollToTab = () => {
    setTimeout(() => {
      if (tabRef.value) {
        nextTick(() => {
          if (tabRef.value) {
            const scrollContainer = tabRef.value.closest('.overflow-x-auto')

            if (scrollContainer) {
              const containerRect = scrollContainer.getBoundingClientRect()
              const tabRect = tabRef.value.getBoundingClientRect()

              scrollContainer.scrollLeft = tabRef.value.offsetLeft - (containerRect.width / 2) + (tabRect.width / 2)
            }
          }
        })
      }
    }, 50)
  }
  return tabRef
}
