<script setup>
import NavbarMain from '@/components/layout/navbar/NavbarMain.vue'
import SponsorHeader from '@/components/layout/headers/SponsorHeader.vue';
// Define the rootUrl prop to receive data passed from the controller
const props = defineProps({
  rootUrl: { type: String, required: true }
});
</script>

<template>
  <SponsorHeader class="bg-azul-400" />
  <NavbarMain :root-url="props.rootUrl"/>
  <main>
    <slot />
  </main>
</template>
