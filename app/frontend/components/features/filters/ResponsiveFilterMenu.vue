
<!--
REFACTORED: ResponsiveFilterMenu is now a PURE LAYOUT COMPONENT
- No more updateField logic (moved to SearchFilter)
- No more filter handling logic (moved to SearchFilter)
- No more console.logs (moved to SearchFilter)
- Just responsive layout and event pass-through
- 100% reusable for any filter system
-->
<script setup>
import { useTemplateRef } from "vue";
import { IconClose } from "@/components/common/icons";
import SearchFilter from "@/components/features/filters/SearchFilter.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  isOpen: { type: Boolean, required: true },
  modelValue: { type: Object, required: true },
  debugMode: { type: Boolean, default: false },
});

const emit = defineEmits([
  "update:modelValue",
  "filtersApplied",
  "filtersCleared",
  "close-filter-menu",
]);

const closeBtn = useTemplateRef('close-btn');

// ============================================================================
// PURE PASS-THROUGH COMPONENT - NO FILTER LOGIC HERE
// All events are forwarded directly to SearchFilter
// All filter logic happens in SearchFilter
// This component only handles layout and UI state
// ============================================================================
</script>

<template>
  <!-- Debug info -->
  <div v-if="props.debugMode" class="bg-amarelo-200 p-2 mb-4 text-md text-neutrals-900">
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

        <!-- Desktop Filter Content - SearchFilter handles all logic -->
        <SearchFilter
          :modelValue="props.modelValue"
          @update:modelValue="$emit('update:modelValue', $event)"
          @filtersApplied="$emit('filtersApplied', $event)"
          @filtersCleared="$emit('filtersCleared', $event)"
          @close-filter-menu="$emit('close-filter-menu')"
        >
          <!-- Pass all SearchFilter slot props directly to our slot -->
          <template #filters="searchFilterProps">
            <slot name="filters" v-bind="searchFilterProps" />
          </template>

          <!-- Pass action slot props if needed -->
          <template #actions="actionProps">
            <slot name="actions" v-bind="actionProps">
              <!-- SearchFilter provides default actions if no slot given -->
            </slot>
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
        class="fixed inset-0 z-50 bg-white flex md:hidden flex-col w-full max-w-full h-[100dvh] right-0 shadow-lg"
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
                aria-label="Fechar filtros"
              >
                <IconClose height="32px" width="32px" />
              </button>
            </div>
            <!-- Mobile Filter Content -->
             <div class="flex-grow flex flex-col justify-between">
               <SearchFilter
                 :modelValue="props.modelValue"
                 @update:modelValue="$emit('update:modelValue', $event)"
                 @filtersApplied="$emit('filtersApplied', $event)"
                 @filtersCleared="$emit('filtersCleared', $event)"
                 @close-filter-menu="$emit('close-filter-menu')"
               >
                 <template #filters="searchFilterProps">
                   <slot name="filters" v-bind="searchFilterProps" />
                 </template>
               </SearchFilter>
             </div>
          </div>
        </TwContainer>
      </div>
    </transition>
  </Teleport>
</template>

<style scoped></style>
