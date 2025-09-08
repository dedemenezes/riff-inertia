<script setup>
import { ref } from "vue";
import { router } from "@inertiajs/vue3"
import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import SessionCard from "@/components/common/cards/SessionCard.vue";
import InfiniteScrollLayout from "@/components/layout/InfiniteScrollLayout.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import MenuTabs from "@/components/layout/navbar/MenuTabs.vue";
import SearchBar from "@/components/features/filters/SearchBar.vue";

const props = defineProps({
  tabBaseUrl: { type: String, required: true },
  items: { type: Array, required: true }
  ,elements: { type: Object, required: true }
  ,pagy: { type: Object, required: true }
  ,available_dates: { type: Array }
  ,selected_date: { type: String }
  ,searchQuery: { type: String }
})

const searchQuery = ref(props.searchQuery)

const handleSearch = () => {
  const query = `query=${searchQuery.value}`
  console.log(query);
  router.visit(`${props.tabBaseUrl}?${query}`, {
    preserveScroll: true,
    preserveState: true,
    only: ["elements", "searchQuery", "available_dates"],
  });
}
const handleClear = () => {
  const url = new URL(window.location.href)
  const params = url.searchParams
  params.delete("query") // TODO: hardcode query params name
    router.visit(props.tabBaseUrl, {
    preserveScroll: true,
    preserveState: true,
    only: ["elements", "searchQuery", "available_dates"],
  });
}

const iconMapping = {
  "program": IconProgram,
  "user": IconNewUser,
  "change": IconChange,
  "clock": IconClock
};
</script>

<template>
  <MenuContext
  :items="props.items"
  :icon-mapping="iconMapping"
  />
  <TwContainer>
    <SearchBar
      v-model="searchQuery"
      @search="handleSearch"
      @clear="handleClear"
    />

    <MenuTabs
    :collection="props.available_dates"
    :tabBaseUrl="props.tabBaseUrl"
    :current-query="searchQuery"
    />
    <h1 class="text-header-medium-sm py-400 text-neutrals-900">{{ selected_date }}</h1>
    <InfiniteScrollLayout #content="{ allElements }"
      :elements="props.elements"
      :pagy="props.pagy"
    >
      <SessionCard v-for="session in allElements"
        :session="session"
      />
    </InfiniteScrollLayout>
  </TwContainer>
</template>

<style scoped></style>
