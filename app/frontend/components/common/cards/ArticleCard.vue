<script setup>
import { Link } from "@inertiajs/vue3"
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
  permalink: { type: String, required: true },
});

const backgroundImageStyle = computed(() => ({
  backgroundImage: `url(${props.backgroundImage})`
}));

// Added to fix responsivenes in the home page
const secondaryImageHeightClass = computed(() => {
  if (props.variant === "secondary") {
    return "lg:mix-h-[182px] lg:max-h-[182px]"
  }
  return ""
})
</script>

<template>
  <div class="flex flex-col gap-y-200" :class="heightClass">
    <div
      class="flex-grow self-stretch bg-no-repeat bg-cover bg-center rounded-200"
      :class="secondaryImageHeightClass"
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
      <Link :href="`/pt/noticias/${props.permalink}`">
        {{ props.title }}
      </Link>
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
