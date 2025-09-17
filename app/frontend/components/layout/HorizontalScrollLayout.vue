<script setup>
import { ref } from "vue";
import TwContainer from "./TwContainer.vue";
import { IconChevronRight, IconChevronLeft } from "@/components/common/icons"

const scrollContainer = ref(null);
const width = ref(typeof window !== 'undefined' ? window.innerWidth : 0)
const scrollLeft = () => {
  scrollContainer.value.scrollBy({ left: -width.value*0.80, behavior: 'smooth' });
};
const scrollRight = () => {
  scrollContainer.value.scrollBy({ left: width.value*0.80, behavior: 'smooth' });
};
</script>

<template>
  <div class="relative flex flex-col gap-600">
    <TwContainer>
      <slot name="header" />
    </TwContainer>
    <div ref="scrollContainer" class="flex overflow-x-auto no-scroll-bar gap-800">
      <slot name="content" />
    </div>
    <button
      @click="scrollLeft"
      class="absolute left-400 top-1/2 -translate-y-1/2 z-10 bg-transparent hover:text-white-neutrals-900"
      aria-label="Scroll right"
    >
      <IconChevronLeft class="w-6 h-6 text-white-transp-800" />
    </button>
    <button
      @click="scrollRight"
      class="absolute right-400 top-1/2 -translate-y-1/2 z-10 bg-transparent hover:text-white-transp-1000" aria-label="Scroll right"
    >
      <IconChevronRight class="w-6 h-6 text-white-transp-800" />
    </button>
  </div>
</template>

<style scoped></style>
