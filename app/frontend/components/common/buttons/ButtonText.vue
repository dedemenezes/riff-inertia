<script setup>
import { computed } from "vue";

const variants = {
  dark: "text-neutrals-900 hover:text-neutrals-700 active:text-neutrals-800 disabled:text-neutrals-600",
  light: "text-white-transp-1000",
  color:
    "bg-clip-text text-transparent bg-gradient-to-r from-magenta-600 to-laranja-600 hover:bg-gradient-to-l active:bg-gradient-to-r",
};

const sizes = {
  sm: "text-sm leading-[19.6px]",
  md: "text-md leading-[22.4px]",
};

const props = defineProps({
  variant: {
    type: String,
    validator: (value) => ["dark", "light", "color"].includes(value),
    default: "dark",
  },
  size: {
    type: String,
    validator: (value) => ["sm", "md"].includes(value),
    default: "md",
  },
  text: { type: String, default: "" },
  tag: { type: String, default: "a" },
  href: { type: String, default: "#" },
  fontWeight: {
    type: String,
    default: "semibold", // matches current behavior
  },
});

const fontWeightClass = computed(() => `font-${props.fontWeight}`);
const variantClass = computed(() => variants[props.variant]);
const sizeClass = computed(() => sizes[props.size]);
</script>

<template>
  <component
    :is="tag"
    v-bind="tag === 'a' ? { href } : {}"
    class="p-100 inline-flex items-center justify-center max-w-fit font-body"
    :class="[sizeClass, variantClass, fontWeightClass]"
  >
    <slot name="icon" />
    {{ text }}
  </component>
</template>

<style scoped></style>
