<script setup>
// TODO: REFAC SIMPLE TRANSLATIONS BUT AFTER RELEASE
import { computed, defineAsyncComponent } from "vue";
const AccordionGroup = defineAsyncComponent(() => import("@/components/AccordionGroup.vue"));
const ComboboxComponent = defineAsyncComponent(() => import('@/components/ui/ComboboxComponent.vue'));
const SelectComponent = defineAsyncComponent(() => import("@/components/ui/SelectComponent.vue"));
import SearchBar from "@/components/features/filters/SearchBar.vue";
import { displayFormattedTime, simpleTranslation } from "@/lib/utils";
import { usePage } from "@inertiajs/vue3";

const props = defineProps({
  modelValue: { type: Object, required: true },
  updateField: { type: Function, required: true },
  mostras: { type: Array, default: () => [] }, // Program-specific prop
  cinemas: { type: Array, default: () => [] }, // Program-specific prop
  paises: { type: Array, default: () => [] },
  genres: { type: Array, default: () => [] },
  sessoes:  { type: Array, default: () => [] },
  directors:  { type: Array, default: () => [] },
  actors:  { type: Array, default: () => [] },
});

const mapFilterOptions = (filterList) => {
  return filterList.map(option => ({
    label: option.filter_display,
    value: option.filter_value,
  }));
}

const mostrasFilterOptions = computed(() => mapFilterOptions(props.mostras));
const mostraLabel = computed(() => props.mostras[0].filter_label)

const actorsFilterOptions = computed(() => mapFilterOptions(props.actors));
const actorsLabel = computed(() => props.actors[0]?.filter_label)

const cinemasFilterOptions = computed(() => mapFilterOptions(props.cinemas));
const cinemaLabel = computed(() => props.cinemas[0].filter_label)

const paisesFilterOptions = computed(() => mapFilterOptions(props.paises));
const paisLabel = computed(() => props.paises[0].filter_label)

const genresFilterOptions = computed(() => mapFilterOptions(props.genres));
const genreLabel = computed(() => props.genres[0].filter_label)

const directorsOptions = computed(() => mapFilterOptions(props.directors));
const directorLabel = computed(() => props.directors[0].filter_label)

const sessoesFilterOptions = computed(() => {
  // TODO: TRANSLATE ✅
  const page = usePage();

  const locale = page.props.currentLocale  // or inject it however you're doing it
  return props.sessoes.map(sessao => {
    const formattedTime = displayFormattedTime(sessao.filter_display)
    return  {
      label: `${locale === 'pt' ? 'Início às' : 'Starts at'} ${formattedTime}`,
      value: sessao.filter_value,
    }
  })
});
const sessaoLabel = computed(() => props.sessoes[0].filter_label)

const getSelectedFrom = (collectionName, value) => {
  return props[collectionName].find(option => option.filter_value == value)
}

const getQueryObject = (filter_value) => {
  // TODO: REFACTOR ⏭️
  // I'm building here beause the other get here as collection
  // everything gets here from controller current_filters prop
  // this is just one so i cant search for it so we build
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

   <!-- HORARIO -->
    <AccordionGroup
      :text="sessaoLabel"
      :isOpen="!!props.modelValue.sessao"
    >
      <template v-slot:content>
        <SelectComponent
          :modelValue="props.modelValue.sessao?.filter_value || null"
          @update:modelValue="(val) => props.updateField('sessao', getSelectedFrom('sessoes', val))"
          :collection="sessoesFilterOptions"
        />
      </template>
    </AccordionGroup>

   <!-- MOSTRAS -->
   <AccordionGroup
   :text="mostraLabel"
   :isOpen="!!props.modelValue.mostra"
   >
   <template v-slot:content>
     <div class="overflow-hidden w-full">
       <ComboboxComponent
       :collection="mostrasFilterOptions"
       :modelValue="props.modelValue.mostra?.filter_value || null"
       @update:modelValue="(val) => props.updateField('mostra', getSelectedFrom('mostras', val))"
       :placeholder="simpleTranslation('Selecione uma mostra', 'Choose a showcase')"
       />
      </div>
    </template>
  </AccordionGroup>

  <!-- CINEMAS -->
  <AccordionGroup
    :text="cinemaLabel"
    :isOpen="!!props.modelValue.cinema"
  >
    <template v-slot:content>
      <div class="overflow-hidden w-full">
        <ComboboxComponent
        :collection="cinemasFilterOptions"
        :modelValue="props.modelValue.cinema?.filter_value || null"
        @update:modelValue="(val) => props.updateField('cinema', getSelectedFrom('cinemas', val))"
        :placeholder="simpleTranslation('Selecione um cinema', 'Choose a theater')"
        />
      </div>
    </template>
  </AccordionGroup>

  <!-- GENRES -->
  <AccordionGroup
    :text="genreLabel"
    :isOpen="!!props.modelValue.genero"
  >
    <template v-slot:content>
      <div class="overflow-hidden w-full">
        <ComboboxComponent
        :collection="genresFilterOptions"
        :modelValue="props.modelValue.genero?.filter_value || null"
        @update:modelValue="(val) => props.updateField('genero', getSelectedFrom('genres', val))"
       :placeholder="simpleTranslation('Selecione um gênero', 'Choose a genre')"
        />
      </div>
    </template>
  </AccordionGroup>

  <!-- PAISES -->
  <AccordionGroup
    :text="paisLabel"
    :isOpen="!!props.modelValue.pais"
  >
    <template v-slot:content>
      <div class="overflow-hidden w-full">
        <ComboboxComponent
        :collection="paisesFilterOptions"
        :modelValue="props.modelValue.pais?.filter_value || null"
        @update:modelValue="(val) => props.updateField('pais', getSelectedFrom('paises', val))"
       :placeholder="simpleTranslation('Selecione um país', 'Choose a country')"
        />
      </div>
    </template>
  </AccordionGroup>

  <!-- DIRETORES -->
  <AccordionGroup
    :text="directorLabel"
    :isOpen="!!props.modelValue.direcao"
  >
    <template v-slot:content>
      <div class="overflow-hidden w-full">
        <ComboboxComponent
        :collection="directorsOptions"
        :modelValue="props.modelValue.direcao?.filter_value || null"
        @update:modelValue="(val) => props.updateField('direcao', getSelectedFrom('directors', val))"
       :placeholder="simpleTranslation('Selecione um diretor', 'Choose a director')"
        />
      </div>
    </template>
  </AccordionGroup>

  <!-- ACTORS -->
  <AccordionGroup
    :text="actorsLabel"
    :isOpen="!!props.modelValue.elenco"
  >
    <template v-slot:content>
      <div class="overflow-hidden w-full">
        <ComboboxComponent
        :collection="actorsFilterOptions"
        :modelValue="props.modelValue.elenco?.filter_value || null"
        @update:modelValue="(val) => props.updateField('elenco', getSelectedFrom('actors', val))"
       :placeholder="simpleTranslation('Selecione um ator(a)', 'Choose an actor')"
        />
      </div>
    </template>
  </AccordionGroup>
</template>
