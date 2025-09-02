<script setup>
import DropdownPanel from "@/components/layout/navbar/DropdownPanel.vue";
import { BaseButton } from "@/components/common/buttons";

const props = defineProps({
  mainItems: { type: Array },
  secondaryItems: { type: Array },
})


import { ref } from "vue";

const isDropdownOpen = ref(false)
const handleDropdownIn = (item) => {
  console.log(isDropdownOpen.value);
  console.log("DROPDOWN ON!");
  isDropdownOpen.value = true
  console.log(isDropdownOpen.value);
  // Calculate the position for the columns
  // based on the parent position
  console.log(item);

}
const handleDropdownOut = () => {
  console.log(isDropdownOpen.value);
  console.log("DROPDOWN OFF!");
  isDropdownOpen.value = false
  console.log(isDropdownOpen.value);
}
</script>

<template>
  <div class="relative">

    <div
      class="p-400 lg:pb-0 mx-auto lg:max-w-7xl hidden md:flex items-center justify-between"
    >
      <ul class="flex flex-grow gap-600 justify-start items-center me-400 h-1600">
        <li v-for="item in props.mainItems" :key="item" class="h-full">
          <BaseButton
            class="h-full uppercase"
            as="button"
            variant="underline"
            size="lg"
            @mouseenter="handleDropdownIn(item)"
            @mouseleave="handleDropdownOut"
            >{{ item }}</BaseButton
          >
        </li>
      </ul>
      <ul class="hidden md:flex items-center space-x-400">
        <li v-for="item in props.secondaryItems" :key="item">
          <BaseButton :as="item.tag" :href="item.href" variant="gray" size="xs">{{
            item.name
          }}</BaseButton>
        </li>
      </ul>
    </div>
    <DropdownPanel :is-open="isDropdownOpen" :on-mouse-enter="handleDropdownIn" :on-mouse-leave="handleDropdownOut">
      <div
        class="p-400 lg:pb-0 mx-auto lg:max-w-7xl hidden md:flex items-center justify-between"
      >
        <ul class="flex flex-grow gap-600 justify-start items-center me-400 h-1600">
          <p>FLAMENGO</p>
          <p class="px-200">OCTA</p>
        </ul>
      </div>
    </DropdownPanel>
  </div>
</template>

<style scoped></style>
