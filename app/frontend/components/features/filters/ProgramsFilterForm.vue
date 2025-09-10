<script setup>
import { computed } from "vue";
import AccordionGroup from "@/components/AccordionGroup.vue";
import ComboboxComponent from "@/components/ui/ComboboxComponent.vue";
import SearchBar from "@/components/features/filters/SearchBar.vue";
import SelectComponent from "@/components/ui/SelectComponent.vue";

const props = defineProps({
  modelValue: { type: Object, required: true },
  updateField: { type: Function, required: true },
  mostrasFilter: { type: Array, default: () => [] }, // Program-specific prop
  cinemasFilter: { type: Array, default: () => [] }, // Program-specific prop
  paisesFilter: { type: Array, default: () => [] },
  genresFilter: { type: Array, default: () => [] },
  sessoes:  { type: Array, default: () => [] },
  directors:  { type: Array, default: () => [] },
});

const mapFilterOptions = (filterList) => {
  return filterList.map(option => ({
    label: option.filter_display,
    value: option.filter_value,
  }));
}

const mostrasFilterOptions = computed(() => mapFilterOptions(props.mostrasFilter));
const mostraLabel = computed(() => props.mostrasFilter[0].filter_label)

const cinemasFilterOptions = computed(() => mapFilterOptions(props.cinemasFilter));
const cinemaLabel = computed(() => props.cinemasFilter[0].filter_label)

const paisesFilterOptions = computed(() => mapFilterOptions(props.paisesFilter));
const paisLabel = computed(() => props.paisesFilter[0].filter_label)

const genresFilterOptions = computed(() => mapFilterOptions(props.genresFilter));
const genreLabel = computed(() => props.genresFilter[0].filter_label)

const directorsOptions = computed(() => mapFilterOptions(props.directors));
const directorLabel = computed(() => props.directors[0].filter_label)


// Transform cinema prop for ComboboxComponent format
const sessoesFilterOptions = computed(() => {
  return props.sessoes.map(sessao => ({
    label: `Início às ${sessao.filter_display}`,
    value: sessao.filter_value,
  }));
});
const sessaoLabel = computed(() => props.sessoes[0].filter_label)

const getMostraObjectFromTagClas = (filter_value) => {
  return props.mostrasFilter.find(c => c.filter_value === filter_value) || null;
};
const getSessaoObject = (filter_value) => {
  return props.sessoes.find(c => c.filter_value === filter_value) || null;
};
const getCinemaObject = (filter_value) => {
  return props.cinemasFilter.find(c => c.filter_value === filter_value) || null;
};

const getPaisObject = (filter_value) => {
  return props.paisesFilter.find(c => c.filter_value === filter_value) || null;
}

const getGenreObject = (filter_value) => {
  return props.genresFilter.find(c => c.filter_value === filter_value) || null;
}

const getDirectorObject = (filter_value) => {
  return props.directors.find(c => c.filter_value === filter_value) || null;
}
const getQueryObject = (filter_value) => {
  // TODO: REFACTOR
  // I'm building here beause the other get here as collection
  // everything gets here from controller current_filters prop
  // this is just one so i cant search for it so we build
  return {"filter_display": filter_value, "filter_value": filter_value} || null;
}

</script>

<template>
  <!-- Article-specific filter content -->
   <div class="pt-400">
     <SearchBar
       :modelValue="props.modelValue.query?.filter_value"
       @update:modelValue="(val) => props.updateField('query', getQueryObject(val))"
       />
   </div>

   <!-- HORARIO -->
    <AccordionGroup
      :text="sessaoLabel"
      :isOpen="!!props.modelValue.sessao"
    >
      <template v-slot:content>
        <SelectComponent
          :modelValue="props.modelValue.sessao?.filter_value || null"
          @update:modelValue="(val) => props.updateField('sessao', getSessaoObject(val))"
          :collection="sessoesFilterOptions"
        />
      </template>
    </AccordionGroup>

   <!-- MOSTRAS -->
   <AccordionGroup
   :text="mostraLabel"
   :isOpen="!!props.modelValue.mostrasFilter"
   >
   <template v-slot:content>
     <div class="overflow-hidden w-full">
       <ComboboxComponent
       :collection="mostrasFilterOptions"
       :modelValue="props.modelValue.mostrasFilter?.filter_value || null"
       @update:modelValue="(val) => props.updateField('mostrasFilter', getMostraObjectFromTagClas(val))"
       />
      </div>
    </template>
  </AccordionGroup>

  <!-- CINEMAS -->
  <AccordionGroup
    :text="cinemaLabel"
    :isOpen="!!props.modelValue.cinemasFilter"
  >
    <template v-slot:content>
      <div class="overflow-hidden w-full">
        <ComboboxComponent
        :collection="cinemasFilterOptions"
        :modelValue="props.modelValue.cinemasFilter?.filter_value || null"
        @update:modelValue="(val) => props.updateField('cinemasFilter', getCinemaObject(val))"
        />
      </div>
    </template>
  </AccordionGroup>

  <!-- GENRES -->
  <AccordionGroup
    :text="genreLabel"
    :isOpen="!!props.modelValue.genresFilter"
  >
    <template v-slot:content>
      <div class="overflow-hidden w-full">
        <ComboboxComponent
        :collection="genresFilterOptions"
        :modelValue="props.modelValue.genresFilter?.filter_value || null"
        @update:modelValue="(val) => props.updateField('genresFilter', getGenreObject(val))"
        />
      </div>
    </template>
  </AccordionGroup>

  <!-- PAISES -->
  <AccordionGroup
    :text="paisLabel"
    :isOpen="!!props.modelValue.paisesFilter"
  >
    <template v-slot:content>
      <div class="overflow-hidden w-full">
        <ComboboxComponent
        :collection="paisesFilterOptions"
        :modelValue="props.modelValue.paisesFilter?.filter_value || null"
        @update:modelValue="(val) => props.updateField('paisesFilter', getPaisObject(val))"
        />
      </div>
    </template>
  </AccordionGroup>

  <!-- DIRETORES -->
  <AccordionGroup
    :text="directorLabel"
    :isOpen="!!props.modelValue.director"
  >
    <template v-slot:content>
      <div class="overflow-hidden w-full">
        <ComboboxComponent
        :collection="directorsOptions"
        :modelValue="props.modelValue.director?.filter_value || null"
        @update:modelValue="(val) => props.updateField('director', getDirectorObject(val))"
        />
      </div>
    </template>
  </AccordionGroup>
</template>
