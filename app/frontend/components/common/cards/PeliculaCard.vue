<script setup>
import { computed, ref } from "vue";
import { Link } from "@inertiajs/vue3";

import DefaultImage from "@assets/images/poc-poster.jpg";
import TagMostra from "@/components/common/tags/TagMostra.vue";

const isHovered = ref(false);
const props = defineProps({
  pelicula: { type: Object, required: true },
  linkable: { type: Boolean, default: true },
});
const cardImage = computed(() => props.pelicula.card_image || null);
const moviePoster = computed(
  () => cardImage.value?.src || props.pelicula.imageURL || DefaultImage,
);
const movieGenre = computed(() => props.pelicula.genre || "TBD");
const wrapperTag = computed(() => (props.linkable ? Link : "div"));
const wrapperProps = computed(() =>
  props.linkable ? { href: props.pelicula.url } : {},
);
</script>

<template>
  <!--  w-[380px] -->
  <div
    class="flex flex-col items-start gap-200"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <!-- image -->
    <!-- LINK (plain wrapper when not linkable, e.g. previous editions) -->
     <component :is="wrapperTag" v-bind="wrapperProps" class="w-full">
      <div class="relative w-full">
        <img
          :src="moviePoster"
          :srcset="cardImage?.srcset"
          :sizes="cardImage?.sizes"
          :alt="props.pelicula.display_titulo"
          class="rounded-200 h-[268px] w-full object-cover"
          loading="lazy"
          decoding="async"
        />
        <!-- Overlay -->
        <div
          class="absolute inset-0 rounded-200 pointer-events-none"
          style="
            background: linear-gradient(
              180deg,
              rgba(0, 0, 0, 0.3) 36.54%,
              rgba(0, 0, 0, 0.45) 100%
            );
          "
        ></div>
        <!-- tag -->
        <TagMostra
          class="absolute top-0 left-0 rounded-tl-200"
          :tag-class="props.pelicula.mostra_tag_class"
          :text="props.pelicula.mostra_display_name"
        />

        <div class="content absolute bottom-250 left-250 flex flex-col gap-[5px]">
          <!-- LINK movie title -->
          <h2 class="text-header-sm text-on-dark">
            {{ props.pelicula.display_titulo }}
          </h2>
          <div class="flex items-center gap-200">
            <span class="text-overline text-on-dark-secondary">{{ props.pelicula.display_paises }}</span>
            <img
              src="@assets/icons/divisor.svg"
              alt="divisor"
              height="16px"
              width="1px"
            />
            <span class="text-overline text-on-dark-secondary">{{
              movieGenre
            }}</span>
            <img
              src="@assets/icons/divisor.svg"
              alt="divisor"
              height="16px"
              width="1px"
            />
            <span class="text-overline text-on-dark-secondary"
              >{{ props.pelicula.duracao_coord_int }}'</span
            >
          </div>
          <!-- Animated underline -->
          <span
            class="w-full bg-white-transp-900 transition-height duration-100"
            :style="{ height: props.linkable && isHovered ? '1px' : '0px' }"
          ></span>
        </div>
      </div>
    </component>
  </div>
</template>
