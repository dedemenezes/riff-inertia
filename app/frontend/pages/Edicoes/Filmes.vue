<script setup>
import { computed, ref } from "vue";
import { router } from "@inertiajs/vue3";

import EdicaoHeader from "@/components/common/EdicaoHeader.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import SearchBar from "@/components/features/filters/SearchBar.vue";
import SearchFilter from "@/components/features/filters/SearchFilter.vue";
import MostrasFilterForm from "@/components/features/filters/MostrasFilterForm.vue";
import InfiniteScrollLayout from "@/components/layout/InfiniteScrollLayout.vue";
import PeliculaCard from "@/components/common/cards/PeliculaCard.vue";
import TagFilter from "@/components/common/tags/TagFilter.vue";
import { IconArrowDown, IconFilter, IconClose } from "@/components/common/icons";
import { extractFilterValues } from "@/lib/filterUtils";
import { simpleTranslation } from "@/lib/utils";
import { useSearchFilter } from "@/components/features/filters/composables/usaSearchFilter";

const props = defineProps({
  edicao: { type: Object, required: true },
  elements: { type: Array, default: () => [] },
  pagy: { type: Object, required: true },
  submostras: { type: Array, default: () => [] },
  paises: { type: Array, default: () => [] },
  genres: { type: Array, default: () => [] },
  directors: { type: Array, default: () => [] },
  actors: { type: Array, default: () => [] },
  current_filters: { type: Object, default: () => ({}) },
  has_active_filters: { type: Boolean, default: false },
  sort: { type: String, default: "asc" },
  tabBaseUrl: { type: String, required: true },
  fallBackUrl: { type: String, required: true },
  endMessage: { type: String, required: true },
  activePage: { type: String, required: true },
});

// Only the listing props change on search/sort/filter; everything else (filter
// options, menu, edicao) stays put.
const PROPS_TO_UPDATE = ["elements", "pagy", "current_filters", "has_active_filters"];

// `filters` mirrors the server's current_filters and is the source of truth for
// the drawer form. Sort is kept locally (page-owned) per design decision.
const { filters } = useSearchFilter(props);
const sortDir = ref(props.sort === "desc" ? "desc" : "asc");
const isFilterOpen = ref(false);

// Single navigation entry point so sort + active filters always travel together
// (and land in the URL, which InfiniteScrollLayout reads when loading more).
const navigate = () => {
  router.get(
    props.tabBaseUrl,
    { ...extractFilterValues(filters.value), sort: sortDir.value },
    { only: PROPS_TO_UPDATE, preserveScroll: true, preserveState: true, replace: true },
  );
};

const searchText = computed({
  get: () => filters.value.query?.filter_value || "",
  set: (value) => {
    filters.value.query = value
      ? { filter_display: value, filter_value: value, filter_label: "Busca" }
      : null;
  },
});

const onClearQuery = () => {
  filters.value.query = null;
  navigate();
};

const toggleSort = () => {
  sortDir.value = sortDir.value === "asc" ? "desc" : "asc";
  navigate();
};

const onFiltersApplied = () => {
  isFilterOpen.value = false;
  navigate();
};

const onFiltersCleared = () => {
  navigate();
};

const activeFilters = computed(() =>
  Object.entries(props.current_filters).filter(([, value]) => value != null),
);

const onRemoveFilter = (filter) => {
  for (const key of Object.keys(filters.value)) {
    if (filters.value[key]?.filter_value === filter.filter_value) {
      filters.value[key] = null;
    }
  }
  navigate();
};
</script>

<template>
  <TwContainer>
    <EdicaoHeader :edicao="edicao" :fallBackUrl="fallBackUrl" />
  </TwContainer>
  <MenuContext nav="edicoes_anteriores" :active-page="activePage" />
  <hr class="text-neutrals-300" />

  <!-- Bar/filtro -->
  <TwContainer>
    <div
      class="flex flex-col gap-400 py-400 md:flex-row md:items-center md:justify-between"
    >
      <SearchBar
        v-model="searchText"
        @search="navigate"
        @clear="onClearQuery"
        class="w-full md:max-w-[454px]"
      />

      <div class="flex items-center justify-end gap-800">
        <button
          type="button"
          @click="toggleSort"
          class="cursor-pointer flex items-center gap-200 p-200 text-body-strong-sm text-neutrals-900"
        >
          <IconArrowDown :className="sortDir === 'desc' ? 'up' : ''" />
          {{ sortDir === "asc" ? "A–Z" : "Z–A" }}
        </button>

        <button
          type="button"
          @click="isFilterOpen = true"
          class="cursor-pointer flex items-center gap-200 p-200 text-body-strong-sm text-neutrals-900"
        >
          <IconFilter height="16px" width="16px" color="inherit" />
          <span>{{ simpleTranslation("Filtros", "Filters") }}</span>
        </button>
      </div>
    </div>
  </TwContainer>

  <!-- Active filters -->
  <TwContainer
    v-if="activeFilters.length"
    class="flex gap-300 pb-300 overflow-x-auto no-scroll-bar"
  >
    <TagFilter
      v-for="[key, value] in activeFilters"
      :key="key"
      :filter="value"
      :text="value.filter_display"
      @remove-filter="onRemoveFilter"
    />
  </TwContainer>

  <hr class="text-neutrals-300" />

  <!-- Films grid -->
  <TwContainer>
    <InfiniteScrollLayout
      #content="{ allElements }"
      :elements="elements"
      :pagy="pagy"
      :end-message="endMessage"
    >
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 py-1200 gap-800">
        <PeliculaCard
          v-for="pelicula in allElements"
          :key="pelicula.url"
          :pelicula="pelicula"
          :linkable="false"
        />
      </div>
    </InfiniteScrollLayout>
  </TwContainer>

  <!-- Filters drawer -->
  <Teleport to="body">
    <div v-show="isFilterOpen">
      <div
        class="fixed inset-0 z-40 bg-black/40"
        @click="isFilterOpen = false"
      ></div>

      <div
        class="fixed inset-y-0 right-0 z-50 bg-white flex flex-col w-full max-w-full h-[100dvh] shadow-lg md:max-w-[420px]"
      >
        <TwContainer class="h-full">
          <div class="flex flex-col h-full">
            <div
              class="shrink-0 flex justify-between items-center py-400 sticky top-0 bg-white-transp-1000 z-50"
            >
              <p class="text-header-sm text-neutrals-900 uppercase">
                {{ simpleTranslation("Filtros", "Filters") }}
              </p>
              <button
                type="button"
                @click="isFilterOpen = false"
                class="cursor-pointer text-neutrals-900"
                :aria-label="simpleTranslation('Fechar filtros', 'Close filters')"
              >
                <IconClose height="32px" width="32px" />
              </button>
            </div>

            <div class="flex-grow flex flex-col justify-between">
              <SearchFilter
                :modelValue="filters"
                @update:modelValue="filters = $event"
                @filters-applied="onFiltersApplied"
                @filters-cleared="onFiltersCleared"
                @close-filter-menu="isFilterOpen = false"
              >
                <template #filters="searchFilterProps">
                  <MostrasFilterForm
                    :model-value="searchFilterProps.modelValue"
                    :update-field="searchFilterProps.updateField"
                    :submostras="submostras"
                    :paises="paises"
                    :genres="genres"
                    :directors="directors"
                    :actors="actors"
                  />
                </template>
              </SearchFilter>
            </div>
          </div>
        </TwContainer>
      </div>
    </div>
  </Teleport>
</template>

<style scoped></style>
