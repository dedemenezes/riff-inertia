<script setup>
import JuriCard from "@/components/common/cards/JuriCard.vue";
import SectionHeader from "@/components/common/SectionHeader.vue";
import NavTab from "@/components/common/tabs/NavTab.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

defineProps({
  pagina: { type: Object, required: true },
  sections: { type: Array, required: false, default: () => [] },
  tabs: { type: Array, required: false, default: () => [] },
});
</script>

<template>
  <TwContainer>
    <div v-if="tabs.length" class="py-800">
      <nav
        aria-label="Talents sections"
        class="flex gap-300 items-center px-400 h-12"
      >
        <NavTab
          v-for="tab in tabs"
          :key="tab.label"
          :href="tab.href"
          :active="tab.active"
        >
          {{ tab.label }}
        </NavTab>
      </nav>
    </div>
    <div class="flex flex-col gap-1600 py-1600">
      <section
        v-for="section in sections"
        :key="section.titulo"
        class="flex flex-col gap-800"
      >
        <SectionHeader>{{ section.titulo }}</SectionHeader>
        <ul class="flex flex-col gap-600">
          <li
            v-for="(participante, index) in section.participantes"
            :key="participante.name + '_' + index"
          >
            <JuriCard
              :photo="participante.photo"
              :name="participante.name"
              :bio="participante.bio"
              bio-variant="double-spaced"
            />
          </li>
        </ul>
      </section>
    </div>
  </TwContainer>
</template>
