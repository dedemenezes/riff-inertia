<script setup>
import BarraLogos from "@/components/features/parceiros/BarraLogos.vue";
import Flashes from "@/components/shared/Flashes.vue";
import Footer from "@/components/layout/headers/Footer.vue";
import NavbarMain from "@/components/layout/navbar/NavbarMain.vue";
import NavbarSecondary from "@/components/layout/navbar/NavbarSecondary.vue";
import SponsorHeader from "@/components/layout/headers/SponsorHeader.vue";
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

    <BarraLogos class="mt-1200" />
    <Footer />
  </div>
</template>
