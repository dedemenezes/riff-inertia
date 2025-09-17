<script setup>
import { BaseButton } from "@/components/common/buttons";
import MobileMenu from "@/components/layout/navbar/MobileMenu.vue";
import { IconSearch } from "@/components/common/icons";
import TheLanguageSwitcher from "@components/TheLanguageSwitcher.vue";

import FestivalLogo from "@assets/logos/logo-nova-full.svg"
import IconArrowOut from "@/components/common/icons/misc/IconArrowOut.vue";
const props = defineProps({
  rootUrl: { type: String, required: true }
});
</script>

<template>
  <!-- NAVBARMAIN -->
  <nav
    class="px-400 py-200 mx-auto lg:max-w-7xl flex items-start md:items-center justify-between"
    role="navigation"
    aria-label="Navegação primária"
  >
    <div
      class="flex flex-col md:flex-row md:gap-400 items-start md:items-center"
    >
    <a
      :href="props.rootUrl"
      class="focus:outline-2 focus:-outline-offset-2 focus:outline-neutrals-300"
    >
      <img
        class="py-200"
        :src="FestivalLogo"
        alt="Logo do Festival do Rio"
        width="300"
      />
    </a>

    <div class="hidden md:block">
      <img src="@assets/icons/divisor.svg" alt="divisor" aria-hidden="true" />
    </div>

    <div class="festival-dates py-100">
      <p
        class="font-body text-neutrals-900 text-sm font-regular leading-[21px] uppercase"
      >
        27th rio de janeiro int'l film festival
      </p>
      <p class="text-primary font-body text-md font-bold leading-[22.4px]">
        2 - 12 OUT 2025
      </p>
    </div>

    </div>

    <!-- MOBILE TOGGLER -->
    <MobileMenu />
    <!-- Navbar Actions -->
    <div class="hidden md:flex items-center gap-1200">
      <IconSearch />
      <TheLanguageSwitcher />

<BaseButton
  as="button"
  size="sm"
  class="py-300 px-400 group flex items-center justify-center"
  variant="rioMarket"
>
  <span class="transition-all duration-300 group-hover:translate-x-2">
    RioMarket
  </span>

  <IconArrowOut
    class="ms-150 w-4 h-4 transition-all duration-300 group-hover:opacity-0"
  />
</BaseButton>
    </div>
  </nav>
</template>

<style scoped></style>
