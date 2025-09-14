<script setup>
import { defineAsyncComponent } from 'vue';
import BaseButton from '@/components/common/buttons/BaseButton.vue';
const PeliculaSessionCard = defineAsyncComponent(() => import('@/components/common/cards/PeliculaSessionCard.vue'));
const props = defineProps({
  sessions: { type: Array, default: () => [] }
})
</script>
<!-- TODO: TRADUZIR -->
<template>
  <BaseButton variant="dark" class="w-full">Comprar pacote de ingressos</BaseButton>
  <div v-for="(session, index) in props.sessions">
    <PeliculaSessionCard class="mb-400" :session="session" />
    <hr v-show="index < 2" class="text-neutrals-300">
  </div>
</template>

<style scoped></style>
