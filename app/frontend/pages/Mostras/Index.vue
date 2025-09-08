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
  <!-- TODO: alterar a imagem do card -->
  <!-- TODO: linkar para o show de mostras -->
  <MenuContext
    :items="props.items"
    :icon-mapping="iconMapping"
  />
  <hr class="text-neutrals-300">

  <TwContainer>
    <ul class="grid grid-cols-1 lg:grid-cols-2 py-1200 gap-800">
      <li v-for="mostra in props.mostras" :class="`border-s-30 border-${mostra.tag_class} rounded-lg overflow-hidden lg:h-[320px] h-[206px]`">
        <figure class="relative m-0 h-full p-600 flex flex-col justify-end">
          <img
            class="absolute inset-0 w-full h-full object-cover -z-1"
            src="https://s3.amazonaws.com/festivaldorio/2024/site/peliculas/original/mals_f01cor_2024113147.jpg"
            :alt="mostra.nome_pt"
          >
          <h1 class="text-white-transp-1000 mt-max text-header-regular-md z-1">{{ mostra.nome_pt }}</h1>
        </figure>
      </li>
    </ul>
  </TwContainer>
</template>

<style scoped>
figure::after {
    position: absolute;
    content: "";
    height: 100%;
    width: 100%;
    top: 0;
    left: 0;
    background: linear-gradient(180deg, rgba(0, 0, 0, 0.30) 73.08%, rgba(0, 0, 0, 0.64) 100%);
  }
</style>
