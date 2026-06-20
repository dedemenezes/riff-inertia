<script setup>
import { computed } from "vue";

const props = defineProps({
  photo: { type: String, required: true },
  name: { type: String, required: true },
  role: { type: String, required: false, default: "" },
  bio: {
    type: [String, Array],
    required: false,
    default: () => [],
  },
  bioVariant: {
    type: String,
    default: "default",
    validator: (v) => [ "default", "double-spaced" ].includes(v),
  },
});

const bioParagraphs = computed(() => {
  if (Array.isArray(props.bio)) return props.bio.filter((p) => p && p.trim());
  return props.bio && props.bio.trim() ? [props.bio] : [];
});

const bioClass = computed(() =>
  props.bioVariant === "double-spaced"
    ? "text-body-regular-double"
    : "text-body-regular",
);
</script>

<template>
  <div class="flex items-start gap-400 overflow-hidden rounded-b-200 pb-0 text-primary">
    <img
      :src="photo"
      :alt="name"
      class="size-[107px] shrink-0 rounded-100 object-cover md:size-[180px] md:rounded-200"
      loading="lazy"
    />
    <div class="flex min-w-0 flex-1 flex-col gap-150">
      <p class="w-full text-header-sm">{{ name }}</p>
      <p v-if="role" class="w-full font-body text-md font-regular leading-[150%]">
        {{ role }}
      </p>
      <p
        v-for="(paragraph, idx) in bioParagraphs"
        :key="idx"
        class="w-full"
        :class="bioClass"
      >
        {{ paragraph }}
      </p>
    </div>
  </div>
</template>
