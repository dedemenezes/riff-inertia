<script setup>
import { BaseIcon } from "@components/common/icons";

const props = defineProps({
  color: { type: String, default: "text-neutrals-900" },
  active: { type: Boolean, default: false },
});
</script>

<template>
  <BaseIcon viewBox="0 0 21 20" :active="active" :className="props.color">
    <template #default="{ fill }">
      <path
        d="M10.5 1.25C10.7427 1.25 10.9636 1.39035 11.0667 1.6101L13.5262 6.85103L19.0096 7.69042C19.2413 7.72588 19.4342 7.88797 19.5091 8.11001C19.5841 8.33205 19.5284 8.57703 19.3651 8.74516L15.3818 12.8452L16.3222 18.6413C16.3603 18.8762 16.2615 19.1117 16.0673 19.2492C15.873 19.3866 15.6171 19.402 15.4077 19.289L10.5 16.6406L5.59231 19.289C5.38286 19.402 5.12697 19.3866 4.93273 19.2492C4.73848 19.1117 4.6397 18.8762 4.67779 18.6413L5.61819 12.8452L1.63492 8.74516C1.47155 8.57703 1.41593 8.33205 1.49085 8.11001C1.56577 7.88797 1.75874 7.72588 1.99043 7.69042L7.47378 6.85103L9.93329 1.6101C10.0364 1.39035 10.2573 1.25 10.5 1.25Z"
        :fill="fill"
      />
    </template>
  </BaseIcon>
</template>

<style scoped></style>
