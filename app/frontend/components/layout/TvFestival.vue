<script setup>
import { defineAsyncComponent } from 'vue';
import TwContainer from './TwContainer.vue';
const VideoBanner = defineAsyncComponent(() => import( "@/components/features/peliculas/VideoBanner.vue"));
const CarouselComponent = defineAsyncComponent(() => import( "@/components/ui/CarouselComponent.vue"));
const CarouselItem = defineAsyncComponent(() => import( "@/components/ui/carousel/CarouselItem.vue"));

defineProps({
  youtubeVideos: {
    type: Array,
    required: true,
    default: () => []
  }
})
</script>

<template>
  <div class="tv-festival bg-neutrals-1000 py-1600">
    <TwContainer>
      <div class="flex flex-col gap-800">
        <h3 class="text-white-transp-1000 leading-[120%] font-regular text-3xl">TV Festival do Rio</h3>

        <CarouselComponent :full-screen="true">
          <template v-slot:items>
            <CarouselItem v-for="(youtubeVideo, index) in youtubeVideos" :key="youtubeVideo['id']">
              <VideoBanner
                :youtube-video-id="youtubeVideo['snippet']['resourceId']['videoId']"
                :title="youtubeVideo['snippet']['title']"
                />
            </CarouselItem>
          </template>
        </CarouselComponent>
      </div>
    </TwContainer>
  </div>
</template>

<style scoped></style>
