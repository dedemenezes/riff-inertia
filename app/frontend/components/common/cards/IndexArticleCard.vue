<script setup>
import { Link, usePage } from "@inertiajs/vue3"
import { computed } from "vue";

const page = usePage();
const props = defineProps({
  date: { type: String, required: true },
  category: { type: String, required: true },
  permalink: { type: String, required: true },
  imagem: { type: String, required: true },
  title: { type: String, required: true },
  chamada: { type: String, required: true },
})

const imageUrl = computed(() => {
  return `https://s3.amazonaws.com/festivaldorio/imagens/noticias/medium2/${props.imagem}`
})
</script>

<template>
  <div class="flex flex-col gap-200 md:flex-row md:gap-400">
    <!-- TODO: Review for locale ✅ filtering from controller by idioma -->
    <Link
      :href="`/${page.props.currentLocale}/noticias/${props.permalink}`"
      class="w-full"
    >
      <img :src="imageUrl" class="w-full h-[216px] md:h-[155px] object-cover rounded-200" />
    </Link>
    <div class="content grid grid-rows gap-200">
      <div class="flex gap-x-200 items-center self-start">
        <span class="text-overline text-primary">
          {{ props.date }}
        </span>
        <svg xmlns="http://www.w3.org/2000/svg" width="1" height="16" viewBox="0 0 1 16" fill="none">
          <rect width="1" height="16" fill="#908C84"/>
        </svg>
        <span class="text-overline text-primary">
          {{ props.category }}
        </span>
      </div>
      <h3 class="text-header-medium-sm text-neutrals-900">
        <Link :href="`/pt/noticias/${props.permalink}`">
          {{ props.title }}
        </Link>
      </h3>
      <p class="text-neutrals-900 text-body-regular-xs">{{ props.chamada }}</p>
    </div>
  </div>
</template>

<style scoped>
</style>
