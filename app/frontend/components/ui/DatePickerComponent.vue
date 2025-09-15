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

// For display in the button
const df = new DateFormatter("en-US", {
  dateStyle: "long",
})
</script>

<template>
  <Popover>
    <PopoverTrigger as-child>
      <Button
        variant="outline"
        :class="cn(
          'w-full justify-start text-left font-normal',
          !value && 'text-muted-foreground',
        )"
      >
        <CalendarIcon class="mr-2 h-4 w-4" />
        {{
          value
            ? df.format(value.toDate(getLocalTimeZone()))
            : "Pick a date"
        }}
      </Button>
    </PopoverTrigger>
    <PopoverContent class="w-auto p-0">
      <Calendar v-model="value" initial-focus />
    </PopoverContent>
  </Popover>
</template>
