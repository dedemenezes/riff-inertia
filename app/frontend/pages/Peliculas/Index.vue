<script setup>
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import PeliculaCard from "@/components/common/cards/PeliculaCard.vue";


const props = defineProps({
  peliculas: { type: Array, default: () => []},
  crumbs: { type: Array, required: true, default: () => []}
})

</script>

<template>
  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
  </TwContainer>
  <MenuContext
    nav="edicao"
  />
  <hr class="text-neutrals-300">

  <TwContainer>
    <ul class="grid grid-cols-2 lg:grid-cols-3 py-1200 gap-800">
      <PeliculaCard
        v-for="pelicula in props.peliculas"
        :pelicula="pelicula"
      />
    </ul>
  </TwContainer>
</template>

<style scoped></style>
