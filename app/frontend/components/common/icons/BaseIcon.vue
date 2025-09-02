<script setup>
import { computed } from "vue";
const props = defineProps({
  width: { type: String, default: "20" },
  height: { type: String, default: "20" },
  className: { type: String, default: "text-neutrals-1000" },
  viewbox: { type: String, default: "0 0 20 20" },
  title: { type: String, default: "" },
  active: { type: Boolean, default: false },
});

const fillColor = computed(() =>
  props.active ? "url(#grad)" : "currentColor",
);
</script>

<template>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    :class="props.className"
    :width="props.width"
    :height="props.height"
    :viewBox="props.viewbox"
    fill="none"
    :aria-hidden="!title"
  >
    <!-- Only add gradient if active -->
    <defs v-if="props.active">
      <linearGradient
        id="grad"
        x1="0.5"
        y1="15"
        x2="29.5"
        y2="15"
        gradientUnits="userSpaceOnUse"
      >
        <stop stop-color="#FF007F" />
        <stop offset="1" stop-color="#FF7F00" />
      </linearGradient>
    </defs>
    <title v-if="props.title">{{ props.title }}</title>
    <slot :fill="fillColor" />
  </svg>
</template>
