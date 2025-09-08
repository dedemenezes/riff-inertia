<script setup>
import { computed } from 'vue';
import { useTabScroll } from './useTabScroll';

const props = defineProps({
  active: { type: Boolean, default: false },
  tabIndex: { type: Number, required: true },
  content: { type: String, default: new Date().toISOString().split('T')[0] }
})

const day = computed(() => props.content.split("-")[2])
const weekDay = computed(() => {
  const dateParts = props.content.split('-').map(Number)
  const date = new Date(dateParts[0], dateParts[1] - 1, dateParts[2])

  const shortName = date.toLocaleString("pt-BR", { weekday: "short" })
  const firstLetter = shortName[0].toUpperCase()
  const restOfWord = shortName.substring(1).toLowerCase()

  return `${firstLetter}${restOfWord}`
})
const month = computed(() => props.content.split("-")[1])
const monthName = computed(() => {
  const shortName = new Date(props.content).toLocaleString("pt-BR", { month: "short" })
  const firstLetter = shortName[0].toUpperCase()
  const restOfWord = shortName.substring(1).toLowerCase()
  return `${firstLetter}${restOfWord}`
})

const tabRef = useTabScroll(props.active); // used to reference "self"
</script>

<template>
  <div ref="tabRef" :class="props.active ? 'bg-gradient-to-r from-magenta-600 to-laranja-600 pb-[2px]' : 'bg-neutrals-200 pb-[1px]'" class="p-0 pb-[2px]">
    <div class="flex items-center justify-center bg-white back px-[33.3px] pt-[6px]">
      <div
        class="tab-content"
        role="tab"
        :aria-selected="props.active"
        :id="`tab-${month}-${day}`"
      >
        <time :datetime="props.content">
          <div class="text-body-strong-sm flex items-center" :class="props.active ? 'text-neutrals-900' : 'text-neutrals-700'">
            <span class="day me-100">{{ weekDay }}</span> <span>{{ day }}</span> <span class="month ms-100">{{ monthName }}</span>
          </div>
        </time>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
