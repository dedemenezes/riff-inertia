<script setup>
import { defineAsyncComponent, ref } from 'vue';
import BaseButton from '@/components/common/buttons/BaseButton.vue';
import { IconChevronLeft, IconChevronRight } from '@/components/common/icons';
const PeliculaSessionCard = defineAsyncComponent(() => import('@/components/common/cards/PeliculaSessionCard.vue'));
const props = defineProps({
  sessions: { type: Array, default: () => [] }
})

const pagesTotal = props.sessions.length;
const activePage = ref(0);

const sessionWrapper = ref(null);

function scrollToTopOfSessions() {
  sessionWrapper.value?.scrollIntoView({ behavior: 'smooth' });
}

console.log(props.sessions)
</script>
<!-- TODO: TRADUZIR -->
<template>
  <div ref="sessionWrapper" class="flex flex-col gap-400">
    <BaseButton variant="dark" class="w-full">Comprar pacote de ingressos</BaseButton>
    <div v-for="(session, index) in props.sessions[activePage]">
      <PeliculaSessionCard class="mb-400" :session="session" />
      <hr v-show="index < 2" class="text-neutrals-300">
    </div>
    <div class="flex items-center justify-center gap-600">
      <button
        v-if="pagesTotal > 1"
        type="button"
        :disabled="activePage == 0"
        class="text-neutrasl-700 cursor-pointer disabled:pointer-events-none disabled:text-neutrals-300"
        @click="() => { activePage--; scrollToTopOfSessions(); }"
      >
        <IconChevronLeft />
      </button>
      <p class="flex items-center gap-200 text-neutrals-500">
        <span>{{ activePage + 1 }}</span>/<span>{{ pagesTotal }}</span>
      </p>

      <button
        v-if="pagesTotal > 1"
        type="button"
        :disabled="activePage >= pagesTotal - 1"
        class="text-neutrasl-700 disabled:text-neutrals-300 cursor-pointer disabled:pointer-events-none"
        @click="() => { activePage++; scrollToTopOfSessions(); }"
      >
        <IconChevronRight />
      </button>
    </div>
  </div>
</template>

<style scoped></style>
