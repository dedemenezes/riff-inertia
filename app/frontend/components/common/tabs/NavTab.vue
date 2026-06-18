<script setup>
import { Link } from "@inertiajs/vue3";

defineProps({
  href: { type: String, required: true },
  active: { type: Boolean, default: false },
  stretch: { type: Boolean, default: true },
  stretchFrom: { type: String, default: "" },
});
</script>

<template>
  <Link
    :href="href"
    class="flex flex-col items-center justify-end h-full gap-150"
    :class="[
      stretch ? 'flex-1 min-w-0' : 'flex-none min-w-max',
      stretchFrom === 'md' ? 'md:flex-1 md:min-w-0' : '',
    ]"
  >
    <span
      class="text-body-strong-sm uppercase whitespace-nowrap"
      :class="active ? 'text-primary' : 'text-secondary-gray'"
    >
      <slot />
    </span>
    <span
      class="h-px w-full"
      :class="active ? 'bg-gradient-to-r from-magenta-600 to-laranja-600' : 'bg-transparent'"
    ></span>
  </Link>
</template>
