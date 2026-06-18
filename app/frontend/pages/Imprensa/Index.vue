<script setup>
import { Head } from "@inertiajs/vue3";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  titulo: { type: String, default: "" },
  conteudo: { type: String, default: "" },
});
</script>

<template>
  <Head>
    <title>{{ props.titulo }}</title>
  </Head>

  <TwContainer>
    <section class="flex flex-col gap-600 md:gap-800 max-w-[1428px] py-800 md:py-1200">
      <div class="flex flex-col gap-150">
        <h1 class="text-header-lg text-neutrals-900">
          {{ props.titulo }}
        </h1>
        <div class="h-px bg-gradient-to-r from-magenta-600 to-laranja-600"></div>
      </div>

      <div
        class="content max-w-[940px] text-neutrals-900"
        v-html="props.conteudo"
      ></div>
    </section>
  </TwContainer>
</template>

<!--
  NOTE: estilos .content duplicados de pages/Ingressos/Conteudo.vue de propósito.
  A extração de um renderer compartilhado de conteúdo legado fica para uma
  task/branch separada. O conteúdo é renderizado como está (sem normalização de
  <br> ou <p> vazios), conforme decisão de produto.
-->
<style scoped>
:deep(.content p),
:deep(.content span),
:deep(.content li) {
  font-family: "Inter", sans-serif;
  font-size: 16px;
  font-weight: 400;
  line-height: 2;
}

:deep(.content p) {
  margin-bottom: 1.5rem;
}

:deep(.content b),
:deep(.content strong) {
  font-weight: 600;
}

:deep(.content ul) {
  list-style: disc;
  padding-left: 1.5rem;
  margin-bottom: 1.5rem;
}

:deep(.content ol) {
  list-style: decimal;
  padding-left: 1.5rem;
  margin-bottom: 1.5rem;
}

:deep(.content a) {
  text-decoration: underline;
}

:deep(.content a:hover) {
  color: var(--color-vermelho-400);
}
</style>
