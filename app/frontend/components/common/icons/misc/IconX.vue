<script setup>
import { BaseIcon } from "@components/common/icons";
const props = defineProps({
  color: { type: String, default: 'text-neutrals-900' },
  active: { type: Boolean, default: false },
});
</script>

<template>
  <BaseIcon viewBox="0 0 25 25" :active="active" :className="props.color">
    <template #default="{ fill }">
      <path
        d="M18.901 1H22.581L14.541 10.19L24 22.693H16.594L10.794 15.109L4.156 22.693H0.474L9.074 12.863L0 1.001H7.594L12.837 7.933L18.901 1ZM17.61 20.491H19.649L6.486 3.087H4.298L17.61 20.491Z"
        :fill="fill"
      />
    </template>
  </BaseIcon>
</template>

<style scoped></style>
