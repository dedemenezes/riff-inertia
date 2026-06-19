<script setup>
import IconBoxArrowUp from "@/components/common/icons/navigation/IconBoxArrowUp.vue";

const props = defineProps({
  material: {
    type: Object,
    required: true,
  },
});

const coverClasses = {
  purple: "from-magenta-800 via-magenta-600 to-laranja-600",
  magenta: "from-magenta-600 via-magenta-800 to-laranja-600",
  orange: "from-laranja-600 via-magenta-600 to-magenta-800",
};
</script>

<template>
  <article class="flex w-full flex-col items-center gap-600 text-center md:w-[304px]">
    <img
      v-if="props.material.coverImageUrl"
      :src="props.material.coverImageUrl"
      :alt="props.material.coverAlt || props.material.title"
      class="h-[200px] max-w-[162px] object-contain drop-shadow-[10px_10px_24px_rgba(82,81,81,0.18)]"
    />

    <div
      v-else
      class="relative h-[178px] w-[120px] overflow-hidden rounded-sm bg-gradient-to-br shadow-[10px_10px_35px_6px_rgba(82,81,81,0.10)]"
      :class="coverClasses[props.material.coverTone] || coverClasses.purple"
      aria-hidden="true"
    >
      <div class="absolute inset-x-0 top-6 h-12 bg-laranja-500/70"></div>
      <div class="absolute inset-x-4 bottom-8 h-16 rounded-full bg-laranja-400/80 blur-sm"></div>
      <div class="absolute inset-x-3 top-5 flex flex-col gap-1">
        <span v-for="line in 9" :key="line" class="h-px rounded bg-white/25"></span>
      </div>
    </div>

    <div class="flex flex-col items-center gap-600">
      <h2 class="text-header-sm text-neutrals-900">
        {{ props.material.title }}
      </h2>

      <a
        v-if="props.material.pdfUrl"
        :href="props.material.pdfUrl"
        target="_blank"
        rel="noopener noreferrer"
        class="inline-flex items-center gap-200 rounded p-100 text-md font-semibold leading-[22.4px] text-neutrals-900 hover:text-neutrals-700 focus:outline-2 focus:outline-offset-2 focus:outline-neutrals-300"
      >
        {{ props.material.cta }}
        <IconBoxArrowUp width="14" height="14" />
      </a>

      <span
        v-else
        class="inline-flex items-center gap-200 rounded p-100 text-md font-semibold leading-[22.4px] text-neutrals-600"
        aria-disabled="true"
      >
        {{ props.material.cta }}
        <IconBoxArrowUp width="14" height="14" />
      </span>
    </div>
  </article>
</template>
