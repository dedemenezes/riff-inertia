<script setup>
import { Link } from "@inertiajs/vue3";
import { ref } from "vue";
import TabComponent from "@/components/common/tabs/TabComponent.vue";
import { IconChevronLeft, IconChevronRight } from "@/components/common/icons";

const props = defineProps({
  tabs: { type: Array, required: true },
  isSticky: { type: Boolean, default: false }
})

const scrollContainer = ref(null);

const scrollLeft = () => {
  scrollContainer.value.scrollBy({ left: -200, behavior: 'smooth' });
};

const scrollRight = () => {
  scrollContainer.value.scrollBy({ left: 200, behavior: 'smooth' });
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
      @click="scrollLeft"
      class="absolute left-0 top-1/2 -translate-y-1/2 z-10 p-2 hover:bg-gray-50"
      aria-label="Scroll left"
    >
      <IconChevronLeft class="w-4 h-4 text-neutrals-900" />
    </button>

    <!-- Scrollable tabs -->
    <div
      ref="scrollContainer"
      role="tablist"
      class="flex gap-300 overflow-x-auto no-scroll-bar py-300 lg:py-400 px-12 fade-out--left fade-out--right"
      :class="{ '-mt-[1px]': props.isSticky }"
    >
      <Link
        class="block flex-shrink-0"
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

    <!-- Right scroll button -->
    <button
      @click="scrollRight"
      class="absolute right-0 top-1/2 -translate-y-1/2 z-10 p-2 bg-transparent hover:bg-gray-50"
      aria-label="Scroll right"
    >
      <IconChevronRight class="w-4 h-4 text-neutrals-900" />
    </button>
  </nav>
</template>

<style scoped>
.fade-out--left.fade-out--right {
  -webkit-mask-image: linear-gradient(to right, transparent 0%, black 15%, black 85%, transparent 100%);
  mask-image: linear-gradient(to right, transparent 0%, black 15%, black 85%, transparent 100%);
  -webkit-mask-size: 100% 100%;
  mask-size: 100% 100%;
}
</style>
