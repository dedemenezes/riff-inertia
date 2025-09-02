<script setup>
import { ButtonText } from "@/components/common/buttons";

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  href: {
    type: String,
    default: "#",
  },
});
</script>

<template>
  <div
    class="flex flex-col gap-y-5 border-l border-neutrals-300 px-[1.25rem] py-0"
  >
    <ButtonText
      tag="a"
      :href="href"
      variant="dark"
      size="md"
      :text="props.title"
    />
    <p
      class="text-neutrals-900 font-body text-md font-light leading-[24px] tracking-wid"
    >
      {{ props.description }}
    </p>
  </div>
</template>

<style scoped></style>
