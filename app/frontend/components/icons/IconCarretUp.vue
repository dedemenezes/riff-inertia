<script setup>
const { className, size } = defineProps({
  className: { type: String, default: "text-neutrals-700" },
  size: { type: Number, default: 16 },
});
</script>

<template>
  <svg
    :class="className"
    xmlns="http://www.w3.org/2000/svg"
    :width="size"
    :height="size"
    viewBox="0 0 16 16"
    fill="none"
  >
    <path
      fill-rule="evenodd"
      clip-rule="evenodd"
      d="M7.64663 4.64621C7.69308 4.59964 7.74825 4.5627 7.809 4.53749C7.86974 4.51229 7.93486 4.49931 8.00063 4.49931C8.0664 4.49931 8.13152 4.51229 8.19226 4.53749C8.25301 4.5627 8.30819 4.59964 8.35463 4.64621L14.3546 10.6462C14.4485 10.7401 14.5013 10.8674 14.5013 11.0002C14.5013 11.133 14.4485 11.2603 14.3546 11.3542C14.2607 11.4481 14.1334 11.5008 14.0006 11.5008C13.8679 11.5008 13.7405 11.4481 13.6466 11.3542L8.00063 5.70721L2.35463 11.3542C2.26075 11.4481 2.13341 11.5008 2.00063 11.5008C1.86786 11.5008 1.74052 11.4481 1.64663 11.3542C1.55274 11.2603 1.5 11.133 1.5 11.0002C1.5 10.8674 1.55274 10.7401 1.64663 10.6462L7.64663 4.64621Z"
      fill="currentColor"
    />
  </svg>
</template>

<style scoped>
details svg.accordion-icon {
  transition: transform 0.2s ease;
  transform: rotate(180deg);
}
details[open] svg.accordion-icon {
  transform: rotate(0deg);
}
</style>
