<script setup>
import { computed } from "vue";

const props = defineProps({
  state: {
    type: String,
    default: "default",
    validator: (value) => ["default", "active", "disabled"].includes(value),
  },
  time: {
    type: String,
    default: "21h30",
  },
});

const baseClasses = `inline-flex items-center px-200 py-100 border rounded-sm max-w-fit
                     text-2xs leading-[16px] tracking-widest
                     font-body font-medium uppercase`;

const stateClasses = computed(() => ({
  "bg-neutrals-100 border-neutrals-300 text-neutrals-900":
    props.state === "default",
  "bg-neutrals-100 border-neutrals-900 text-neutrals-900":
    props.state === "active",
  "bg-neutrals-300 text-neutrals-600 cursor-not-allowed":
    props.state === "disabled",
}));

const isDisabled = computed(() => props.state === "disabled");
</script>

<template>
  <p :class="[baseClasses, stateClasses]" :aria-disabled="isDisabled">
    {{ props.time }}
  </p>
</template>
