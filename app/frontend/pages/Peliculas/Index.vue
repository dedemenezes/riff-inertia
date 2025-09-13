<script setup>
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import PeliculaCard from "@/components/common/cards/PeliculaCard.vue";
import SearchBar from "@/components/features/filters/SearchBar.vue";
import { reactive } from "vue";


const props = defineProps({
  peliculas: { type: Array, default: () => []},
  crumbs: { type: Array, required: true, default: () => []}
})

const peliculas = reactive([...props.peliculas])

const filterPeliculas = (value) => {
  const v = value.trim().toLowerCase()
  const filtered = props.peliculas.filter(pelicula =>
    pelicula.display_titulo.toLowerCase().startsWith(v)
  )
  peliculas.splice(0, peliculas.length, ...filtered)
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
      class="py-400"
      @input="filterPeliculas"
    />
  </TwContainer>

  <hr class="text-neutrals-300">

  <TwContainer>
    <ul class="grid grid-cols-1 lg:grid-cols-3 py-1200 gap-800">
      <PeliculaCard
        v-for="pelicula in peliculas"
        :pelicula="pelicula"
      />
    </ul>
  </TwContainer>
</template>

<style scoped></style>
