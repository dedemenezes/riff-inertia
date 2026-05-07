<script setup>
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import Cartaz from "@/components/common/cards/Cartaz.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import { Link } from "@inertiajs/vue3";

const props = defineProps({
  edicoes: { type: Array, default: () => [] },
  crumbs: { type: Array, required: true },
});
</script>

<template>
  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
  </TwContainer>
  <MenuContext nav="sobre" />
  <hr class="text-neutrals-300" />

  <TwContainer>
    <ul class="grid grid-cols-2 lg:grid-cols-6 py-1200 gap-800">
      <li v-for="edicao in props.edicoes" :key="edicao.id">
        <Link :href="`/edicoes_anteriores/${edicao.id}/mostras`" prefetch>
          <Cartaz
            :cartaz="`https://s3.amazonaws.com/festivaldorio/imagens/edicoes/small/${edicao.cartaz}`"
            :descricao="edicao.descricao"
          />
        </Link>
      </li>
    </ul>
  </TwContainer>
</template>

<style scoped></style>
