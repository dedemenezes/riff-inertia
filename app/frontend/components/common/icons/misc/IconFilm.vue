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
        d="M2 4.5A2.5 2.5 0 0 1 4.5 2h11A2.5 2.5 0 0 1 18 4.5v11A2.5 2.5 0 0 1 15.5 18h-11A2.5 2.5 0 0 1 2 15.5v-11ZM4 5.75c0-.414.336-.75.75-.75h.5a.75.75 0 0 1 0 1.5h-.5A.75.75 0 0 1 4 5.75Zm0 4c0-.414.336-.75.75-.75h.5a.75.75 0 0 1 0 1.5h-.5A.75.75 0 0 1 4 9.75Zm0 4c0-.414.336-.75.75-.75h.5a.75.75 0 0 1 0 1.5h-.5A.75.75 0 0 1 4 13.75Zm10.25-.75a.75.75 0 0 0 0 1.5h.5a.75.75 0 0 0 0-1.5h-.5Zm0-4a.75.75 0 0 0 0 1.5h.5a.75.75 0 0 0 0-1.5h-.5Zm0-4a.75.75 0 0 0 0 1.5h.5a.75.75 0 0 0 0-1.5h-.5ZM7.25 5A.75.75 0 0 0 6.5 5.75v8.5c0 .414.336.75.75.75h5.5a.75.75 0 0 0 .75-.75v-8.5A.75.75 0 0 0 12.75 5h-5.5Z"
        :fill="fill"
      />
    </template>
  </BaseIcon>
</template>

<style scoped></style>
