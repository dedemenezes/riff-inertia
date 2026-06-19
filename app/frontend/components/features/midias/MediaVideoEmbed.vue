<script setup>
import IconPlay from "@/components/common/icons/actions/IconPlay.vue";

const props = defineProps({
  video: {
    type: Object,
    required: true,
  },
});
</script>

<template>
  <article class="w-full overflow-hidden rounded-lg bg-neutrals-1000">
    <iframe
      v-if="props.video.embedUrl"
      class="aspect-video w-full"
      :src="props.video.embedUrl"
      :title="props.video.title"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
      allowfullscreen
    ></iframe>

    <div
      v-else
      class="flex aspect-video w-full items-center justify-center bg-neutrals-1000 text-white-transp-1000"
      :aria-label="props.video.title"
      role="img"
    >
      <span class="rounded bg-neutrals-800 p-200">
        <IconPlay color="text-white-transp-1000" width="24" height="24" />
      </span>
    </div>
  </article>
</template>
