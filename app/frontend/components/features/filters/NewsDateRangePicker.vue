<script setup>
import {
  DateFormatter,
  getLocalTimeZone,
  parseDate,
} from "@internationalized/date"
import { CalendarIcon, ChevronLeft, ChevronRight } from "lucide-vue-next"
import {
  RangeCalendarCell,
  RangeCalendarCellTrigger,
  RangeCalendarGrid,
  RangeCalendarGridBody,
  RangeCalendarGridHead,
  RangeCalendarGridRow,
  RangeCalendarHeadCell,
  RangeCalendarHeader,
  RangeCalendarHeading,
  RangeCalendarNext,
  RangeCalendarPrev,
  RangeCalendarRoot,
} from "reka-ui"
import { computed, nextTick, ref, watch } from "vue"

import { cn } from "@/lib/utils"
import { Button, buttonVariants } from "@/components/ui/button"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
import {
  inputFieldButtonClasses,
  inputFieldPlaceholderTextClasses,
  inputFieldValueTextClasses,
} from "@/components/ui/inputStyles"

const props = defineProps({
  modelValue: { type: Object, default: null },
  placeholder: { type: String, default: "Pick a date" },
  locale: { type: String, default: "en-US" },
  min: { type: String, default: null },
  max: { type: String, default: null },
  defaultMonth: { type: String, default: null },
  label: { type: String, required: true },
  clearLabel: { type: String, default: "Clear" },
})

const emit = defineEmits(["update:modelValue"])

const range = ref({ start: undefined, end: undefined })
const isSyncingFromProps = ref(false)

const df = computed(() => new DateFormatter(props.locale, { dateStyle: "long" }))
const minValue = computed(() => parseOptionalDate(props.min))
const maxValue = computed(() => parseOptionalDate(props.max))
const defaultPlaceholder = computed(() =>
  parseOptionalDate(props.defaultMonth) || range.value.start || minValue.value || undefined
)

const parseOptionalDate = (value) => {
  if (!value) return undefined

  try {
    return parseDate(value)
  } catch {
    return undefined
  }
}

const dateValueToIso = (date) => date?.toString()

const filterParamsFromModelValue = (modelValue) => {
  if (!modelValue) return {}

  if (modelValue.filter_params) {
    return modelValue.filter_params
  }

  if (modelValue.filter_value) {
    return { data_inicio: modelValue.filter_value }
  }

  return {}
}

const filterFromRange = ({ start, end }) => {
  const startValue = dateValueToIso(start)
  const endValue = dateValueToIso(end)

  if (!startValue) return null

  const filterParams = { data_inicio: startValue }
  if (endValue) filterParams.data_fim = endValue

  return {
    filter_display: endValue ? `${startValue} - ${endValue}` : startValue,
    filter_value: endValue ? `${startValue}..${endValue}` : startValue,
    filter_label: props.label,
    filter_params: filterParams,
  }
}

const displayValue = computed(() => {
  const { start, end } = range.value
  if (!start) return props.placeholder

  if (end) {
    return `${df.value.format(start.toDate(getLocalTimeZone()))} - ${df.value.format(end.toDate(getLocalTimeZone()))}`
  }

  return df.value.format(start.toDate(getLocalTimeZone()))
})

const clearRange = () => {
  range.value = { start: undefined, end: undefined }
}

watch(
  () => props.modelValue,
  async (newValue) => {
    const filterParams = filterParamsFromModelValue(newValue)
    isSyncingFromProps.value = true
    range.value = {
      start: parseOptionalDate(filterParams.data_inicio),
      end: parseOptionalDate(filterParams.data_fim),
    }
    await nextTick()
    isSyncingFromProps.value = false
  },
  { immediate: true, deep: true },
)

watch(
  range,
  (newRange) => {
    if (isSyncingFromProps.value) return

    emit("update:modelValue", filterFromRange(newRange))
  },
  { deep: true },
)
</script>

<template>
  <Popover>
    <PopoverTrigger as-child>
      <Button
        variant="outline"
        :class="cn(
          inputFieldButtonClasses,
          'justify-start gap-300 hover:bg-white hover:text-neutrals-900',
          range.start ? inputFieldValueTextClasses : inputFieldPlaceholderTextClasses,
        )"
      >
        <CalendarIcon
          class="h-4 w-4"
          :class="range.start ? 'text-neutrals-700' : 'text-neutrals-400'"
        />
        {{ displayValue }}
      </Button>
    </PopoverTrigger>
    <PopoverContent class="w-auto p-0 border-neutrals-300" align="start">
      <RangeCalendarRoot
        v-slot="{ grid, weekDays }"
        v-model="range"
        :default-placeholder="defaultPlaceholder"
        :min-value="minValue"
        :max-value="maxValue"
        :number-of-months="2"
        initial-focus
        class="p-3"
      >
        <RangeCalendarHeader class="flex justify-center pt-1 relative items-center w-full">
          <RangeCalendarPrev
            :class="cn(
              buttonVariants({ variant: 'outline' }),
              'absolute left-1 size-7 bg-transparent p-0 opacity-50 hover:opacity-100',
            )"
          >
            <ChevronLeft class="size-4" />
          </RangeCalendarPrev>
          <RangeCalendarHeading class="text-sm font-medium" />
          <RangeCalendarNext
            :class="cn(
              buttonVariants({ variant: 'outline' }),
              'absolute right-1 size-7 bg-transparent p-0 opacity-50 hover:opacity-100',
            )"
          >
            <ChevronRight class="size-4" />
          </RangeCalendarNext>
        </RangeCalendarHeader>

        <div class="flex flex-col gap-y-4 mt-4 sm:flex-row sm:gap-x-4 sm:gap-y-0">
          <RangeCalendarGrid
            v-for="month in grid"
            :key="month.value.toString()"
            class="w-full border-collapse space-x-1"
          >
            <RangeCalendarGridHead>
              <RangeCalendarGridRow class="flex">
                <RangeCalendarHeadCell
                  v-for="day in weekDays"
                  :key="day"
                  class="text-muted-foreground rounded-md w-8 font-normal text-[0.8rem]"
                >
                  {{ day }}
                </RangeCalendarHeadCell>
              </RangeCalendarGridRow>
            </RangeCalendarGridHead>
            <RangeCalendarGridBody>
              <RangeCalendarGridRow
                v-for="(weekDates, index) in month.rows"
                :key="`weekDate-${index}`"
                class="mt-2 flex w-full"
              >
                <RangeCalendarCell
                  v-for="weekDate in weekDates"
                  :key="weekDate.toString()"
                  :date="weekDate"
                  class="relative p-0 text-center text-sm focus-within:relative focus-within:z-20 [&:has([data-selected])]:bg-accent"
                >
                  <RangeCalendarCellTrigger
                    :day="weekDate"
                    :month="month.value"
                    :class="cn(
                      buttonVariants({ variant: 'ghost' }),
                      'size-8 p-0 font-normal aria-selected:opacity-100 cursor-default',
                      '[&[data-today]:not([data-selected])]:bg-accent [&[data-today]:not([data-selected])]:text-accent-foreground',
                      'data-[selected]:bg-primary data-[selected]:text-primary-foreground data-[selected]:opacity-100 data-[selected]:hover:bg-primary data-[selected]:hover:text-primary-foreground',
                      'data-[disabled]:text-muted-foreground data-[disabled]:opacity-50',
                      'data-[unavailable]:text-destructive-foreground data-[unavailable]:line-through',
                      'data-[outside-view]:text-muted-foreground',
                    )"
                  />
                </RangeCalendarCell>
              </RangeCalendarGridRow>
            </RangeCalendarGridBody>
          </RangeCalendarGrid>
        </div>
      </RangeCalendarRoot>

      <div class="border-t border-neutrals-300 p-2 text-right">
        <Button
          type="button"
          variant="ghost"
          size="sm"
          @click="clearRange"
        >
          {{ clearLabel }}
        </Button>
      </div>
    </PopoverContent>
  </Popover>
</template>
