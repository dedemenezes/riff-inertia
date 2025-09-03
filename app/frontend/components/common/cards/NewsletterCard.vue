<script setup>
import { BaseButton } from "@components/common/buttons"
</script>

<template>
  <div class="flex items-center justify-between mb-800">
    <p class="text-header-regular-md w-[350px]">
      Receba nossas newsletters e fique por dentro das novidades do Festival do Rio →
    </p>
    <div class="w-[454px] flex flex-col gap-400">
      <input type="text" name="email" id="email">
      <BaseButton
        as="button"
        size="md"
        variant="dark"
        class="w-[50%]"
      >Enviar</BaseButton>

    </div>
  </div>
</template>

<style scoped>
</style>
