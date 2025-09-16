<script setup>
import { computed } from "vue"
import ArticleCard from '@components/common/cards/ArticleCard.vue';
import { ButtonText } from '@components/common/buttons';
import { IconPlus } from "@components/common/icons"
import { usePage } from "@inertiajs/vue3";

const props = defineProps({
  articles: { type: Array, required: true, default: () => []}
})

const page = usePage();

const computedHeightClass = computed(() => {
  return (index) => {
    if (index === 0) {
      return "h-[589px]";
    }
    if (index === 1) {
      return "h-[472px]";
    }
    return "h-[472px]";
  };
});

const backgroundImageUrl = (fileName) => {
  // TODO: ADD CDN
  const baseUrl = "https://s3.amazonaws.com/festivaldorio/imagens/noticias/medium2/"
  return `${baseUrl}${fileName}`
}
</script>

<template>
  <div class="flex flex-col gap-y-800">
    <h2 class="text-header-base text-3xl text-primary">Últimas notícias</h2>
    <div
      class="grid lg:grid-flow-col lg:grid-rows-3 items-start gap-800"
      style="grid-auto-rows: min-content;"
    >
      <!-- Main two articles. First is bigger -->
      <ArticleCard
        v-for="(article, index) in articles.slice(0, 2)"
        :key="article.id"
        :title="article.titulo"
        :content="article.chamada"
        :date="article.display_date"
        :category="article.caderno_nome"
        :background-image="backgroundImageUrl(article.imagem)"
        :permalink="article.permalink"
        :variant="index === 0 ? 'primary' : 'secondary'"
        :heightClass="[index === 0 ? 'lg:row-span-3 lg:col-span-2' : 'lg:row-span-2']"
        />
    </div>

    <!-- Small 4 articles -->
    <div
      class="flex flex-col gap-y-800 lg:-mt-20 lg:grid lg:gap-x-800 lg:grid-cols-4"
    >
      <ArticleCard
        v-for="article in articles.slice(2,6)"
        :key="article.id"
        :title="article.titulo"
        :content="article.chamada"
        :date="article.display_date"
        :category="article.caderno_nome"
        :background-image="backgroundImageUrl(article.imagem)"
        :permalink="article.permalink"
        variant="secondary"
        />
        <!-- :heightClass="computedHeightClass(2)" -->
    </div>

    <ButtonText
      tag="a"
      :href="`${page.props.currentLocale}/noticias`"
      text="Ver mais"
      variant="dark"
      size="md"
      class="self-center hover:text-neutrals-700"
    >
      <!-- <template v-slot:icon>
        <IconPlus class="me-100" />
      </template> -->
    </ButtonText>
  </div>
</template>

<style scoped></style>
