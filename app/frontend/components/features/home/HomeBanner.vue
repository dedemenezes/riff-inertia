
<script setup>
import { computed } from "vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  imagePath: {
    type: String,
    required: true,
  },
  height: {
    type: String,
    default: "h-[573px]",
  },
});

const mobileSizing = "height: 708px;";

const backgroundImageStyle = computed(() => {
  return `background-image: url(${props.imagePath});
    background-position: center;
    background-size: cover;
    background-repeat: no-repeat;`;
});
</script>

<template>
  <slot />
  <!-- <div class="flex items-end" :style="[backgroundImageStyle, mobileSizing]">
    <TwContainer extra-classes="pb-[58px] lg:pb-[77px]">
    </TwContainer>
  </div> -->
</template>

<style scoped></style>
