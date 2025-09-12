<script setup>
import { defineAsyncComponent } from 'vue';
import BaseButton from '@/components/common/buttons/BaseButton.vue';
const PeliculaSession = defineAsyncComponent(() => import('@/components/common/cards/PeliculaSessionCard.vue'));
</script>
<!-- TODO: TRADUZIR -->
<template>
  <BaseButton variant="dark" class="w-full">Comprar pacote de ingressos</BaseButton>

  <div v-for="(item, index) in [1,2,3]">
    <PeliculaSession class="mb-400" />
    <hr v-show="index < 2" class="text-neutrals-300">
  </div>
</template>

<style scoped></style>
