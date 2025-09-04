<script setup>
import { IconClose } from "@/components/common/icons";
const props = defineProps({
  text: {
    type: String,
    required: true,
  },
  filter: {
    type: Object,
    required: true
  }
});

const emit = defineEmits(["remove-filter"]);
const removeSelf = () => {
  emit("remove-filter", props.filter.value);
};
</script>

<template>
<span
  class="max-w-fit inline-flex items-center gap-100 px-200 py-100 border rounded-full border-neutrals-300 font-body text-xs text-neutrals-700 font-regular leading-[18px]"
  role="group"
  :aria-label="`Filter: ${props.filter.label}`"
>
  {{ props.filter.label }}

  <button
    type="button"
    :aria-label="`Remove ${props.filter.label} filter`"
    class="ml-100 p-50 -m-50 bg-transparent border-0 rounded
           cursor-pointer
           hover:bg-neutrals-100 hover:text-neutrals-800
           focus:outline-none focus:ring-1 focus:ring-neutrals-500 focus:ring-offset-1
           transition-colors duration-200"
    @click="removeSelf"
  >
    <IconClose
      aria-hidden="true"
      color="inherit"
    />
  </button>
</span>
</template>

<style scoped>
</style>
