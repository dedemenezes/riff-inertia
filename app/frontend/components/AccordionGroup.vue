<script setup>
import { IconCarretUp } from '@components/common/icons';

// import AccordionHeader from './AccordionHeader.vue';
const { text } = defineProps({
  text: {
    type: String,
    required: true,
  },
  isOpen: {
    type: Boolean,
    default: false,
  },
});
</script>

<template>
  <details :open="isOpen">
    <summary
      class="font-body font-semibold text-neutrals-900 leadgin-[19.6px] text-sm uppercase flex justify-between items-center pb-300 border-b hover:cursor-pointer"
    >
      {{ text }}
      <IconCarretUp className="text-neutrals-900 accordion-icon" :width="16" />
    </summary>
    <slot name="content"></slot>
  </details>
</template>

<style scoped></style>
