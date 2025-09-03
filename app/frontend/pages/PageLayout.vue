<script setup>
import NavbarMain from '@/components/layout/navbar/NavbarMain.vue'
import SponsorHeader from '@/components/layout/headers/SponsorHeader.vue';
import { usePage } from "@inertiajs/vue3"
import Flashes from '@/components/shared/Flashes.vue';

const page = usePage()

</script>

<template>
  <SponsorHeader class="bg-azul-400" />
  <NavbarMain :root-url="page.props.rootUrl"/>
  <Flashes />

  <main>
    <slot />
  </main>
</template>
