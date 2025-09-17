<script setup>
import { Head } from "@inertiajs/vue3";
import { ref, defineAsyncComponent, computed } from "vue";
import TwContainer from "@components/layout/TwContainer.vue"

import HomeBanner from '@/components/features/home/HomeBanner.vue';
import banneImagePath from "@assets/images/mobile-banner.png";
import QuickLinkSection from '@components/common/cards/QuickLinkSection.vue';
import ArticlesSection from '@components/features/home/ArticlesSection.vue';
import NavbarSecondary from "@components/layout/navbar/NavbarSecondary.vue";
import SessionCard from "@/components/common/cards/SessionCard.vue";
import HorizontalScrollLayout from "@/components/layout/HorizontalScrollLayout.vue";
const TvFestival = defineAsyncComponent(() => import("@/components/layout/TvFestival.vue"));

import { simpleTranslation } from "@/lib/utils";


const props = defineProps({
  quickLinksConfig: { type: Array },
  mainItems: { type: Object },
  secondaryItems: { type: Array },
  noticias: { type: Array },
  noticasUrl: { type: String },
  youtubeVideos: { type: Array },
  nextSessions: { type: Array }
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


  <div class="py-1600">
    <HorizontalScrollLayout>
      <template v-slot:header>
        <h3 class="text-header-xxl text-neutrals-900">{{ simpleTranslation("Próximas sessões", "Upcoming sessions") }}</h3>
      </template>
      <template v-slot:content>
        <div class="flex-shrink-0 w-[calc(80%-0.75rem)] sm:w-[calc(30%-0.75rem)] sm:min-w-[300px]"
          v-for="(session, index) in props.nextSessions" :key="session.id">
          <SessionCard :session="session" />
        </div>
      </template>
    </HorizontalScrollLayout>
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
