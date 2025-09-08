<script setup>
import { Link } from "@inertiajs/vue3";
import TabComponent from "@/components/common/tabs/TabComponent.vue";
import { usePage } from '@inertiajs/vue3';
const page = usePage()

const props = defineProps({
  collection: { type: Array, required: true },
  tabBaseUrl: { type: String, required: true },
  currentQuery: { type: String, default: null }
})

// TODO: MAKE REUSABLE!
const isActiveTab = (tabDate, tabIndex) => {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(tabDate)) return false

  return page.url.includes(`date=${tabDate}`) || (tabIndex === 0 && !page.url.includes('date='))
}

</script>

<template>
  <nav aria-label="Program dates">
    <div role="tablist" class="flex gap-300 overflow-x-auto no-scroll-bar py-400">
      <Link
        class="block"
        v-for="(content, index) in props.collection"
        :key="content"
        :href="`${props.tabBaseUrl}?date=${content}${currentQuery ? `&query=${currentQuery}` : ''}`"
      >
        <TabComponent
          :active="isActiveTab(content, index)"
          :tabIndex="index"
          :content="content"
        />
      </Link>
    </div>
  </nav>
</template>

<style scoped></style>
