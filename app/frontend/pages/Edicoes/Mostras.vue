<script setup>
import EdicaoHeader from "@/components/common/EdicaoHeader.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import { Link } from "@inertiajs/vue3";
defineProps({
  edicao: {
    type: Object,
    required: true,
  },
  categorias: {
    type: Array,
    required: true,
  },
});
</script>
<template>
  <TwContainer>
    <EdicaoHeader :edicao="edicao" />
  </TwContainer>
  <MenuContext nav="edicoes_anteriores" active-page="Mostras" />
  <hr class="text-neutrals-300" />
  <TwContainer>
    <ul class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 py-1200 gap-800">
      <Link v-for="categoria in categorias" :href="categoria.path">
        <li
          :class="`border-s-30 border-${categoria.class} rounded-lg overflow-hidden lg:h-[320px] h-[206px]`"
        >
          <figure class="relative m-0 h-full p-600 flex flex-col justify-end">
            <!-- src="https://s3.amazonaws.com/festivaldorio/2024/site/peliculas/original/mals_f01cor_2024113147.jpg" -->
            <img
              class="absolute inset-0 w-full h-full object-cover -z-1"
              :src="categoria.mostraImageURL"
              :alt="categoria.name"
            />
            <h1
              class="text-white-transp-1000 mt-max text-header-regular-md z-1"
            >
              {{ categoria.name }}
            </h1>
          </figure>
        </li>
      </Link>
    </ul>
  </TwContainer>
</template>
<style scoped>
figure::after {
  position: absolute;
  content: "";
  height: 100%;
  width: 100%;
  top: 0;
  left: 0;
  background: linear-gradient(
    180deg,
    rgba(0, 0, 0, 0.3) 73.08%,
    rgba(0, 0, 0, 0.64) 100%
  );
}
</style>
