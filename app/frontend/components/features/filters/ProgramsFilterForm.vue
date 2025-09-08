<script setup>
import { computed } from "vue";
import AccordionGroup from "@/components/AccordionGroup.vue";
import ComboboxComponent from "@/components/ui/ComboboxComponent.vue";

const props = defineProps({
  modelValue: { type: Object, required: true },
  updateField: { type: Function, required: true },
  mostrasFilter: { type: Array, default: () => [] }, // Program-specific prop
});

// Transform cadernos prop for ComboboxComponent format
const mostrasFilterOptions = computed(() => {
  return props.mostrasFilter.map(caderno => ({
    label: caderno.display_name,
    value: caderno.tag_class,
  }));
});

const getMostraObjectFromTagClas = (tag_class) => {
  return props.mostrasFilter.find(c => c.tag_class === tag_class) || null;
};
</script>

<template>
  <!-- Article-specific filter content -->
  <AccordionGroup
    text="Mostras"
    :isOpen="!!props.modelValue.mostrasFilter"
  >
    <template v-slot:content>
      <div class="pt-400 overflow-hidden w-full">
        <ComboboxComponent
        :collection="mostrasFilterOptions"
        :modelValue="props.modelValue.mostrasFilter?.tag_class || null"
        @update:modelValue="(val) => props.updateField('mostrasFilter', getMostraObjectFromTagClas(val))"
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
