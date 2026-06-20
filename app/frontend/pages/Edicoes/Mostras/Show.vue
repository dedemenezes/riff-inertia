<script setup>
import EdicaoHeader from "@/components/common/EdicaoHeader.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import MostraShowContent from "@/components/features/mostras/MostraShowContent.vue";

defineProps({
  edicao: { type: Object, required: true },
  fallBackUrl: { type: String, required: true },
  activePage: { type: String, required: true },
  mostras: { type: Array, default: () => [] },
  categoria: { type: String },
  tag_class: { type: String },
  tabBaseUrl: { type: String, required: true },
  elements: { type: Array, default: () => [] },
  pagy: { type: Object, required: true },
  submostras: { type: Array, default: () => [] },
  paises: { type: Array, default: () => [] },
  genres: { type: Array, default: () => [] },
  directors: { type: Array, default: () => [] },
  actors: { type: Array, default: () => [] },
  current_filters: { type: Object, default: () => ({}) },
  has_active_filters: { type: Boolean, default: false },
  endMessage: { type: String, required: true },
  verFilmesLabel: { type: String, required: true },
  filmCardsLinkable: { type: Boolean, default: false },
});
</script>

<template>
  <TwContainer>
    <EdicaoHeader :edicao="edicao" :fallBackUrl="fallBackUrl" />
  </TwContainer>
  <MenuContext nav="edicoes_anteriores" :active-page="activePage" />
  <hr class="text-neutrals-300" />
  <MostraShowContent
    :mostras="mostras"
    :categoria="categoria"
    :tag_class="tag_class"
    :tabBaseUrl="tabBaseUrl"
    :elements="elements"
    :pagy="pagy"
    :submostras="submostras"
    :paises="paises"
    :genres="genres"
    :directors="directors"
    :actors="actors"
    :current_filters="current_filters"
    :has_active_filters="has_active_filters"
    :endMessage="endMessage"
    :verFilmesLabel="verFilmesLabel"
    :filmCardsLinkable="filmCardsLinkable"
  />
</template>
