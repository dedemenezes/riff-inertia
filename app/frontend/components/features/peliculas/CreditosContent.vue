<script setup>
const props = defineProps({
  director_image: { type: String, required: true },
  diretor_coord_int: { type: String, required: true },
  diretor_coord_int: { type: String, required: true },
  roteiro_team: { type: Array, required: true },
  fotografia_team: { type: Array, required: true },
  montagem_team: { type: Array, required: true },
  diretor_team: { type: Array, required: true },
  producaoempresa_team: { type: Array, required: true },
})

</script>

<template>
  <div class="py-600 md:pt-0">
    <h3 class="text-overline text-neutrals-700 uppercase pb-300">DIREÇÃO</h3>
    <!-- TODO: TRANSLATE -->
    <div class="card__director rounded-200 w-1/2">
      <img
        :src="props.director_image"
        :alt="`Foto de ${props.diretor_coord_int}`"
        class="h-[154px] w-full object-cover object-top rounded-t-200"
        loading="lazy"
      >
      <div class="card__content bg-neutrals-200 rounded-200 ps-200 py-250">
        <p class="text-header-md text-neutrals-900">{{ props.diretor_coord_int }}</p>
      </div>
    </div>
  </div>
  <hr class="text-neutrals-300">
  <div class="space-y-400 pt-400">
    <div class="grid grid-cols-3">
      <p class="text-overline text-neutrals-700 uppercase pb-200">roteiro</p>
      <ul class="col-span-2 flex flex-col">
        <li
          v-for="member in props.roteiro_team"
          :key="member"
        >
          <p class="text-body-regular">{{ member }}</p>
        </li>
      </ul>
    </div>
    <div class="grid grid-cols-3">
      <p class="text-overline text-neutrals-700 uppercase pb-200">fotografia</p>
      <ul class="col-span-2 flex flex-col">
        <li
          v-for="member in props.fotografia_team"
          :key="member"
        >
          <p class="text-body-regular">{{ member }}</p>
        </li>
      </ul>
    </div>
    <div class="grid grid-cols-3">
      <p class="text-overline text-neutrals-700 uppercase pb-200">montagem</p>
      <ul class="col-span-2 flex flex-col">
        <li
          v-for="member in props.montagem_team"
          :key="member"
        >
          <p class="text-body-regular">{{ member }}</p>
        </li>
      </ul>
    </div>
    <div class="grid grid-cols-3">
      <p class="text-overline text-neutrals-700 uppercase pb-200">direção</p>
      <ul class="col-span-2 flex flex-col">
        <li
          v-for="member in props.diretor_team"
          :key="member"
        >
          <p class="text-body-regular">{{ member }}</p>
        </li>
      </ul>
    </div>
    <div class="grid grid-cols-3">
      <p class="text-overline text-neutrals-700 uppercase pb-200">direção</p>
      <ul class="col-span-2 flex flex-col">
        <li
          v-for="member in props.producaoempresa_team"
          :key="member"
        >
          <p class="text-body-regular text-neutrals-900">{{ member }}</p>
        </li>
      </ul>
    </div>

  </div>
</template>

<style scoped></style>
