<script setup>
import NavButtonContext from "@components/common/buttons/NavButtonContext.vue";
const props = defineProps({
  text: { type: String },
})
const items = [
  { name: "programming", route: "/programacao", component: IconProgram },
  { name: "sessoes_com_convidados", route: "/", component: IconNewUser },
  { name: "mudancas_na_programacao", route: "/", component: IconChange },
  { name: "sessoes_ao_ar_livre", route: "/", component: IconClock },
];

import { IconProgram, IconClock, IconChange, IconNewUser } from "@components/common/icons";


</script>

<template>
  <div
    class="flex gap-800 px-400 py-200 lg:gap-1600 lg:py-800 lg:justify-center overflow-x-auto"
  >
    <NavButtonContext
      v-for="item in items"
      :key="item"
      class="flex-shrink-0"
      :content="item.name"
      :route="item.route"
    >
      <template #icon="{ active }">
        <component
          :is="item.component"
          height="30px"
          width="30px"
          :active="active"
        />
      </template>
    </NavButtonContext>
  </div>
</template>

<style scoped></style>
