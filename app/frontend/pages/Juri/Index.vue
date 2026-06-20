<script setup>
import { computed, ref } from "vue";
import { Head } from "@inertiajs/vue3";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import JuriCard from "@/components/common/cards/JuriCard.vue";
import { IconFilter } from "@/components/common/icons";
import IconArrowDown from "@/components/common/icons/navigation/IconArrowDown.vue";
import SearchBar from "@/components/features/filters/SearchBar.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";

const props = defineProps({
  titulo: { type: String, required: true },
  activePage: { type: String, required: true },
  crumbs: { type: Array, default: () => [] },
  sections: { type: Array, default: () => [] },
});

const selectedSectionId = ref(props.sections[0]?.id || "");
const searchText = ref("");
const sortDir = ref(null);

const selectedSection = computed(() =>
  props.sections.find((section) => section.id === selectedSectionId.value) || props.sections[0],
);

const normalizedSearchText = computed(() => searchText.value.trim().toLowerCase());

const visibleJurors = computed(() => {
  const jurors = selectedSection.value?.jurors || [];
  const filteredJurors = normalizedSearchText.value
    ? jurors.filter((juror) => {
      const bio = Array.isArray(juror.bio) ? juror.bio.join(" ") : juror.bio || "";
      return [ juror.name, juror.role, bio ].some((value) =>
        value?.toLowerCase().includes(normalizedSearchText.value),
      );
    })
    : jurors;

  if (!sortDir.value) return filteredJurors;

  return [ ...filteredJurors ].sort((a, b) => {
    const direction = sortDir.value === "asc" ? 1 : -1;
    return a.name.localeCompare(b.name) * direction;
  });
});

const selectSection = (section) => {
  selectedSectionId.value = section.id;
};

const toggleSort = () => {
  sortDir.value = sortDir.value === "asc" ? "desc" : "asc";
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
        data-test="juri-filter-bar"
        class="flex flex-col gap-400 py-600"
      >
        <SearchBar
          v-model="searchText"
          @clear="searchText = ''"
        />

        <div class="flex h-[35px] items-center justify-between">
          <button
            type="button"
            data-test="juri-sort-button"
            class="flex cursor-pointer items-center gap-200 rounded-100 p-100 text-body-strong-sm text-primary"
            @click="toggleSort"
          >
            <IconArrowDown
              :className="sortDir === 'desc' ? 'up text-primary' : 'text-primary'"
              :size="14"
            />
            {{ sortDir === "desc" ? "Z - A" : "A - Z" }}
          </button>

          <button
            type="button"
            data-test="juri-filter-button"
            class="flex cursor-pointer items-center gap-200 rounded-100 p-100 text-body-strong-sm text-primary"
          >
            <IconFilter color="text-primary" />
            Filtros
          </button>
        </div>
      </div>

      <nav
        v-if="props.sections.length"
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
            v-for="juror in visibleJurors"
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
