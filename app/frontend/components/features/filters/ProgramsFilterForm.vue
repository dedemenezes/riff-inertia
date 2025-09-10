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
});

// Transform cadernos prop for ComboboxComponent format
const mostrasFilterOptions = computed(() => {
  return props.mostrasFilter.map(caderno => ({
    label: caderno.nome_abreviado,
    value: caderno.permalink_pt,
  }));
});
// Transform cinema prop for ComboboxComponent format
const cinemasFilterOptions = computed(() => {
  return props.cinemasFilter.map(cinema => ({
    label: cinema.nome,
    value: cinema.id,
  }));
});
// Transform cinema prop for ComboboxComponent format
const paisesFilterOptions = computed(() => {
  return props.paisesFilter.map(pais => ({
    label: pais.nome_pais,
    value: pais.id,
  }));
});
// Transform cinema prop for ComboboxComponent format
const genresFilterOptions = computed(() => {
  return props.genresFilter.map(genre => ({
    label: genre.filter_display,
    value: genre.filter_value,
  }));
});

// Transform cinema prop for ComboboxComponent format
const sessoesFilterOptions = computed(() => {
  return props.sessoes.map(sessao => ({
    label: `Início às ${sessao.filter_display}`,
    value: sessao.filter_value,
  }));
});

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

  <!-- GENRES -->
  <AccordionGroup
    text="Gênero"
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

   <!-- HORARIO -->
    <AccordionGroup
      text="Horário"
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
   text="Mostra"
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
    text="Cinema"
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

  <!-- PAISES -->
  <AccordionGroup
    text="Pais"
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
</template>
