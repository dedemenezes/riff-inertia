<!-- TODO: Refac active statte to mathc contain url -->
<script setup>
import NavButtonContext from "@components/common/buttons/NavButtonContext.vue";

const props = defineProps({
  items: { type: Array, required: true },
  iconMapping: { type: Object, required: true }
})


</script>

<template>
  <!-- TODO: check padding y -->
  <div
    class="flex gap-600 px-400 py-200 lg:gap-1600 lg:py-800 lg:justify-center overflow-x-auto no-scroll-bar"
  >
    <NavButtonContext
      v-for="item in props.items"
      :key="item"
      class="flex-shrink-0"
      :content="item.name"
      :route="item.route"
    >
      <template #icon="{ active }">
        <component
          :is="props.iconMapping[item.icon]"
          height="30px"
          width="30px"
          :active="active"
        />
      </template>
    </NavButtonContext>
  </div>
</template>

<style scoped></style>
