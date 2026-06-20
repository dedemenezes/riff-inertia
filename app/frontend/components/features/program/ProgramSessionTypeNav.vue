<script setup>
import NavButtonContext from "@/components/common/buttons/NavButtonContext.vue";
import IconProgram from "@/components/common/icons/misc/IconProgram.vue";
import IconStar from "@/components/common/icons/misc/IconStar.vue";
import IconTicket from "@/components/common/icons/misc/IconTicket.vue";
import IconChatDots from "@/components/common/icons/misc/IconChatDots.vue";

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

const icons = {
  program: IconProgram,
  star: IconStar,
  ticket: IconTicket,
  chatDots: IconChatDots,
};

function getIconComp(name) {
  return icons[name] || null;
}
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
          <component
            :is="getIconComp(item.icon)"
            height="30px"
            width="30px"
            :active="active"
          />
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
