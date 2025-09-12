<script setup>
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import Cartaz from "@/components/common/cards/Cartaz.vue";

const props = defineProps({
  edicoes: { type: Array, default: () => []}
})

</script>

<template>
  <MenuContext
    nav="sobre"
  />
  <hr class="text-neutrals-300">

  <TwContainer>
    <ul class="grid grid-cols-2 lg:grid-cols-6 py-1200 gap-800">
      <Cartaz
        v-for="edicao in props.edicoes" :key="edicao.id"
        :cartaz="`https://s3.amazonaws.com/festivaldorio/imagens/edicoes/small/${edicao.cartaz}`"
        :descricao="edicao.descricao"
      />
    </ul>
  </TwContainer>
</template>

<style scoped></style>
