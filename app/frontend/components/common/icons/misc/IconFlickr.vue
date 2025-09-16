<script setup>
import { BaseIcon } from "@components/common/icons";
const props = defineProps({
  color: { type: String, default: undefined },
  active: { type: Boolean, default: false },
});
</script>

<template>
  <BaseIcon viewBox="0 0 25 25" :active="active" :className="props.color">
    <template #default="{ fill }">
      <path
        d="M5.334 7C2.3884 7 0 9.389 0 12.334C0 15.2796 2.3884 17.668 5.334 17.668C8.2796 17.668 10.666 15.2796 10.666 12.334C10.666 9.389 8.2796 7 5.334 7ZM18.666 7C15.7204 7 13.334 9.389 13.334 12.334C13.334 15.2796 15.7204 17.668 18.666 17.668C21.6116 17.668 24 15.2796 24 12.334C24 9.389 21.6116 7 18.666 7Z"
        :fill="fill"
      />
    </template>
  </BaseIcon>
</template>

<style scoped></style>
