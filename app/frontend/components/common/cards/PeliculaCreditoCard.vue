<script setup>
const props = defineProps({
  header: { type: String, default: "direção"},
  pelicula: { type: Object, required: true }
})
</script>

<template>
  <!-- Debug info -->
  <div v-if="false" class="bg-amarelo-200 p-2 mb-4 text-xs">
    <p><strong>PeliculaCreditoCard teams :</strong> {{ teams }} </p>
    <p><strong>PeliculaCreditoCard teamsfromController :</strong> {{ props.pelicula.teams }} </p>
  </div>
  <div class="credito__card">
    <div class="pb-600">
      <h3 class="text-overline text-neutrals-700 uppercase pb-300">{{ header }}</h3>
      <!-- TODO: TRANSLATE -->
      <div class="card__director rounded-200 w-1/2 sm:w-1/3">
        <img
          :src="pelicula.director_image"
          :alt="`Foto de ${pelicula.diretor_coord_int}`"
          class="h-[154px] w-full object-cover object-top rounded-t-200"
          loading="lazy"
        >
        <div class="card__content bg-neutrals-200 rounded-200 ps-200 py-250">
          <p class="text-header-md text-neutrals-900">{{ pelicula.diretor_coord_int }}</p>
        </div>
      </div>
    </div>
    <hr class="text-neutrals-300">
    <div class="space-y-400 pt-400">
      <!-- { roteiro: [], fotografia: [], montagem: [],  direção: [], producaoempresa: []} -->
      <div class="grid grid-cols-4" v-for="([name, members]) in Object.entries(props.pelicula.teams)">
        <p class="text-overline text-neutrals-700 uppercase pb-200">{{ name }}</p>
        <ul class="col-span-2 flex flex-col">
          <li v-for="member in members" :key="member">
            <p class="text-body-regular">{{ member }}</p>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
