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
// import { slugify } from "@/lib/utils";
import { useSearchFilter } from "@/components/features/filters/composables/usaSearchFilter";

const { isFilterMenuOpen, openMenu, closeMenu } = useMobileTrigger();

// items: { type: Array, required: true }
const props = defineProps({
  tabBaseUrl: { type: String, required: true }
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

const controllerParamsKeys = {
  // query: null,
  // sessao: null,
  // mostra: null,
  // cinema: null,
  // genero: null,
  // pais: null,
  // // direcao: null,
  // elenco: null,
}

const {
    initializeFilters,
    overrideFiltersValues,
    filters,
    filterSearch,
    removeQuery,
    clearSearchQuery,
    handleClear
}  = useSearchFilter(props)

// ============================================================================
// UI UTILITIES
// ============================================================================

// sticket menutabs
const { sentinel, isSticky } = useStickyMenuTabs();

const debugMode = false;
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
          class="hidden lg:flex gap-300 pt-200 pb-300 overflow-x-auto no-scroll-bar sticky top-13 z-10 bg-white"
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
          @filters-applied="filterSearch"
          @filters-cleared="clearSearchQuery"
          @close-filter-menu="closeMenu"
          :debug-mode="debugMode"
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
