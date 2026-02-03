<script setup>
import { ref, watch } from "vue";
import { IconClose } from "@/components/common/icons";
import SearchFilter from "@/components/features/filters/SearchFilter.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  isOpen: { type: Boolean, required: true },
  // modelValue: { type: Object, required: true },
  initialFilters: { type: Object, required: true },
});
watch(() => props.initialFilters, (newFilters) => {
  internalFilters.value = { ...newFilters };
}, { deep: true });
// const internalFilters = ref(props.modelValue);

// watch(internalFilters, (val) => emit("update:modelValue", val), { deep: true });

const internalFilters = ref({ ...props.initialFilters });

const emit = defineEmits([
  "update:modelValue",
  "filtersApplied",
  "filtersCleared",
  "close-filter-menu",
]);
</script>

<!-- v-if="props.isOpen" -->
<template>
  <div
    style="margin-top: 0"
    class="desktop-style bg-white hidden md:flex md:flex-col sticky top-15"
  >
    <TwContainer class="h-full">
      <div class="flex flex-col h-full">
        <!-- Filter header -->
        <div
          class="shrink-0 flex justify-between items-center py-400 sticky top-0 bg-white-transp-1000 z-10"
        >
          <p class="text-header-sm text-neutrals-900 uppercase">
            <!-- {{ $t("filtro", 2) }} -->
              FILTROS
          </p>
          <button @click="emit('close-filter-menu')" class="text-neutrals-900 cursor-pointer absolute -right-[.425rem]">
            <IconClose height="32px" width="32px" />
          </button>
        </div>
        <!-- Filter header -->
        <SearchFilter
          v-model="internalFilters"
          @update:modelValue="(val) => emit('update:modelValue', val)"
          @filters-applied="emit('filtersApplied', internalFilters)"
          @filters-cleared="emit('filtersCleared')"
          @close-filter-menu="emit('close-filter-menu')"
        >
          <template #filters="slotProps">
            <slot
              name="filters"
              :modelValue="internalFilters"
              :update-field="(field, value) => {
                internalFilters[field] = value
              }"
            />
          </template>
        </SearchFilter>
      </div>
    </TwContainer>
  </div>
</template>

<style scoped></style>
