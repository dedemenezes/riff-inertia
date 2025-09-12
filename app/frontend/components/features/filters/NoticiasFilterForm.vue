<script setup>
import { computed, defineAsyncComponent } from "vue";
import AccordionGroup from "@/components/AccordionGroup.vue";
const ComboboxComponent = defineAsyncComponent(() => import('@/components/ui/ComboboxComponent.vue'))

const props = defineProps({
  modelValue: { type: Object, required: true },
  updateField: { type: Function, required: true },
  cadernos: { type: Array, default: () => [] }, // Article-specific prop
});

// Transform cadernos prop for ComboboxComponent format
const cadernosOptions = computed(() => {
  return props.cadernos.map(caderno => ({
    label: caderno.nome_pt,
    value: caderno.permalink_pt,
  }));
});

const getCadernoObjectFromPermalink = (permalink) => {
  return props.cadernos.find(c => c.permalink_pt === permalink) || null;
};
</script>

<template>
  <!-- Article-specific filter content -->
  <AccordionGroup
    text="Cadernos"
    :isOpen="!!props.modelValue.cadernos"
  >
    <template v-slot:content>
      <div class="pt-400 overflow-hidden w-full">
        <ComboboxComponent
          :collection="cadernosOptions"
          :modelValue="props.modelValue.cadernos?.permalink_pt || null"
          @update:modelValue="(val) => props.updateField('cadernos', getCadernoObjectFromPermalink(val))"
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
