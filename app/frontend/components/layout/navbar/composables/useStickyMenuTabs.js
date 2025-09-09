import { ref, onMounted, onUnmounted } from "vue"

export function useStickyMenuTabs() {
  const sentinel = ref(null)
  const isSticky = ref(false)

  let observer = null

  onMounted(() => {
    if (!sentinel.value) return

    observer = new IntersectionObserver(
      ([entry]) => {
        isSticky.value = !entry.isIntersecting
      },
      { threshold: 0 }
    )

    observer.observe(sentinel.value)
  })

  onUnmounted(() => {
    if (observer && sentinel.value) {
      observer.unobserve(sentinel.value)
      observer.disconnect()
    }
  })

  return { sentinel, isSticky }
}
