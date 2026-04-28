<script setup>
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import { useCarousel } from './useCarousel';
import IconChevronRight from '@components/common/icons/navigation/IconChevronRight.vue';

const props = defineProps({
  variant: { type: null, required: false, default: 'ghost' },
  size: { type: null, required: false, default: 'icon' },
  class: { type: null, required: false }
});

const { orientation, canScrollNext, scrollNext } = useCarousel();
</script>

<template>
  <Button
    data-slot="carousel-next"
    :disabled="!canScrollNext"
    :class="
      cn(
        'absolute size-8 rounded-full border-none bg-transparent',
        'text-neutrals-400 hover:bg-transparent hover:text-neutrals-200',
        'active:text-white-transp-1000 disabled:opacity-30 disabled:cursor-not-allowed',
        orientation === 'horizontal'
          ? 'top-1/2 -right-12 -translate-y-1/2'
          : '-bottom-12 left-1/2 -translate-x-1/2 rotate-90',
        props.class,
      )
    "
    :variant="variant"
    :size="size"
    @click="scrollNext"
  >
    <slot>
      <IconChevronRight color="size-10" />
      <span class="sr-only">Próximo slide</span>
    </slot>
  </Button>
</template>
