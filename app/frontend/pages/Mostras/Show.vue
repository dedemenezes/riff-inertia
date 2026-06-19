<script setup>
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MostraShowContent from "@/components/features/mostras/MostraShowContent.vue";

const props = defineProps({
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
});
</script>

<template>
  <MenuContext nav="edicao" activePage="Mostras" />
  <MostraShowContent
    :mostras="props.mostras"
    :categoria="props.categoria"
    :tag_class="props.tag_class"
    :tabBaseUrl="props.tabBaseUrl"
    :elements="props.elements"
    :pagy="props.pagy"
    :submostras="props.submostras"
    :paises="props.paises"
    :genres="props.genres"
    :directors="props.directors"
    :actors="props.actors"
    :current_filters="props.current_filters"
    :has_active_filters="props.has_active_filters"
    :endMessage="props.endMessage"
    :verFilmesLabel="props.verFilmesLabel"
  />
</template>
