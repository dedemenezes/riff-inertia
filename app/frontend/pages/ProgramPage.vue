<script setup>
import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import SkeletonSessionCard from "@/components/common/cards/SkeletonSessionCard.vue";
import SessionCard from "@/components/common/cards/SessionCard.vue";
import InfiniteScrollLayout from "@/components/layout/InfiniteScrollLayout.vue";

const props = defineProps({
  items: { type: Array, required: true }
  ,elements: { type: Object, required: true }
  ,pagy: { type: Object, required: true }
})

const iconMapping = {
  "program": IconProgram,
  "user": IconNewUser,
  "change": IconChange,
  "clock": IconClock
};

</script>

<template>
  {{ props.elements.length }}
  <MenuContext
  :items="props.items"
  :icon-mapping="iconMapping"
  />
  <InfiniteScrollLayout #content="{ allElements }"
    :elements="props.elements"
    :pagy="props.pagy"
  >
  {{ console.log(allElements) }}
    <SessionCard v-for="session in allElements"
      :session="session"
    />
  </InfiniteScrollLayout>
</template>

<style scoped></style>
