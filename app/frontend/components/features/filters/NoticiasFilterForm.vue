<script setup>
import { computed, defineAsyncComponent } from "vue";
import AccordionGroup from "@/components/AccordionGroup.vue";
import DatePickerComponent from "@/components/ui/DatePickerComponent.vue";
const ComboboxComponent = defineAsyncComponent(() => import('@/components/ui/ComboboxComponent.vue'))

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
const cadernoLabel = computed(() => props.cadernos[0].filter_label)

const getCadernoObjectFromPermalink = (inputValue) => {
  return props.cadernos.find(c => c.filter_value === inputValue) || null;
};

const getDateFromInput = (value) => {
  // debugger
  return { "filter_display": value, "filter_value": value, filter_label: props.dataLabel } || null;
}
</script>

<template>
  <AccordionGroup
    :text="props.dataLabel"
    :isOpen="!!props.modelValue.data?.filter_value"
  >
    <template v-slot:content>
      <div class="w-full">
        <DatePickerComponent
          :model-value="props.modelValue.data?.filter_value"
          placeholder="Pick session date"
          @update:model-value="updateField('data', getDateFromInput($event))"
        />
      </div>
    </template>
  </AccordionGroup>
  <!-- Article-specific filter content -->
  <AccordionGroup
    :text="cadernoLabel"
    :isOpen="!!props.modelValue.caderno"
  >
    <template v-slot:content>
      <div class="pt-400 overflow-hidden w-full">
        <ComboboxComponent
          :collection="cadernosOptions"
          :modelValue="props.modelValue.caderno?.filter_value || null"
          @update:modelValue="(val) => props.updateField('caderno', getCadernoObjectFromPermalink(val))"
        />
      </div>
    </template>
  </AccordionGroup>

  <!-- Add other article-specific filters -->
  <!--
  <AccordionGroup
    text="Categoria"
    :isOpen="props.modelValue.categoria != null"
  >
    <template v-slot:content>
      <div class="pt-400 overflow-hidden">
        <ComboboxComponent
          :collection="categorias"
          :modelValue="props.modelValue.categoria"
          @update:modelValue="(val) => props.updateField('categoria', val)"
        />
      </div>
    </template>
  </AccordionGroup>
  -->
</template>
