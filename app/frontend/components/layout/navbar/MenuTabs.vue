<script setup>
import { Link, usePage } from "@inertiajs/vue3";
import { computed } from "vue";
import TabComponent from "@/components/common/tabs/TabComponent.vue";
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

const tabUrls = computed(
  () => {
    return props.collection.map(content => {
      const url = new URL(window.location);
      url.pathname = new URL(props.tabBaseUrl).pathname;
      url.searchParams.set('date', content);
      return {
        content,
        url: url.toString()
      };
    });
  }
);

</script>

<template>
  <nav aria-label="Program dates">
    <div role="tablist" class="flex gap-300 overflow-x-auto no-scroll-bar py-400">
      <Link
        class="block"
        v-for="(tab, index) in tabUrls"
        :key="tab.content"
        :href=tab.url
      >
        <TabComponent
          :active="isActiveTab(tab.content, index)"
          :tabIndex="index"
          :content="tab.content"
        />
      </Link>
    </div>
  </nav>
</template>

<style scoped></style>
