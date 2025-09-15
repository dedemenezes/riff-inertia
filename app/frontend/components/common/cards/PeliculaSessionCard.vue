<script setup>
import { BaseButton } from '@/components/common/buttons';
import { IconPin } from '@/components/common/icons';
import TagScreening from '@/components/common/tags/TagScreening.vue';

const props = defineProps({
  session: { type: Object, required: true }
})

// TODO: date display
</script>

<template>
  <div class="bg-neutrals-200 p-400 flex flex-col gap-400 rounded-200 mb-400">
    <h3 class="text-header-medium-sm">{{ props.session.data}}</h3>
    <div>
      <div class="flex items-center gap-200 pb-100">
        <IconPin height="16" width="16" color="text-neutrals-900"/> <p class="text-body-regular-line-small"> {{ props.session.cinema_name }}</p>
      </div>
      <p class="text-body-regular-xs">{{ props.session.cinema_address }}</p>
    </div>
    <div class="flex items-center gap-200">
      <img src="@/assets/icons/icon_info.svg" alt="Ícone de informação">
      <p class="font-body text-xs leading-[140%] font-regular italic">Venda de ingressos limitada</p>
    </div>
    <TagScreening state="default" :time="props.session.sessao"/>
    <BaseButton size="sm" class="border-neutrals-900 border-2">Comprar ingressos</BaseButton>
  </div>
</template>
<style scoped>
</style>
