<script setup>
import { computed } from "vue";
import { toRaw } from "vue";
import { cleanObject, toHHMM } from "@/lib/utils";
import FilterActions from "@/components/features/filters/FilterActions.vue";
// import FilterForm from "./FilterForm.vue";

const closeMenu = () => {
  emit("close-filter-menu", false);
};

const props = defineProps({
  modelValue: { type: Object, required: true },
});

const emit = defineEmits([
  "filtersApplied",
  "filtersCleared",
  "close-filter-menu",
  "update:modelValue",
]);

const applyFilters = () => {
  const rawFilters = toRaw(props.modelValue);
  const cleanedFilters = cleanObject(rawFilters);
  // TODO: THINK. time processing maybe helper
  if (cleanedFilters.startTime) {
    cleanedFilters.startTime = toHHMM(cleanedFilters.startTime);
  }
  if (cleanedFilters.endTime) {
    cleanedFilters.endTime = toHHMM(cleanedFilters.endTime);
  }
  emit("filtersApplied", cleanedFilters);
  closeMenu();
};

const clearAllFilters = () => {
  const cleared = Object.fromEntries(
    Object.keys(props.modelValue).map((key) => [key, null]),
  );
  emit("update:modelValue", cleared);
  emit("filtersCleared", cleared);
};

const hasActiveFilters = computed(() => {
  return Object.values(props.modelValue).some((value) => value !== null);
});

const updateField = (key, value) => {
  emit("update:modelValue", { ...props.modelValue, [key]: value });
};
</script>

<template>
  <div class="flex-grow flex flex-col space-y-600 overflow-y-auto">
    <slot
      name="filters"
      :modelValue="props.modelValue"
      :updateField="updateField"
    >
      <!-- Default content -->
       <p class="text-gradient text-header-lg text-center">No content passed</p>
    </slot>
  </div>
  <div
    class="shrink-0 py-400 actions justify-self-end sticky bottom-0 bg-white-transp-1000 z-10"
  >
    <slot
      name="actions"
      :hasActiveFilters="hasActiveFilters"
      :applyFilters="applyFilters"
      :clearAllFilters="clearAllFilters"
    >
      <!-- DFAULT -->
      <FilterActions
        @clear="clearAllFilters"
        @apply="applyFilters"
        :hasActiveFilters="hasActiveFilters"
      />
    </slot>
  </div>
</template>
