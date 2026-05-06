<script setup>
import { usePage } from "@inertiajs/vue3";
import { Head } from "@inertiajs/vue3";
import NewsCard from "@/components/common/cards/NewsCard.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import TalentsLayout from "@/pages/Talents/TalentsLayout.vue";

defineOptions({ layout: TalentsLayout });

defineProps({
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
