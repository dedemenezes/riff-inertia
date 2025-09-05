<script setup>
import NavbarMain from '@/components/layout/navbar/NavbarMain.vue'
import SponsorHeader from '@/components/layout/headers/SponsorHeader.vue';
import NavbarSecondary from '@/components/layout/navbar/NavbarSecondary.vue';
import { usePage } from "@inertiajs/vue3"
import Flashes from '@/components/shared/Flashes.vue';

const page = usePage()
// Define the rootUrl prop to receive data passed from the controller
const props = defineProps({
  rootUrl: { type: String, required: true }
});
</script>

<template>
  <SponsorHeader class="bg-azul-400" />
  <NavbarMain :root-url="props.rootUrl"/>
  <NavbarSecondary />
  <Flashes />

  <main>
    <slot />
  </main>
</template>
