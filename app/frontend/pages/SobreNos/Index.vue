<script setup>
import { onBeforeUnmount, onMounted } from "vue";
import PhotoSwipeLightbox from "photoswipe/lightbox";
import "photoswipe/dist/photoswipe.css";
import TwContainer from "@components/layout/TwContainer.vue";
import Breadcrumb from "@components/common/Breadcrumb.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import NewsletterCard from "@components/common/cards/NewsletterCard.vue";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import sobreImg from "@assets/images/sobre-img.png";
import trofeuRedentor from "@assets/images/trofeu_redentor.png";

const props = defineProps({
  titulo: { type: String, default: "" },
  conteudo: { type: String, default: "" },
  breadcrumbs: { type: Array, default: () => [] },
});

const carouselImages = [
  { src: sobreImg, alt: "Festival do Rio", width: 1728, height: 688 },
  { src: trofeuRedentor, alt: "Troféu Redentor", width: 1428, height: 688 },
];

const lightbox = new PhotoSwipeLightbox({
  gallery: "#sobre-nos-carousel",
  children: "a",
  pswpModule: () => import("photoswipe"),
});

onMounted(() => {
  lightbox.init();
});

onBeforeUnmount(() => {
  lightbox.destroy();
});
</script>

<template>
  <TwContainer>
    <Breadcrumb :crumbs="props.breadcrumbs" />
  </TwContainer>

  <MenuContext nav="sobre" />
  <hr class="text-neutrals-300" />

  <TwContainer>
    <div class="flex flex-col gap-600 py-1200">
      <h1 class="text-header-lg">{{ props.titulo }}</h1>
      <div
        v-html="props.conteudo"
        class="content text-justify text-neutrals-900"
      ></div>
    </div>
  </TwContainer>

  <div id="sobre-nos-carousel" class="mb-1200">
    <Carousel class="w-full">
      <CarouselContent class="-ml-0">
        <CarouselItem
          v-for="(image, idx) in carouselImages"
          :key="idx"
          class="pl-0 carousel-slide"
        >
          <a
            class="block h-[222px] md:h-[634px] w-full cursor-zoom-in outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
            :href="image.src"
            :data-pswp-width="image.width"
            :data-pswp-height="image.height"
          >
            <img
              :src="image.src"
              :alt="image.alt"
              class="h-full w-full object-cover pointer-events-none"
            />
          </a>
        </CarouselItem>
      </CarouselContent>
      <CarouselPrevious class="left-4 translate-x-0" />
      <CarouselNext class="right-4 translate-x-0" />
    </Carousel>
  </div>

  <TwContainer>
    <NewsletterCard />
  </TwContainer>
</template>

<style scoped>
::v-deep .content p,
::v-deep .content span,
::v-deep .content b {
  font-family: "Inter" !important;
  font-size: 16px !important;
  font-style: normal !important;
  font-weight: 400 !important;
  line-height: 200% !important;
}

::v-deep .content p:not(:empty):not(:has(img)) {
  margin-bottom: 1.5rem;
}

::v-deep .content b {
  font-weight: 600 !important;
}

::v-deep .content a {
  text-decoration: underline !important;
}

::v-deep .content a:hover {
  color: var(--color-vermelho-400) !important;
}

::v-deep .content img {
  width: 100% !important;
  border-radius: 8px;
  object-fit: cover;
}

::v-deep .content img + br + i:not(:empty),
::v-deep .content i > span,
::v-deep .content span > i {
  font-family: "Inter" !important;
  font-size: 14px !important;
  font-style: normal !important;
  font-weight: 400 !important;
  line-height: 150% !important;
  color: #3b3935 !important;
}

::v-deep p:has(i) {
  margin-bottom: 1rem;
}

::v-deep br {
  display: none;
}

/* .carousel-slide {
  height: 278px;
}

@media (min-width: 768px) {
  .carousel-slide {
    height: 568px;
  }
} */
</style>
