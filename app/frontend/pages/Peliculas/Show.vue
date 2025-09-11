<!-- const ComboboxComponent = defineAsyncComponent(() => import('@/components/ui/ComboboxComponent.vue')) -->
<script setup>
import { computed, defineAsyncComponent } from 'vue';
import { usePage } from '@inertiajs/vue3';

const Breadcrumb = defineAsyncComponent(() => import('@/components/common/Breadcrumb.vue'));
const ButtonText = defineAsyncComponent(() => import('@/components/common/buttons/ButtonText.vue'));
const IconChevronLeft = defineAsyncComponent(() => import('@/components/common/icons/navigation/IconChevronLeft.vue'));
const TwContainer = defineAsyncComponent(() => import('@/components/layout/TwContainer.vue'));
const TagMostra = defineAsyncComponent(() => import('@/components/common/tags/TagMostra.vue'))
const page = usePage()

const props = defineProps({
  rootUrl: { type: String, required: true },
  crumbs: { type: Array, required: true, default: () => []},
  pelicula: { type: Object, required: true }
});
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
            <p class="text-body-regular italic">{{ props.pelicula.titulo_ingles_coord_int }}</p>
          </section>
          <div class="flex items-center gap-200">
            <p class="text-overline">{{ props.pelicula.display_paises }}</p>
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
     <!-- SOBRE -->
     <!-- Cartaz/link imprensa -->
     <!-- Selos -->
     <!-- PREMIOS -->
     <!-- palavras-chave -->


</template>

<style scoped>
</style>
