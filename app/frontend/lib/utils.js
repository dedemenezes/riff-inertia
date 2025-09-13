import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";
import { ref, computed, onMounted, onUnmounted } from "vue";

export function cn(...inputs) {
  return twMerge(clsx(inputs));
}

export function cleanObject(obj) {
  return Object.fromEntries(
    Object.entries(obj).filter(
      ([, v]) => v !== "" && v !== null && v !== undefined,
    ),
  );
}

export function toHHMM(timeStr) {
  const [hh = "00", mm = "00"] = timeStr.split(":");
  return `${hh}:${mm}`;
}

export function slugify(str) {
  return str
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
}

export function useUpdateWindowWidth() {
  const width = ref(typeof window !== 'undefined' ? window.innerWidth : 0)
  const updateWidth = () => width.value = window.innerWidth

  const isDesktop = computed(() => width.value >= 740)

  onMounted(() => window.addEventListener('resize', updateWidth))
  onUnmounted(() => window.removeEventListener('resize', updateWidth))

  return isDesktop
}
