<script setup>
import NavbarMain from '@/components/layout/navbar/NavbarMain.vue'
import SponsorHeader from '@/components/layout/headers/SponsorHeader.vue';
import NavbarSecondary from '@/components/layout/navbar/NavbarSecondary.vue';
import { usePage } from "@inertiajs/vue3"
import Flashes from '@/components/shared/Flashes.vue';
import Footer from '@/components/layout/headers/Footer.vue'

const page = usePage()
// Define the rootUrl prop to receive data passed from the controller
const props = defineProps({
  rootUrl: { type: String, required: true }
});
</script>

<template>
  <div class="flex flex-col justify-between min-h-[100vh]">
    <div>
      <SponsorHeader class="bg-azul-400" />
      <NavbarMain :root-url="props.rootUrl"/>
      <NavbarSecondary />
      <Flashes />

      <main>
        <slot />
      </main>
    </div>

    <Footer />
  </div>
</template>
