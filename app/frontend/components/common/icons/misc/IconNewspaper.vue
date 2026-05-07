<script setup>
import { BaseIcon } from "@components/common/icons";
const props = defineProps({
  color: { type: String, default: 'text-neutrals-900' },
  active: { type: Boolean, default: false },
});
</script>

<template>
  <BaseIcon viewBox="0 0 20 20" :active="active" :className="props.color">
    <template #default="{ fill }">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M2 3.5A1.5 1.5 0 0 1 3.5 2h9A1.5 1.5 0 0 1 14 3.5V4h1.5A2.5 2.5 0 0 1 18 6.5v9a2.5 2.5 0 0 1-2.5 2.5H4a2 2 0 0 1-2-2V3.5ZM3.5 3a.5.5 0 0 0-.5.5V16a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5V3.5a.5.5 0 0 0-.5-.5h-9Zm11 2.5H14v10.028A1.5 1.5 0 0 0 15.5 17a1 1 0 0 0 1-1V6.5a1 1 0 0 0-1-1ZM5 5.75A.75.75 0 0 1 5.75 5h4.5a.75.75 0 0 1 0 1.5h-4.5A.75.75 0 0 1 5 5.75ZM5.75 8A.75.75 0 0 0 5 8.75v2.5c0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75v-2.5A.75.75 0 0 0 10.25 8h-4.5ZM5 13.75a.75.75 0 0 1 .75-.75h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1-.75-.75Z"
        :fill="fill"
      />
    </template>
  </BaseIcon>
</template>

<style scoped></style>
