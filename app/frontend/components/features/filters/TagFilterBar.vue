<script setup>
import TagFilter from "@/components/common/tags/TagFilter.vue";

defineProps({
  filters: Object,
  onRemove: Function,
  className: {
    type: String,
    default: ''
  }
});
</script>

<template>
  <div
    class="gap-300 overflow-x-auto no-scroll-bar"
    :class="className"
    v-if="Object.values(filters).some((item) => item !== null)"
  >
    <TagFilter
      v-for="[key, value] in Object.entries(filters).filter(([k, v]) => v !== null)"
      :key="value.filter_value"
      :filter="value"
      :text="value.filter_display"
      @remove-filter="onRemove"
    />
  </div>
</template>
