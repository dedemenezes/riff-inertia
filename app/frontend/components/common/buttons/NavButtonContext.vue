<script setup>
import { Link, usePage } from "@inertiajs/vue3";
import { computed, ref } from "vue";
import { useTabScroll } from '@/components/common/tabs/useTabScroll'

const props = defineProps({
  content: { type: String, required: true },
  route: { type: String, default: "#" },
  active: { type: Boolean, default: undefined }
});
const isHovered = ref(false);
const handleMouseEnter = () => {
  isHovered.value = true;
};
const handleMouseLeave = () => {
  isHovered.value = false;
};

const isFocused = ref(false);
const handleFocus = () => {
  isFocused.value = true;
};
const handleBlur = () => {
  isFocused.value = false;
};

const page = usePage();

const getPath = (url) => {
  const u = new URL(url, window.location.origin);
  return u.pathname;
};

const isActive = computed(() => getPath(page.url) === getPath(props.route)); // Check if current URL matches the route
const hasExplicitActive = computed(() => props.active !== undefined);
const routeActive = computed(() => hasExplicitActive.value ? props.active : isActive.value);
const isIconActive = computed(() => isHovered.value || isFocused.value || routeActive.value);

const navRef = useTabScroll(routeActive);
</script>

<template>
  <Link
    :href="props.route"
    class=""
    :class="{ 'route-active-TEST': routeActive }"
    :aria-label="`Navegar para ${props.content}`"
    @mouseenter="handleMouseEnter"
    @mouseleave="handleMouseLeave"
    @focus="handleFocus"
    @blur="handleBlur"
  >
    <div ref="navRef" class="flex flex-col items-center gap-200">
      <slot
        name="icon"
        :hovered="isHovered"
        :active="isIconActive"
        :routeActive="routeActive"
      />
      <p class="text-body-strong-xs text-primary text-center uppercase">
        {{ props.content }}
      </p>
    </div>
  </Link>
</template>
