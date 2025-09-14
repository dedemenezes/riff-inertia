<script setup>
import { computed } from 'vue';
const props = defineProps({
  header: { type: String, default: "direção"},
  pelicula: { type: Object, required: true }
})

// TODO: Think about sending it
// from controller in order
// to trasnlate keys. Those are used
// to display the team name in the view
const teams = computed(() => {
  return { roteiro: props.pelicula.roteiro_team,
    "direção": props.pelicula.diretor_team,
    fotografia: props.pelicula.fotografia_team,
    "Produção Empresa": props.pelicula.producaoempresa_team,
    montagem: props.pelicula.montagem_team
  }
})

console.log(props.pelicula);

</script>

<template>
  <div class="credito__card">
    <div class="py-600 md:pt-0">
      <h3 class="text-overline text-neutrals-700 uppercase pb-300">{{ header }}</h3>
      <!-- TODO: TRANSLATE -->
      <div class="card__director rounded-200 w-1/2">
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
      <div class="grid grid-cols-3" v-for="([name, members]) in Object.entries(teams)">
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
