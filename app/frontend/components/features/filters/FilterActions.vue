<script setup>
import { ButtonText, BaseButton } from "@/components/common/buttons";

const emit = defineEmits(["clear", "apply"]);
const props = defineProps({
  hasActiveFilters: { type: Boolean, default: false },
});
</script>

<template>
  <div class="flex justify-between">
    <ButtonText
      size="sm"
      class="cursor-pointer disabled:cursor-auto"
      tag="button"
      text="Limpar tudo"
      @click="emit('clear')"
      :disabled="!props.hasActiveFilters"
    />
    <BaseButton
      size="sm"
      class="cursor-pointer"
      variant="dark"
      @click="emit('apply')"
      :disabled="!props.hasActiveFilters"
      >Aplicar filtros</BaseButton
    >
  </div>
</template>

<style scoped></style>
