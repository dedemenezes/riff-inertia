<script setup>
import { computed } from "vue";
import { usePage } from "@inertiajs/vue3";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import NavTab from "@/components/common/tabs/NavTab.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const page = usePage();
const crumbs = computed(() => page.props.crumbs || []);
const tabs = computed(() => page.props.tabs || []);
</script>

<template>
  <TwContainer>
    <Breadcrumb :crumbs="crumbs" />
  </TwContainer>
  <MenuContext nav="sobre" />
  <hr class="text-neutrals-300" />

  <TwContainer>
    <div v-if="tabs.length" class="py-800">
      <nav
        aria-label="Talents sections"
        class="flex gap-300 items-center px-400 h-12"
      >
        <NavTab
          v-for="tab in tabs"
          :key="tab.label"
          :href="tab.href"
          :active="tab.active"
        >
          {{ tab.label }}
        </NavTab>
      </nav>
    </div>
  </TwContainer>
  <slot />
</template>
