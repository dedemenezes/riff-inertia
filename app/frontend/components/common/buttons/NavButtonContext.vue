<script setup>
import { Link, usePage } from "@inertiajs/vue3";
import { computed, ref } from "vue";

const props = defineProps({
  content: { type: String, required: true },
  route: { type: String, default: "#" },
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

const { url } = usePage();

const getPath = (url) => {
  const u = new URL(url, window.location.origin);
  return u.pathname;
};

const isActive = computed(() => getPath(url) === getPath(props.route)); // Check if current URL matches the route
const isIconActive = computed(() => isHovered.value || isFocused.value || isActive.value);</script>

<template>
  <Link
    :href="props.route"
    class=""
    :class="{ 'route-active-TEST': $page.url == props.route }"
    :aria-label="`Navegar para ${props.content}`"
    @mouseenter="handleMouseEnter"
    @mouseleave="handleMouseLeave"
    @focus="handleFocus"
    @blur="handleBlur"
  >
    <div class="flex flex-col items-center gap-200">
      <slot
        name="icon"
        :hovered="isHovered"
        :active="isIconActive"
        :routeActive="isActive"
      />
      <p class="text-body-strong-xs text-primary text-center uppercase">
        {{ props.content }}
      </p>
    </div>
  </Link>
</template>
