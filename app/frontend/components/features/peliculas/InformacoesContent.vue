<script setup>
import { defineAsyncComponent } from 'vue';
import PeliculaCreditoCard from '@/components/common/cards/PeliculaCreditoCard.vue';
import PeliculaPosterCard from '@/components/common/cards/PeliculaPosterCard.vue';
const CarouselComponent = defineAsyncComponent(() => import('@/components/ui/CarouselComponent.vue'));

import { useUpdateWindowWidth } from '@/lib/utils';

const props = defineProps({
  pelicula: { type: Object, required: true },
})
const isDesktop =  useUpdateWindowWidth()
</script>

<template>
  <div class="space-y-600">
    <div class="">
      <h3 class="text-overline text-neutrals-700 uppercase pb-200">sobre o filme</h3>
      <p class="text-body-regular text-neutrals-900">{{ props.pelicula.display_sinopse }}</p>
    </div>

    <hr class="text-neutrals-300">

    <div v-if="isDesktop">
      <!-- desktop display policula creditos -->
      <PeliculaCreditoCard
        header="direção"
        :pelicula="props.pelicula"
      />
    </div>
    <!-- mobile display pelicula poster -->
    <div v-else>
      <PeliculaPosterCard :pelicula="props.pelicula" />
    </div>

    <hr class="text-neutrals-300">

    <div :class="`border-s-8 border-${props.pelicula.mostra_tag_class} rounded-100 px-400 py-300 flex flex-col gap-200 col-span-2 h-fit`">
      <h2 class="text-header-medium-sm text-neutrals-900">{{ props.pelicula.mostra_name }}</h2>
      <!-- todo: mostra description?? -->
      <p class="text-body-regular text-neutrals-900">A Première Brasil é a mostra competitiva central do Festival do Rio, dedicada a filmes brasileiros inéditos que valorizam a diversidade de narrativas e refletem a realidade do país. Desde 1999, já apresentou mais de 1.300 títulos. Curtas e longas selecionados integram mostras competitivas e não competitivas, com as produções em disputa concorrendo ao Troféu Redentor na seleção principal ou na Première Brasil: Novos Rumos.</p>
    </div>

    <div></div>
    <Suspense>
      <CarouselComponent v-if="!isDesktop" :imageCollection="props.pelicula.carousel_images" :class-names="['pt-800']" />
      <template #fallback>
        <div class="h-48 bg-gray-200 animate-pulse rounded pt-800"></div>
      </template>
    </Suspense>
  </div>
</template>

<style scoped></style>
