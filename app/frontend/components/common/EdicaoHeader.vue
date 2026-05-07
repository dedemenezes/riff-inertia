<script setup>
import { router } from "@inertiajs/vue3";
import { onBeforeUnmount, onMounted, ref } from "vue";
import PhotoSwipeLightbox from "photoswipe/lightbox";
import "photoswipe/dist/photoswipe.css";
import ButtonText from "@/components/common/buttons/ButtonText.vue";
import IconChevronLeft from "@/components/common/icons/navigation/IconChevronLeft.vue";

const props = defineProps({
  edicao: { type: Object, required: true },
  fallBackUrl: { type: String, required: true },
});

const goBack = () => {
  window.history.state?.url ? router.back() : router.visit(props.fallBackUrl);
};

const cartazDims = ref(null);

const onCartazLoad = (e) => {
  cartazDims.value = {
    width: e.target.naturalWidth,
    height: e.target.naturalHeight,
  };
};

const lightbox = new PhotoSwipeLightbox({
  gallery: "#edicao-header-cartaz",
  children: "a",
  pswpModule: () => import("photoswipe"),
});

onMounted(() => lightbox.init());
onBeforeUnmount(() => lightbox.destroy());
</script>

<template>
  <div class="flex items-center justify-between py-300">
    <ButtonText tag="button" text="Voltar" @click="goBack">
      <template #icon>
        <IconChevronLeft width="16" height="16" class="mr-200" />
      </template>
    </ButtonText>

    <div id="edicao-header-cartaz" class="flex items-end gap-800 pt-600">
      <p class="text-header-xl text-neutrals-900">
        {{ props.edicao.descricao }}
      </p>
      <a
        v-if="props.edicao.cartazURL"
        :href="props.edicao.cartazURL"
        :data-pswp-width="cartazDims?.width"
        :data-pswp-height="cartazDims?.height"
        class="cursor-zoom-in outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
      >
        <img
          :src="props.edicao.cartazURL"
          :alt="`Cartaz ${props.edicao.descricao}`"
          class="h-[98px] w-[68px] object-cover rounded-100 pointer-events-none"
          @load="onCartazLoad"
        />
      </a>
    </div>
  </div>
</template>
