<script setup>
// TODO: REFACTOR TO HAVE THE SAME STRUCTURE AS PROGRAM FOR FILTERS
// WE MUST FOLLOW ONE PATTERN ONLY OR I WILL GO CRAZY!

// 1. 📦 Node.js built-ins (if used)
// 2. 🔌 External packages (npm, libraries)
import { Head } from "@inertiajs/vue3";
// 3. 🧠 Internal libs/helpers/utilities

// 4. 🧩 Global components / shared UI
import TwContainer from "@/components/layout/TwContainer.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import TagFilter from "@/components/common/tags/TagFilter.vue";

// 5. 🧱 Feature-specific components
import MobileTrigger from "@/components/features/filters/MobileTrigger.vue";
import ResponsiveFilterMenu from "@/components/features/filters/ResponsiveFilterMenu.vue";
import NoticiasFilterForm from "@/components/features/filters/NoticiasFilterForm.vue";
import InfiniteScrollLayout from "@/components/layout/InfiniteScrollLayout.vue";
import IndexArticleCard from "@/components/common/cards/IndexArticleCard.vue";

import { useMobileTrigger } from "@/components/features/filters/composables/useMobileTrigger";
import { useSearchFilter } from "@/components/features/filters/composables/usaSearchFilter";

const props = defineProps({
  breadcrumbs: { type: Array, default: () => []},
  tabBaseUrl: { type: String, default: "MISSING" },
  dataLabel: { type: String, required: true },
  elements: { type: Array, default: () => []},
  cadernos: { type: Array, required: true },
  current_filters: { type: Object, default: () => {} },
  pagy: { type: Object, required: true }
})

const { isFilterMenuOpen, openMenu, closeMenu } = useMobileTrigger();

const { filters, filterSearch, removeQuery } = useSearchFilter(props)
console.log(filters);

</script>

<template>
  <!-- DEBUGGER -->
  <div v-if="false" class="bg-amarelo-200 p-2 mb-4 text-md text-neutrals-900">
    <p><strong>Noticias.Index current_filters:</strong> {{ current_filters }}</p>
  </div>
  <Head>
    <title>Noticias - Festival do Rio</title>
    <!-- TODO: Add metatags into all pages! -->
  </Head>
    <!-- <Breadcrumb  :crumbs="props.breadcrumbs"/> -->
  <TwContainer>
    <Breadcrumb :crumbs="props.breadcrumbs" />
  </TwContainer>
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
        <div
          class="hidden lg:flex gap-300 pt-200 pb-300 overflow-x-auto no-scroll-bar sticky top-0 z-10 bg-white"
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
        <InfiniteScrollLayout #content="{ allElements }"
          :elements="props.elements"
          :pagy="props.pagy"
        >
        <IndexArticleCard
          v-for="article in allElements"
          :key="article.id"
          :title="article.titulo"
          :permalink="article.permalink"
          :chamada="article.chamada"
          :imagem="article.imagem"
          :category="article.caderno_nome"
          :date="article.display_date"
        />
        </InfiniteScrollLayout>
      </div>
      <div class="col-start-8 col-span-6 sticky top-0 z-50">
        <div ref="sentinel" class="h-1"></div>
        <ResponsiveFilterMenu
          v-model="filters"
          :is-open="isFilterMenuOpen"
          @filters-applied="filterSearch"
          @close-filter-menu="closeMenu"
        >
          <template #filters="{ modelValue, updateField }">
            <NoticiasFilterForm
              :model-value="modelValue"
              :update-field="updateField"
              :data-label="props.dataLabel"
              :cadernos="props.cadernos"
            />
          </template>
        </ResponsiveFilterMenu>
      </div>
    </div>
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
