<script setup>
// TODO: CHANGE TEXT WHEN NO RESULT FOR FILTERING
import { ref,  watch } from "vue";
import { router } from "@inertiajs/vue3"
import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";

import TwContainer from "@/components/layout/TwContainer.vue";
import InfiniteScrollLayout from "@/components/layout/InfiniteScrollLayout.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MenuTabs from "@/components/layout/navbar/MenuTabs.vue";

import MobileTrigger from "@/components/features/filters/MobileTrigger.vue";
import ProgramsFilterForm from "@/components/features/filters/ProgramsFilterForm.vue";
import SessionCard from "@/components/common/cards/SessionCard.vue";

import { useMobileTrigger } from "@/components/features/filters/composables/useMobileTrigger";
import { useStickyMenuTabs } from "@/components/layout/navbar/composables/useStickyMenuTabs";

import ResponsiveFilterMenu from "@/components/features/filters/ResponsiveFilterMenu.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";

const { isFilterMenuOpen, openMenu, closeMenu } = useMobileTrigger();

const props = defineProps({
  tabBaseUrl: { type: String, required: true },
  items: { type: Array, required: true }
  ,elements: { type: Object, required: true }
  ,pagy: { type: Object, required: true }
  ,mostrasFilter: { type: Array, default: () => [] }
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
  const cleanedFilters = {}

  for (const [key, value] of Object.entries(filtersFromChild)) {
    if (key === 'mostrasFilter' && typeof value === 'object' && value?.permalink_pt) {
      cleanedFilters[key] = value.permalink_pt  // Extract just the string
    } else {
      cleanedFilters[key] = value
    }
  }
  router.get(props.tabBaseUrl, cleanedFilters, {
    preserveState: true,
    preserveScroll: true,
    only: ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']
  })
};

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
    <!-- Added for sticky menutabs -->
    <div ref="sentinel" class="h-1"></div>
    <MenuTabs
      :is-sticky="isSticky"
      :tabs="menuTabs"
      class="h-15"
    />
    <div
    class="filter flex items-center justify-end py-300 sticky top-15 z-40 bg-white"
    >
      <MobileTrigger @open-menu="openMenu" />
    </div>

    <div class="grid grid-cols-12">
      <div class="col-span-12 md:col-span-6">
        <InfiniteScrollLayout #content="{ allElements }"
          :elements="props.elements"
          :pagy="props.pagy"
        >
          <SessionCard v-for="session in allElements"
            :session="session"
          />
        </InfiniteScrollLayout>
      </div>
      <div class="col-start-8 col-span-6 sticky top-0 z-70">
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
            />
          </template>
        </ResponsiveFilterMenu>
      </div>
    </div>
  </TwContainer>
</template>

<style scoped></style>
