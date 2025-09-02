<script setup>
import { computed } from "vue"
import ArticleCard from '@components/common/cards/ArticleCard.vue';
import { ButtonText } from '@components/common/buttons';
import { IconPlus } from "@components/common/icons"

const props = defineProps({
  articles: { type: Array, required: true, default: () => []}
})

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
</script>

<template>
  <div class="flex flex-col gap-y-800">
    <h2 class="text-header-base text-3xl text-primary">Últimas notícias</h2>
    <div
      class="flex flex-col gap-y-800 lg:grid lg:gap-x-800 lg:grid-cols-[2fr_1fr]"
    >
    <!-- Main two articles. First is bigger -->
    <ArticleCard
      v-for="(article, index) in articles.slice(0, 2)"
      :key="article.id"
      :title="article.titulo"
      :content="article.chamada"
      :date="article.display_date"
      :category="article.caderno_nome"
      :background-image="`https://s3.amazonaws.com/festivaldorio/files/imagens/${article.imagem}`"
      :permalink="article.permalink"
      :heightClass="computedHeightClass(index)"
      variant="primary"
    />
    </div>

    <!-- Small 4 articles -->
    <div
      class="flex flex-col gap-y-800 lg:grid lg:gap-x-800 lg:grid-cols-4"
    >
      <ArticleCard
        v-for="article in articles.slice(2,6)"
        :key="article.id"
        :title="article.titulo"
        :content="article.chamada"
        :date="article.display_date"
        :category="article.caderno_nome"
        :background-image="`https://s3.amazonaws.com/festivaldorio/files/imagens/${article.imagem}`"
        :permalink="article.permalink"
        :heightClass="computedHeightClass"
        variant="secondary"
      />
    </div>

    <ButtonText
      tag="a"
      text="Ver mais"
      variant="dark"
      size="md"
      class="self-center hover:text-neutrals-700"
    >
      <template v-slot:icon>
        <IconPlus class="me-100" />
      </template>
    </ButtonText>
  </div>
</template>

<style scoped></style>
