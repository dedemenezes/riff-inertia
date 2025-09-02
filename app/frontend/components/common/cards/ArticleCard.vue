<script setup>
import { computed } from "vue";
const props = defineProps({
  variant: {
    type: String,
    default: "primary",
    validator: (value) => ["primary", "secondary", "simple"].includes(value),
  },
  backgroundImage: {
    type: String,
    required: true,
  },
  heightClass: {
    type: String,
    default: "",
  },
  title: { type: String, required: true },
  content: { type: String, required: false },
  date: { type: String, required: true },
  category: { type: String, required: true },
});

const backgroundImageStyle = computed(() => ({
  backgroundImage: `url(${props.backgroundImage})`,
  ...(props.variant === "secondary" && {
    minHeight: "182px",
    maxHeight: "182px",
  }),
}));
</script>

<template>
  <div class="flex flex-col gap-y-200" :class="heightClass">
    <div
      class="flex-grow self-stretch bg-no-repeat bg-cover bg-center rounded-200"
      :style="backgroundImageStyle"
    ></div>
    <div v-if="date && category" class="flex gap-x-200 items-center">
      <span class="text-overline text-primary">
        {{ date }}
      </span>
      <img src="@assets/icons/divisor.svg" alt="divisor" style="height: 16px" />
      <span class="text-overline text-primary">
        {{ category }}
      </span>
    </div>
    <h3 class="text-header-sm text-primary">
      {{ props.title }}
    </h3>
    <p
      v-if="props.variant === 'primary'"
      class="text-body-regular text-primary"
    >
      {{ props.content }}
    </p>
  </div>
</template>

<style scoped></style>
