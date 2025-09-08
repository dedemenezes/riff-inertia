<script setup>
import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";


const props = defineProps({
  items: { type: Array, required: true },
  mostras: { type: Array, default: () => []}
})

// TODO: alterar icones
const iconMapping = {
  "program": IconProgram,
  "user": IconNewUser,
  "change": IconChange,
  "clock": IconClock
};
</script>

<template>
  <MenuContext
    :items="props.items"
    :icon-mapping="iconMapping"
  />
  <hr class="text-neutrals-300">

  <TwContainer>
    <ul class="grid grid-cols-1 lg:grid-cols-2 py-1200 gap-800">
      <li v-for="mostra in props.mostras" :class="`border-s-30 bg-${mostra.tag_class}`">
        <figure>
          <img src="https://s3.amazonaws.com/festivaldorio/2024/site/peliculas/large/suzhour_f01cor_2024113912.jpg" :alt="mostra.nome_pt">
        </figure>
      </li>
    </ul>
  </TwContainer>
</template>

<style scoped></style>
