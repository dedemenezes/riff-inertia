<script setup>
import NavButtonContext from "@components/common/buttons/NavButtonContext.vue";
import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";

const props = defineProps({
  text: { type: String },
  items: { type: Array, required: true }
})

const iconMapping = {
  "program": IconProgram,
  "user": IconNewUser,
  "change": IconChange,
  "clock": IconClock
};

console.log(iconMapping);

</script>

<template>
  <div
    class="flex gap-800 px-400 py-200 lg:gap-1600 lg:py-800 lg:justify-center overflow-x-auto"
  >
    <NavButtonContext
      v-for="item in items"
      :key="item"
      class="flex-shrink-0"
      :content="item.name"
      :route="item.route"
    >
      <template #icon="{ active }">
        <component
          :is="iconMapping[item.icon]"
          height="30px"
          width="30px"
          :active="active"
        />
      </template>
    </NavButtonContext>
  </div>
</template>

<style scoped></style>
