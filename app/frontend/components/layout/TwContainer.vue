<script setup>
const props = defineProps({
  extraClasses: {
    type: String,
    default: "",
  },
  breakpoints: {
    type: String,
    default: "lg:max-w-7xl xl:max-w-7xl xxl:max-w-7xl",
  },
  centered: {
    type: Boolean,
    default: true
  }
});
// TODO: SERÁ? xl:max-w-[1640px]
</script>
<template>
  <div class="w-full px-400" :class="[props.breakpoints, props.extraClasses, props.centered ? 'mx-auto' : '']">
    <slot />
  </div>
</template>
