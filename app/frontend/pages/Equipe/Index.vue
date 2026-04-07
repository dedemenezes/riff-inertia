<script setup>
import { computed } from "vue";
import { Head, usePage } from "@inertiajs/vue3";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";

const page = usePage();

const props = defineProps({
  intro_blocks: { type: Array, required: true },
  sections: { type: Array, required: true },
  crumbs: { type: Array, required: true },
});

const editionTeamLabel = computed(() => {
  const main = page.props.mainItems;
  if (!main || typeof main !== "object") return "";
  for (const subItems of Object.values(main)) {
    if (!Array.isArray(subItems)) continue;
    const item = subItems.find((entry) => {
      const p = entry?.path;
      return typeof p === "string" && p.replace(/\/$/, "").endsWith("/equipe");
    });
    if (item?.name) return item.name;
  }
  return "";
});
</script>

<template>
  <Head :title="editionTeamLabel" />
  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
  </TwContainer>

  <MenuContext nav="edicao" :active-page="editionTeamLabel" />

  <hr class="text-neutrals-300" />

  <TwContainer>
    <div class="flex flex-col gap-1200 py-1200">
      <div
        class="grid grid-cols-1 gap-x-800 gap-y-800 md:grid-cols-2"
      >
        <div
          v-for="(block, index) in props.intro_blocks"
          :key="`intro-${index}`"
          class="flex min-w-0 flex-col gap-150"
        >
          <p class="text-body-strong-sm text-primary max-w-[20.75rem]">
            {{ block.title }}
          </p>
          <div class="text-body-regular text-primary">
            <p
              v-for="(line, lineIndex) in block.names"
              :key="lineIndex"
              class="whitespace-pre-wrap leading-[150%]"
            >
              {{ line }}
            </p>
          </div>
        </div>
      </div>

      <section
        v-for="(section, sIndex) in props.sections"
        :key="`section-${sIndex}`"
        class="flex flex-col gap-800"
      >
        <h2
          class="border-b border-solid border-magenta-600 pb-150 text-header-base text-xl text-primary"
        >
          {{ section.title }}
        </h2>
        <div
          class="grid grid-cols-1 gap-x-800 gap-y-800 md:grid-cols-2"
        >
          <div
            v-for="(block, bIndex) in section.blocks"
            :key="`${sIndex}-${bIndex}`"
            class="flex min-w-0 flex-col gap-150"
          >
            <p class="text-body-strong-sm text-primary max-w-[20.75rem]">
              {{ block.title }}
            </p>
            <div class="text-body-regular text-primary">
              <p
                v-for="(line, lineIndex) in block.names"
                :key="lineIndex"
                class="whitespace-pre-wrap leading-[150%]"
              >
                {{ line }}
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  </TwContainer>
</template>
