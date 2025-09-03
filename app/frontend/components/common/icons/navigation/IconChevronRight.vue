<script setup>
import { BaseIcon } from "@components/common/icons"

const props = defineProps({
  color: { type: String, default: undefined },
  active: { type: Boolean, default: false },
  width: { type: String, default: "20" },
  height: { type: String, default: "20" }
});
</script>

<template>
  <BaseIcon viewBox="0 0 21 20" :width="props.width" :height="props.height"  :active="active" :className="props.color">
    <template #default="{ fill }">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M6.35159 2.18362C6.40964 2.12541 6.47861 2.07923 6.55454 2.04773C6.63047 2.01622 6.71188 2 6.79409 2C6.87629 2 6.9577 2.01622 7.03363 2.04773C7.10956 2.07923 7.17853 2.12541 7.23659 2.18362L14.7366 9.68362C14.7948 9.74167 14.841 9.81064 14.8725 9.88658C14.904 9.96251 14.9202 10.0439 14.9202 10.1261C14.9202 10.2083 14.904 10.2897 14.8725 10.3657C14.841 10.4416 14.7948 10.5106 14.7366 10.5686L7.23659 18.0686C7.11923 18.186 6.96006 18.2519 6.79409 18.2519C6.62812 18.2519 6.46894 18.186 6.35159 18.0686C6.23423 17.9513 6.1683 17.7921 6.1683 17.6261C6.1683 17.4601 6.23423 17.301 6.35159 17.1836L13.4103 10.1261L6.35159 3.06862C6.29338 3.01056 6.2472 2.94159 6.21569 2.86566C6.18419 2.78973 6.16797 2.70833 6.16797 2.62612C6.16797 2.54391 6.18419 2.46251 6.21569 2.38658C6.2472 2.31064 6.29338 2.24167 6.35159 2.18362Z"
        :fill="fill"
      />
    </template>
  </BaseIcon>
</template>

<style scoped></style>
