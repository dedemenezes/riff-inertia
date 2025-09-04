<script setup>
import { ref, watch } from "vue";
import { IconClose } from "@/components/common/icons";
import SearchFilter from "@/components/features/filters/SearchFilter.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  isOpen: { type: Boolean, required: true },
  modelValue: { type: Object, required: true },
});
const internalFilters = ref(props.modelValue);

watch(internalFilters, (val) => emit("update:modelValue", val), { deep: true });

const emit = defineEmits([
  "update:modelValue",
  "filtersApplied",
  "filtersCleared",
  "close-filter-menu",
]);

const name = defineModel()
</script>

<template>
  <div
    v-if="props.isOpen"
    style="margin-top: 0"
    class="fixed inset-0 z-50 bg-white flex flex-col w-full max-w-full h-[100vh] right-0 shadow-lg overflow-y-auto"
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
          @filtersApplied="emit('filtersApplied', $event)"
          @filtersCleared="emit('filtersCleared', $event)"
          @close-filter-menu="emit('close-filter-menu')"
        >
          <template #filters="slotProps">
            <slot
              name="filters"
              v-bind="slotProps"
            />
          </template>
        </SearchFilter>
      </div>
    </TwContainer>
  </div>
</template>

<style scoped></style>
