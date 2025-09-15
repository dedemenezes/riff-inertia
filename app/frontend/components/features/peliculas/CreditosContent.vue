<script setup>
import { useUpdateWindowWidth } from '@/lib/utils';
import { defineAsyncComponent } from 'vue';

const PeliculaCreditoCard = defineAsyncComponent(() => import('@/components/common/cards/PeliculaCreditoCard.vue'));
const PeliculaPosterCard = defineAsyncComponent(() => import('@/components/common/cards/PeliculaPosterCard.vue'));

const props = defineProps({
  pelicula: { type: Object, required: true}
})

const isDesktop = useUpdateWindowWidth()
console.log(isDesktop.value);

</script>

<template>
  <div v-if="isDesktop">
    <PeliculaPosterCard :pelicula="props.pelicula" />
  </div>
  <div v-else>
    <PeliculaCreditoCard
      :header="props.pelicula.displayTeamsHeader"
      :pelicula="props.pelicula"
    />
  </div>
</template>

<style scoped></style>
