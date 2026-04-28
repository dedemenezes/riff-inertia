<script setup>
import HorizontalScrollLayout from "@/components/layout/HorizontalScrollLayout.vue";
import DestaqueCard from "@/components/common/cards/DestaqueCard.vue";

defineProps({
  tipoNome: { type: String, required: true },
  items: { type: Array, required: true, default: () => [] },
});
</script>

<template>
  <div class="py-800">
    <HorizontalScrollLayout
      variant="light"
      mobile-variant="dark"
      :mobile-scroll-distance="0.4"
    >
      <template #header>
        <h3 class="text-header-xxl text-neutrals-900">{{ tipoNome }}</h3>
      </template>
      <template #content>
        <div
          v-for="destaque in items"
          :key="destaque.id"
          class="flex-shrink-0 w-full sm:w-1/3 lg:w-1/4 sm:min-w-[280px]"
        >
          <DestaqueCard
            :titulo="destaque.titulo"
            :imagem="destaque.imagem"
            :url="destaque.url"
            :destino="destaque.destino"
          />
        </div>
      </template>
    </HorizontalScrollLayout>
  </div>
</template>
