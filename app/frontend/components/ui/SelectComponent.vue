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
      <SelectValue :placeholder="simpleTranslation('Selecione um horário', 'Choose starting time')" />
    </SelectTrigger>
    <SelectContent>
      <SelectGroup>
        <!-- <SelectLabel>North America</SelectLabel> -->
        <SelectItem v-for="sessao in collection" :key="sessao" :value="sessao.value">
          {{ sessao.label }}
        </SelectItem>
      </SelectGroup>
    </SelectContent>
  </Select>
</template>
