<script setup>
import { ref, watch, useTemplateRef } from "vue";
import { IconClose } from "@/components/common/icons";
import SearchFilter from "@/components/features/filters/SearchFilter.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  isOpen: { type: Boolean, required: true },
  initialFilters: { type: Object, required: true },
});

const internalFilters = ref({ ...props.initialFilters });

// Watch for changes in initialFilters (after successful submission)
watch(() => props.initialFilters, (newFilters) => {
  internalFilters.value = { ...newFilters };
}, { deep: true });

const emit = defineEmits([
  "update:modelValue",
  "filtersApplied",
  "filtersCleared",
  "close-filter-menu",
]);

const closeBtn = useTemplateRef('close-btn');
</script>

<template>
  <!-- Desktop Layout: Sticky sidebar (always visible) -->
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
          <!-- <button @click="emit('close-filter-menu')" class="text-neutrals-900 cursor-pointer absolute -right-[.425rem]">
            <IconClose height="32px" width="32px" />
          </button> -->
        </div>

        <!-- Desktop Filter Content -->
        <SearchFilter
          v-model="internalFilters"
          @update:modelValue="(val) => emit('update:modelValue', val)"
          @filtersApplied="emit('filtersApplied', internalFilters)"
          @filtersCleared="emit('filtersCleared')"
          @close-filter-menu="emit('close-filter-menu')"
        >
          <template #filters="slotProps">
            <slot
              name="filters"
              :modelValue="internalFilters"
              :updateField="(field, value) => {
                internalFilters[field] = value
              }"
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
      <FocusTrap
        v-if="props.isOpen"
        :initial-focus="() => $refs.closeBtn"
        v-model:active="props.isOpen"
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
                <button ref="closeBtn" @click="emit('close-filter-menu')" class="text-neutrals-900 cursor-pointer absolute -right-[.425rem]">
                  <IconClose height="32px" width="32px" />
                </button>
              </div>

              <!-- Mobile Filter Content -->
              <SearchFilter
                v-model="internalFilters"
                @update:modelValue="(val) => emit('update:modelValue', val)"
                @filtersApplied="emit('filtersApplied', internalFilters)"
                @filtersCleared="emit('filtersCleared')"
                @close-filter-menu="emit('close-filter-menu')"
              >
                <template #filters="slotProps">
                  <slot
                    name="filters"
                    :modelValue="internalFilters"
                    :updateField="(field, value) => {
                      internalFilters[field] = value
                    }"
                  />
                </template>
              </SearchFilter>
            </div>
          </TwContainer>
        </div>
      </FocusTrap>
     </transition>
   </Teleport>
</template>

<style scoped></style>
