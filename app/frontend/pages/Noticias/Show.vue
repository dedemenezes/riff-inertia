<script setup>
import TwContainer from "@components/layout/TwContainer.vue"
import { IconLink } from "@components/common/icons";
import { ButtonText } from "@components/common/buttons"
import { ref, computed } from "vue";
import Breadcrumb from "@components/common/Breadcrumb.vue";
import NewsletterCard from "../../components/common/cards/NewsletterCard.vue";

const props = defineProps({
  conteudo: { type: String, required: true, default: '' },
  titulo: { type: String, required: true, default: '' },
  chamada: { type: String, required: true, default: '' },
  breadcrumbs: { type: Array, default: () => []}
})

const copyURL = () => {
  const url = window.location.href; // Get the current URL

  // Use the Clipboard API to copy the URL to the clipboard
  navigator.clipboard.writeText(url).then(() => {
    alert('URL copied to clipboard!'); // Show success message
  }).catch(err => {
    console.error('Failed to copy URL: ', err);
    alert('Failed to copy URL!');
  });
}

const isHovered = ref(false);
const handleMouseEnter = () => {
  isHovered.value = true;
};
const handleMouseLeave = () => {
  isHovered.value = false;
};

const isFocused = ref(false);
const handleFocus = () => {
  isFocused.value = true;
};
const handleBlur = () => {
  isFocused.value = false;
};

const isActive = computed(() => isHovered.value || isFocused.value);

// const currentRoute = useRoute();
// const isRouteActive = computed(() => currentRoute.path == props.route);
const isIconActive = computed(() => isActive.value);

</script>

<template>
  <TwContainer>
    <Breadcrumb  :crumbs="props.breadcrumbs"/>
    <div class="">
      <div class="flex flex-col gap-600 mb-800">
        <h1 class="text-header-lg">{{ props.titulo }}</h1>
        <p class="text-body-regular-lg">{{ props.chamada }}</p>
        <p class="flex items-center gap-[8px] text-overline text-neutrals-900"><span class="date">22.07.25</span> <img style="height: 16px;" src="@assets/icons/divisor.svg" alt="Divisor"> <span class="caderno">ESTREIA DA SEMANA</span></p>
        <ButtonText
          @click="copyURL"
          tag="button"
          text="Copiar URL"
          variant="dark"
          size="sm"
          class="cursor-pointer hover:text-neutrals-700"
          font-weight="font-regular"
          @mouseenter="handleMouseEnter"
          @mouseleave="handleMouseLeave"
          @focus="handleFocus"
          @blur="handleBlur"
        >
          <template v-slot:icon>
            <IconLink :active="isIconActive" class="me-100" />
          </template>
        </ButtonText>
      </div>
      <div v-html="props.conteudo" class="content text-justify text-neutrals-900"></div>
    </div>
    <NewsletterCard />
  </TwContainer>
</template>

<style scoped>
::v-deep .content p, ::v-deep .content span, ::v-deep .content b {
  /* Body/Regular/Body Double Space Regular medium */
  font-family: "Inter" !important;
  font-size: 16px !important;
  font-style: normal !important;
  font-weight: 400 !important;
  line-height: 200% !important; /* 32px */
}

::v-deep .content p:not(:empty):not(:has(img)) {
  margin-bottom: 1.5rem;
}

::v-deep .content b {
  font-weight: 600 !important;
}

::v-deep .content a {
  text-decoration: underline !important;
}

::v-deep .content a:hover {
  color: var(--color-vermelho-400) !important; /* Using the custom variable */
}

::v-deep .content img {
  width: 100% !important;
  border-radius: 8px;
  object-fit: cover;
}

::v-deep .content img + br + i:not(:empty), ::v-deep .content i > span, ::v-deep .content span > i  {
  /* Body/Regular/Body Regular small */
  font-family: "Inter" !important;
  font-size: 14px !important;
  font-style: normal !important;
  font-weight: 400 !important;
  line-height: 150% !important; /* 21px */
  color: #3B3935 !important;
}

::v-deep p:has(i) {
  margin-bottom: 1rem;
}

::v-deep br {
  display: none;
}

::v-deep .content li > span:has(b) {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: .5rem;
}

::v-deep .content li > span b {
  background: linear-gradient(to right, #FF007F, #FF7F00);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  color: transparent;
  transition: background 0.3s ease;
}
</style>
