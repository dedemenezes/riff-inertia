<script setup>
import { computed, defineAsyncComponent } from "vue";
import { usePage } from "@inertiajs/vue3";
import DatePickerComponent from "@/components/ui/DatePickerComponent.vue";
import SearchBar from "@/components/features/filters/SearchBar.vue";
import { simpleTranslation } from "@/lib/utils";
const ComboboxComponent = defineAsyncComponent(() => import('@/components/ui/ComboboxComponent.vue'))
const page = usePage()
const props = defineProps({
  modelValue: { type: Object, required: true },
  updateField: { type: Function, required: true },
  dataLabel: String,
  cadernos: { type: Array, default: () => [] }, // Article-specific prop
});

// Transform cadernos prop for ComboboxComponent format
const cadernosOptions = computed(() => {
  return props.cadernos.map(caderno => ({
    label: caderno.filter_display,
    value: caderno.filter_value,
  }));
});
const cadernoLabel = computed(() => simpleTranslation("Assunto", "Subject"))
const datePickerLocale = computed(() => page.props.currentLocale === "pt" ? "pt-BR" : "en-US")

const getCadernoObjectFromPermalink = (inputValue) => {
  return props.cadernos.find(c => c.filter_value === inputValue) || null;
};

const getDateFromInput = (value) => {
  return value
    ? { filter_display: value, filter_value: value, filter_label: props.dataLabel }
    : null;
}

const getQueryObject = (value) => {
  return value
    ? {
        filter_display: value,
        filter_value: value,
        filter_label: simpleTranslation("Busca", "Search"),
      }
    : null;
}
</script>

<template>
  <div class="w-full">
    <p class="font-body font-semibold text-neutrals-900 text-sm pb-300">
      {{ props.dataLabel }}
    </p>
    <DatePickerComponent
      :model-value="props.modelValue.data?.filter_value"
      :placeholder="simpleTranslation('Escolha uma data', 'Pick a date')"
      :locale="datePickerLocale"
      @update:model-value="updateField('data', getDateFromInput($event))"
    />
  </div>
  <!-- Article-specific filter content -->

  <div class="pt-400 overflow-hidden w-full">
    <p class="font-body font-semibold text-neutrals-900 text-sm pb-300">
      {{ cadernoLabel }}
    </p>
    <ComboboxComponent
      :collection="cadernosOptions"
      :modelValue="props.modelValue.caderno?.filter_value || null"
      :placeholder="page.props.locale_messages.placeholder.select"
      @update:modelValue="(val) => props.updateField('caderno', getCadernoObjectFromPermalink(val))"
    />
  </div>

  <div class="pt-400 w-full">
    <p class="font-body font-semibold text-neutrals-900 text-sm pb-300">
      {{ simpleTranslation("Palavra-chave", "Keyword") }}
    </p>
    <SearchBar
      :model-value="props.modelValue.query?.filter_value"
      @update:model-value="(val) => props.updateField('query', getQueryObject(val))"
    />
  </div>
</template>
