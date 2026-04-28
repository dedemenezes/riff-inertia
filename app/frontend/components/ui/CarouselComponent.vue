<script setup>
import { ref, computed } from 'vue';
import { Carousel, CarouselContent, CarouselItem, CarouselNext, CarouselPrevious } from '@/components/ui/carousel';

const props = defineProps({
  imageCollection: { // [{imagePath: "", imageLabel: "" (optional)}]
    type: Array,
    required: false,
    default: () => []
  },
  classNames: Array,
  fullScreen: { type: Boolean, default: false }
})

const brokenPaths = ref(new Set());
const onImageError = (path) => { brokenPaths.value = new Set([...brokenPaths.value, path]); };
const visibleImages = computed(() => props.imageCollection.filter(img => !brokenPaths.value.has(img.path)));

const imageLabel = (image) => image?.label || null;

const navigatorsXPositionClass = (side) => {
  if (side === 'left') return props.fullScreen ? 'lg:translate-x-2400' : 'lg:translate-x-0';
  if (side === 'right') return props.fullScreen ? 'lg:-translate-x-2400' : 'lg:translate-x-0';
};
</script>

<template>
  <Carousel v-if="visibleImages.length > 0 || $slots.items" class="w-[100%]" :class="[props.classNames]">
    <CarouselContent>
      <slot name="items"/>
      <!-- DEFAULT -->
      <CarouselItem v-for="image in visibleImages" :key="image.path">
        <figure class="relative m-0 lg:h-[688px] h-[164px] p-600 flex flex-col justify-end">
          <img :src="image.path" :alt="image.label" class="absolute inset-0 w-full h-full object-cover -z-1" @error="onImageError(image.path)" />
          <h3 v-show="imageLabel(image)" class="text-header-sm text-white-transp-1000 mt-max z-1">{{ imageLabel(image) }}</h3>
        </figure>
      </CarouselItem>
    </CarouselContent>
    <CarouselPrevious :class="['translate-x-[56px] scale-70 lg:scale-100', navigatorsXPositionClass('left')]"/>
    <CarouselNext :class="['translate-x-[-56px] scale-70 lg:scale-100', navigatorsXPositionClass('right')]" />
  </Carousel>
</template>

<style scoped></style>
