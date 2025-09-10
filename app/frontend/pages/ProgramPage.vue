<script setup>
// TODO: CHANGE TEXT WHEN NO RESULT FOR FILTERING
// TODO: FIX LIMPAR FILTRO
// TODO: Click cleansearchbar should close mobile filter menu?
// TODO: Click cleansearchbar should make new request to remove query param

import { ref } from "vue";
import { router } from "@inertiajs/vue3"
import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";

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
  ,mostrasFilter: { type: Array, default: () => [] }
  ,cinemasFilter: { type: Array, default: () => [] }
  ,paisesFilter: { type: Array, default: () => [] }
  ,genresFilter: { type: Array, default: () => [] }
  ,sessoes: { type: Array, default: () => [] }
  // NEW LIFE
  ,menuTabs: { type: Array, required: true }
  ,current_filters: { type: Object, default: () => ({}) }
  ,has_active_filters: { type: Boolean, default: false }
  ,crumbs: { type: Array, required: true }
})

const localFilters = ref({ ...props.current_filters })


const iconMapping = {
  "program": IconProgram,
  "user": IconNewUser,
  "change": IconChange,
  "clock": IconClock
};


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
  debugger
  // remove the correct queryparams from url
  // make new request with the up to date filters
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
  :items="props.items"
  :icon-mapping="iconMapping"
  />
  <hr class="text-neutrals-300">
  <!-- TODO: review border maybe just desktop -->
  <TwContainer class="relative">
    <div
    class="filter flex lg:hidden items-center justify-end py-300 bg-white"
    >
      <MobileTrigger @open-menu="openMenu" />
    </div>

    <!-- filtered tag -->
     <!-- { "query": null,
       "mostrasFilter": null,
       "cinemasFilter": null,
       "paisesFilter": null,
       "sessao": { "sessao": "2000-01-01T19:00:00.000Z",
       "display_sessao": "19:00",
       "filter_value": "19h00",
       "filter_display": "19h00" }
      } -->
    <div
      class="flex lg:hidden gap-300 pt-200 pb-300 overflow-x-auto no-scroll-bar"
      v-if="Object.values(props.current_filters).some((item) => item !== null)"
    >
      <TagFilter
        v-for="[key, value] in Object.entries(props.current_filters).filter(([k, v]) => v !== null)"
        :key="key"
        :filter="{ label: value.filter_display, value: value.filter_value }"
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
        <div
          class="hidden lg:flex gap-300 pt-200 pb-300 overflow-x-auto no-scroll-bar sticky top-15 z-10 bg-white"
          v-if="Object.values(props.current_filters).some((item) => item !== null)"
        >
          <TagFilter
            v-for="[key, value] in Object.entries(props.current_filters).filter(([k, v]) => v !== null)"
            :key="key"
            :filter="{ label: value.filter_display, value: value.filter_value }"
            :text="value.filter_display"
            @remove-filter="removeQuery"
            />
        </div>
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
              :mostrasFilter="props.mostrasFilter"
              :cinemasFilter="props.cinemasFilter"
              :paisesFilter="props.paisesFilter"
              :genresFilter="props.genresFilter"
              :sessoes="props.sessoes"
            />
          </template>
        </ResponsiveFilterMenu>
      </div>
    </div>
  </TwContainer>
</template>

<style scoped></style>
