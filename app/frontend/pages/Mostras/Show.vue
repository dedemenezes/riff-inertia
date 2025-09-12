<script setup>
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import trofeuImagePath from "@assets/images/trofeu_redentor.png";
import { ref } from "vue";

import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from '@/components/ui/carousel'

const displayAllMostras = ref(false)

const refToFilmesSession = ref(null)

const toggleAllMostras = () => {
  displayAllMostras.value = !displayAllMostras.value
}

const scrollToFilmes = () => {
  refToFilmesSession.value?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

const props = defineProps({
  mostras: { type: Array, default: () => []},
  categoria: { type: String },
  tag_class: { type: String }
})

</script>

<template>
  <MenuContext
    nav="edicao"
    activePage="Mostras"
  />

  <TwContainer class="flex flex-col gap-1200">
    <!-- Title and Submostras -->
    <div class="grid lg:grid-cols-3 grid-cols-1 gap-800">
      <div :class="`border-s-8 border-${props.tag_class} rounded-100 px-400 py-300 flex flex-col gap-200 col-span-2 h-fit`">
        <h2 class="text-header-medium-sm">{{ props.categoria }}</h2>
        <p class="text-body-regular">A Première Brasil é a mostra competitiva central do Festival do Rio, dedicada a filmes brasileiros inéditos que valorizam a diversidade de narrativas e refletem a realidade do país. Desde 1999, já apresentou mais de 1.300 títulos. Curtas e longas selecionados integram mostras competitivas e não competitivas, com as produções em disputa concorrendo ao Troféu Redentor na seleção principal ou na Première Brasil: Novos Rumos.</p>
      </div>
      <div :class="`${ (props.mostras.length === 1) ? 'hidden' : '' } relative`">
        <div :class="`${ displayAllMostras ? '' : 'overflow-hidden fade-out h-[140px]' } flex flex-col gap-400`">
          <h3 class="text-body-strong-sm">Submostras</h3>
          <div class="flex flex-wrap gap-100 max-w-full">

            <span
              v-for="mostra in props.mostras"
              class="inline-flex max-w-[100%] inline-flex items-center px-200 py-100 border rounded-full border-neutrals-300 font-body text-xs text-neutrals-700 font-regular leading-[18px] truncate min-w-0"
              role="group"
            >
                <span class="flex-1 min-w-0 truncate">
                {{ mostra.nome_abreviado }}
              </span>
            </span>

          </div>
        </div>
        <button :class="`cursor-pointer absolute left-[50%] ${ displayAllMostras ? 'bottom-[-40px]' : 'bottom-[-20px]' } translate-[-50%] text-body-strong-sm flex gap-200`" @click="toggleAllMostras">
          {{ displayAllMostras ? 'Ver menos' : 'Ver mais' }} <IconCarretUp :class="displayAllMostras ? '' : 'rotate-180' "/>
        </button>
      </div>
    </div>

    <!-- Scroll to Filmes -->
    <div class="flex justify-center">
      <button :class="`cursor-pointer text-body-strong-sm flex gap-200`" @click="scrollToFilmes">
        Ver Filmes<IconCarretUp class="rotate-180"/>
      </button>
    </div>


    <!-- Carrousel -->
    <Carousel class="w-[100%]">
      <CarouselContent>
        <CarouselItem>
          <figure class="relative m-0 lg:h-[688px] h-[164px] p-600 flex flex-col justify-end">
            <img
              :src="trofeuImagePath" alt="Troféu Redentor"
              class="absolute inset-0 w-full h-full object-cover -z-1"
            >
            <h3 class="text-header-sm text-white-transp-1000 mt-max z-1">Troféu Redentor</h3>
          </figure>
        </CarouselItem>
        <CarouselItem>
          <figure class="relative m-0 lg:h-[688px] h-[164px] p-600 flex flex-col justify-end">
            <img
              :src="trofeuImagePath" alt="Troféu Redentor"
              class="absolute inset-0 w-full h-full object-cover -z-1"
            >
            <h3 class="text-header-sm text-white-transp-1000 mt-max z-1">Troféu Redentor</h3>
          </figure>
        </CarouselItem>
        <CarouselItem>
          <figure class="relative m-0 lg:h-[688px] h-[164px] p-600 flex flex-col justify-end">
            <img
              :src="trofeuImagePath" alt="Troféu Redentor"
              class="absolute inset-0 w-full h-full object-cover -z-1"
            >
            <h3 class="text-header-sm text-white-transp-1000 mt-max z-1">Troféu Redentor</h3>
          </figure>
        </CarouselItem>
      </CarouselContent>
      <CarouselPrevious class="translate-x-[56px] scale-70 lg:translate-x-0 lg:scale-100"/>
      <CarouselNext class="translate-x-[-56px] scale-70 lg:translate-x-0 lg:scale-100" />
    </Carousel>

    <!-- TODO: Completar sessão dos filmes aproveitando componente da programação -->
    <div ref="refToFilmesSession">
      <h2>Filmes</h2>
    </div>
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

  .fade-out {
    -webkit-mask-image: linear-gradient(to bottom, black 70%, transparent 100%);
    mask-image: linear-gradient(to bottom, black 70%, transparent 100%);
    -webkit-mask-size: 100% 100%;
    mask-size: 100% 100%;
  }
</style>
