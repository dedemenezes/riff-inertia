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

  <section>
    <TwContainer>
      <div
        v-if="props.sections.length"
        data-test="juri-tabs-block"
        class="pt-600 lg:pt-1200"
      >
        <nav
          role="tablist"
          class="mx-auto flex h-[32px] w-full max-w-[940px] items-center gap-300 overflow-x-auto no-scroll-bar"
        >
          <button
            v-for="section in props.sections"
            :id="`juri-tab-${section.id}`"
            :key="section.id"
            type="button"
            role="tab"
            :aria-controls="`juri-panel-${section.id}`"
            :aria-selected="selectedSection?.id === section.id"
            class="flex h-full min-w-fit flex-1 cursor-pointer items-center justify-center border-b text-body-strong-sm uppercase"
            :class="selectedSection?.id === section.id ? 'border-magenta-600 text-primary' : 'border-neutrals-300 text-neutrals-700'"
            @click="selectSection(section)"
          >
            {{ section.tab_label }}
          </button>
        </nav>
      </div>
    </TwContainer>

    <div
      v-if="selectedSection"
      data-test="juri-title-block"
      class="border-neutrals-300 py-400"
    >
      <TwContainer>
        <div class="py-400">
          <h1 class="text-header-lg text-primary">
            {{ selectedSection.tab_label }}
          </h1>
        </div>
      </TwContainer>
    </div>

    <TwContainer>
      <section
        v-if="selectedSection"
        :id="`juri-panel-${selectedSection.id}`"
        role="tabpanel"
        :aria-labelledby="`juri-tab-${selectedSection.id}`"
      >
        <ul class="flex flex-col gap-800 py-0 lg:grid lg:grid-cols-2">
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
    </TwContainer>
  </section>
</template>
