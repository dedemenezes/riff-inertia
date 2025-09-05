<script setup>
import { Head } from "@inertiajs/vue3";
import TwContainer from "@components/layout/TwContainer.vue"

import HomeBanner from '@/components/features/home/HomeBanner.vue';
import banneImagePath from "@assets/images/mobile-banner.png";

import QuickLinkSection from '@components/common/cards/QuickLinkSection.vue';
import ArticlesSection from '@components/features/home/ArticlesSection.vue';
import NavbarSecondary from "@components/layout/navbar/NavbarSecondary.vue";

const props = defineProps({
  quickLinksConfig: { type: Array },
  mainItems: { type: Object },
  secondaryItems: { type: Array },
  noticias: { type: Array },
  noticasUrl: { type: String },
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
</template>

<style scoped></style>
