<script setup>
import { ref, computed, onMounted, onUpdated } from "vue";
import TwContainer from "./TwContainer.vue";
import { IconChevronRight, IconChevronLeft } from "@/components/common/icons";

const props = defineProps({
  variant: {
    type: String,
    default: "dark",
    validator: (v) => ["dark", "light"].includes(v),
  },
  mobileVariant: {
    type: String,
    default: null,
    validator: (v) => v === null || ["dark", "light"].includes(v),
  },
  scrollDistance: {
    type: Number,
    default: 0.8,
  },
  mobileScrollDistance: {
    type: Number,
    default: 0.5,
  },
});

const iconClasses = computed(() => {
  if (currentVariant.value === "dark") {
    return "text-white-transp-800 hover:text-white-transp-1000";
  }
  return "cursor-pointer text-neutrals-900 hover:text-neutrals-700";
});

const disabledIconClasses = computed(() => {
  if (currentVariant.value === "dark") {
    return "text-neutrals-400 cursor-not-allowed";
  }
  return "text-neutrals-400 cursor-not-allowed";
});

const scrollContainer = ref(null);
const width = ref(typeof window !== "undefined" ? window.innerWidth : 0);
const canScrollLeft = ref(false);
const canScrollRight = ref(true);
const isMobile = ref(
  typeof window !== "undefined" ? window.innerWidth < 1024 : false,
);

const currentVariant = computed(() => {
  return isMobile.value && props.mobileVariant
    ? props.mobileVariant
    : props.variant;
});

const currentScrollDistance = computed(() => {
  return isMobile.value ? props.mobileScrollDistance : props.scrollDistance;
});

const updateScrollState = () => {
  if (!scrollContainer.value) return;
  const { scrollLeft, scrollWidth, clientWidth } = scrollContainer.value;
  canScrollLeft.value = scrollLeft > 0;
  canScrollRight.value = scrollLeft + clientWidth < scrollWidth - 10;
};

const scrollLeft = () => {
  scrollContainer.value.scrollBy({
    left: -width.value * currentScrollDistance.value,
    behavior: "smooth",
  });
};
const scrollRight = () => {
  scrollContainer.value.scrollBy({
    left: width.value * currentScrollDistance.value,
    behavior: "smooth",
  });
};

onMounted(() => {
  updateScrollState();
  isMobile.value = window.innerWidth < 1024;
  scrollContainer.value?.addEventListener("scroll", updateScrollState);
  window.addEventListener("resize", () => {
    width.value = window.innerWidth;
    isMobile.value = window.innerWidth < 1024;
  });
});
onUpdated(() => {
  updateScrollState();
});
</script>

<template>
  <div class="relative flex flex-col gap-600">
    <TwContainer>
      <slot name="header" />
    </TwContainer>
    <div
      ref="scrollContainer"
      class="flex overflow-x-auto no-scroll-bar gap-800 scroll-snap-x-mandatory"
    >
      <slot name="content" />
    </div>
    <button
      @click="scrollLeft"
      :disabled="!canScrollLeft"
      class="absolute left-400 top-1/2 -translate-y-1/2 lg:-translate-x-16 z-10 bg-transparent transition-colors"
      aria-label="Scroll left"
    >
      <IconChevronLeft
        :class="['w-6 h-6', canScrollLeft ? iconClasses : disabledIconClasses]"
      />
    </button>
    <button
      @click="scrollRight"
      :disabled="!canScrollRight"
      class="absolute right-400 top-1/2 -translate-y-1/2 lg:translate-x-16 z-10 bg-transparent transition-colors"
      aria-label="Scroll right"
    >
      <IconChevronRight
        :class="['w-6 h-6', canScrollRight ? iconClasses : disabledIconClasses]"
      />
    </button>
  </div>
</template>

<style scoped>
.scroll-snap-x-mandatory {
  scroll-snap-type: x mandatory;
}

.scroll-snap-x-mandatory > * {
  scroll-snap-align: start;
  scroll-snap-stop: always;
}
</style>
