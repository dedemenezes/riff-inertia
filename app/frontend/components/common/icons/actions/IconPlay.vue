<script setup>
import { BaseIcon } from "@/components/common/icons";

const props = defineProps({
  color: { type: String, default: 'inherit' },
  active: { type: Boolean, default: false },
  width: { type: String, default: "20" },
  height: { type: String, default: "20" }
});
</script>

<template>
  <!-- Fixed conflict here remove after testing -->
  <BaseIcon viewBox="0 0 20 20" :active="active" :height="props.height" :width="props.width" :className="props.color">
    <template #default="{ fill }">
      <path d="M14.495 10.8712L6.54125 15.4862C5.86625 15.8774 5 15.4037 5 14.6149V5.38495C5 4.59745 5.865 4.12245 6.54125 4.51495L14.495 9.12995C14.6485 9.2176 14.7762 9.34431 14.865 9.49721C14.9537 9.65011 15.0005 9.82377 15.0005 10.0006C15.0005 10.1774 14.9537 10.351 14.865 10.5039C14.7762 10.6568 14.6485 10.7835 14.495 10.8712Z"
        :fill="fill"
      />
    </template>
  </BaseIcon>
</template>

<style scoped></style>
