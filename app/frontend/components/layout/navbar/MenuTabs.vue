<script setup>
import { Link } from "@inertiajs/vue3";
import { ref, computed, watch } from "vue";
import TabComponent from "@/components/common/tabs/TabComponent.vue";
import { IconChevronLeft, IconChevronRight } from "@/components/common/icons";
import { useUpdateWindowWidth } from "@/lib/utils";
const props = defineProps({
  tabs: { type: Array, required: true },
  isSticky: { type: Boolean, default: false }
})

const scrollContainer = ref(null);
const currentStartIndex = ref(0);


const isDesktop = useUpdateWindowWidth();
// Show 3 tabs at a time
const visibleTabsCount = isDesktop.value ? 3 : 1;

// Find the active tab index
const activeTabIndex = computed(() => {
  return props.tabs.findIndex(tab => tab.active);
});

// Auto-center the active tab
const centerActiveTab = () => {
  if (activeTabIndex.value !== -1 && props.tabs.length > visibleTabsCount) {
    // Calculate the ideal start index to center the active tab
    const idealStart = activeTabIndex.value - Math.floor(visibleTabsCount / 2);

    // Ensure we don't go below 0 or beyond the valid range
    const maxStart = props.tabs.length - visibleTabsCount;
    currentStartIndex.value = Math.max(0, Math.min(idealStart, maxStart));
  }
};

// Watch for changes in active tab and auto-center
watch(() => activeTabIndex.value, () => {
  centerActiveTab();
}, { immediate: true });

// Get the currently visible tabs
const visibleTabs = computed(() => {
  return props.tabs.slice(currentStartIndex.value, currentStartIndex.value + visibleTabsCount);
});

// Check if we can scroll
const canScrollLeft = computed(() => currentStartIndex.value > 0);
const canScrollRight = computed(() => currentStartIndex.value + visibleTabsCount < props.tabs.length);

const scrollLeft = () => {
  if (canScrollLeft.value) {
    currentStartIndex.value = Math.max(0, currentStartIndex.value - 1);
  }
};

const scrollRight = () => {
  if (canScrollRight.value) {
    currentStartIndex.value = Math.min(props.tabs.length - visibleTabsCount, currentStartIndex.value + 1);
  }
};
</script>

<template>
  <!-- MenuTabs.vue -->
  <nav
    aria-label="Program dates"
    :class="[
      'bg-white-transp-1000 relative',
      { 'sticky top-0 z-30 will-change-transform': props.isSticky }
    ]"
  >
    <!-- Left scroll button -->
    <button
      v-if="props.tabs.length > visibleTabsCount"
      @click="scrollLeft"
      class="absolute left-0 top-1/2 -translate-y-1/2 z-10 p-2 hover:cursor-pointer hover:opacity-50 transition-all duration-200"
      :class="!canScrollLeft ? 'opacity-30 cursor-not-allowed' : 'opacity-100'"
      :disabled="!canScrollLeft"
      aria-label="Scroll left"
    >
      <IconChevronLeft class="w-4 h-4 text-neutrals-900" />
    </button>

    <!-- Tabs container -->
    <div class="overflow-hidden">
      <div
        ref="scrollContainer"
        role="tablist"
        class="flex py-300 lg:py-400 px-12 transition-all duration-300 ease-in-out"
        :class="{ '-mt-[1px]': props.isSticky }"
      >
        <!-- Show only visible tabs -->
        <Link
          class="block flex-1 min-w-0"
          v-for="(tab, index) in visibleTabs"
          :key="tab.date"
          :href="tab.url"
        >
          <TabComponent
            :active="tab.active"
            :tabIndex="currentStartIndex + index"
            :content="tab.date"
          />
        </Link>
      </div>
    </div>

    {{  }}
    <!-- Right scroll button -->
    <button
      v-if="props.tabs.length > visibleTabsCount"
      @click="scrollRight"
      class="absolute right-0 top-1/2 -translate-y-1/2 z-10 p-2 bg-transparent hover:cursor-pointer hover:opacity-50 transition-all duration-200"
      :class="!canScrollRight ? 'opacity-30 cursor-not-allowed' : 'opacity-100'"
      :disabled="!canScrollRight"
      aria-label="Scroll right"
    >
      <IconChevronRight class="w-4 h-4 text-neutrals-900" />
    </button>
  </nav>
</template>

<style scoped>
/* Keep any existing styles you need */
</style>
