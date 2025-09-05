<script setup>
import DropdownPanel from "@/components/layout/navbar/DropdownPanel.vue";
import { BaseButton } from "@/components/common/buttons";
import { ref, reactive } from "vue";
import { usePage } from "@inertiajs/vue3"

const page = usePage()

const mainItemsKeys = Object.keys(page.props.mainItems);
const allClosed = mainItemsKeys.reduce((acc, key) => {
  acc[key] = false;
  return acc;
}, {});

const isDropdownOpen = ref(allClosed)
const handleDropdownIn = (item) => {
  const openDropdown = {...allClosed}
  openDropdown[item] = true
  isDropdownOpen.value = openDropdown
  if (dropdownRefs[item].ul.style.marginLeft === "") {
    setDropdownOffset(item)
  }
}

const handleDropdownOut = () => {
  isDropdownOpen.value = allClosed
}

const dropdownRefs = reactive({})
const setDropdownOffset = (item) => {
  const button = dropdownRefs[item].button
  const ul = dropdownRefs[item].ul

  const offset = button.getBoundingClientRect().x
  ul.style.marginLeft = `${offset}px`
}

</script>

<template>
  <div class="">

    <div
      class="p-400 lg:pb-0 mx-auto lg:max-w-7xl hidden md:flex items-center justify-between"
    >
      <ul class="flex flex-grow gap-600 justify-start items-center me-400 h-1600">
        <li v-for="(subitems, item) in page.props.mainItems" :key="item" class="h-full">
          <BaseButton
            class="h-full uppercase"
            as="button"
            variant="underline"
            size="lg"
            @mouseenter="handleDropdownIn(item)"
            @mouseleave="handleDropdownOut"
            :ref="buttonComponent => {
              dropdownRefs[item] ??= {}
              dropdownRefs[item].button = buttonComponent?.$el
            }"
            >{{ item }}</BaseButton
          >
        </li>
      </ul>
      <ul class="hidden md:flex items-center space-x-400">
        <li v-for="item in page.props.secondaryItems" :key="item">
          <BaseButton :as="item.tag" :href="item.href" variant="gray" size="xs">{{
            item.name
          }}</BaseButton>
        </li>
      </ul>
    </div>
    <DropdownPanel v-for="(subitems, item) in page.props.mainItems" :key="item" :is-open="isDropdownOpen[item]" @mouseenter="handleDropdownIn(item)" @mouseleave="handleDropdownOut">
      <div
        class="py-400 lg:pb-0 lg:max-w-7xl text-neutrals-800"
      >
        <ul class="" :ref="ul => dropdownRefs[item]['ul'] = ul">
          <p v-for="subitem in subitems" class="p-200">
            <a :href="subitem.path">{{ subitem.description }}</a>
          </p>
        </ul>
      </div>
    </DropdownPanel>
  </div>
</template>

<style scoped></style>
