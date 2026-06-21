<script setup>
import { Head } from "@inertiajs/vue3";
import TwContainer from "@components/layout/TwContainer.vue";

import HomeBanner from "@/components/features/home/HomeBanner.vue";
import QuickLinkSection from "@components/common/cards/QuickLinkSection.vue";
import ArticlesSection from "@components/features/home/ArticlesSection.vue";
import SessionCard from "@/components/common/cards/SessionCard.vue";
import HorizontalScrollLayout from "@/components/layout/HorizontalScrollLayout.vue";
import TvFestival from "@/components/layout/TvFestival.vue";
import DestaquesSection from "@/components/features/home/DestaquesSection.vue";

import { simpleTranslation } from "@/lib/utils";
import CarouselComponent from "@/components/ui/CarouselComponent.vue";
import { CarouselItem } from "@/components/ui/carousel";

const props = defineProps({
  quickLinksConfig: { type: Array },
  mainItems: { type: Object },
  secondaryItems: { type: Array },
  noticias: { type: Array },
  noticasUrl: { type: String },
  youtubeVideos: { type: Array },
  nextSessions: { type: Array },
  webdoors: { type: Array },
  destaques: { type: Array, default: () => [] },
});
</script>

<!-- <h1 class="text-header-base text-2xl lg:text-3xl mb-200 text-primary">
  A 26ª edição do Festival do Rio vem aí!
</h1>
<p class="text-subheading text-primary">
  De 2 a 12 de outubro o cinema estará sob a luz do Rio
</p> -->
<template>
  <Head title="Festival do Rio">
    <link
      v-if="props.webdoors?.[0]?.mobile_image_url"
      rel="preload"
      as="image"
      :href="props.webdoors[0].mobile_image_url"
      media="(max-width: 1023px)"
      fetchpriority="high"
    />
    <link
      v-if="props.webdoors?.[0]?.desktop_image_url"
      rel="preload"
      as="image"
      :href="props.webdoors[0].desktop_image_url"
      media="(min-width: 1024px)"
      fetchpriority="high"
    />
  </Head>
  <HomeBanner>
    <CarouselComponent :full-screen="true">
      <template v-slot:items>
        <CarouselItem
          v-for="(webdoor, index) in props.webdoors"
          :key="webdoor.id"
        >
          <div
            class="relative z-0 flex items-end justify-start h-[562px] lg:h-[618px] overflow-hidden"
          >
            <picture
              v-if="webdoor.mobile_image_url || webdoor.desktop_image_url"
              class="absolute inset-0 -z-10"
            >
              <source
                v-if="webdoor.desktop_image_url"
                media="(min-width: 1024px)"
                :srcset="webdoor.desktop_image_url"
              />
              <img
                :src="webdoor.mobile_image_url || webdoor.desktop_image_url"
                :alt="webdoor.titulo"
                class="h-full w-full object-cover"
                :loading="index === 0 ? 'eager' : 'lazy'"
                :fetchpriority="index === 0 ? 'high' : 'auto'"
                decoding="async"
              />
            </picture>
            <div
              class="px-400 py-200 lg:ps-[150px] lg:max-w-5xl pb-[58px] lg:pb-[77px]"
            >
              <h1
                class="banner font-regular leading-[150%] text-2xl lg:text-3xl mb-200 text-primary"
              >
                {{ webdoor.titulo }}
              </h1>
            </div>
            <!-- </TwContainer> -->
          </div>
        </CarouselItem>
      </template>
    </CarouselComponent>
  </HomeBanner>
  <QuickLinkSection v-bind:links="quickLinksConfig" />

  <TwContainer>
    <div class="py-1200">
      <ArticlesSection
        :articles="props.noticias"
        :noticiasUrl="props.noticasUrl"
      />
    </div>
  </TwContainer>
  <TvFestival :youtube-videos="props.youtubeVideos" />

  <div class="py-1200">
    <TwContainer>
      <HorizontalScrollLayout variant="light" mobile-variant="dark">
        <template v-slot:header>
          <h3 class="text-header-xxl text-neutrals-900">
            {{ simpleTranslation("Próximas sessões", "Upcoming sessions") }}
          </h3>
        </template>
        <template v-slot:content>
          <div
            class="flex-shrink-0 w-[calc(80%-0.75rem)] sm:w-[calc(30%-0.75rem)] sm:min-w-[300px]"
            v-for="(session, index) in props.nextSessions"
            :key="session.id"
          >
            <SessionCard :session="session" />
          </div>
        </template>
      </HorizontalScrollLayout>
    </TwContainer>
  </div>
  <TwContainer>
    <DestaquesSection
      v-for="grupo in props.destaques"
      :key="grupo.tipo_id"
      :tipo-nome="grupo.tipo_nome"
      :items="grupo.items"
    />
  </TwContainer>
</template>

<style scoped>
.fade-out--right {
  -webkit-mask-image: linear-gradient(
    to right,
    black 0%,
    black 85%,
    transparent 100%
  );
  mask-image: linear-gradient(to right, black 0%, black 85%, transparent 100%);
  -webkit-mask-size: 100% 100%;
  mask-size: 100% 100%;
}
h1.banner {
  background: white;
  display: inline;
  /* line-height: 1.4; */
}
</style>
