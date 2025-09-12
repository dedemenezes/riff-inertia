<script setup>
import { computed } from "vue";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from '@/components/ui/carousel'

const props = defineProps({
  imageCollection: { // [{imagePath: "", imageLabel: "" (optional)}]
    type: Array,
    required: true,
    default: () => []
  },
  classNames: Array
})

const imageLabel = (image) => {
  return image?.label || null
}

</script>

<template>
  <Carousel class="w-[100%]" :class="[props.classNames]">
    <CarouselContent>
      <CarouselItem
        v-for="image in props.imageCollection"
        :key="image.path"
      >
        <figure class="relative m-0 lg:h-[688px] h-[164px] p-600 flex flex-col justify-end">
          <img
            :src="image.path" :alt="image.label"
            class="absolute inset-0 w-full h-full object-cover -z-1"
          >
          <h3 v-show="imageLabel(image)" class="text-header-sm text-white-transp-1000 mt-max z-1">{{ imageLabel(image) }}</h3>
        </figure>
      </CarouselItem>
    </CarouselContent>
    <CarouselPrevious class="translate-x-[56px] scale-70 lg:translate-x-0 lg:scale-100"/>
    <CarouselNext class="translate-x-[-56px] scale-70 lg:translate-x-0 lg:scale-100" />
  </Carousel>
</template>

<style scoped></style>
