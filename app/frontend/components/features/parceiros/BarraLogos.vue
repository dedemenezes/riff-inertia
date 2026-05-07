<script setup>
import shellLogo from "@assets/images/parceiros/shell.webp";
import visitrioLogo from "@assets/images/parceiros/visitrio.webp";
import cinemaDoRioLogo from "@assets/images/parceiros/cinemadorio.webp";
import governoFedLogo from "@assets/images/parceiros/governofed.webp";
import leiRouanetLogo from "@assets/images/parceiros/leirouanet.webp";
import apoioBlocLogo from "@assets/images/parceiros/apoio-bloc.webp";
</script>

<template>
  <section class="w-full flex flex-col gap-0">
    <div class="flex flex-col md:flex-row gap-0">
      <div
        class="flex-1 bg-white border-t border-neutrals-300 flex flex-col gap-400 h-[124px] items-start justify-center pl-800 lg:pl-[150px] py-600"
      >
        <p
          class="text-[10px] font-medium tracking-[1.5px] uppercase text-neutrals-700"
        >
          Incentivo
        </p>
        <img
          :src="leiRouanetLogo"
          alt="Lei Rouanet — Fundo Nacional de Cultura"
          class="h-[52px] w-auto object-contain"
        />
      </div>

      <div
        class="flex-1 bg-white border-t border-l border-neutrals-300 flex flex-col gap-400 h-[124px] items-start justify-center pl-800 py-600"
      >
        <p
          class="text-[10px] font-medium tracking-[1.5px] uppercase text-neutrals-700"
        >
          Patrocínio Master
        </p>
        <img
          :src="shellLogo"
          alt="Shell"
          class="h-[52px] w-auto object-contain"
        />
      </div>

      <div
        class="flex-1 bg-white border-t border-l border-neutrals-300 flex flex-col gap-400 h-[124px] items-start justify-center pl-800 py-600"
      >
        <p
          class="text-[10px] font-medium tracking-[1.5px] uppercase text-neutrals-700"
        >
          Apoio Especial
        </p>
        <div class="flex gap-800 items-center">
          <img
            :src="apoioBlocLogo"
            alt="RioFilme — Prefeitura do Rio Secretaria Municipal de Cultura"
            class="h-[52px] w-auto object-contain"
          />
          <img
            :src="visitrioLogo"
            alt="Visit.Rio"
            class="h-[32px] w-auto object-contain"
          />
        </div>
      </div>
    </div>

    <div
      class="bg-white border-t border-b border-neutrals-300 flex flex-col gap-400 h-[124px] items-start justify-center pl-800 lg:pl-[150px] py-600 w-full"
    >
      <p
        class="text-[10px] font-medium tracking-[1.5px] uppercase text-neutrals-700"
      >
        Realização
      </p>
      <div class="flex gap-400 h-[52px] items-center">
        <img
          :src="cinemaDoRioLogo"
          alt="Cinema do Rio"
          class="h-[44px] w-auto object-contain"
        />
        <img
          :src="governoFedLogo"
          alt="Governo Federal — União e Reconstrução"
          class="h-[44px] w-auto object-contain"
        />
      </div>
    </div>
  </section>
</template>
