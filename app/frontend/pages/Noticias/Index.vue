<script setup>
import { usePage, router } from '@inertiajs/vue3'
import { ref } from 'vue';

import Breadcrumb from '@/components/common/Breadcrumb.vue';
import TwContainer from '@/components/layout/TwContainer.vue';
import SearchBar from '@/components/features/filters/SearchBar.vue';
import PagyPagination from '../PagyPagination.vue';

const props = defineProps({
  breadcrumbs: { type: Array, default: () => []},
  noticias: { type: Array, default: () => []},
  currentUrl: { type: String, default: '/pt/noticias'},
  searchQuery: { type: String, default: ''},
  pagy: { type: Object, required: true }
})

const page = usePage()
const searchQuery = ref(props.searchQuery)

const handleSearch = (modelV) => {
  // Get current locale from page props (set by ApplicationController)
  const locale = page.props.currentLocale || 'pt'
  console.log(modelV);

  router.get(`/${locale}/noticias`, {
    search: modelV
  }, {
    preserveState: true,
    replace: true
  })
}

const handleClear = () => {
  // clear search results
}
</script>

<template>
  <TwContainer>
    {{ console.log("Index.vue") }}
    {{ console.log(props.noticias) }}
    <SearchBar
      v-model="searchQuery"
      @search="handleSearch"
      @clear="handleClear"
    />
    <Breadcrumb  :crumbs="props.breadcrumbs"/>
    <PagyPagination
      :noticias="props.noticias"
      :pagy="props.pagy"
      >
      <!-- :filters="props.filters" -->
    </PagyPagination>
  </TwContainer>
</template>

<style scoped></style>
