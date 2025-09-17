<script setup>
import { computed } from 'vue';
import { useTabScroll } from './useTabScroll';

const props = defineProps({
  active: { type: Boolean, default: false },
  tabIndex: { type: Number, required: true },
  content: { type: String, default: new Date().toISOString().split('T')[0] }
})

const tabRef = useTabScroll(props.active); // used to reference "self"
</script>

<template>
  <div ref="tabRef" :class="props.active ? 'bg-gradient-to-r from-magenta-600 to-laranja-600 pb-[2px]' : 'bg-neutrals-200 pb-[1px]'" class="p-0 pb-[2px]">
    <div class="flex items-center justify-center bg-white back px-[33.3px] pt-[6px]">
      <div
        class="tab-content"
        role="tab"
        :aria-selected="props.active"
        :id="`tab-${month}-${day}`"
      >
        <time :datetime="props.content">
          <div class="text-body-strong-sm flex items-center" :class="props.active ? 'text-neutrals-900' : 'text-neutrals-700'">
            <span class="day me-100">{{ content }}</span>
          </div>
        </time>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
