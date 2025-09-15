<script setup>
import NavButtonContext from "@components/common/buttons/NavButtonContext.vue";
import { ref, defineAsyncComponent, watchEffect } from 'vue'
import { usePage } from "@inertiajs/vue3"

const IconChevronRight = defineAsyncComponent(() => import("@/components/common/icons/navigation/IconChevronRight.vue"))
const IconChevronLeft = defineAsyncComponent(() => import("@/components/common/icons/navigation/IconChevronLeft.vue"))


const page = usePage()

const menuContext = page.props.menuContext;

const props = defineProps({
  nav: { type: String, required: true },
  activePage: { type: String }
})

const loaders = {
  program: () => import('@/components/common/icons/misc/IconProgram.vue'),
  newUser: () => import('@/components/common/icons/misc/IconNewUser.vue'),
  change: () => import('@/components/common/icons/misc/IconChange.vue'),
  ticket: () => import('@/components/common/icons/misc/IconTicket.vue'),
  grid: () => import('@/components/common/icons/misc/IconGrid.vue'),
  pin: () => import('@/components/common/icons/misc/IconPin.vue'),
  trophy: () => import('@/components/common/icons/misc/IconTrophy.vue'),
  people: () => import('@/components/common/icons/misc/IconPeople.vue'),
  logoFest: () => import('@/components/common/icons/misc/IconLogoFest.vue'),
  calendar: () => import('@/components/common/icons/misc/IconCalendar.vue'),
  talentPress: () => import('@/components/common/icons/misc/IconTalentPress.vue'),
  handshake: () => import('@/components/common/icons/misc/IconHandshake.vue'),
  image: () => import('@/components/common/icons/misc/IconImage.vue'),
  book: () => import('@/components/common/icons/misc/IconBook.vue')
}

const loadersPerNav = {
  programacao: ["program", "newUser", "change", "ticket"],
  edicao: ["program", "grid", "pin", "trophy", "people"],
  sobre: ["logoFest", "calendar", "talentPress", "handshake"],
  midias: ["image", "book"]
}

const cache = new Map()

function getIconComp(name) {
  if (!name || !loaders[name]) return null
  if (!cache.has(name)) cache.set(name, defineAsyncComponent(loaders[name]))
  return cache.get(name)
}

watchEffect(() => {
  loadersPerNav[props.nav]?.forEach((k) => { void loaders[k]?.() })
})


const scrollContainer = ref(null);

const scrollLeft = () => {
  scrollContainer.value.scrollBy({ left: -200, behavior: 'smooth' });
};

const scrollRight = () => {
  scrollContainer.value.scrollBy({ left: 200, behavior: 'smooth' });
};
</script>

<template>
  <div class="relative">
    <!-- Left scroll button -->
    <button
      @click="scrollLeft"
      class="absolute left-0 top-1/2 -translate-y-2/3 z-10 p-2 hover:bg-gray-50 md:hidden"
      aria-label="Scroll left"
    >
      <IconChevronLeft class="w-4 h-4 text-neutrals-900" />
    </button>
    <div
      class="flex gap-600 px-1200 py-200 lg:gap-1600 lg:py-800 lg:justify-center overflow-x-auto no-scroll-bar fade-out--left fade-out--right"
      ref="scrollContainer"
    >
      <NavButtonContext
        v-for="item in menuContext[props.nav]"
        :key="item"
        class="flex-shrink-0"
        :content="item.name"
        :route="item.path"
        :active="props.activePage === item.name"
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
      <!-- Right scroll button -->
    </div>
    <button
      @click="scrollRight"
      class="absolute right-0 top-1/2 -translate-y-2/3 z-10 p-2 bg-transparent hover:bg-gray-50 md:hidden"
      aria-label="Scroll right"
    >
      <IconChevronRight class="w-4 h-4 text-neutrals-900" />
    </button>
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
