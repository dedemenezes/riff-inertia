<script setup>
import { IconFilter } from "@/components/common/icons"

const emit = defineEmits(["open-menu"])
const variant = "text-body-strong-sm text-neutrals-900 hover:text-neutrals-700 active:text-neutrals-800 disabled:text-neutrals-600"
</script>

<template>
  <!-- FilterMobileTrigger -->
<button
  @click="emit('open-menu')"
  class="cursor-pointer py-100 flex items-center gap-200  md:order-2 lg:hidden"
  :class="variant"
>
  <IconFilter height="16px" width="16px" color="inherit" />
  <!-- {{ $t("filter.title") }} -->
    <span>Filtros</span>
</button>
<!-- FilterMobileTrigger -->
</template>

<style scoped></style>
