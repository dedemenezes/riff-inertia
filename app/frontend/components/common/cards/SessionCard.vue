<script setup>
import { computed, ref } from "vue";

import TagMostra from "@/components/common/tags/TagMostra.vue";
import TagScreening from "@/components/common/tags/TagScreening.vue";
import { IconPin } from "@/components/common/icons";
// Hover state
const isHovered = ref(false);
const props = defineProps({
  session: { type: Object, required: true },
  edicao: { type: String, default: "2024" },
  size: { type: String, default: "large" },
});
const moviePoster = computed(() => {
  const baseUrl = "https://festivaldorio.s3.us-east-1.amazonaws.com"

  const fullUrl = `${baseUrl}/${props.edicao}/site/peliculas/${props.size}`
  if (props.session.imagem) {
    return `${fullUrl}/${props.session.imagem}`
  }

  return "@assets/poc-poster.jpg";
});
const movieGenre = computed(() => {
  return props.session.genero || "TBD";
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
        :tag-class="props.session.mostra_tag_class"
        :text="props.session.mostra"
      />

      <div class="content absolute bottom-250 left-250 flex flex-col gap-[5px]">
        <!-- movie title -->
        <h2 class="text-header-sm text-on-dark">
          {{ props.session.titulo }}
        </h2>
        <div class="flex items-center gap-200">
          <span class="text-overline text-on-dark-secondary">{{ props.session.paises }}</span>
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
            >{{ props.session.duracao }}'</span
          >
        </div>
        <!-- Animated underline -->
        <span
          class="w-full bg-white-transp-900 transition-height duration-100"
          :style="{ height: isHovered ? '1px' : '0px' }"
        ></span>
      </div>
    </div>
    <div class="px-200 space-y-250 w-full">
      <div class="flex items-center gap-[6px]">
        <IconPin width="16" height="16" />
        <p class="text-body-regular text-primary">
          {{ props.session.cinema }}
        </p>
      </div>
      <div class="flex items-center space-x-200">
        <TagScreening
          v-for="screening in props.session.sessao"
          :key="screening"
          :time="screening"
        />
      </div>
    </div>
  </div>
</template>
