<script setup>
import { usePage } from "@inertiajs/vue3";
import { Head } from "@inertiajs/vue3";
import NewsCard from "@/components/common/cards/NewsCard.vue";
import NavTab from "@/components/common/tabs/NavTab.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  tabs: { type: Array, required: false, default: () => [] },
  noticias: { type: Array, required: false, default: () => [] },
});

const page = usePage();

const noticiaPermalink = (permalink) =>
  `/${page.props.currentLocale}/noticias/${permalink}`;
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
        v-if="noticias.length"
        class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-800"
      >
        <li v-for="noticia in noticias" :key="noticia.id">
          <NewsCard
            variant="secundaria"
            :image="noticia.image_url"
            :title="noticia.titulo"
            :date="noticia.display_date"
            :category="noticia.caderno_nome"
            :permalink="noticiaPermalink(noticia.permalink)"
          />
        </li>
      </ul>
    </div>
  </TwContainer>
</template>
