<script setup>
import DropdownPanel from "@/components/layout/navbar/DropdownPanel.vue";
import { BaseButton } from "@/components/common/buttons";
import { ref, reactive } from "vue";
import { usePage } from "@inertiajs/vue3"
import { IconInstagram, IconFacebook, IconTikTok, IconYoutube, IconLetterboxd, IconX, IconThreads, IconBlueSky, IconFlickr } from '@/components/common/icons/';


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
          >
            {{ item }}
          </BaseButton>
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

    <!-- TODO: Idealmente accesibilidade com teclado -->
    <DropdownPanel v-for="(subitems, item) in page.props.mainItems" :key="item" :is-open="isDropdownOpen[item]" @mouseenter="handleDropdownIn(item)" @mouseleave="handleDropdownOut">
      <!-- TODO: espacamento de cima entre dropdown e nav -->
      <div
        class="py-400 lg:pb-0 lg:max-w-7xl text-neutrals-800 flex justify-between"
      >
        <ul class="" :ref="ul => dropdownRefs[item]['ul'] = ul">
          <p v-for="subitem in subitems" class="p-200">
            <a :href="subitem.path">{{ subitem.name }}</a>
          </p>
        </ul>

        <div class="flex flex-col gap-1200 items-end py-1200">
          <div class="flex gap-1200">
            <a href="https://www.instagram.com/festivaldorio/">
              <IconInstagram
                color="text-neutrals-900"
              />
            </a>

            <a href="https://www.facebook.com/festivaldecinemadorio/">
              <IconFacebook
                color="text-neutrals-900"
              />
            </a>

            <a href="https://www.tiktok.com/@festivaldorio">
              <IconTikTok
                color="text-neutrals-900"
              />
            </a>

            <a href="https://www.youtube.com/@FestivaldoRio">
              <IconYoutube
                color="text-neutrals-900"
              />
            </a>
            <a href="https://letterboxd.com/festivaldorio/">
              <IconLetterboxd
              color="text-neutrals-900"
              />
            </a>
          </div>
          <div class="flex gap-1200">
            <a href="https://x.com/festivaldorio">
              <IconX
                color="text-neutrals-900"
              />
            </a>

            <a href="https://www.threads.net/@festivaldorio">
              <IconThreads
                color="text-neutrals-900"
              />
            </a>

            <a href="https://bsky.app/profile/festivaldorio.bsky.social">
              <IconBlueSky
                color="text-neutrals-900"
              />
            </a>

            <a href="https://www.flickr.com/photos/festivaldorio/">
              <IconFlickr
                color="text-neutrals-900"
              />
            </a>
          </div>
        </div>
      </div>
    </DropdownPanel>
  </div>
  <!-- TODO: review border maybe just desktop -->
  <hr class="text-neutrals-300">
</template>

<style scoped></style>
