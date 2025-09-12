<script setup>
import { defineAsyncComponent } from 'vue';

import IconChevronRight from '@/components/common/icons/navigation/IconChevronRight.vue';
import ButtonText from '@/components/common/buttons/ButtonText.vue';
const CarouselComponent = defineAsyncComponent(() => import('@/components/ui/CarouselComponent.vue'));

const props = defineProps({
  display_sinopse: String,
  imageURL: String,
  display_titulo: String,
  mostra_tag_class: String,
  mostra_name: String,
  carousel_images: Array,
})
</script>

<template>
  <div>
    <h3 class="text-overline text-neutrals-700 uppercase pb-200">sobre o filme</h3>
    <p class="text-body-regular text-neutrals-900">{{ props.display_sinopse }}</p>
    <div class="flex flex-col gap-400 py-400 items-center justify-center">
      <img
        :src="props.imageURL"
        class="h-[251px] w-[201px] object-cover"
        :alt="`${props.display_titulo} banner`"
        loading="lazy"
      >
      <!-- TRanslate website -->
      <ButtonText variant="dark" class="gap-200" text="Ver fotos de imprensa" tag="a">
        <template #icon>
          <IconChevronRight height="16" width="16" color="inherit order-2"/>
        </template>
      </ButtonText>
    </div>
    <div :class="`border-s-8 border-${props.mostra_tag_class} rounded-100 px-400 py-300 flex flex-col gap-200 col-span-2 h-fit`">
      <h2 class="text-header-medium-sm text-neutrals-900">{{ props.mostra_name }}</h2>
      <p class="text-body-regular text-neutrals-900">A Première Brasil é a mostra competitiva central do Festival do Rio, dedicada a filmes brasileiros inéditos que valorizam a diversidade de narrativas e refletem a realidade do país. Desde 1999, já apresentou mais de 1.300 títulos. Curtas e longas selecionados integram mostras competitivas e não competitivas, com as produções em disputa concorrendo ao Troféu Redentor na seleção principal ou na Première Brasil: Novos Rumos.</p>
    </div>

    <Suspense>
      <CarouselComponent :imageCollection="props.carousel_images" :class-names="['pt-800']" />
      <template #fallback>
        <div class="h-48 bg-gray-200 animate-pulse rounded pt-800"></div>
      </template>
    </Suspense>
  </div>
</template>

<style scoped></style>
