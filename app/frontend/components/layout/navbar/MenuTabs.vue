<script setup>
import { Link } from "@inertiajs/vue3";
import TabComponent from "@/components/common/tabs/TabComponent.vue";

const props = defineProps({
  tabs: { type: Array, required: true }, // Pre-built tabs from backend
  isSticky: { type: Boolean, default: false }
})
</script>

<template>
  <!-- MenuTabs.vue -->
  <nav
    aria-label="Program dates"
    :class="[
      'bg-white-transp-1000',
      { 'sticky top-0 z-30 will-change-transform': props.isSticky }
    ]"
  >
    <div
      role="tablist"
      class="flex gap-300 overflow-x-auto no-scroll-bar py-300 lg:py-400"
      :class="{ '-mt-[1px]': props.isSticky }"
    >
      <Link
        class="block"
        v-for="(tab, index) in tabs"
        :key="tab.date"
        :href="tab.url"
      >
        <TabComponent
          :active="tab.active"
          :tabIndex="index"
          :content="tab.date"
        />
      </Link>
    </div>
  </nav>
</template>
