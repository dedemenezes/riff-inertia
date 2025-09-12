<script setup>
import { BaseIcon } from "@components/common/icons";
const props = defineProps({
  color: { type: String, default: undefined },
  active: { type: Boolean, default: false },
});
</script>

<template>
  <BaseIcon viewBox="0 0 21 20" :active="active" :className="props.color">
    <template #default="{ fill }">
      <g clip-path="url(#clip0_1212_33586)">
        <path
          d="M12.3729 0L0 5.59322L0.677966 16.9492L13.8983 20L20 8.98305L12.3729 0Z"
          :fill="fill"
        />
      </g>
      <defs>
        <clipPath id="clip0_1212_33586">
          <rect width="20" height="20" fill="white"/>
        </clipPath>
      </defs>
    </template>
  </BaseIcon>
</template>

<style scoped></style>
