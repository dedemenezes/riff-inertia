<script setup>
import { Link } from "@inertiajs/vue3";
import { computed } from "vue";

const props = defineProps({
  variant: {
    type: String,
    default: "principal",
    validator: (value) =>
      ["principal", "secundaria", "horizontal", "horizontal-2"].includes(value),
  },
  image: { type: String, required: true },
  title: { type: String, required: true },
  date: { type: String, required: true },
  category: { type: String, required: true },
  permalink: { type: String, required: true },
  content: { type: String, required: false, default: "" },
});

const isHorizontal = computed(() =>
  ["horizontal", "horizontal-2"].includes(props.variant)
);

const showContent = computed(() => {
  if (props.variant === "secundaria") return false;
  return Boolean(props.content);
});

const rootClasses = computed(() => {
  if (isHorizontal.value) {
    return "flex flex-col md:flex-row gap-200 md:gap-400 md:items-start";
  }
  return "flex flex-col gap-200";
});

const imageWrapperClasses = computed(() => {
  switch (props.variant) {
    case "secundaria":
      return "w-full h-[182px]";
    case "horizontal":
      return "w-full md:w-[332px] md:h-[155px] aspect-16/9 md:aspect-auto shrink-0";
    case "horizontal-2":
      return "w-full md:flex-1 md:h-[155px] aspect-16/9 md:aspect-auto";
    default:
      return "w-full aspect-16/9";
  }
});

const textWrapperClasses = computed(() => {
  if (isHorizontal.value) {
    return "flex flex-col gap-200 md:flex-1 md:min-w-0";
  }
  return "flex flex-col gap-200";
});

const titleClasses = computed(() => {
  const base = "text-header-sm text-primary";
  if (props.variant === "secundaria") return `${base} line-clamp-3`;
  if (props.variant === "horizontal-2") return `${base} line-clamp-4`;
  return base;
});

const contentClasses = computed(() => {
  const base = "text-body-regular text-primary";
  if (props.variant === "horizontal-2") {
    return `${base} truncate`;
  }
  return base;
});
</script>

<template>
  <article :class="rootClasses">
    <Link :href="permalink" :class="imageWrapperClasses" class="block">
      <img
        :src="image"
        :alt="title"
        class="w-full h-full object-cover rounded-200"
      />
    </Link>

    <div :class="textWrapperClasses">
      <div class="flex gap-200 items-center">
        <span class="text-overline text-primary whitespace-nowrap">
          {{ date }}
        </span>
        <img
          src="@assets/icons/divisor.svg"
          alt=""
          aria-hidden="true"
          style="height: 16px"
        />
        <span class="text-overline text-primary">
          {{ category }}
        </span>
      </div>

      <h3 :class="titleClasses">
        <Link :href="permalink">{{ title }}</Link>
      </h3>

      <p v-if="showContent" :class="contentClasses">
        {{ content }}
      </p>
    </div>
  </article>
</template>
