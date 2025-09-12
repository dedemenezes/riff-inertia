<script setup>
import NavButtonContext from "@components/common/buttons/NavButtonContext.vue";
import { defineAsyncComponent, watchEffect } from 'vue'
import { usePage } from "@inertiajs/vue3"

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
</script>

<template>
  <div
    class="flex gap-600 px-400 py-200 lg:gap-1600 lg:py-800 lg:justify-center overflow-x-auto no-scroll-bar"
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
  </div>
</template>

<style scoped></style>
