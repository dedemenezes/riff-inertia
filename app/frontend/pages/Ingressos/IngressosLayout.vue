<script setup>
import { computed } from "vue";
import { usePage } from "@inertiajs/vue3";
import NavTab from "@/components/common/tabs/NavTab.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const page = usePage();
const tabs = computed(() => page.props.tabs || []);
</script>

<template>
  <TwContainer>
    <div v-if="tabs.length" class="py-800">
      <nav
        aria-label="Ingressos"
        class="flex gap-300 items-center justify-start md:justify-center px-400 max-w-[940px] mx-auto h-12 overflow-x-auto no-scroll-bar md:overflow-visible"
      >
        <NavTab
          v-for="tab in tabs"
          :key="tab.label"
          :href="tab.href"
          :active="tab.active"
          :stretch="false"
        >
          {{ tab.label }}
        </NavTab>
      </nav>
    </div>
  </TwContainer>

  <slot />
</template>
