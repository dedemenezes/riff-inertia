<script setup>
// TODO: ADD PROPS AND EVERYTHING
import { BaseButton } from '@/components/common/buttons';
import { IconPin } from '@/components/common/icons';
import TagScreening from '@/components/common/tags/TagScreening.vue';
</script>

<template>
  <div class="bg-neutrals-200 p-400 flex flex-col gap-400 rounded-200">
    <h3 class="text-header-medium-sm">Qua, 9 Set</h3>
    <div>
      <div class="flex items-center gap-200 pb-100">
        <IconPin height="16" width="16" color="text-neutrals-900"/> <p class="text-body-regular-line-small">Cine Odeon - CCLSR</p>
      </div>
      <p class="text-body-regular-xs">Praça Floriano, 7 - Centro</p>
    </div>
    <div class="flex items-center gap-200">
      <img src="@/assets/icons/icon_info.svg" alt="Ícone de informação">
      <p class="font-body text-xs leading-[140%] font-regular italic">Venda de ingressos limitada</p>
    </div>
    <TagScreening state="default" time="21h15"/>
    <BaseButton size="sm" class="border-neutrals-900 border-2">Comprar ingressos</BaseButton>
  </div>
</template>
<style scoped>
</style>
