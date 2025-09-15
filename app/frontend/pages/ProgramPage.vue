<script setup>
// TODO: Click cleansearchbar should close mobile filter menu?
// TODO: Click cleansearchbar should make new request to remove query param
// TODO: Add icon for menu tabs scroll
// TODO: Fix image urls

// FOLLOWING THE COMMENTS INSIDE RESPONSIVE MENU
// IN HERE WE RECEIVE ALL THE FILTER OPTIONS AS PROPS
// WE RECEIVE THE CURRENT_FILTERS FROM THE CONTROLLER
// A HASH CONTAINING THE SELECTED OPTION
// WITH STRUCTURE PREDEFINED
// {filter_display: '', filter_value: '', filter_label: ''}
// but maybe this is not mandatory


import { ref, watch } from "vue";
import { router } from "@inertiajs/vue3"

import TwContainer from "@/components/layout/TwContainer.vue";
import InfiniteScrollLayout from "@/components/layout/InfiniteScrollLayout.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MenuTabs from "@/components/layout/navbar/MenuTabs.vue";
import TagFilter from "@/components/common/tags/TagFilter.vue";
import MobileTrigger from "@/components/features/filters/MobileTrigger.vue";
import ProgramsFilterForm from "@/components/features/filters/ProgramsFilterForm.vue";
import SessionCard from "@/components/common/cards/SessionCard.vue";

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

// ============================================================================
// FILTER STATE MANAGEMENT - SINGLE SOURCE OF TRUTH
// ============================================================================

/**
 * Initialize empty filter structure
 */
const initializeFilters = () => ({
  query: null,
  sessao: null,
  mostra: null,
  cinema: null,
  genero: null,
  pais: null,
  direcao: null,
  elenco: null,
})

/**
 * Override empty filters with current filter values from controller
 */
const overrideFiltersValues = () => {
  return { ...initializeFilters(), ...props.current_filters }
}


// Main filter state - this is passed to SearchFilter via ResponsiveFilterMenu
const filters = ref(overrideFiltersValues())

// Watch for prop changes from server (shouldn't happen often but good to have)
watch(() => props.current_filters, (newFilters) => {
  console.log('ProgramPage: current_filters changed from server:', newFilters);
  filters.value = overrideFiltersValues()
}, { immediate: true, deep: true })

// ============================================================================
// FILTER OPERATIONS - CALLED BY SEARCHFILTER VIA EVENTS
// ============================================================================

/**
 * Called when SearchFilter emits filtersApplied
 * This makes the actual router call to update the page
 */

const filterSearch = (filtersFromSearchFilter) => {
  console.log('ProgramPage: Applying filters from SearchFilter:', filtersFromSearchFilter);

  // Build query params by rejecting any filter: null or ""
  const cleanedFilters = extractFilterValues(filtersFromSearchFilter || filters.value)

  // MAke search request and says which prop to update
  router.get(props.tabBaseUrl, cleanedFilters, {
    preserveScroll: true,
    only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
  })
};

/**
 * Called when user clicks a filter tag to remove it
 * This updates the filters state and makes a router call
 */

const removeQuery = (filterToRemove) => {
  const newParams = new URLSearchParams()
  // Clear the specific filter
  // TODO: REFAC TIP ADD FILTER_KEY FROM CONTROLLER
  // IT SHOULD MAKE AGNOSTIC
  // Map filter labels to filter keys (could be improved with a filter_key from controller)
  const filterKeyMap = {
    'Time': 'sessao',
    'Sessão': 'sessao',
    'Showcase': 'mostra',
    'Mostra': 'mostra',
    'Cinema': 'cinema',
    'Genre': 'genero',
    'Genero': 'genero',
    'Country': 'pais',
    'Pais': 'pais',
    'Director': 'direcao',
    'Direção': 'direcao',
    'Cast': 'elenco',
    'Elenco': 'elenco'
  };
  const filterKey = filterKeyMap[filterToRemove.filter_label];
  if (filterKey) {
    // Updated local filter state
    filters.value[filterKey] = null;

    // Build new URL params from remaining filters
    const newParams = new URLSearchParams();
    Object.entries(filters.value).forEach(([key, value]) => {
      if (value !== null && value !== undefined && value !== "" && value?.filter_value) {
        newParams.set(key, value.filter_value);
      }
    });

    router.get(props.tabBaseUrl, newParams, {
      preserveScroll: true,
      only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
    })
  } else {
    console.warn('ProgramPage: Unknown filter label:', filterToRemove.filter_label);
  }
}

/**
 * Called when SearchFilter emits filtersCleared
 * This clears all filters and optionally makes a router call
 */
const clearSearchQuery = () => {
  console.log('ProgramPage: Clearing all filters');

  const clearedFilters = initializeFilters()
  filters.value = clearedFilters
  // Only make router call if there were actually filters applied
  const hasFiltersApplied = Object.entries(props.current_filters).some(([key, value]) => value != null)
  if (hasFiltersApplied) {
    router.get(props.tabBaseUrl, {}, {
      preserveState: true,
      preserveScroll: true,
      only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
    });
  }
};

/**
 * Called when user clears search bar directly (if needed)
 */
const handleClear = () => {
  console.log('ProgramPage: Clearing search query');
  filters.value.query = null;
  filterSearch(filters.value);
};

// ============================================================================
// UI UTILITIES
// ============================================================================

// sticket menutabs
const { sentinel, isSticky } = useStickyMenuTabs();

// const debugMode = false;
</script>

<template>
  <div v-if="debugMode">
    <p class="bg-amarelo-200 p-2 mb-4 text-md text-neutrals-900">current_filters: {{ props.current_filters }}</p>
    <p class="bg-amarelo-200 p-2 mb-4 text-md text-neutrals-900">filters: {{ filters }}</p>
  </div>

  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
  </TwContainer>

  <MenuContext
    nav="programacao"
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
        </div>
        <!-- CONTENT -->
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
          @filtersApplied="filterSearch"
          @filtersCleared="clearSearchQuery"
          @close-filter-menu="closeMenu"
          :debugMode="debugMode || false"
          >
          <template #filters="searchFilterProps">
            <!-- v-bind="searchFilterProps" -->
            <ProgramsFilterForm
              :model-value="searchFilterProps.modelValue"
              :update-field="searchFilterProps.updateField"
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
