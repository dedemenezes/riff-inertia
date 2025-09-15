<script setup>
import { BaseIcon } from "@components/common/icons"

const props = defineProps({
  color: { type: String, default: 'inherit' },
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
        d="M14.3616 2.0574C14.4198 2.11545 14.466 2.18442 14.4975 2.26035C14.529 2.33629 14.5452 2.41769 14.5452 2.4999C14.5452 2.58211 14.529 2.66351 14.4975 2.73944C14.466 2.81537 14.4198 2.88434 14.3616 2.9424L7.30284 9.9999L14.3616 17.0574C14.4789 17.1748 14.5449 17.3339 14.5449 17.4999C14.5449 17.6659 14.4789 17.825 14.3616 17.9424C14.2442 18.0598 14.0851 18.1257 13.9191 18.1257C13.7531 18.1257 13.5939 18.0598 13.4766 17.9424L5.97659 10.4424C5.91838 10.3843 5.8722 10.3154 5.84069 10.2394C5.80919 10.1635 5.79297 10.0821 5.79297 9.9999C5.79297 9.91769 5.80919 9.83629 5.84069 9.76035C5.8722 9.68442 5.91838 9.61545 5.97659 9.5574L13.4766 2.0574C13.5346 1.99919 13.6036 1.95301 13.6795 1.92151C13.7555 1.89 13.8369 1.87378 13.9191 1.87378C14.0013 1.87378 14.0827 1.89 14.1586 1.92151C14.2346 1.95301 14.3035 1.99919 14.3616 2.0574Z"
        :fill="fill"
      />
    </template>
  </BaseIcon>
</template>

<style scoped></style>
