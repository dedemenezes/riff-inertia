<script setup>
import { onBeforeUnmount, onMounted } from 'vue';
import { ref, watch, computed, defineAsyncComponent } from 'vue';
import PhotoSwipeLightbox from 'photoswipe/lightbox';
import 'photoswipe/dist/photoswipe.css';
import { Carousel, CarouselContent, CarouselItem, CarouselNext, CarouselPrevious } from '@/components/ui/carousel';

const InformacoesContent = defineAsyncComponent(() => import('@/components/features/peliculas/InformacoesContent.vue'));
const SessoesContent = defineAsyncComponent(() => import('@/components/features/peliculas/SessoesContent.vue'));
const CreditosContent = defineAsyncComponent(() => import('@/components/features/peliculas/CreditosContent.vue'));
const TwContainer = defineAsyncComponent(() => import('@/components/layout/TwContainer.vue'));
const TagMostra = defineAsyncComponent(() => import('@/components/common/tags/TagMostra.vue'));
const TabbedPanel = defineAsyncComponent(() => import('@/components/common/tabs/TabbedPanel.vue'));
const VideoBanner = defineAsyncComponent(() => import('@/components/features/peliculas/VideoBanner.vue'));
import { useUpdateWindowWidth } from '@/lib/utils';

const props = defineProps({
  rootUrl: { type: String, required: true },
  crumbs: { type: Array, required: true, default: () => []},
  backPath: String,
  pelicula: { type: Object, required: true }
});

const tabs = [
  { id: 'first', label: 'Informações' },
  { id: 'second', label: 'Sessões' },
  { id: 'third', label: 'Créditos' }
]

const startingTab = 0
const activeTab = ref(tabs[startingTab].id)

const isDesktop = useUpdateWindowWidth();

// PhotoSwipe uses data-pswp-width/height; preload natural size for every banner image.
const pswpDims = ref(new Map());

function preloadDims(url) {
  if (!url || pswpDims.value.has(url)) return;
  const img = new Image();
  img.onload = () => {
    if (img.naturalWidth > 0) {
      pswpDims.value = new Map(pswpDims.value).set(url, {
        w: img.naturalWidth,
        h: img.naturalHeight
      });
    }
  };
  img.src = url;
}

watch(
  () => [props.pelicula.imageURL, ...(props.pelicula.carousel_images ?? []).map((i) => i.path)],
  (urls) => urls.forEach(preloadDims),
  { immediate: true }
);

const brokenBannerSrcs = ref(new Set());
const onBannerImageError = (src) => {
  brokenBannerSrcs.value = new Set([...brokenBannerSrcs.value, src]);
};

const bannerImages = computed(() => {
  const images = [];
  if (props.pelicula.imageURL) {
    const dims = pswpDims.value.get(props.pelicula.imageURL);
    const src = props.pelicula.banner_image?.src ?? props.pelicula.imageURL;
    if (!brokenBannerSrcs.value.has(src)) {
      images.push({
        href: props.pelicula.imageURL,
        src,
        srcset: props.pelicula.banner_image?.srcset,
        sizes: props.pelicula.banner_image?.sizes,
        pswpWidth: dims?.w ?? 1920,
        pswpHeight: dims?.h ?? 1080
      });
    }
  }
  (props.pelicula.carousel_images ?? []).forEach((img) => {
    if (brokenBannerSrcs.value.has(img.path)) return;
    const dims = pswpDims.value.get(img.path);
    images.push({
      href: img.path,
      src: img.path,
      pswpWidth: dims?.w ?? 1920,
      pswpHeight: dims?.h ?? 1080
    });
  });
  return images;
});

const lightbox = new PhotoSwipeLightbox({
  gallery: '#my-gallery',
  children: 'a',
  pswpModule: () => import('photoswipe')
});

onMounted(() => {
  lightbox.init();
});

onBeforeUnmount(() => {
  lightbox.destroy();
});
</script>

<template>
  <!-- banner carousel: each <a> supplies PhotoSwipe href + data-pswp-* inside #my-gallery. -->
  <div id="my-gallery">
    <Carousel v-if="bannerImages.length > 0" class="w-full">
      <CarouselContent class="-ml-0">
        <CarouselItem v-for="(image, idx) in bannerImages" :key="image.href" class="pl-0">
          <a
            class="block h-[222px] md:h-[634px] w-full cursor-zoom-in outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
            :href="image.href"
            :data-pswp-width="image.pswpWidth"
            :data-pswp-height="image.pswpHeight"
          >
            <img
              :src="image.src"
              :srcset="image.srcset"
              :sizes="image.sizes"
              class="h-full w-full object-cover pointer-events-none"
              :alt="`${pelicula.display_titulo} banner ${idx + 1}`"
              @error="onBannerImageError(image.src)"
            />
          </a>
        </CarouselItem>
      </CarouselContent>
      <CarouselPrevious class="left-4 translate-x-0" />
      <CarouselNext class="right-4 translate-x-0" />
    </Carousel>
  </div>
  <!-- short info card -->
  <header>
    <div class="bg-neutrals-200">
      <TwContainer>
        <div class="py-400 space-y-400">
          <section>
            <h1 class="text-header-medium-sm pb-100">{{ props.pelicula.titulo_portugues_coord_int }}</h1>
            <h2 class="text-body-regular italic">{{ props.pelicula.titulo_ingles_coord_int }}</h2>
          </section>
          <div class="flex items-center gap-200 flex-wrap">
            <p class="text-overline shrink-0">{{ props.pelicula.display_paises }}</p>
            <img
              src="@assets/icons/divisor_black.svg"
              alt=""
              aria-hidden="true"
              class="h-[16px] select-none"
            />
            <p class="text-overline">{{ props.pelicula.ano_coord_int }}</p>
            <img
              src="@assets/icons/divisor_black.svg"
              alt=""
              aria-hidden="true"
              class="h-[16px] select-none"
            />
            <p class="text-overline">{{ props.pelicula.genre }}</p>
            <img
              src="@assets/icons/divisor_black.svg"
              alt=""
              aria-hidden="true"
              class="h-[16px] select-none"
            />
            <p class="text-overline">{{ props.pelicula.duracao_coord_int }}'</p>
            <img
              src="@assets/icons/divisor_black.svg"
              alt=""
              aria-hidden="true"
              class="h-[16px] select-none"
            />
            <p class="text-overline">{{ props.pelicula.cor_coord_int }}</p>
          </div>
          <TagMostra class="rounded-100" :tag-class="props.pelicula.mostra_tag_class" :text="props.pelicula.mostra_name" />
        </div>
      </TwContainer>
    </div>
  </header>

  <!-- Tabs -->
  <TwContainer>

    <TabbedPanel v-model="activeTab" :tabs="tabs" class="py-400 justify-center lg:hidden" />

    <!-- EACH SHOULD BE A COMPONENT LAZY LOADED -->
    <div class="flex flex-col justify-center gap-6 sm:flex-row sm:gap-800 py-600">

      <section v-if="activeTab === 'third' || isDesktop" class="w-full lg:w-1/3">
        <!-- EACH SHOULD BE A COMPONENT LAZY LOADED -->
        <Suspense>
          <CreditosContent :pelicula="pelicula"/>
          <template #fallback>
            <div class="animate-pulse bg-gray-200 h-32 rounded"></div>
          </template>
        </Suspense>
      </section>

      <section v-if="activeTab === 'first' || isDesktop" class="w-full lg:w-2/3">
        <Suspense>
          <InformacoesContent :pelicula="pelicula"/>
          <template #fallback>
            <div class="animate-pulse bg-gray-200 h-32 rounded"></div>
          </template>
        </Suspense>
      </section>

      <section v-if="activeTab === 'second' || isDesktop" class="w-full lg:w-1/3 space-y-400">
        <Suspense>
          <SessoesContent :sessions="pelicula.programacoesAsJson"/>
          <template #fallback>
            <div class="animate-pulse bg-gray-200 h-32 rounded"></div>
          </template>
        </Suspense>
      </section>
    </div>
  </TwContainer>

  <Suspense v-if="pelicula.youtube_link_trailer || pelicula.vimeo_link_trailer">
    <TwContainer>
      <VideoBanner
        :youtube-link-trailer="pelicula.youtube_link_trailer"
        :vimeo-link-trailer="pelicula.vimeo_link_trailer"
        :fallback-image="pelicula.imageURL"
        :title="pelicula.display_titulo"
      />
      <template #fallback>
        <div class="aspect-video w-full bg-neutrals-900 animate-pulse" />
      </template>
    </TwContainer>
  </Suspense>
</template>

<style scoped>
</style>
