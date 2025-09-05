<script setup>
// 1. 📦 Node.js built-ins (if used)
// 2. 🔌 External packages (npm, libraries)
import { Head, router } from "@inertiajs/vue3";
// 3. 🧠 Internal libs/helpers/utilities
import { applyFiltersToQuery } from "@/lib/applyFiltersToQuery";

// 4. 🧩 Global components / shared UI
import TwContainer from "@/components/layout/TwContainer.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import NavbarSecondary from "@/components/layout/navbar/NavbarSecondary.vue";
import TagFilter from "@/components/common/tags/TagFilter.vue";

// 5. 🧱 Feature-specific components
import MobileTrigger from "@/components/features/filters/MobileTrigger.vue";
import MobileFilterMenu from "@/components/features/filters/MobileFilterMenu.vue";
import NoticiasFilterForm from "@/components/features/filters/NoticiasFilterForm.vue";
import PagyPagination from "../PagyPagination.vue"; // relative path (usually for siblings only)

import { useMobileTrigger } from "@/components/features/filters/composables/useMobileTrigger";

const props = defineProps({
  mainItems: { type: Array },
  secondaryItems: { type: Array },
  breadcrumbs: { type: Array, default: () => []},
  noticias: { type: Array, default: () => []},
  cadernos: { type: Array, required: true },
  selectedFilters: { type: Object, default: () => {} },
  pagy: { type: Object, required: true }
})

const { isFilterMenuOpen, openMenu, closeMenu } = useMobileTrigger();


const filterSearch = (filtersFromChild) => {
  // console.log("Filters from MobileFilterMenu:", filtersFromChild);

  const params = applyFiltersToQuery(filtersFromChild)
  const query = params.toString()
  router.visit(`/noticias?${query}`, {
    preserveScroll: true,
    preserveState: true,
    only: ["noticias", "selectedFilters"],
  });
};

const removeQuery = (item) => {
  const newFilters = { ...props.selectedFilters };

  for (const [key, value] of Object.entries(newFilters)) {
    if (value?.permalink_pt === item) {
      newFilters[key] = null;
    }
  }

  const params = applyFiltersToQuery(newFilters)
  const query = params.toString()

  router.visit(`/noticias?${query}`, {
    preserveScroll: true,
    preserveState: false, // full reset
    only: ["noticias", "selectedFilters"],
  });
}

const clearSearchQuery = () => {
  const currentUrl = new URL(window.location.href);
  const hasUrlParams = currentUrl.searchParams.toString() !== "";

  if (!hasUrlParams) {
    // console.log("Already clean - no request needed");
    return;
  }

  router.visit(`/noticias`, {
    preserveScroll: true,
    preserveState: true,
    only: [ "noticias", "selectedFilters" ]
  })
}
</script>

<template>
  <Head>
    <title>Noticias - Festival do Rio</title>
    <!-- TODO: Add metatags into all pages! -->
  </Head>
  <NavbarSecondary :mainItems="props.mainItems" :secondaryItems="props.secondaryItems" />
  <TwContainer>
    <Breadcrumb  :crumbs="props.breadcrumbs"/>
    <!-- search & ordering -->
    <div
      class="filter flex items-center justify-between md:gap-800 lg:gap-1200 py-300"
    >
      <MobileTrigger @open-menu="openMenu" />

      <!-- Ordering -->
      <div class="flex items-center gap-300">
        <span class="text-body-strong-sm uppercase text-secondary-gray"
          >A - Z</span
        >
        <img
          src="@assets/icons/divisor.svg"
          alt="divisor"
          height="16px"
          width="1px"
        />
        <span class="text-body-strong-sm uppercase text-neutrals-900">
          <!-- {{$t("filter_by.date")}} -->
           por Data
        </span>
      </div>
      <!-- Ordering -->
    </div>
    <!-- search & ordering -->

    <!-- mobile filter content -->
    <transition name="slide-left">
      <MobileFilterMenu
        :is-open="isFilterMenuOpen"
        :initialFilters="props.selectedFilters"
        @filtersApplied="filterSearch"
        @filtersCleared="clearSearchQuery"
        @close-filter-menu="closeMenu"
      >
        <template #filters="{ modelValue, updateField }">
          <!-- class="py-600" -->
          <NoticiasFilterForm
            :model-value="modelValue"
            :update-field="updateField"
            :cadernos="props.cadernos"
          />
        </template>
      </MobileFilterMenu>
        <!-- input -->
    </transition>
    <!-- mobile filter content -->

    <!-- filtered tag -->
    <div
      class="flex gap-300 pt-200 pb-300"
      v-show="Object.values(props.selectedFilters).some((item) => item !== null)"
    >
    <TagFilter
      v-for="(value, key) in props.selectedFilters"
      :key="key"
      :filter="{label: value.nome_pt, value: value.permalink_pt }"
      :text="value.nome_pt"
      @remove-filter="removeQuery"
    />
    </div>
    <!-- filtered tag -->

    <!-- list -->
    <div class="grid grid-cols-12">
      <div class="col-span-12">
        <PagyPagination
          :noticias="props.noticias"
          :pagy="props.pagy"
          >
          <!-- :filters="props.filters" -->
        </PagyPagination>
      </div>
      <div class="hidden col-span-5 col-start-8">
        <p>Flamengo</p>
      </div>
    </div>
    <!-- list -->
  </TwContainer>
</template>

<style scoped>
/* transition vue component animation classes */
.slide-left-enter-active,
.slide-left-leave-active {
  transition: transform 0.3s ease;
}
.slide-left-enter-from,
.slide-left-leave-to {
  transform: translateX(-100%);
}

</style>
