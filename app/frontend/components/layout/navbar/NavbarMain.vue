<script setup>
import { BaseButton } from "@/components/common/buttons";
import MobileMenu from "@/components/layout/navbar/MobileMenu.vue";
import { IconSearch } from "@/components/common/icons";
import FestivalLogo from "@assets/logos/festival-logo.svg"
</script>

<template>
  <!-- NAVBARMAIN -->
  <nav
    class="p-400 mx-auto lg:max-w-7xl flex items-start md:items-center justify-between"
    role="navigation"
    aria-label="Navegação primária"
  >
    <div
      class="flex flex-col md:flex-row md:gap-400 items-start md:items-center"
    >
    <a
      href="/"
      class="focus:outline-2 focus:-outline-offset-2 focus:outline-laranja-600"
    >
      <img
        class="py-200"
        :src="FestivalLogo"
        alt="Logo do Festival do Rio"
        width="221"
      />
    </a>

    <div class="hidden md:block">
      <img src="@assets/icons/divisor.svg" alt="divisor" aria-hidden="true" />
    </div>

    <div class="festival-dates py-100">
      <p
        class="font-body text-neutrals-900 text-sm font-regular leading-[21px] uppercase"
      >
        rio international film festival
      </p>
      <p class="font-body text-md font-bold leading-[22.4px]">
        2 - 12 OUT 2025
      </p>
    </div>

    </div>

    <!-- MOBILE TOGGLER -->
    <MobileMenu />
    <!-- Navbar Actions -->
    <div class="hidden md:flex items-center gap-1200">
      <IconSearch />
      <BaseButton as="button" size="md" variant="cta">
        RioMarket
        <img
          src="@assets/icons/Vector.svg"
          alt="carret"
          class="w-full ms-300"
        />
      </BaseButton>
    </div>
  </nav>
</template>

<style scoped></style>
