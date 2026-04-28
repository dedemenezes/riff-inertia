<script setup>
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import { useCarousel } from './useCarousel';
import IconChevronLeft from '@components/common/icons/navigation/IconChevronLeft.vue';

const props = defineProps({
  variant: { type: null, required: false, default: 'ghost' },
  size: { type: null, required: false, default: 'icon' },
  class: { type: null, required: false }
});

const { orientation, canScrollPrev, scrollPrev } = useCarousel();
</script>

<template>
  <Button
    data-slot="carousel-previous"
    :disabled="!canScrollPrev"
    :class="
      cn(
        'absolute size-8 rounded-full border-none bg-transparent',
        'text-neutrals-400 hover:bg-transparent hover:text-neutrals-200',
        'active:text-white-transp-1000 disabled:opacity-30 disabled:cursor-not-allowed',
        orientation === 'horizontal'
          ? 'top-1/2 -left-12 -translate-y-1/2'
          : '-top-12 left-1/2 -translate-x-1/2 rotate-90',
        props.class,
      )
    "
    :variant="variant"
    :size="size"
    @click="scrollPrev"
  >
    <slot>
      <IconChevronLeft color="size-10" />
      <span class="sr-only">Slide anterior</span>
    </slot>
  </Button>
</template>
