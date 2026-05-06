<script setup>
import NavbarMain from '@/components/layout/navbar/NavbarMain.vue'
import SponsorHeader from '@/components/layout/headers/SponsorHeader.vue';
import NavbarSecondary from '@/components/layout/navbar/NavbarSecondary.vue';
import Flashes from '@/components/shared/Flashes.vue';
import Footer from '@/components/layout/headers/Footer.vue'
</script>

<template>
  <div class="flex flex-col justify-between min-h-[100vh]">
    <div>
      <SponsorHeader class="bg-azul-400" />
      <NavbarMain />
      <NavbarSecondary />
      <Flashes />

      <main>
        <slot />
      </main>
    </div>

    <Footer />
  </div>
</template>
