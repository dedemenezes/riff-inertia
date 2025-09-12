<script setup>
// TODO: Close form filter only after success submit?
// TODO: CHANGE TEXT WHEN NO RESULT FOR FILTERING
// TODO: FIX LIMPAR FILTRO
// TODO: Click cleansearchbar should close mobile filter menu?
// TODO: Click cleansearchbar should make new request to remove query param

import { ref } from "vue";
import { router } from "@inertiajs/vue3"

import TwContainer from "@/components/layout/TwContainer.vue";
import InfiniteScrollLayout from "@/components/layout/InfiniteScrollLayout.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MenuTabs from "@/components/layout/navbar/MenuTabs.vue";

import MobileTrigger from "@/components/features/filters/MobileTrigger.vue";
import ProgramsFilterForm from "@/components/features/filters/ProgramsFilterForm.vue";
import SessionCard from "@/components/common/cards/SessionCard.vue";
import TagFilter from "@/components/common/tags/TagFilter.vue";

import { useMobileTrigger } from "@/components/features/filters/composables/useMobileTrigger";
import { useStickyMenuTabs } from "@/components/layout/navbar/composables/useStickyMenuTabs";

import ResponsiveFilterMenu from "@/components/features/filters/ResponsiveFilterMenu.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import { extractFilterValues } from "@/lib/filterUtils";

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

const localFilters = ref({ ...props.current_filters })

// Called when user clears search bar
const handleClear = () => {
  filters.value.query = null;
  submit(props.tabBaseUrl);
};

// Called when filters applied in MobileFilterMenu
const filterSearch = (filtersFromChild) => {
  const cleanedFilters = extractFilterValues(filtersFromChild)
  router.get(props.tabBaseUrl, cleanedFilters, {
    preserveState: true,
    preserveScroll: true,
    only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
  })
};

const removeQuery = (what) => {
  const newParams = new URLSearchParams()
  // TODO: ADD ALL TRANSLATIONS OR REFACTOR AI CAN ADD TRANSLATIONS
  if (["Country", "Pais"].includes(what.filter_label)) {
    localFilters.value['pais'] = null
  }

  if (["Showcase", "Mostra"].includes(what.filter_label)) {
    localFilters.value['mostra'] = null
  }
  // make new request with the up to date filters
  debugger
  if (localFilters.value[what["filter_label"].toLowerCase()]) {
    localFilters.value[what["filter_label"].toLowerCase()] = null
  }
  Object.entries(localFilters.value).forEach(([key, value]) => {
    if (value !== null && value !== undefined && value !== "") {
      newParams.set(key, value.filter_value);
    }
  })
  router.get(props.tabBaseUrl, newParams, {
    preserveState: true,
    preserveScroll: true,
    only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
  })
}

// Called when filters cleared from MobileFilterMenu
const clearSearchQuery = () => {
  clearAll();
  submit(props.tabBaseUrl);
};

// sticket menutabs
const { sentinel, isSticky } = useStickyMenuTabs()
</script>

<template>
  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
  </TwContainer>

  <MenuContext
    nav="programacao"
  />

  <hr class="text-neutrals-300">
  <!-- TODO: review border maybe just desktop -->
  <TwContainer class="relative">
    <div
    class="filter flex lg:hidden items-center justify-end py-300 bg-white"
    >
      <MobileTrigger @open-menu="openMenu" />
    </div>

    <!-- TODO: REFAC into reusable components -->
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
    <!-- filtered tag -->

    <div class="grid grid-cols-12">
      <div class="col-span-12 md:col-span-6">
        <!-- Added for sticky menutabs -->
        <div ref="sentinel" class="h-1"></div>
        <MenuTabs
          :is-sticky="isSticky"
          :tabs="menuTabs"
          class="h-15"
        />

        <!-- DESKTOP TAG FILTER -->
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
          :is-open="isFilterMenuOpen"
          :initialFilters="localFilters"
          @filtersApplied="filterSearch"
          @filtersCleared="clearSearchQuery"
          @close-filter-menu="closeMenu"
        >
          <template #filters="{ modelValue, updateField }">
            <ProgramsFilterForm
              :model-value="modelValue"
              :update-field="updateField"
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
