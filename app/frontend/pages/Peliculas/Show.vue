<script setup>
// TODO: renderizar imagem grande desktop, mobile menor
// TODO: botao com cursor hover para comprar ingresso
// TODO: Fix carousel só se tiver imagem para mostrar
// TODO: E se filme nao tiver imagem na db?

import { ref, defineAsyncComponent } from 'vue';

const InformacoesContent = defineAsyncComponent(() => import('@/components/features/peliculas/InformacoesContent.vue'));
const SessoesContent = defineAsyncComponent(() => import('@/components/features/peliculas/SessoesContent.vue'));
const CreditosContent = defineAsyncComponent(() => import('@/components/features/peliculas/CreditosContent.vue'));
const Breadcrumb = defineAsyncComponent(() => import('@/components/common/Breadcrumb.vue'));
const ButtonText = defineAsyncComponent(() => import('@/components/common/buttons/ButtonText.vue'));
const IconChevronLeft = defineAsyncComponent(() => import('@/components/common/icons/navigation/IconChevronLeft.vue'));
const TwContainer = defineAsyncComponent(() => import('@/components/layout/TwContainer.vue'));
const TagMostra = defineAsyncComponent(() => import('@/components/common/tags/TagMostra.vue'));
const TabbedPanel = defineAsyncComponent(() => import('@/components/common/tabs/TabbedPanel.vue'));
const CarouselComponent = defineAsyncComponent(() => import('@/components/ui/CarouselComponent.vue'));

import { useUpdateWindowWidth } from '@/lib/utils';

const props = defineProps({
  rootUrl: { type: String, required: true },
  crumbs: { type: Array, required: true, default: () => []},
  backPath: String,
  pelicula: { type: Object, required: true }
});

const tabs = [
  { id: 'first', label: 'Informações' },
  { id: 'second', label: 'Sessões' },
  { id: 'third', label: 'Créditos' }
]

const startingTab = 0
const activeTab = ref(tabs[startingTab].id)

const isDesktop = useUpdateWindowWidth();
</script>

<template>
  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
    <!-- TODO: Translate back text instalar i18n vue -->

    <!-- back link -->
    <ButtonText variant="dark" class="gap-200 py-400" text="Voltar" tag="a" :href="props.backPath">
      <template #icon>
        <IconChevronLeft height="16" width="16" color="inherit"/>
      </template>
    </ButtonText>
  </TwContainer>
  <!-- banner image -->
  <img :src="props.pelicula.imageURL" class="h-[222px] lg:h-[634px] w-full object-cover" :alt="`${pelicula.display_titulo} banner`">
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

    <TabbedPanel v-model="activeTab" :tabs="tabs" class="py-400 justify-center lg:hidden" />

    <!-- EACH SHOULD BE A COMPONENT LAZY LOADED -->
    <div class="flex flex-col justify-center gap-6 sm:flex-row sm:gap-800 py-600">

      <section v-if="activeTab === 'third' || isDesktop" class="w-full sm:w-1/3">
        <!-- EACH SHOULD BE A COMPONENT LAZY LOADED -->
        <Suspense>
          <CreditosContent :pelicula="pelicula"/>
          <template #fallback>
            <div class="animate-pulse bg-gray-200 h-32 rounded"></div>
          </template>
        </Suspense>
      </section>

      <section v-if="activeTab === 'first' || isDesktop" class="w-full sm:w-2/3">

          <Suspense>
            <InformacoesContent :pelicula="pelicula"
            />
            <template #fallback>
              <div class="animate-pulse bg-gray-200 h-32 rounded"></div>
            </template>
          </Suspense>
        </section>

      <section v-if="activeTab === 'second' || isDesktop" class="w-full sm:w-1/3 space-y-400">
        <Suspense>
          <SessoesContent />
          <template #fallback>
            <div class="animate-pulse bg-gray-200 h-32 rounded"></div>
          </template>
        </Suspense>
      </section>
    </div>
  </TwContainer>

  <Suspense v-if="isDesktop">
    <CarouselComponent :full-screen="true" :imageCollection="props.pelicula.carousel_images" :class-names="['pt-800']" />
    <template #fallback>
      <div class="h-48 bg-gray-200 animate-pulse rounded pt-800"></div>
    </template>
  </Suspense>
</template>

<style scoped>
</style>
