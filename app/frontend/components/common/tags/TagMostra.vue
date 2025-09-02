<script setup>
import { computed } from "vue";

const props = defineProps({
  variant: {
    type: String,
    required: true,
    default: "cinema-capacete",
  },
  text: {
    type: String,
    default: "TBD"
  },
  mode: {
    type: String,
    validator: (value) => ["filled", "outline"].includes(value),
    default: "filled",
  },
});

const displayText = computed(() => props.text?.trim() || "TBD");
</script>

<template>
  <span
    class="tag-base"
    :class="[`tag-${variant}`, `tag-${mode}`]"
    role="label"
    :aria-label="`${variant} tag`"
  >
    {{ displayText }}
  </span>
</template>

<style scoped>
/* Base tag styles */
/* tag_base.css */

/* Variant color definitions using CSS custom properties */
.tag-gala-abertura {
  --tag-bg: var(--color-magenta-600);
  --tag-text: var(--color-white-transp-1000);
  --tag-border: var(--color-magenta-600);
}

.tag-gala-encerramento {
  --tag-bg: var(--color-magenta-800);
  --tag-text: #ffffff;
  --tag-border: var(--color-magenta-800);
}

.tag-resistencias {
  --tag-bg: var(--color-white-transp-1000);
  --tag-text: var(--color-neutrals-900);
  --tag-border: var(--color-white-transp-1000);
}

.tag-cine-memoria {
  --tag-bg: var(--color-violeta-200);
  --tag-text: var(--color-neutrals-900);
  --tag-border: var(--color-violeta-200);
}

.tag-midnight-movies {
  --tag-bg: var(--color-violeta-600);
  --tag-text: var(--color-white-transp-1000);
  --tag-border: var(--color-violeta-600);
}

.tag-cinema-capacete {
  --tag-bg: var(--color-neutrals-400);
  --tag-text: var(--color-neutrals-900);
  --tag-border: var(--color-neutrals-400);
}

.tag-classicos--cults {
  --tag-bg: var(--color-neutrals-900);
  --tag-text: var(--color-white-transp-1000);
  --tag-border: var(--color-neutrals-900);
}

.tag-expectativas {
  --tag-bg: var(--color-azul-600);
  --tag-text: var(--color-white-transp-1000);
  --tag-border: var(--color-azul-600);
}

.tag-itinerarios-unicos {
  --tag-bg: var(--color-verde-600);
  --tag-text: var(--color-white-transp-1000);
  --tag-border: var(--color-verde-600);
}

.tag-panorama-mundial {
  --tag-bg: var(--color-vermelho-600);
  --tag-text: var(--color-white-transp-1000);
  --tag-border: var(--color-vermelho-600);
}

.tag-premiere-latina {
  --tag-bg: var(--color-amarelo-800);
  --tag-text: var(--color-neutrals-900);
  --tag-border: var(--color-amarelo-800);
}

.tag-premiere-brasil {
  --tag-bg: var(--color-laranja-600);
  --tag-text: var(--color-neutrals-900);
  --tag-border: var(--color-laranja-600);
}

/* Mode styles using custom properties */
.tag-filled {
  background-color: var(--tag-bg, var(--color-magenta-600));
  color: var(--tag-text, var(--color-white-transp-1000));
}

.tag-outline {
  border-left: 4px solid var(--tag-border, var(--color-magenta-600));
  color: var(--color-neutrals-900);
  background-color: transparent;
}

/* Default fallback for unknown variants */
.tag-base:not([class*="tag-gala"]):not([class*="tag-resistencias"]):not([class*="tag-cine"]):not([class*="tag-midnight"]):not([class*="tag-cinema"]):not([class*="tag-classicos"]):not([class*="tag-expectativas"]):not([class*="tag-itinerarios"]):not([class*="tag-panorama"]):not([class*="tag-premiere"]) {
  --tag-bg: var(--color-magenta-600);
  --tag-text: var(--color-white-transp-1000);
  --tag-border: var(--color-magenta-600);
}
</style>
