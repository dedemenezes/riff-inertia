<script setup>
import QuickLinkCard from "@/components/common/cards/QuickLinkCard.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  links: {
    type: Array,
    required: true,
  },
});
</script>

<template>
  <div class="bg-neutrals-200">
    <TwContainer>
      <div class="py-800 flex flex-col space-y-800">
        <h3 class="text-header-base text-xl text-primary">Links Rápidos</h3>
        <div class="flex flex-col gap-y-800 lg:flex-row">
          <QuickLinkCard
            v-for="link in props.links"
            :key="link.id"
            :title="link.title.toUpperCase()"
            :description="link.description"
            :href="link.href"
          />
        </div>
      </div>
    </TwContainer>
  </div>
</template>

<style scoped></style>
