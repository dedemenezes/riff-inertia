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
  // let time = new Date();
  // const [ hour, minute ] = value.split(":")
  // const timeValue = time.setHours(hour, minute, 0, 0);
  emit('update:modelValue', value)
}
</script>

<template>
  <Select :model-value="modelValue" @update:model-value="handleValueChange">
    <SelectTrigger class="w-full">
      <SelectValue placeholder="Select a timezone" />
    </SelectTrigger>
    <SelectContent>
      <SelectGroup>
        <!-- <SelectLabel>North America</SelectLabel> -->
        <SelectItem v-for="sessao in collection" :key="sessao" :value="sessao.value">
          {{ sessao.label }}
        </SelectItem>
        <!-- <SelectItem value="est">
          Eastern Standard Time (EST)
        </SelectItem>
        <SelectItem value="cst">
          Central Standard Time (CST)
        </SelectItem>
        <SelectItem value="mst">
          Mountain Standard Time (MST)
        </SelectItem>
        <SelectItem value="pst">
          Pacific Standard Time (PST)
        </SelectItem>
        <SelectItem value="akst">
          Alaska Standard Time (AKST)
        </SelectItem>
        <SelectItem value="hst">
          Hawaii Standard Time (HST)
        </SelectItem> -->
      </SelectGroup>
      <!-- <SelectGroup>
        <SelectLabel>Europe & Africa</SelectLabel>
        <SelectItem value="gmt">
          Greenwich Mean Time (GMT)
        </SelectItem>
        <SelectItem value="cet">
          Central European Time (CET)
        </SelectItem>
        <SelectItem value="eet">
          Eastern European Time (EET)
        </SelectItem>
        <SelectItem value="west">
          Western European Summer Time (WEST)
        </SelectItem>
        <SelectItem value="cat">
          Central Africa Time (CAT)
        </SelectItem>
        <SelectItem value="eat">
          East Africa Time (EAT)
        </SelectItem>
      </SelectGroup>
      <SelectGroup>
        <SelectLabel>Asia</SelectLabel>
        <SelectItem value="msk">
          Moscow Time (MSK)
        </SelectItem>
        <SelectItem value="ist">
          India Standard Time (IST)
        </SelectItem>
        <SelectItem value="cst_china">
          China Standard Time (CST)
        </SelectItem>
        <SelectItem value="jst">
          Japan Standard Time (JST)
        </SelectItem>
        <SelectItem value="kst">
          Korea Standard Time (KST)
        </SelectItem>
        <SelectItem value="ist_indonesia">
          Indonesia Central Standard Time (WITA)
        </SelectItem>
      </SelectGroup>
      <SelectGroup>
        <SelectLabel>Australia & Pacific</SelectLabel>
        <SelectItem value="awst">
          Australian Western Standard Time (AWST)
        </SelectItem>
        <SelectItem value="acst">
          Australian Central Standard Time (ACST)
        </SelectItem>
        <SelectItem value="aest">
          Australian Eastern Standard Time (AEST)
        </SelectItem>
        <SelectItem value="nzst">
          New Zealand Standard Time (NZST)
        </SelectItem>
        <SelectItem value="fjt">
          Fiji Time (FJT)
        </SelectItem>
      </SelectGroup>
      <SelectGroup>
        <SelectLabel>South America</SelectLabel>
        <SelectItem value="art">
          Argentina Time (ART)
        </SelectItem>
        <SelectItem value="bot">
          Bolivia Time (BOT)
        </SelectItem>
        <SelectItem value="brt">
          Brasilia Time (BRT)
        </SelectItem>
        <SelectItem value="clt">
          Chile Standard Time (CLT)
        </SelectItem>
      </SelectGroup> -->
    </SelectContent>
  </Select>
</template>
