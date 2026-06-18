<script setup>
import { Head, Link } from "@inertiajs/vue3";
import TwContainer from "@/components/layout/TwContainer.vue";
import IngressosLayout from "@/pages/Ingressos/IngressosLayout.vue";

defineOptions({ layout: IngressosLayout });

const props = defineProps({
  titulo: { type: String, default: "" },
  descricao: { type: String, default: "" },
  cta: { type: String, default: "" },
  programPath: { type: String, required: true },
});
</script>

<template>
  <Head>
    <title>{{ props.titulo }}</title>
  </Head>

  <TwContainer>
    <section class="flex flex-col gap-800 max-w-[1428px] py-1200">
      <div class="flex flex-col gap-150">
        <h1 class="text-header-lg text-neutrals-900">
          {{ props.titulo }}
        </h1>
        <div class="h-px bg-gradient-to-r from-magenta-600 to-laranja-600"></div>
      </div>

      <div class="flex flex-col gap-600 max-w-[940px]">
        <p class="text-body-regular-lg leading-[2] text-neutrals-900">
          {{ props.descricao }}
        </p>

        <Link
          :href="props.programPath"
          class="font-body inline-flex w-fit items-center justify-center rounded-lg bg-neutrals-900 px-400 py-400 text-md font-semibold leading-[22.4px] text-white-transp-1000 transition duration-200 hover:bg-neutrals-800 focus:outline-2 focus:outline-offset-2 focus:outline-neutrals-900"
        >
          {{ props.cta }}
        </Link>
      </div>
    </section>
  </TwContainer>
</template>
