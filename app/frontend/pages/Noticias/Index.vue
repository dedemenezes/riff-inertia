<script setup>
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import PagyPagination from "../PagyPagination.vue";
import NavbarSecondary from "@/components/layout/navbar/NavbarSecondary.vue";
import MobileFilterMenu from "@/components/features/filters/MobileFilterMenu.vue";
import NoticiasFilterForm from "@/components/features/filters/NoticiasFilterForm.vue";
import { watch, ref, nextTick } from "vue"
import { router } from "@inertiajs/vue3";
import MobileTrigger from "@/components/features/filters/MobileTrigger.vue";
import TagFilter from "@/components/common/tags/TagFilter.vue";

const props = defineProps({
  cadernos: { type: Array },
  mainItems: { type: Array },
  secondaryItems: { type: Array },
  breadcrumbs: { type: Array, default: () => []},
  noticias: { type: Array, default: () => []},
  // searchQuery: { type: String, default: ""},
  selectedFilters: { type: Object },
  pagy: { type: Object, required: true }
})

// 📦 UI state - mobile filter menu open/close
const isFilterMenuOpen = ref(false);

// 👇 DOM side effect - lock scroll when menu is open
const openMenu = () => {
  console.log(filters.value);
  console.log(props.selectedFilters);

  isFilterMenuOpen.value = true;
  document.body.style.overflow = "hidden";
};

// 👇 DOM side effect - unlock scroll when menu closes
const closeMenu = () => {
  isFilterMenuOpen.value = false;
  document.body.style.overflow = "";
};
// para mostrar é label, value

const filters = ref({ ...props.selectedFilters})



// Watch for prop changes and sync local state
watch(
  () => props.selectedFilters,
  (newSelectedFilters) => {
    filters.value = { ...newSelectedFilters };
  },
  { deep: true }
);

const filterSearch = () => {
  console.log("TODO: MAKE SEARCH");
  const params = new URLSearchParams();

  for (const [key, value] of Object.entries(filters.value)) {
    if (value && typeof value === "object" && value.permalink_pt) {
      params.append(key, value.permalink_pt);
    }
  }
  router.visit(`/noticias?${params.toString()}`, {
    preserveScroll: true,
    preserveState: true,
    only: [ "noticias", "selectedFilters" ]
  })
}

const removeQuery = (item) => {
  const currentUrl = new URL(window.location.href);
  const params = currentUrl.searchParams;

  let newFilters = { ...filters.value };

  for (const [key, value] of params.entries()) {
    if (value === item) {
      params.delete(key);
    }
  }

  for (const [filterKey, filterValue] of Object.entries(filters.value)) {
    if (filterValue && filterValue.permalink_pt === item) {
      newFilters[filterKey] = null;
    }
  }

  // Assign whole object to trigger reactivity
  filters.value = newFilters;

  const newUrl = `${currentUrl.pathname}?${params.toString()}`

  router.visit(newUrl, {
    preserveScroll: true,
    preserveState: false,
    only: [ "noticias", "selectedFilters" ]
  })
}

const clearSearchQuery = () => {
  const currentUrl = new URL(window.location.href);
  // debugger
  const hasUrlParams = currentUrl.searchParams.toString() !== "";

  if (!hasUrlParams) {
    // console.log("Already clean - no request needed");
    return;
  }

  // console.log("TODO: CLEAN SEARCH");

  router.visit(`/noticias`, {
    preserveScroll: true,
    preserveState: true,
    only: [ "noticias", "selectedFilters" ]
  })
}
</script>

<template>
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
        v-model="filters"
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
      class="flex gap-300 pt-300 pb-400"
      v-show="Object.values(filters).some((item) => item !== null)"
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
