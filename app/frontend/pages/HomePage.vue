<script setup>
import { Head } from "@inertiajs/vue3";
import { ref, defineAsyncComponent, computed } from "vue";
import TwContainer from "@components/layout/TwContainer.vue"

import HomeBanner from '@/components/features/home/HomeBanner.vue';
import banneImagePath from "@assets/images/mobile-banner.png";
import { IconChevronRight, IconChevronLeft } from "@/components/common/icons"
import QuickLinkSection from '@components/common/cards/QuickLinkSection.vue';
import ArticlesSection from '@components/features/home/ArticlesSection.vue';
import NavbarSecondary from "@components/layout/navbar/NavbarSecondary.vue";
import SessionCard from "@/components/common/cards/SessionCard.vue";
import { simpleTranslation, useUpdateWindowWidth } from "@/lib/utils";
const TvFestival = defineAsyncComponent(() => import("@/components/layout/TvFestival.vue"));

const props = defineProps({
  quickLinksConfig: { type: Array },
  mainItems: { type: Object },
  secondaryItems: { type: Array },
  noticias: { type: Array },
  noticasUrl: { type: String },
  youtubeVideos: { type: Array },
  nextSessions: { type: Array }
})

const isDesktop = useUpdateWindowWidth()

const scrollContainer = ref(null);

const scrollLeft = () => {
  scrollContainer.value.scrollBy({ left: -250, behavior: 'smooth' });
};


const width = ref(typeof window !== 'undefined' ? window.innerWidth : 0)

const scrollRight = () => {
  scrollContainer.value.scrollBy({ left: width.value, behavior: 'smooth' });
};
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

  <div class="py-1600">
    <div class="relative flex flex-col gap-600">
      <h3 class="text-header-xxl text-neutrals-900 ml-4 lg:ml-16 xl:ml-18 xxl:ml-20">{{ simpleTranslation("Próximas sessões", "Upcoming sessions") }}</h3>
      <div ref="scrollContainer" class="flex overflow-x-auto no-scroll-bar gap-800 pb-4">
        <div class="flex-shrink-0 w-[calc(80%-0.75rem)] sm:w-[calc(30%-0.75rem)] sm:min-w-[300px]"
             :class="{ 'ml-4 lg:ml-16 xl:ml-18 xxl:ml-20': index === 0, 'mr-4': index === props.nextSessions.length - 1 }"
             v-for="(session, index) in props.nextSessions" :key="session.id">
          <SessionCard :session="session" />
        </div>
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
        class="absolute right-400 top-1/2 -translate-y-1/2 z-10 bg-transparent hover:text-white-transp-1000"
        aria-label="Scroll right"
      >
        <IconChevronRight class="w-6 h-6 text-white-transp-800" />
      </button>
    </div>
  </div>
  <!-- </div> -->
  <TwContainer>
  </TwContainer>
  <TwContainer>
    <div class="py-1200">
      <ArticlesSection :articles="props.noticias" :noticiasUrl="props.noticasUrl"/>
    </div>

  </TwContainer>
  <TvFestival :youtube-videos="props.youtubeVideos" />
</template>

<style scoped>
.fade-out--right {
  -webkit-mask-image: linear-gradient(to right, black 0%, black 85%, transparent 100%);
  mask-image: linear-gradient(to right, black 0%, black 85%, transparent 100%);
  -webkit-mask-size: 100% 100%;
  mask-size: 100% 100%;
}
</style>
