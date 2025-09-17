<script setup>
import { computed, ref } from "vue";
import { Link } from "@inertiajs/vue3";

import DefaultImage from "@assets/images/poc-poster.jpg"
import TagMostra from "@/components/common/tags/TagMostra.vue";

// Hover state
const isHovered = ref(false);
const props = defineProps({
  pelicula: { type: Object, required: true },
  edicao: { type: String, default: "2024" },
  size: { type: String, default: "large" },
});
const moviePoster = computed(() => {
  const baseUrl = "https://festivaldorio.s3.us-east-1.amazonaws.com"

  const fullUrl = `${baseUrl}/${props.edicao}/site/peliculas/${props.size}`
  if (props.pelicula.imagem) {
    return `${fullUrl}/${props.pelicula.imagem}`
  }

  return DefaultImage
});
const movieGenre = computed(() => {
  return props.pelicula.genre || "TBD";
});
</script>

<template>
  <!--  w-[380px] -->
  <div
    class="flex flex-col items-start gap-200"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <!-- image -->
    <!-- LINK -->
     <Link :href="props.pelicula.url" class="w-full">
      <div class="relative w-full">
        <img
          :src="moviePoster"
          alt="movie-name poster"
          class="rounded-200 h-[268px] w-full object-cover"
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
            :style="{ height: isHovered ? '1px' : '0px' }"
          ></span>
        </div>
      </div>
    </Link>
  </div>
</template>
