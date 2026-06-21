import { nextTick, ref, onMounted, unref, watch } from 'vue';

export function useTabScroll(isActive) {
  const tabRef = ref(null)

  onMounted(() => {
    if (unref(isActive)) {
      scrollToTab()
    }
  })

  watch(
    () => unref(isActive),
    (active) => {
      if (active) {
        scrollToTab()
      }
    },
    { flush: 'post' }
  )

  const scrollToTab = () => {
    setTimeout(() => {
      nextTick(() => {
        const tabElement = tabRef.value?.$el ?? tabRef.value

        if (!(tabElement instanceof Element)) {
          return
        }

        const scrollContainer = tabElement.closest('.overflow-x-auto')

        if (scrollContainer) {
          const containerRect = scrollContainer.getBoundingClientRect()
          const tabRect = tabElement.getBoundingClientRect()

          scrollContainer.scrollLeft = tabElement.offsetLeft - (containerRect.width / 2) + (tabRect.width / 2)
        }
      })
    }, 50)
  }
  return tabRef
}
