<!--
// WE REMOVED EVERYHTING BELOW
// AND NOW THE WHOLE DATA FLOW
// INSIDE THIS COMPONENT RELIES
// ON THE MODELVALUE PROPS PASSED FROM THE PARENT
// IT WILL FORWARD THE MODELVALUE
// TO THE SEARCHFILTER COMPONENT
// AS PROP :modelValue AND RECEIVE
// IT BACK IN THE TEMPLATE THROUGH
// MODELVALUE :modelValue

// WHEN SEARCHFILTER UPDATES MODELVALUE
// IT WILL FORWARD THE EVENT UPDATE:MODELVALUE
// WE RECEIVE HERE, UPDATE THE KEY FILTER
// INSIDE MODELVALUE WITH THE USER SELECTED OPTION
// AND FORWARD AN UPDATE:MODELVALUE EVENT

// THIS LAST EMIT IS NOT RECEIVED HERE BUT IN THE PARENT
// AND THEN WE SUBMIT THE FILTER IN THE PARENT

// A HUGE CHAIN THAT FOR SURE CAN BE SIMPLIFIED
// BECAUSE THE SEARCHFILTER ALSO HAS AN UPDATEFIELD FUNCTION
// THIS SHOULD BE ONLY IN ONE PLACE.
 -->
<script setup>
import { ref, watch, useTemplateRef } from "vue";
import { IconClose } from "@/components/common/icons";
import SearchFilter from "@/components/features/filters/SearchFilter.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  isOpen: { type: Boolean, required: true },
  // initialFilters: { type: Object, required: true },
  modelValue: { type: Object, required: true },
});

const emit = defineEmits([
  "update:modelValue",
  "filtersApplied",
  "filtersCleared",
  "close-filter-menu",
]);

const closeBtn = useTemplateRef('close-btn');

// Unified update function that emits changes back to parent
const updateField = (field, value) => {
  console.log(`ResponsiveFilterMenu updating ${field}:`, value);
  // Emit the change back to parent
  const updatedFilters = { ...props.modelValue, [field]: value };
  emit('update:modelValue', updatedFilters);
};

// Handle filter application
const handleFiltersApplied = () => {
  console.log('Filters applied:', props.modelValue);
  emit('filtersApplied', props.modelValue);
};

// Handle filter clearing
const handleFiltersCleared = () => {
  console.log('Clearing Filters...');
  // Reset internal filters = RESET MODELVALUE
  const clearedFilters = Object.keys(props.modelValue).reduce((acc, key) => {
    acc[key] = null;
    return acc;
  }, {});
  console.log('Filters cleared', clearedFilters);

  emit('update:modelValue', clearedFilters);
  emit('filtersCleared');
};
</script>

<template>
  <!-- Debug info -->
  <div class="bg-blue-50 p-2 mb-4 text-xs">
    <p><strong>ResponsiveFilterMenu modelValue:</strong> {{ modelValue }}</p>
  </div>

  <!-- Desktop Layout: Sticky sidebar (always visible) -->
   <!-- add js to isDesktop -->
  <div
    style="margin-top: 0"
    class="desktop-style bg-white hidden md:flex md:flex-col sticky top-0"
  >
    <TwContainer class="h-full">
      <div class="flex flex-col h-full">
        <!-- Desktop Filter header -->
        <div
          class="shrink-0 flex justify-between items-center py-400 sticky top-0 bg-white-transp-1000"
        >
          <p class="text-header-sm text-neutrals-900 uppercase">
            FILTROS
          </p>
        </div>

        <!-- Desktop Filter Content -->
        <SearchFilter
          :modelValue="props.modelValue"
          @update:modelValue="emit('update:modelValue', $event)"
          @filtersApplied="handleFiltersApplied"
          @filtersCleared="handleFiltersCleared"
          @close-filter-menu="emit('close-filter-menu')"
        >
          <template #filters="slotProps">
            <slot
              name="filters"
              :modelValue="modelValue"
              :updateField="updateField"
            />
          </template>
        </SearchFilter>
      </div>
    </TwContainer>
  </div>

  <!-- Mobile Layout: Fullscreen modal (only when open) -->
  <Teleport to="body">
    <transition
      name="slide"
      enter-active-class="transition-transform duration-300 ease-out"
      leave-active-class="transition-transform duration-300 ease-in"
      enter-from-class="transform -translate-x-full"
      enter-to-class="transform translate-x-0"
      leave-from-class="transform translate-x-0"
      leave-to-class="transform -translate-x-full"
    >
      <div
        v-show="props.isOpen"
        style="margin-top: 0"
        class="fixed inset-0 z-50 bg-white flex md:hidden flex-col w-full max-w-full h-[100vh] right-0 shadow-lg overflow-y-auto"
      >
        <TwContainer class="h-full">
          <div class="flex flex-col h-full">
            <!-- Mobile Filter header -->
            <div
              class="shrink-0 flex justify-between items-center py-400 sticky top-0 bg-white-transp-1000 z-50"
            >
              <p class="text-header-sm text-neutrals-900 uppercase">
                FILTROS
              </p>
              <button
                ref="closeBtn"
                @click="emit('close-filter-menu')"
                class="text-neutrals-900 cursor-pointer absolute -right-[.425rem]"
              >
                <IconClose height="32px" width="32px" />
              </button>
            </div>

            <!-- Mobile Filter Content -->
            <SearchFilter
              :modelValue="modelValue"
              @update:modelValue="(val) => emit('update:modelValue', val)"
              @filtersApplied="handleFiltersApplied"
              @filtersCleared="handleFiltersCleared"
              @close-filter-menu="emit('close-filter-menu')"
            >
              <template #filters="slotProps">
                <slot
                  name="filters"
                  :modelValue="modelValue"
                  :updateField="updateField"
                />
              </template>
            </SearchFilter>
          </div>
        </TwContainer>
      </div>
    </transition>
  </Teleport>
</template>

<style scoped></style>
