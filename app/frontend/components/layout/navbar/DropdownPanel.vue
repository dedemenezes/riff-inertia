<script setup>
const props = defineProps({
  isOpen: Boolean,
  onMouseEnter: Function,
  onMouseLeave: Function
});
</script>

<template>
  <transition
    enter-active-class="transition-opacity duration-400 ease-in-out"
    enter-from-class="opacity-0"
    enter-to-class="opacity-100"
    leave-active-class="transition-opacity duration-400 ease-in-out"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div
      v-show="props.isOpen"
      @mouseenter="props.onMouseEnter"
      @mouseleave="props.onMouseLeave"
      class="absolute p-400 bg-neutrals-200 h-[100px] w-full"
    >
      <slot />
    </div>
  </transition>
</template>

<style scoped></style>
