<script setup>
import IconChevronRight from '@/components/common/icons/navigation/IconChevronRight.vue';
import ButtonText from '@/components/common/buttons/ButtonText.vue';

const props = defineProps({
  pelicula: { type: Object, required: true }
})
</script>

<template>
  <div class="flex flex-col gap-400 items-center justify-center">
    <img
      :src="props.pelicula.posterImageURL"
      class="aspect-[4/5]  max-h-[251px] max-w-[201px] w-full object-cover"
      :alt="`${props.pelicula.display_titulo} banner`"
      loading="lazy"
    >
    <!-- TRanslate website -->
    <ButtonText variant="dark" class="gap-200" text="Ver fotos de imprensa" tag="a">
      <template #icon>
        <IconChevronRight height="16" width="16" color="inherit order-2"/>
      </template>
    </ButtonText>
  </div>
</template>

<style scoped></style>
