<script setup>
import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";

const props = defineProps({
  text: { type: String },
  items: { type: Array, required: true }
})

const iconMapping = {
  "program": IconProgram,
  "user": IconNewUser,
  "change": IconChange,
  "clock": IconClock
};

</script>

<template>
  <MenuContext
    :items="props.items"
    :icon-mapping="iconMapping"
  />
</template>

<style scoped></style>
