<script setup>
// TODO: Close form filter only after success submit?
// TODO: CHANGE TEXT WHEN NO RESULT FOR FILTERING
// TODO: FIX LIMPAR FILTRO
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
})

// Override with reactive filter with
// current filtered values in case
// there are any coming from controller
const overrideFiltersValues = () => {
  const emptyFilters = initializeFilters()
  return {emptyFilters, ...props.current_filters}
}

const filters = ref(overrideFiltersValues())

// Watch for prop changes and update our local state
// DONT THINK WE NEED AS THE PROP COMES FROM THE CONTROLLER
// WHEN WE CHANGE A FILTER WE WILL AND SHOULD
// ALWAYS UPDATE FILTERS REACTIVE AND NOT PROPS
// PROPS DONT CHANGE VALUE
watch(() => props.current_filters, (newFilters) => {
  filters.value = overrideFiltersValues()
}, { immediate: true, deep: true })

// Update field function to pass to the form
// if we are defining and passin we dont need it there
// but in my mind it should be inside searchfilter
// i said smth related to this
// inside responsivefiltermenu comments
const updateField = (fieldName, value) => {
  console.log(`Updating ${fieldName}:`, value)
  filters.value[fieldName] = value
}

// Called when user clears search bar
const handleClear = () => {
  debugger
  filters.value.query = null;
  submit(props.tabBaseUrl);
};

// Called when filters applied through button inside filter
const filterSearch = (filtersFromChild) => {
  // this function extract actually
  // build the query params ignoring null filters
  const cleanedFilters = extractFilterValues(filtersFromChild || filters.value)
  router.get(props.tabBaseUrl, cleanedFilters, {
    preserveScroll: true,
    only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
  })
};

const removeQuery = (what) => {
  const newParams = new URLSearchParams()

  // Clear the specific filter
  // TODO: REFAC TIP ADD FILTER_KEY FROM CONTROLLER
  // IT SHOULD MAKE AGNOSTIC
  if (["Time", "Sessão"].includes(what.filter_label)) {
    filters.value['sessao'] = null
  }

  if (["Showcase", "Mostra"].includes(what.filter_label)) {
    filters.value['mostra'] = null
  }

  // Add other filter types as needed
  if (["Cinema"].includes(what.filter_label)) {
    filters.value['cinema'] = null
  }

  if (["Genre", "Genero"].includes(what.filter_label)) {
    filters.value['genero'] = null
  }

  if (["Country", "Pais"].includes(what.filter_label)) {
    filters.value['pais'] = null
  }

  if (["Director", "Direção"].includes(what.filter_label)) {
    filters.value['direcao'] = null
  }


  if (["Cast", "Elenco"].includes(what.filter_label)) {
    filters.value['elenco'] = null
  }

  Object.entries(filters.value).forEach(([key, value]) => {
    if (value !== null && value !== undefined && value !== "" && value?.filter_value) {
      newParams.set(key, value.filter_value);
    }
  })

  router.get(props.tabBaseUrl, newParams, {
    preserveScroll: true,
    only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
  })
}

// Called when filters cleared from Limpar Todos btn
const clearSearchQuery = () => {
  const clearedFilters = initializeFilters()
  filters.value = clearedFilters
  const hasFiltersApplied = Object.entries(props.current_filters).some(([key, value]) => value != null)
  if (hasFiltersApplied) {
    router.get(props.tabBaseUrl, {}, {
      preserveState: true,
      preserveScroll: true,
      only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
    });
  }
};

// sticket menutabs
const { sentinel, isSticky } = useStickyMenuTabs()
</script>

<template>
  <p class="text-neutrals-900">current_filters: {{ props.current_filters }}</p>
  <!-- <p class="text-neutrals-700">localFilters: {{ localFilters }}</p> -->
  <p class="text-neutrals-500">filters: {{ filters }}</p>

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
