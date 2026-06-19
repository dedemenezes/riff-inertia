<script setup>
import IconBoxArrowUp from "@/components/common/icons/navigation/IconBoxArrowUp.vue";

const props = defineProps({
  href: { type: String, required: true },
  label: { type: String, required: true },
});
</script>

<template>
  <a
    :href="props.href"
    target="_blank"
    rel="noopener noreferrer"
    class="inline-flex items-center gap-200 rounded p-100 text-md font-semibold leading-[22.4px] text-neutrals-900 hover:text-neutrals-700 focus:outline-2 focus:outline-offset-2 focus:outline-neutrals-300"
  >
    {{ props.label }}
    <IconBoxArrowUp width="14" height="14" />
  </a>
</template>
