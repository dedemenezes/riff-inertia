<script setup>
import { computed } from "vue";
import { Head } from "@inertiajs/vue3";
import TwContainer from "@/components/layout/TwContainer.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MediaExternalLink from "@/components/features/midias/MediaExternalLink.vue";
import MediaVideoEmbed from "@/components/features/midias/MediaVideoEmbed.vue";
import trofeuRedentorImage from "@assets/images/midias/trofeu-redentor.png";

const props = defineProps({
  title: { type: String, default: "" },
  activePage: { type: String, default: "" },
  galleryLink: {
    type: Object,
    default: () => ({ label: "", href: "#" }),
  },
  youtubeLink: {
    type: Object,
    default: () => ({ label: "", href: "#" }),
  },
  heroPhoto: {
    type: Object,
    default: () => ({ title: "", caption: "", imageUrl: "" }),
  },
  videos: {
    type: Array,
    default: () => [],
  },
});

const heroImages = {
  "trofeu-redentor": trofeuRedentorImage,
};

const heroImageUrl = computed(() => {
  return props.heroPhoto.imageUrl || heroImages[props.heroPhoto.imageKey] || "";
});
</script>

<template>
  <Head>
    <title>{{ props.title }}</title>
  </Head>

  <MenuContext nav="midias" :active-page="props.activePage" />
  <hr class="text-neutrals-300" />

  <TwContainer>
    <section class="flex flex-col items-center gap-1000 py-800 md:py-1200">
      <MediaExternalLink
        :href="props.galleryLink.href"
        :label="props.galleryLink.label"
      />

      <figure class="relative w-full max-w-[1428px] overflow-hidden rounded-lg bg-neutrals-1000 shadow-[4px_4px_14px_6px_rgba(82,81,81,0.10)]">
        <img
          v-if="heroImageUrl"
          :src="heroImageUrl"
          :alt="props.heroPhoto.title"
          class="h-[260px] w-full object-cover md:h-[688px]"
        />

        <div
          v-else
          class="flex h-[260px] w-full items-end bg-gradient-to-br from-neutrals-1000 via-neutrals-900 to-neutrals-700 p-600 md:h-[688px]"
          role="img"
          :aria-label="props.heroPhoto.title"
        >
          <span class="text-body-strong-sm text-white-transp-1000">
            {{ props.heroPhoto.caption }}
          </span>
        </div>
      </figure>

      <div class="flex w-full max-w-[1428px] flex-col items-center gap-800">
        <MediaExternalLink
          :href="props.youtubeLink.href"
          :label="props.youtubeLink.label"
        />

        <div class="grid w-full gap-800">
          <MediaVideoEmbed
            v-for="video in props.videos"
            :key="video.title"
            :video="video"
          />
        </div>
      </div>
    </section>
  </TwContainer>
</template>
