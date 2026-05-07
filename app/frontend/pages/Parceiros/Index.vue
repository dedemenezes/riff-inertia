<script setup>
import ParceirosLayout from "./ParceirosLayout.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import parceirosPoster from "@assets/images/parceiros-2025.webp";
</script>

<template>
  <ParceirosLayout>
    <TwContainer>
      <div class="flex justify-center pb-1200">
        <img
          :src="parceirosPoster"
          alt="Parceiros do Festival do Rio 2025"
          class="w-full max-w-[1428px] h-auto"
          width="1428"
          height="2046"
        />
      </div>
    </TwContainer>
  </ParceirosLayout>
</template>
