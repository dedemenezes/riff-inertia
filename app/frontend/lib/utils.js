import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";
import { ref, computed, onMounted, onUnmounted } from "vue";
import { usePage } from "@inertiajs/vue3";

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

  const isDesktop = computed(() => width.value >= 1024)

  onMounted(() => window.addEventListener('resize', updateWidth))
  onUnmounted(() => window.removeEventListener('resize', updateWidth))

  return isDesktop
}

export function displayFormattedTime(time) {
    const page = usePage();

    const locale = page.props.currentLocale  // or inject it however you're doing it

    // Convert "14h30" → "14:30"
    const timeStr = time.replace('h', ':');

    // Create a Date object with today's date and the session time
    const [hours, minutes] = timeStr.split(':').map(Number);
    const date = new Date();
    date.setHours(hours, minutes, 0, 0);

    // Format the time
    const formattedTime = new Intl.DateTimeFormat(locale, {
      hour: 'numeric',
      minute: 'numeric',
    }).format(date);

    return formattedTime
}

export function simpleTranslation(ptMessage, enMessage) {
  const page = usePage();
  const locale = page.props.currentLocale
  return locale == "pt" ? ptMessage : enMessage
}
