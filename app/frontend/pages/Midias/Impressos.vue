<script setup>
import { computed } from "vue";
import { Head } from "@inertiajs/vue3";
import TwContainer from "@/components/layout/TwContainer.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MediaPdfCard from "@/components/features/midias/MediaPdfCard.vue";
import revistaProgramacaoCover from "@assets/images/midias/revista-programacao.png";
import catalogoOficialCover from "@assets/images/midias/catalogo-oficial.png";
import cartazesCover from "@assets/images/midias/cartazes.png";

const props = defineProps({
  title: { type: String, default: "" },
  activePage: { type: String, default: "" },
  printMaterials: {
    type: Array,
    default: () => [],
  },
});

const coverImages = {
  "revista-programacao": revistaProgramacaoCover,
  "catalogo-oficial": catalogoOficialCover,
  cartazes: cartazesCover,
};

const printMaterialsWithImages = computed(() =>
  props.printMaterials.map((material) => ({
    ...material,
    coverImageUrl: material.coverImageUrl || coverImages[material.coverImageKey] || "",
  })),
);
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
          v-for="material in printMaterialsWithImages"
          :key="material.title"
          :material="material"
        />
      </div>
    </section>
  </TwContainer>
</template>
