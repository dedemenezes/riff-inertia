<script setup>
// TODO: DESelected element if clicking same value
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { simpleTranslation } from "@/lib/utils"

// Define props and emits for v-model
const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  collection: {
    type: Array,
    default: [
      {label: "03:30", value: "03:30"},
      {label: "22:00", value: "22:00"}
    ]
  },
  placeholder: {
    type: String,
    default: () => simpleTranslation('Selecione um horário', 'Choose starting time')
  }
})

const emit = defineEmits(['update:modelValue'])

const handleValueChange = (value) => {
  emit('update:modelValue', value)
}
</script>

<template>
  <Select :model-value="modelValue" @update:model-value="handleValueChange">
    <SelectTrigger class="w-full">
      <SelectValue :placeholder="props.placeholder" />
    </SelectTrigger>
    <SelectContent class="border-neutrals-300 shadow-md outline-none ring-0 focus:outline-none focus-visible:ring-0">
      <SelectGroup>
        <!-- <SelectLabel>North America</SelectLabel> -->
        <SelectItem
          v-for="sessao in collection"
          :key="sessao.value"
          :value="sessao.value"
          class="rounded-100 px-300 py-300 font-body text-md text-neutrals-900 focus:bg-neutrals-100 focus:text-neutrals-900"
        >
          {{ sessao.label }}
        </SelectItem>
      </SelectGroup>
    </SelectContent>
  </Select>
</template>
