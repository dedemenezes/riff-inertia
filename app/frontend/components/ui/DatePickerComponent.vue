<script setup>
import {
  DateFormatter,
  getLocalTimeZone,
  parseDate,
} from "@internationalized/date"
import { CalendarIcon } from "lucide-vue-next"

import { ref, watch } from "vue"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { Calendar } from "@/components/ui/calendar"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"

const props = defineProps({
  modelValue: String, // ISO format date, e.g., "2025-10-09"
  placeholder: { type: String, default: "Pick a date" },
  locale: { type: String, default: "en-US" },
})
const emit = defineEmits(["update:modelValue"])

// Create local DateValue from string
const value = ref(props.modelValue ? parseDate(props.modelValue) : null)

// Sync from external modelValue -> internal DateValue
watch(
  () => props.modelValue,
  (newVal) => {
    value.value = newVal ? parseDate(newVal) : null
  }
)

// Emit ISO string when user picks a date
watch(value, (newVal) => {
  if (newVal) {
    const iso = newVal.toDate(getLocalTimeZone()).toISOString().split("T")[0]
    emit("update:modelValue", iso)
  } else {
    emit("update:modelValue", null)
  }
})

const df = new DateFormatter(props.locale, {
  dateStyle: "long",
})
</script>

<template>
  <Popover>
    <PopoverTrigger as-child>
      <Button
        variant="outline"
        :class="cn(
          'w-full h-[45px] justify-start gap-300 rounded-[5px] border-neutrals-300 bg-white px-300 py-300 font-body text-sm font-normal leading-[150%] shadow-none hover:bg-white hover:text-neutrals-900 focus-visible:border-neutrals-600 focus-visible:ring-0 focus-visible:ring-offset-0',
          value ? 'text-neutrals-900' : 'text-neutrals-400',
        )"
      >
        <CalendarIcon
          class="h-4 w-4"
          :class="value ? 'text-neutrals-700' : 'text-neutrals-400'"
        />
        {{
          value
            ? df.format(value.toDate(getLocalTimeZone()))
            : props.placeholder
        }}
      </Button>
    </PopoverTrigger>
    <PopoverContent class="w-auto p-0 border-neutrals-300">
      <Calendar v-model="value" initial-focus />
    </PopoverContent>
  </Popover>
</template>
