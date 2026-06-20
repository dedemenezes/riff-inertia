  <script setup>
import { computed, defineAsyncComponent } from "vue";
const ComboboxComponent = defineAsyncComponent(() => import('@/components/ui/ComboboxComponent.vue'));
import SearchBar from "@/components/features/filters/SearchBar.vue";
import { simpleTranslation } from "@/lib/utils";

const props = defineProps({
  modelValue: { type: Object, required: true },
  updateField: { type: Function, required: true },
  submostras: { type: Array, default: () => [] },
  paises: { type: Array, default: () => [] },
  genres: { type: Array, default: () => [] },
  directors: { type: Array, default: () => [] },
  actors: { type: Array, default: () => [] },
});

const mapFilterOptions = (filterList) => {
  return filterList.map(option => ({
    label: option.filter_display,
    value: option.filter_value,
  }));
}

const submostrasFilterOptions = computed(() => mapFilterOptions(props.submostras));
const submostraLabel = computed(() => props.submostras[0]?.filter_label);

const paisesFilterOptions = computed(() => mapFilterOptions(props.paises));
const paisLabel = computed(() => props.paises[0]?.filter_label);

const genresFilterOptions = computed(() => mapFilterOptions(props.genres));
const genreLabel = computed(() => props.genres[0]?.filter_label);

const directorsOptions = computed(() => mapFilterOptions(props.directors));
const directorLabel = computed(() => props.directors[0]?.filter_label);

const actorsFilterOptions = computed(() => mapFilterOptions(props.actors));
const actorsLabel = computed(() => props.actors[0]?.filter_label);

const getSelectedFrom = (collectionName, value) => {
  return props[collectionName].find(option => option.filter_value == value)
}

const getQueryObject = (filter_value) => {
  return {"filter_display": filter_value, "filter_value": filter_value} || null;
}
</script>

<template>
  <div class="pt-400">
    <SearchBar
      :modelValue="props.modelValue.query?.filter_value"
      @update:modelValue="(val) => props.updateField('query', getQueryObject(val))"
    />
  </div>

  <!-- SUBMOSTRAS -->
  <div
    v-if="props.submostras.length > 1"
  >
    <p class="font-body font-semibold text-neutrals-900 text-sm pb-300">
      {{ submostraLabel }}
    </p>
    <div class="overflow-hidden w-full">
      <ComboboxComponent
        :collection="submostrasFilterOptions"
        :modelValue="props.modelValue.mostra?.filter_value || null"
        @update:modelValue="(val) => props.updateField('mostra', getSelectedFrom('submostras', val))"
        :placeholder="simpleTranslation('Selecione uma mostra', 'Choose a showcase')"
      />
    </div>
  </div>

  <!-- GENRES -->
  <div>
    <p class="font-body font-semibold text-neutrals-900 text-sm pb-300">
      {{ genreLabel }}
    </p>
    <div class="overflow-hidden w-full">
      <ComboboxComponent
        :collection="genresFilterOptions"
        :modelValue="props.modelValue.genero?.filter_value || null"
        @update:modelValue="(val) => props.updateField('genero', getSelectedFrom('genres', val))"
        :placeholder="simpleTranslation('Selecione um gênero', 'Choose a genre')"
      />
    </div>
  </div>

  <!-- PAISES -->
  <div>
    <p class="font-body font-semibold text-neutrals-900 text-sm pb-300">
      {{ paisLabel }}
    </p>
    <div class="overflow-hidden w-full">
      <ComboboxComponent
        :collection="paisesFilterOptions"
        :modelValue="props.modelValue.pais?.filter_value || null"
        @update:modelValue="(val) => props.updateField('pais', getSelectedFrom('paises', val))"
        :placeholder="simpleTranslation('Selecione um país', 'Choose a country')"
      />
    </div>
  </div>

  <!-- DIRETORES -->
  <div>
    <p class="font-body font-semibold text-neutrals-900 text-sm pb-300">
      {{ directorLabel }}
    </p>
    <div class="overflow-hidden w-full">
      <ComboboxComponent
        :collection="directorsOptions"
        :modelValue="props.modelValue.direcao?.filter_value || null"
        @update:modelValue="(val) => props.updateField('direcao', getSelectedFrom('directors', val))"
        :placeholder="simpleTranslation('Selecione um diretor', 'Choose a director')"
      />
    </div>
  </div>

  <!-- ACTORS -->
  <div>
    <p class="font-body font-semibold text-neutrals-900 text-sm pb-300">
      {{ actorsLabel }}
    </p>
    <div class="overflow-hidden w-full">
      <ComboboxComponent
        :collection="actorsFilterOptions"
        :modelValue="props.modelValue.elenco?.filter_value || null"
        @update:modelValue="(val) => props.updateField('elenco', getSelectedFrom('actors', val))"
        :placeholder="simpleTranslation('Selecione um ator(a)', 'Choose an actor')"
      />
    </div>
  </div>
</template>
