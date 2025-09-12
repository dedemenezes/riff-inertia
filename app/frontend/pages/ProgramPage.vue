<script setup>
// TODO: Close form filter only after success submit?
// TODO: CHANGE TEXT WHEN NO RESULT FOR FILTERING
// TODO: FIX LIMPAR FILTRO
// TODO: Click cleansearchbar should close mobile filter menu?
// TODO: Click cleansearchbar should make new request to remove query param

import { ref, watch } from "vue";
import { router } from "@inertiajs/vue3"
import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";

import TwContainer from "@/components/layout/TwContainer.vue";
import InfiniteScrollLayout from "@/components/layout/InfiniteScrollLayout.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MenuTabs from "@/components/layout/navbar/MenuTabs.vue";
import TagFilter from "@/components/common/tags/TagFilter.vue";
import MobileTrigger from "@/components/features/filters/MobileTrigger.vue";
import ProgramsFilterForm from "@/components/features/filters/ProgramsFilterForm.vue";
import SessionCard from "@/components/common/cards/SessionCard.vue";

import TagFilterBar from "@/components/features/filters/TagFilterBar.vue";

import { useMobileTrigger } from "@/components/features/filters/composables/useMobileTrigger";
import { useStickyMenuTabs } from "@/components/layout/navbar/composables/useStickyMenuTabs";

import ResponsiveFilterMenu from "@/components/features/filters/ResponsiveFilterMenu.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import { extractFilterValues } from "@/lib/filterUtils";
import { slugify } from "@/lib/utils";

const { isFilterMenuOpen, openMenu, closeMenu } = useMobileTrigger();

const props = defineProps({
  tabBaseUrl: { type: String, required: true },
  items: { type: Array, required: true }
  ,elements: { type: Object, required: true }
  ,pagy: { type: Object, required: true }
  ,mostras: { type: Array, default: () => [] }
  ,cinemas: { type: Array, default: () => [] }
  ,paises: { type: Array, default: () => [] }
  ,genres: { type: Array, default: () => [] }
  ,sessoes: { type: Array, default: () => [] }
  ,directors: { type: Array, default: () => [] }
  ,actors: { type: Array, default: () => [] }
  // NEW LIFE
  ,menuTabs: { type: Array, required: true }
  ,current_filters: { type: Object, default: () => ({}) }
  ,has_active_filters: { type: Boolean, default: false }
  ,crumbs: { type: Array, required: true }
})

// Initialize with proper structure
const initializeFilters = () => ({
  query: null,
  sessao: null,
  mostra: null,
  cinema: null,
  genero: null,
  pais: null,
  direcao: null,
  elenco: null,
  ...props.current_filters // Override with actual values
})

const localFilters = ref(initializeFilters())
const filters = ref(initializeFilters())

// Watch for prop changes and update our local state
watch(() => props.current_filters, (newFilters) => {
  localFilters.value = initializeFilters()
  filters.value = initializeFilters()
}, { immediate: true, deep: true })

const iconMapping = {
  "program": IconProgram,
  "user": IconNewUser,
  "change": IconChange,
  "clock": IconClock
};

// Update field function to pass to the form
const updateField = (fieldName, value) => {
  console.log(`Updating ${fieldName}:`, value)
  filters.value[fieldName] = value
  localFilters.value[fieldName] = value
}

// Called when filters applied in MobileFilterMenu
const filterSearch = (filtersFromChild) => {
  const cleanedFilters = extractFilterValues(filtersFromChild || filters.value)
  router.get(props.tabBaseUrl, cleanedFilters, {
    preserveScroll: true,
    only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
  })
};

const removeQuery = (what) => {
  const newParams = new URLSearchParams()

  // Clear the specific filter
  if (["Country", "Pais"].includes(what.filter_label)) {
    localFilters.value['pais'] = null
    filters.value['pais'] = null
  }

  if (["Showcase", "Mostra"].includes(what.filter_label)) {
    localFilters.value['mostra'] = null
    filters.value['mostra'] = null
  }

  // Add other filter types as needed
  if (["Cinema"].includes(what.filter_label)) {
    localFilters.value['cinema'] = null
    filters.value['cinema'] = null
  }

  if (["Genre", "Genero"].includes(what.filter_label)) {
    localFilters.value['genero'] = null
    filters.value['genero'] = null
  }

  if (["Cast", "Elenco"].includes(what.filter_label)) {
    localFilters.value['elenco'] = null
    filters.value['elenco'] = null
  }

  Object.entries(localFilters.value).forEach(([key, value]) => {
    if (value !== null && value !== undefined && value !== "" && value?.filter_value) {
      newParams.set(key, value.filter_value);
    }
  })

  router.get(props.tabBaseUrl, newParams, {
    preserveScroll: true,
    only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
  })
}

// Called when filters cleared from MobileFilterMenu
const clearSearchQuery = () => {
  const clearedFilters = initializeFilters()
  localFilters.value = clearedFilters
  filters.value = clearedFilters
  // router.get(props.tabBaseUrl, {}, {
  //   preserveScroll: true,
  //   only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
  // });
};

// sticket menutabs
const { sentinel, isSticky } = useStickyMenuTabs()
</script>

<template>
  <!-- <p>current_filters: {{ props.current_filters }}</p>
  <p>localFilters: {{ localFilters }}</p>
  <p>filters: {{ filters }}</p> -->

  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
  </TwContainer>

  <MenuContext
    :items="props.items"
    :icon-mapping="iconMapping"
  />

  <hr class="text-neutrals-300">

  <TwContainer class="relative">
    <div class="filter flex lg:hidden items-center justify-end py-300 bg-white">
      <MobileTrigger @open-menu="openMenu" />
    </div>

    <!-- MOBILE TAG FILTER -->
    <div
      class="flex lg:hidden gap-300 pt-200 pb-300 overflow-x-auto no-scroll-bar"
      v-if="Object.values(props.current_filters).some((item) => item !== null)"
    >
      <TagFilter
        v-for="[key, value] in Object.entries(props.current_filters).filter(([k, v]) => v !== null)"
        :key="key"
        :filter="value"
        :text="value.filter_display"
        @remove-filter="removeQuery"
      />
    </div>

    <div class="grid grid-cols-12">
      <div class="col-span-12 md:col-span-6">
        <div ref="sentinel" class="h-1"></div>
        <MenuTabs
          :is-sticky="isSticky"
          :tabs="menuTabs"
          class="h-15"
        />
        <div
          class="hidden lg:flex gap-300 pt-200 pb-300 overflow-x-auto no-scroll-bar sticky top-15 z-10 bg-white"
          v-if="Object.values(props.current_filters).some((item) => item !== null)"
        >
          <TagFilter
            v-for="[key, value] in Object.entries(props.current_filters).filter(([k, v]) => v !== null)"
            :key="value.filter_value"
            :filter="value"
            :text="value.filter_display"
            @remove-filter="removeQuery"
          />
        </div>        <!-- CONTENT -->
        <InfiniteScrollLayout #content="{ allElements }"
          :elements="props.elements"
          :pagy="props.pagy"
        >
          <SessionCard v-for="session in allElements"
            :session="session"
          />
        </InfiniteScrollLayout>
      </div>

      <div class="col-start-8 col-span-6 sticky top-0 z-50">
        <div ref="sentinel" class="h-1"></div>
        <ResponsiveFilterMenu
          v-model="filters"
          :is-open="isFilterMenuOpen"
          :initialFilters="localFilters"
          @filtersApplied="filterSearch"
          @filtersCleared="clearSearchQuery"
          @close-filter-menu="closeMenu"
        >
          <template #filters="{ modelValue, updateField: updateFromMenu }">
            <ProgramsFilterForm
              :model-value="modelValue"
              :update-field="updateFromMenu || updateField"
              :mostras="props.mostras"
              :cinemas="props.cinemas"
              :paises="props.paises"
              :genres="props.genres"
              :sessoes="props.sessoes"
              :directors="props.directors"
              :actors="props.actors"
            />
          </template>
        </ResponsiveFilterMenu>
      </div>
    </div>
  </TwContainer>
</template>

<style scoped></style>
