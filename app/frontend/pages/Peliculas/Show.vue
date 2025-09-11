<!-- const ComboboxComponent = defineAsyncComponent(() => import('@/components/ui/ComboboxComponent.vue')) -->
<script setup>
import { ref, defineAsyncComponent } from 'vue';
import { usePage } from '@inertiajs/vue3';
import PeliculaSession from '@/components/common/cards/PeliculaSessionCard.vue';

const Breadcrumb = defineAsyncComponent(() => import('@/components/common/Breadcrumb.vue'));
const ButtonText = defineAsyncComponent(() => import('@/components/common/buttons/ButtonText.vue'));
const BaseButton = defineAsyncComponent(() => import('@/components/common/buttons/BaseButton.vue'));
const IconChevronLeft = defineAsyncComponent(() => import('@/components/common/icons/navigation/IconChevronLeft.vue'));
const TwContainer = defineAsyncComponent(() => import('@/components/layout/TwContainer.vue'));
const TagMostra = defineAsyncComponent(() => import('@/components/common/tags/TagMostra.vue'));
const TabbedPanel = defineAsyncComponent(() => import('@/components/common/tabs/TabbedPanel.vue'));
const page = usePage()

const props = defineProps({
  rootUrl: { type: String, required: true },
  crumbs: { type: Array, required: true, default: () => []},
  pelicula: { type: Object, required: true }
});

const activeTab = ref('sessoes')

const tabs = [
  { id: 'sessoes', label: 'Sessões' },
  { id: 'informacoes', label: 'Informações' },
  { id: 'credito', label: 'Créditos' }
]
</script>

<template>
  <TwContainer>
     <Breadcrumb :crumbs="props.crumbs" />
     <!-- TODO: Translate back text instalar i18n vue -->

     <!-- back link -->
     <ButtonText variant="dark" class="gap-200" style="padding-left: 0 !important;" text="Voltar" tag="a">
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
    <!--  || isDesktop -->
    <div class="flex flex-col gap-6 sm:flex-row sm:gap-4 py-600">
      <section v-show="activeTab === 'informacoes'" class="w-full sm:w-1/3">
        <div>
          <h3 class="text-overline text-neutrals-700 uppercase">sobre o filme</h3>
          <p class="text-body-regular"></p>
        </div>
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
        CAMPEAO
      </section>
    </div>
       <!-- SOBRE -->
       <!-- Cartaz/link imprensa -->
       <!-- Selos -->
       <!-- PREMIOS -->
       <!-- palavras-chave -->
  </TwContainer>

</template>

<style scoped>
</style>
