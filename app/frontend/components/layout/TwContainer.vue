<script setup>
const { extraClasses, breakpoints } = defineProps({
  extraClasses: {
    type: String,
    default: "",
  },
  breakpoints: {
    type: String,
    default: "lg:max-w-6xl xl:max-w-7xl xxl:max-w-xxl",
  },
});
</script>
<template>
  <div class="w-full px-400 mx-auto" :class="[breakpoints, extraClasses]">
    <slot />
  </div>
</template>
