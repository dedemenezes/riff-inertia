<script setup>
import Breadcrumb from '@/components/common/Breadcrumb.vue';
import IndexArticleCard from '@/components/common/cards/IndexArticleCard.vue';
import TwContainer from '@/components/layout/TwContainer.vue';
const props = defineProps({
  breadcrumbs: { type: Array, default: () => []},
  noticias: { type: Array, default: () => []}
})
</script>

<template>
  <TwContainer>
    <Breadcrumb  :crumbs="props.breadcrumbs"/>
    <div class="flex flex-col gap-800">
      <IndexArticleCard
        v-for="article in noticias"
        :key="article.id"
        :title="article.titulo"
        :permalink="article.permalink"
        :chamada="article.chamada"
        :imagem="article.imagem"
        :category="article.caderno_nome"
        :date="article.display_date"
      />
    </div>
  </TwContainer>
</template>

<style scoped></style>
