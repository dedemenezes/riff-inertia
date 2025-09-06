<script setup>
import { computed } from "vue";

const props = defineProps({
  tagClass: {
    type: String,
    required: true,
    // default: "cinema-capacete",
  },
  text: {
    type: String,
    default: "TBD"
  },
  mode: {
    type: String,
    validator: (value) => ["filled", "outline"].includes(value),
    default: "filled",
  },
});

const displayText = computed(() => props.text?.trim() || "TBD");
</script>

<template>
  <span
    class="tag-base"
    :class="[`${tagClass}`, `tag-${mode}`]"
    role="label"
    :aria-label="`${displayText} tag`"
  >
    {{ displayText }}
  </span>
</template>

<style scoped>
</style>
