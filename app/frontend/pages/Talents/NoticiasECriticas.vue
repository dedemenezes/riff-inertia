<script setup>
import { computed } from "vue";
import { Head, usePage } from "@inertiajs/vue3";
import NewsCard from "@/components/common/cards/NewsCard.vue";
import NavTab from "@/components/common/tabs/NavTab.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  tabs: { type: Array, required: false, default: () => [] },
  noticias: { type: Array, required: false, default: () => [] },
});

const page = usePage();

const NOTICIA_IMAGE_BASE_URL =
  "https://s3.amazonaws.com/festivaldorio/imagens/noticias/medium2/";

const cards = computed(() =>
  props.noticias.map((noticia) => ({
    id: noticia.id,
    title: noticia.titulo,
    date: noticia.display_date,
    category: noticia.caderno_nome,
    image: `${NOTICIA_IMAGE_BASE_URL}${noticia.imagem}`,
    permalink: `/${page.props.currentLocale}/noticias/${noticia.permalink}`,
  }))
);
</script>

<template>
  <Head>
    <title>Talents Rio - Notícias e Críticas</title>
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

    <div class="py-1600">
      <ul
        v-if="cards.length"
        class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-800"
      >
        <li v-for="card in cards" :key="card.id">
          <NewsCard
            variant="secundaria"
            :image="card.image"
            :title="card.title"
            :date="card.date"
            :category="card.category"
            :permalink="card.permalink"
          />
        </li>
      </ul>
    </div>
  </TwContainer>
</template>
