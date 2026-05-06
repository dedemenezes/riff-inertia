<script setup>
import { Head } from "@inertiajs/vue3";
import SectionHeader from "@/components/common/SectionHeader.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import TalentsLayout from "@/pages/Talents/TalentsLayout.vue";

defineOptions({ layout: TalentsLayout });

defineProps({
  sections: { type: Array, required: false, default: () => [] },
});
</script>

<template>
  <Head>
    <title>Talents Rio - Programação</title>
  </Head>

  <TwContainer>
    <div class="flex flex-col gap-600 py-1600">
      <section
        v-for="(section, index) in sections"
        :key="section.titulo + '_' + index"
        class="flex flex-col gap-800"
      >
        <SectionHeader>{{ section.titulo }}</SectionHeader>
        <div class="content text-neutrals-900" v-html="section.body_html"></div>
      </section>
    </div>
  </TwContainer>
</template>

<style scoped>
:deep(.content p),
:deep(.content span),
:deep(.content li) {
  font-family: "Inter", sans-serif;
  font-size: 16px;
  font-weight: 400;
  line-height: 2;
}

:deep(.content p:not(:empty):not(:has(img))) {
  margin-bottom: 1rem;
}

:deep(.content b) {
  font-weight: 600;
}

:deep(.content ul) {
  list-style: disc;
  padding-left: 1.5rem;
  margin-bottom: 1rem;
}

:deep(.content a) {
  text-decoration: underline;
}

:deep(.content a:hover) {
  color: var(--color-vermelho-400);
}
</style>
