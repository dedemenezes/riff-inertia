<script setup>
import NavbarMain from '@/components/layout/navbar/NavbarMain.vue'
import SponsorHeader from '@/components/layout/headers/SponsorHeader.vue';

</script>

<template>
  <SponsorHeader class="bg-azul-400" />

  <NavbarMain />
  <main>
    <slot />
  </main>
</template>
