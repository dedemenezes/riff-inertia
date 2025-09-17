<script setup>
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import PeliculaCard from "@/components/common/cards/PeliculaCard.vue";
import SearchBar from "@/components/features/filters/SearchBar.vue";
import InfiniteScrollLayout from "@/components/layout/InfiniteScrollLayout.vue";
import { ref, reactive } from "vue";
import { router } from '@inertiajs/vue3';

const props = defineProps({
  elements: { type: Array, default: () => []},
  crumbs: { type: Array, required: true, default: () => []},
  pagy: { type: Object, required: true }
})

const allElements = reactive([...props.elements])

const inputValue = ref("")
const search = (value) => {
  const url = new URL(window.location.href).pathname

  const query = `?query=${value}`
  const newUrl = url + query

  router.visit(newUrl, {
    method: 'get',
    only: ['elements', 'pagy'],
    preserveState: true,
    preserveScroll: true,
    replace: true,
    onSuccess: (page) => {
      const newElements = page.props.elements || []

      allElements.value = newElements
    },
    onError: () => {
      console.error('Failed to load more content')
    }
  })
}
</script>

<template>
  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
  </TwContainer>
  <MenuContext
    nav="edicao"
  />

  <TwContainer
    class="grid grid-cols-1 lg:grid-cols-3 gap-800"
  >
    <SearchBar
      v-model="inputValue"
      @search="search"
      class="py-400"
    />
  </TwContainer>

  <hr class="text-neutrals-300">

  <TwContainer>
    <ul>
      <InfiniteScrollLayout #content="{ allElements }"
          :elements="props.elements"
          :pagy="props.pagy"
          class="grid grid-cols-1 lg:grid-cols-3 py-1200 gap-800"
        >
        <PeliculaCard
          v-for="pelicula in allElements"
          :pelicula="pelicula"
        />
      </InfiniteScrollLayout>
    </ul>
  </TwContainer>
</template>

<style scoped></style>
