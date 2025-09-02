<script setup>
import { ref, onMounted } from 'vue';
import { Inertia } from '@inertiajs/inertia';

const availableLanguages = [
  { code: 'en', name: 'English' },
  { code: 'pt', name: 'Portuguese' },
];

const currentLanguage = ref(''); // This will be dynamic based on the current locale

const switchLanguage = (languageCode) => {
  // Construct the new URL by replacing the language code in the current URL
  const newUrl = window.location.pathname.replace(/^\/[a-z]{2}/, `/${languageCode}`);

  // Update the currentLanguage to reflect the new language
  currentLanguage.value = languageCode;

  // Navigate to the new URL with the selected language
  Inertia.visit(newUrl, { preserveState: true });
};

onMounted(() => {
  const pathLang = window.location.pathname.split('/')[1]; // Get the language code from the URL
  currentLanguage.value = pathLang || 'pt'; // Set it to the current language or default to 'pt'
});
</script>

<template>
  <div
    class="languages flex items-center gap-400 text-neutrals-700"
    aria-label="language selection"
  >
    <template v-for="language in availableLanguages" :key="language.code">
      <button
        :class="[
          'text-body-strong-sm uppercase cursor-pointer',
          { 'text-neutrals-900': language.code === currentLanguage },
        ]"
        @click="switchLanguage(language.code)"
        :aria-label="`Alterar para ${language.name}`"
        :aria-pressed="language.code === currentLanguage"
      >
        {{ language.code.toUpperCase() }}
      </button>
      <img
        v-if="language.code !== availableLanguages.at(-1).code"
        src="@assets/icons/divisor.svg"
        alt="Divisor"
        aria-hidden="true"
      />
    </template>
  </div>
</template>
