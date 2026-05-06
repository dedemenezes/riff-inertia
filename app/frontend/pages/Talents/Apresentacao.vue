<script setup>
import JuriCard from "@/components/common/cards/JuriCard.vue";
import SectionHeader from "@/components/common/SectionHeader.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import TalentsLayout from "@/pages/Talents/TalentsLayout.vue";

defineOptions({ layout: TalentsLayout });

defineProps({
  sections: { type: Array, required: false, default: () => [] },
});
</script>

<template>
  <TwContainer>
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
