<script setup>
import { computed, ref } from "vue";
import { Head } from "@inertiajs/vue3";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import JuriCard from "@/components/common/cards/JuriCard.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  titulo: { type: String, required: true },
  activePage: { type: String, required: true },
  crumbs: { type: Array, default: () => [] },
  sections: { type: Array, default: () => [] },
});

const selectedSectionId = ref(props.sections[0]?.id || "");

const selectedSection = computed(() =>
  props.sections.find((section) => section.id === selectedSectionId.value) || props.sections[0],
);

const selectSection = (section) => {
  selectedSectionId.value = section.id;
};
</script>

<template>
  <Head>
    <title>{{ props.titulo }} - Festival do Rio</title>
  </Head>

  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
  </TwContainer>

  <MenuContext nav="edicao" :active-page="props.activePage" />
  <hr class="text-neutrals-300" />

  <TwContainer>
    <section class="flex flex-col gap-1200 py-1200">
      <nav
        v-if="props.sections.length"
        role="tablist"
        class="mx-auto flex w-full max-w-[940px] items-center gap-300 px-400"
      >
        <button
          v-for="section in props.sections"
          :id="`juri-tab-${section.id}`"
          :key="section.id"
          type="button"
          role="tab"
          :aria-controls="`juri-panel-${section.id}`"
          :aria-selected="selectedSection?.id === section.id"
          class="flex-1 cursor-pointer border-b pb-150 pt-150 text-body-strong-sm uppercase"
          :class="selectedSection?.id === section.id ? 'border-magenta-600 text-primary' : 'border-neutrals-300 text-neutrals-700'"
          @click="selectSection(section)"
        >
          {{ section.tab_label }}
        </button>
      </nav>

      <section
        v-if="selectedSection"
        :id="`juri-panel-${selectedSection.id}`"
        role="tabpanel"
        :aria-labelledby="`juri-tab-${selectedSection.id}`"
        class="flex flex-col gap-800"
      >
        <h1 class="text-header-lg text-primary">
          {{ selectedSection.tab_label }}
        </h1>

        <ul class="grid grid-cols-1 gap-800 lg:grid-cols-2">
          <li
            v-for="juror in selectedSection.jurors"
            :key="juror.name"
            class="min-w-0"
          >
            <JuriCard
              :photo="juror.photo"
              :name="juror.name"
              :role="juror.role"
              :bio="juror.bio"
            />
          </li>
        </ul>
      </section>
    </section>
  </TwContainer>
</template>
