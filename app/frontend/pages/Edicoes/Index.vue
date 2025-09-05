<script setup>
import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import Cartaz from "@/components/common/cards/Cartaz.vue";

const props = defineProps({
  items: { type: Array, required: true },
  edicoes: { type: Array, default: () => []}
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
    <ul class="poster-grid py-1200 gap-800">
      <Cartaz
        v-for="edicao in props.edicoes" :key="edicao.id"
        :cartaz="`https://s3.amazonaws.com/festivaldorio/imagens/edicoes/small/${edicao.cartaz}`"
        :descricao="edicao.descricao"
      />
    </ul>
  </TwContainer>
</template>

<style scoped>
  .poster-grid {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr 1fr 1fr 1fr;
  }
</style>
