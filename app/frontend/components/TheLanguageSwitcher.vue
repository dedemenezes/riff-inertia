<script setup>
import { computed } from 'vue'
import { usePage } from '@inertiajs/vue3'

const LANGUAGES = [
  { code: 'en', name: 'English' },
  { code: 'pt', name: 'Portuguese' }
]

const page = usePage()

const currentLocale = computed(() => {
  // locale from ApplicationController
  return page.props.currentLocale ||
         document.documentElement.lang ||
         'pt'
})

const switchLanguage = (targetLocale) => {
  if (targetLocale === currentLocale.value) return

  const newPath = window.location.pathname.replace(new RegExp("/(pt|en)"), `/${targetLocale}`)
  window.location.href = newPath
}

const isCurrentLanguage = (languageCode) => languageCode === currentLocale.value

</script>

<template>
  <div
    class="flex items-center gap-400 text-neutrals-700"
    role="radiogroup"
    aria-label="Language selection"
  >
    <template v-for="(language, index) in LANGUAGES" :key="language.code">
      <button
        type="button"
        role="radio"
        :aria-checked="isCurrentLanguage(language.code)"
        :aria-label="`Switch to ${language.name}`"
        :class="[
          'text-body-strong-sm uppercase cursor-pointer transition-colors',
          'hover:text-neutrals-800 focus:outline-none focus:text-neutrals-900',
          isCurrentLanguage(language.code)
            ? 'text-neutrals-900'
            : 'text-neutrals-700'
        ]"
        @click="switchLanguage(language.code)"
      >
        {{ language.code.toUpperCase() }}
      </button>

      <img
        v-if="index < LANGUAGES.length - 1"
        src="@assets/icons/divisor.svg"
        alt=""
        aria-hidden="true"
        class="select-none"
      />
    </template>
  </div>
</template>
