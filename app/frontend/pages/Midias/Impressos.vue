<script setup>
import { Head } from "@inertiajs/vue3";
import TwContainer from "@/components/layout/TwContainer.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MediaPdfCard from "@/components/features/midias/MediaPdfCard.vue";

const props = defineProps({
  title: { type: String, default: "" },
  activePage: { type: String, default: "" },
  printMaterials: {
    type: Array,
    default: () => [],
  },
});
</script>

<template>
  <Head>
    <title>{{ props.title }}</title>
  </Head>

  <MenuContext nav="midias" :active-page="props.activePage" />
  <hr class="text-neutrals-300" />

  <TwContainer>
    <section class="py-1000 md:py-1600">
      <div class="grid gap-1000 md:grid-cols-3 md:justify-items-center">
        <MediaPdfCard
          v-for="material in props.printMaterials"
          :key="material.title"
          :material="material"
        />
      </div>
    </section>
  </TwContainer>
</template>
