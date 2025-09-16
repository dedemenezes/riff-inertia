<script setup>
import { Head } from "@inertiajs/vue3";
import TwContainer from "@components/layout/TwContainer.vue"

import HomeBanner from '@/components/features/home/HomeBanner.vue';
import banneImagePath from "@assets/images/mobile-banner.png";

import QuickLinkSection from '@components/common/cards/QuickLinkSection.vue';
import ArticlesSection from '@components/features/home/ArticlesSection.vue';
import NavbarSecondary from "@components/layout/navbar/NavbarSecondary.vue";
import VideoBanner from "@/components/features/peliculas/VideoBanner.vue";
import CarouselComponent from "@/components/ui/CarouselComponent.vue";
import { CarouselItem } from "@/components/ui/carousel";

const props = defineProps({
  quickLinksConfig: { type: Array },
  mainItems: { type: Object },
  secondaryItems: { type: Array },
  noticias: { type: Array },
  noticasUrl: { type: String },
  youtubeVideos: { type: Array }
})
</script>

<template>
  <Head title="Festival do Rio" />
  <HomeBanner :imagePath="banneImagePath" alt="Banner promocional">
    <h1 class="text-header-base text-2xl lg:text-3xl mb-200 text-primary">
      A 26ª edição do Festival do Rio vem aí!
    </h1>
    <p class="text-subheading text-primary">
      De 2 a 12 de outubro o cinema estará sob a luz do Rio
    </p>
  </HomeBanner>
  <QuickLinkSection v-bind:links="quickLinksConfig" />

  <TwContainer>
    <div class="py-1200">
      <ArticlesSection :articles="props.noticias" :noticiasUrl="props.noticasUrl"/>
    </div>

  </TwContainer>
  <div class="tv-festival bg-neutrals-1000 py-1600">
    <TwContainer>
      <div class="flex flex-col gap-800">
        <h3 class="text-white-transp-1000 leading-[120%] font-regular text-3xl">TV Festival do Rio</h3>

        <CarouselComponent>
          <template v-slot:items>
            <CarouselItem v-for="(youtubeVideo, index) in props.youtubeVideos" :key="youtubeVideo['id']">
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
