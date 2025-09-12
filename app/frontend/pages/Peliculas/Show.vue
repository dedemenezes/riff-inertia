<script setup>
// TODO: renderizar imagem grande desktop, mobile menor
import { ref, computed, onMounted, onUnmounted, defineAsyncComponent } from 'vue';

const InformacoesContent = defineAsyncComponent(() => import('@/components/features/peliculas/InformacoesContent.vue'));
const SessoesContent = defineAsyncComponent(() => import('@/components/features/peliculas/SessoesContent.vue'));
const CreditosContent = defineAsyncComponent(() => import('@/components/features/peliculas/CreditosContent.vue'));
const Breadcrumb = defineAsyncComponent(() => import('@/components/common/Breadcrumb.vue'));
const ButtonText = defineAsyncComponent(() => import('@/components/common/buttons/ButtonText.vue'));
const IconChevronLeft = defineAsyncComponent(() => import('@/components/common/icons/navigation/IconChevronLeft.vue'));
const TwContainer = defineAsyncComponent(() => import('@/components/layout/TwContainer.vue'));
const TagMostra = defineAsyncComponent(() => import('@/components/common/tags/TagMostra.vue'));
const TabbedPanel = defineAsyncComponent(() => import('@/components/common/tabs/TabbedPanel.vue'));

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
const activeTab = ref(tabs[0].id)

const width = ref(typeof window !== 'undefined' ? window.innerWidth : 0)
const isDesktop = computed(() => width.value >= 740)

const updateWidth = () => width.value = window.innerWidth

onMounted(() => window.addEventListener('resize', updateWidth))
onUnmounted(() => window.removeEventListener('resize', updateWidth))
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
    <div class="flex flex-col gap-6 sm:flex-row sm:gap-800 py-600">

      <section v-show="activeTab === 'creditos' || isDesktop" class="w-full sm:w-1/3">
        <!-- EACH SHOULD BE A COMPONENT LAZY LOADED -->
        <Suspense>
          <CreditosContent
            :director_image="props.pelicula.director_image"
            :diretor_coord_int="props.pelicula.diretor_coord_int"
            :roteiro_team="props.pelicula.roteiro_team"
            :fotografia_team="props.pelicula.fotografia_team"
            :montagem_team="props.pelicula.montagem_team"
            :diretor_team="props.pelicula.diretor_team"
            :producaoempresa_team="props.pelicula.producaoempresa_team"
          />
          <template #fallback>
            <div class="animate-pulse bg-gray-200 h-32 rounded"></div>
          </template>
        </Suspense>
      </section>

      <section v-show="activeTab === 'informacoes' || isDesktop" class="w-full sm:w-2/3">
        <Suspense>
          <InformacoesContent
            :display_sinopse="props.pelicula.display_sinopse"
            :imageURL="props.pelicula.imageURL"
            :display_titulo="props.pelicula.display_titulo"
            :mostra_tag_class="props.pelicula.mostra_tag_class"
            :mostra_name="props.pelicula.mostra_name"
            :carousel_images="props.pelicula.carousel_images"
          />
          <template #fallback>
            <div class="animate-pulse bg-gray-200 h-32 rounded"></div>
          </template>
        </Suspense>
      </section>

      <section v-show="activeTab === 'sessoes' || isDesktop" class="w-full sm:w-1/3 space-y-400">
        <Suspense>
          <SessoesContent />
          <template #fallback>
            <div class="animate-pulse bg-gray-200 h-32 rounded"></div>
          </template>
        </Suspense>
      </section>
    </div>
  </TwContainer>
</template>

<style scoped>
</style>
