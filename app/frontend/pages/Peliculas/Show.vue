<!-- const ComboboxComponent = defineAsyncComponent(() => import('@/components/ui/ComboboxComponent.vue')) -->
<script setup>
import { ref, defineAsyncComponent } from 'vue';
import { usePage } from '@inertiajs/vue3';
import PeliculaSession from '@/components/common/cards/PeliculaSessionCard.vue';
import CarouselComponent from '@/components/ui/CarouselComponent.vue';

const Breadcrumb = defineAsyncComponent(() => import('@/components/common/Breadcrumb.vue'));
const ButtonText = defineAsyncComponent(() => import('@/components/common/buttons/ButtonText.vue'));
const BaseButton = defineAsyncComponent(() => import('@/components/common/buttons/BaseButton.vue'));
const IconChevronLeft = defineAsyncComponent(() => import('@/components/common/icons/navigation/IconChevronLeft.vue'));
const IconChevronRight = defineAsyncComponent(() => import('@/components/common/icons/navigation/IconChevronRight.vue'));
const TwContainer = defineAsyncComponent(() => import('@/components/layout/TwContainer.vue'));
const TagMostra = defineAsyncComponent(() => import('@/components/common/tags/TagMostra.vue'));
const TabbedPanel = defineAsyncComponent(() => import('@/components/common/tabs/TabbedPanel.vue'));
const page = usePage()

const props = defineProps({
  rootUrl: { type: String, required: true },
  crumbs: { type: Array, required: true, default: () => []},
  pelicula: { type: Object, required: true }
});


const tabs = [
  { id: 'informacoes', label: 'Informações' },
  { id: 'sessoes', label: 'Sessões' },
  { id: 'creditos', label: 'Créditos' }
]
const activeTab = ref(tabs[2].id)
</script>

<template>
  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
    <!-- TODO: Translate back text instalar i18n vue -->

    <!-- back link -->
    <ButtonText variant="dark" class="gap-200 py-400" text="Voltar" tag="a">
      <template #icon>
        <IconChevronLeft height="16" width="16" color="inherit"/>
      </template>
    </ButtonText>
  </TwContainer>
  <!-- banner image -->
  <img :src="props.pelicula.imageURL" class="h-[222px] object-cover" :alt="`${pelicula.display_titulo} banner`">
  <!-- short info card -->
  <header>
    <div class="bg-neutrals-200">
      <TwContainer>
        <div class="py-400 space-y-400">
          <section>
            <h1 class="text-header-medium-sm pb-100">{{ props.pelicula.titulo_portugues_coord_int }}</h1>
            <h2 class="text-body-regular italic">{{ props.pelicula.titulo_ingles_coord_int }}</h2>
          </section>
          <div class="flex items-center gap-200 flex-wrap">
            <p class="text-overline shrink-0">{{ props.pelicula.display_paises }}</p>
            <img
              src="@assets/icons/divisor_black.svg"
              alt=""
              aria-hidden="true"
              class="h-[16px] select-none"
            />
            <p class="text-overline">{{ props.pelicula.ano_coord_int }}</p>
            <img
              src="@assets/icons/divisor_black.svg"
              alt=""
              aria-hidden="true"
              class="h-[16px] select-none"
            />
            <p class="text-overline">{{ props.pelicula.genre }}</p>
            <img
              src="@assets/icons/divisor_black.svg"
              alt=""
              aria-hidden="true"
              class="h-[16px] select-none"
            />
            <p class="text-overline">{{ props.pelicula.duracao_coord_int }}</p>
            <img
              src="@assets/icons/divisor_black.svg"
              alt=""
              aria-hidden="true"
              class="h-[16px] select-none"
            />
            <p class="text-overline">{{ props.pelicula.cor_coord_int }}</p>
          </div>
          <TagMostra
            class="rounded-100"
            :tag-class="props.pelicula.mostra_tag_class"
            :text="props.pelicula.mostra_name"
          />
        </div>
      </TwContainer>
    </div>
  </header>
     <!-- Tabs -->
  <TwContainer>

    <TabbedPanel v-model="activeTab" :tabs="tabs" class="py-400 justify-center" />

    <!-- EACH SHOULD BE A COMPONENT LAZY LOADED -->
    <div class="flex flex-col gap-6 sm:flex-row sm:gap-4 py-600">

      <!--  || isDesktop -->
      <section v-show="activeTab === 'informacoes'" class="w-full sm:w-1/3">
        <h3 class="text-overline text-neutrals-700 uppercase pb-200">sobre o filme</h3>
        <p class="text-body-regular text-neutrals-900">{{ props.pelicula.display_sinopse }}</p>
        <div class="flex flex-col gap-400 py-400 items-center justify-center">
          <img :src="props.pelicula.imageURL" class="h-[251px] w-[201px] object-cover" :alt="`${pelicula.display_titulo} banner`">
          <!-- TRanslate website -->
          <ButtonText variant="dark" class="gap-200" text="Ver fotos de imprensa" tag="a">
            <template #icon>
              <IconChevronRight height="16" width="16" color="inherit order-2"/>
            </template>
          </ButtonText>
        </div>
        <div :class="`border-s-8 border-${props.pelicula.mostra_tag_class} rounded-100 px-400 py-300 flex flex-col gap-200 col-span-2 h-fit`">
          <h2 class="text-header-medium-sm">{{ props.pelicula.mostra_name }}</h2>
          <p class="text-body-regular">A Première Brasil é a mostra competitiva central do Festival do Rio, dedicada a filmes brasileiros inéditos que valorizam a diversidade de narrativas e refletem a realidade do país. Desde 1999, já apresentou mais de 1.300 títulos. Curtas e longas selecionados integram mostras competitivas e não competitivas, com as produções em disputa concorrendo ao Troféu Redentor na seleção principal ou na Première Brasil: Novos Rumos.</p>
        </div>

        <CarouselComponent
          :imageCollection="props.pelicula.carousel_images"
          :class-names="['pt-800']"
        />
      </section>

      <section v-show="activeTab === 'sessoes'" class="w-full sm:w-1/3 space-y-400">
        <BaseButton variant="dark" class="w-full">Comprar pacote de ingressos</BaseButton>

        <div v-for="(item, index) in [1,2,3]">
          <PeliculaSession class="mb-400" />
          <hr v-show="index < 2" class="text-neutrals-300">
        </div>
      </section>

      <section v-show="activeTab === 'creditos'" class="w-full sm:w-1/3">
        <!-- EACH SHOULD BE A COMPONENT LAZY LOADED -->
        <div class="py-600">
          <h3 class="text-overline text-neutrals-700 uppercase pb-300">DIREÇÃO</h3>
          <!-- TODO: TRANSLATE -->
          <div class="card__director rounded-200 w-1/2">
            <img
              :src="props.pelicula.director_image"
              :alt="`Foto de ${props.pelicula.diretor_coord_int}`"
              class="h-[154px] w-full object-cover object-top rounded-t-200"
            >
            <div class="card__content bg-neutrals-200 rounded-200 ps-200 py-250">
              <p class="text-header-md text-neutrals-900">{{ props.pelicula.diretor_coord_int }}</p>
            </div>
          </div>
        </div>
        <hr class="text-neutrals-300">
        <div class="space-y-400 pt-400">
          <div class="grid grid-cols-3">
            <p class="text-overline text-neutrals-700 uppercase pb-200">roteiro</p>
            <ul class="col-span-2 flex flex-col">
              <li
                v-for="member in props.pelicula.roteiro_team"
                :key="member"
              >
                <p class="text-body-regular">{{ member }}</p>
              </li>
            </ul>
          </div>
          <div class="grid grid-cols-3">
            <p class="text-overline text-neutrals-700 uppercase pb-200">fotografia</p>
            <ul class="col-span-2 flex flex-col">
              <li
                v-for="member in props.pelicula.fotografia_team"
                :key="member"
              >
                <p class="text-body-regular">{{ member }}</p>
              </li>
            </ul>
          </div>
          <div class="grid grid-cols-3">
            <p class="text-overline text-neutrals-700 uppercase pb-200">montagem</p>
            <ul class="col-span-2 flex flex-col">
              <li
                v-for="member in props.pelicula.montagem_team"
                :key="member"
              >
                <p class="text-body-regular">{{ member }}</p>
              </li>
            </ul>
          </div>
          <div class="grid grid-cols-3">
            <p class="text-overline text-neutrals-700 uppercase pb-200">direção</p>
            <ul class="col-span-2 flex flex-col">
              <li
                v-for="member in props.pelicula.diretor_team"
                :key="member"
              >
                <p class="text-body-regular">{{ member }}</p>
              </li>
            </ul>
          </div>
          <div class="grid grid-cols-3">
            <p class="text-overline text-neutrals-700 uppercase pb-200">direção</p>
            <ul class="col-span-2 flex flex-col">
              <li
                v-for="member in props.pelicula.producaoempresa_team"
                :key="member"
              >
                <p class="text-body-regular text-neutrals-900">{{ member }}</p>
              </li>
            </ul>
          </div>

        </div>
      </section>
    </div>
  </TwContainer>
</template>

<style scoped>
</style>
