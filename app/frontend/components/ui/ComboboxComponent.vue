<script setup>
import { Check, ChevronsUpDown } from "lucide-vue-next";
import { watch, ref } from "vue";
import { Button } from "@/components/ui/button";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from "@/components/ui/command";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { cn } from "@/lib/utils";

// const frameworks = [
//   { value: 'next.js', label: 'Next.js' },
//   { value: 'sveltekit', label: 'SvelteKit' },
//   { value: 'nuxt', label: 'Nuxt' },
//   { value: 'remix', label: 'Remix' },
//   { value: 'astro', label: 'Astro' },
// ]

const open = ref(false);

// Props definition for v-model support
const props = defineProps({
  collection: { type: Array, required: true },
  modelValue: { type: [String, Number], default: "" }, // v-model prop
  placeholder: { type: String, default: "placeholder.select" },
  withIcon: { type: Boolean, default: false },
  emptyMessage: {type: String, default: "Nenhum Encontrado"}
});

// Emit definition for v-model support
const emit = defineEmits(["update:modelValue"]);

// Internal value that syncs with modelValue
const value = ref(props.modelValue);

// Watch external changes and update internal state
watch(
  () => props.modelValue,
  (newValue) => {
    value.value = newValue;
  },
);

// Watch internal changes and notify parent
watch(value, (newValue) => {
  emit("update:modelValue", newValue);
});

const handleSelect = (selectedValue) => {
  value.value = selectedValue; // Update internal value
  open.value = false; // Close dropdown
  // The watch will automatically emit the change to parent
};

const iconColor = (value) =>
  props.collection.find((item) => item.value === value)?.iconColor;
</script>

<template>
  <Popover v-model:open="open">
    <PopoverTrigger class="border-neutrals-300" as-child>
      <Button
        variant="outline"
        role="combobox"
        :aria-expanded="open"
        class="w-[-webkit-fill-available] justify-between m-100"
      >
        <div
          class="flex gap-300 items-center"
          :class="value ? 'text-primary' : 'text-secondary-gray'"
        >
          <span
            v-if="withIcon && value"
            :class="iconColor(value)"
            style="width: 8px; height: 8px; border-radius: 50%"
          ></span>
          {{
            value
              ? props.collection.find((item) => item.value === value)?.label
              : props.placeholder
          }}
        </div>
        <ChevronsUpDown class="ml-2 h-4 w-4 shrink-0 opacity-50" />
      </Button>
    </PopoverTrigger>
    <PopoverContent class="min-w-[var(--reka-popper-anchor-width)] p-0 border-neutrals-300">
      <Command v-model="value">
        <CommandInput placeholder="Search..." class="border-neutrals-300" />
        <CommandEmpty>{{ props.emptyMessage }}</CommandEmpty>
        <CommandList>
          <CommandGroup>
            <CommandItem
              v-for="item in collection"
              :key="item.value"
              :value="item.value"
              @select="handleSelect(item.value)"
            >
              <Check
                :class="
                  cn(
                    'mr-2 h-4 w-4',
                    value === item.value ? 'opacity-100' : 'opacity-0',
                  )
                "
              />
              {{ item.label }}
            </CommandItem>
          </CommandGroup>
        </CommandList>
      </Command>
    </PopoverContent>
  </Popover>
</template>
