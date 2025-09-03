<script setup>
import { Link } from "@inertiajs/vue3"
import { IconHome, IconChevronRight } from "@components/common/icons"
const props = defineProps({
  crumbs: {
    type: Array,
    required: true,
    // Example: [{ label: "Noticias", href: "/pt/noticias" }, { label: "Atual", href: "" }]
  }
})
</script>

<template>
  <ul class="flex items-center space-x-200 py-800">
    <li>
      <Link :href="props.crumbs[0].href" class="flex items-center justify-center">
        <IconHome height="12" width="12" color="text-neutrals-900" />
      </Link>
    </li>

    <li class="flex items-center space-x-200" v-for="(crumb, index) in props.crumbs.slice(1)" :key="index">
      <span>
        <IconChevronRight
          color="text-neutrals-700"
          height="14"
          width="14"
        />
      </span>
      <span
        v-if="index < props.crumbs.length - 2"
        class="text-body-regular-xs text-neutrals-700  hover:text-neutrals-900"
      >
        <Link :href="crumb.href">
          {{ crumb.label }}
        </Link>
      </span>
      <span v-else class="text-body-strong-xs">
        {{ crumb.label.split(" ").slice(0,5).join(" ") }}
      </span>

    </li>
  </ul>
</template>

<style scoped></style>
