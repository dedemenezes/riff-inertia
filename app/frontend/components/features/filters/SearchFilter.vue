<script setup>
import { computed, defineAsyncComponent } from "vue";
import { toRaw } from "vue";
import { cleanObject, toHHMM } from "@/lib/utils";
const FilterActions =  defineAsyncComponent(() => import("@/components/features/filters/FilterActions.vue"));

const closeMenu = () => {
  emit("close-filter-menu", false);
};

const props = defineProps({
  modelValue: { type: Object, required: true },
  debugMode: { type: Boolean, default: false }
});

const emit = defineEmits([
  "filtersApplied",
  "filtersCleared",
  "close-filter-menu",
  "update:modelValue",
]);


// ============================================================================
// PRIMARY FILTER LOGIC - ALL FILTER OPERATIONS HAPPEN HERE
// ============================================================================

/**
 * Primary updateField function - THE SINGLE SOURCE OF TRUTH
 * This is the only place where filter updates should be logged and handled
 */
const updateField = (key, value) => {
  console.log(`SearchFilter updating ${key}:`, value); // Move console.log here
  emit("update:modelValue", { ...props.modelValue, [key]: value });
};

/**
 * Apply filters - clean (remove null) and submit (through event emit) filters
 */
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

/**
 * Clear all filters - reset entire filter state
 */
const clearAllFilters = () => {
  const cleared = Object.fromEntries(
    Object.keys(props.modelValue).map((key) => [key, null])
  );
  emit("update:modelValue", cleared);
  emit("filtersCleared", cleared);
};

/**
 * Check if any filters are active (excluding certain keys)
 */
const hasActiveFilters = computed(() => {
  const keysToIgnore = ['page', 'date']; // Add keys you want to ignore

  return Object.entries(props.modelValue)
    .filter(([key, value]) => !keysToIgnore.includes(key))
    .filter(([key, value]) => value != "")
    .some(([key, value]) => value !== null);
});

/**
 * Clear individual field - for tag removal or specific field clearing
 */
const clearField = (key) => {
  console.log(`SearchFilter clearing ${key}`);
  updateField(key, null);
};

</script>

<template>
  <!-- Debug info -->
  <div v-if="props.debugMode" class="bg-amarelo-200 p-2 mb-4 text-xs">
    <p><strong>SearchFilter modelValue :</strong> {{ modelValue }} </p>
    <p><strong>SearchFilter and hasActiveFilter.value:</strong> {{ hasActiveFilters.value }}</p>
    <p><strong>SearchFilter and hasActiveFilter:</strong> {{ hasActiveFilters }}</p>
  </div>

  <!-- Main filter content area -->
  <div class="flex-grow flex flex-col space-y-600 overflow-y-auto">
    <slot
      name="filters"
      :modelValue="props.modelValue"
      :updateField="updateField"
      :clearField="clearField"
      :hasActiveFilters="hasActiveFilters"
    >
      <!-- Default content -->
      <div class="text-center py-8">
        <p class="text-gradient text-header-lg">No filter content provided</p>
        <p class="text-sm text-gray-500 mt-2">
          Use the #filters slot to add your filter form
        </p>
      </div>
    </slot>
  </div>
  <div
    class="shrink-0 py-400 actions justify-self-end sticky bottom-0 bg-white-transp-1000 z-10"
  >
    <!-- Action buttons (Apply/Clear) -->
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
