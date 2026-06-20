<script setup>
import NavButtonContext from "@/components/common/buttons/NavButtonContext.vue";
import { defineAsyncComponent, watchEffect } from "vue";

const props = defineProps({
  items: { type: Array, required: true },
});

const PARTIAL_RELOAD_PROPS = [
  "elements",
  "pagy",
  "session_type_nav",
  "current_session_type",
  "current_filters",
  "has_active_filters",
];

const loaders = {
  program: () => import("@/components/common/icons/misc/IconProgram.vue"),
  star: () => import("@/components/common/icons/misc/IconStar.vue"),
  ticket: () => import("@/components/common/icons/misc/IconTicket.vue"),
  chatDots: () => import("@/components/common/icons/misc/IconChatDots.vue"),
};

const cache = new Map();

function getIconComp(name) {
  if (!name || !loaders[name]) return null;
  if (!cache.has(name)) cache.set(name, defineAsyncComponent(loaders[name]));
  return cache.get(name);
}

watchEffect(() => {
  props.items.forEach((item) => { void loaders[item.icon]?.() });
});
</script>

<template>
  <div class="relative">
    <div class="flex gap-600 px-800 py-200 lg:gap-1600 lg:py-800 md:justify-center overflow-x-auto no-scroll-bar fade-out--left fade-out--right">
      <NavButtonContext
        v-for="item in props.items"
        :key="item.session_type ?? 'all'"
        :content="item.label"
        :route="item.href"
        :active="item.active"
        :only="PARTIAL_RELOAD_PROPS"
        preserve-state
        preserve-scroll
        replace
        class="flex-shrink-0"
        :aria-label="`Filtrar programação por ${item.label}`"
      >
        <template #icon="{ active }">
          <Suspense>
            <component
              :is="getIconComp(item.icon)"
              height="30px"
              width="30px"
              :active="active"
            />

            <template #fallback>
              <span class="inline-block h-[20px] w-[20px] rounded bg-neutral-200/70" />
            </template>
          </Suspense>
        </template>
      </NavButtonContext>
    </div>
  </div>
</template>

<style scoped>
.fade-out--left.fade-out--right {
  -webkit-mask-image: linear-gradient(to right, transparent 0%, black 15%, black 85%, transparent 100%);
  mask-image: linear-gradient(to right, transparent 0%, black 15%, black 85%, transparent 100%);
  -webkit-mask-size: 100% 100%;
  mask-size: 100% 100%;
}
</style>
