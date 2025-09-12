<script setup>
import { defineAsyncComponent } from 'vue';
const PeliculaSession = defineAsyncComponent(() => import('@/components/common/cards/PeliculaSessionCard.vue'));
const BaseButton = defineAsyncComponent(() => import('@/components/common/buttons/BaseButton.vue'));
</script>

<template>
  <BaseButton variant="dark" class="w-full">Comprar pacote de ingressos</BaseButton>

  <div v-for="(item, index) in [1,2,3]">
    <PeliculaSession class="mb-400" />
    <hr v-show="index < 2" class="text-neutrals-300">
  </div>
</template>

<style scoped></style>
