<script setup>
import { Head } from "@inertiajs/vue3";
import NavTab from "@/components/common/tabs/NavTab.vue";
import SectionHeader from "@/components/common/SectionHeader.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

defineProps({
  sections: { type: Array, required: false, default: () => [] },
  tabs: { type: Array, required: false, default: () => [] },
});
</script>

<template>
  <Head>
    <title>Talents Rio - Programação</title>
  </Head>

  <TwContainer>
    <div v-if="tabs.length" class="py-800">
      <nav
        aria-label="Talents sections"
        class="flex gap-300 items-center px-400 h-12"
      >
        <NavTab
          v-for="tab in tabs"
          :key="tab.label"
          :href="tab.href"
          :active="tab.active"
        >
          {{ tab.label }}
        </NavTab>
      </nav>
    </div>

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
::v-deep(.content p),
::v-deep(.content span),
::v-deep(.content li) {
  font-family: "Inter", sans-serif;
  font-size: 16px;
  font-weight: 400;
  line-height: 2;
}

::v-deep(.content p:not(:empty):not(:has(img))) {
  margin-bottom: 1rem;
}

::v-deep(.content b) {
  font-weight: 600;
}

::v-deep(.content ul) {
  list-style: disc;
  padding-left: 1.5rem;
  margin-bottom: 1rem;
}

::v-deep(.content a) {
  text-decoration: underline;
}

::v-deep(.content a:hover) {
  color: var(--color-vermelho-400);
}
</style>
