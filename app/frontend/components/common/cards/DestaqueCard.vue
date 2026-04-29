<script setup>
defineProps({
  titulo: { type: String, required: true },
  imagem: { type: String, required: true },
  url: { type: String, required: true },
  destino: { type: String, default: "_self" },
});
</script>

<template>
  <div class="flex flex-col gap-y-200">
    <a :href="url" :target="destino" rel="noopener noreferrer">
      <img
        :src="imagem"
        :alt="titulo"
        class="aspect-video w-full object-cover rounded-200"
      />
    </a>
    <h3 class="text-header-sm text-primary">
      <a :href="url" :target="destino" rel="noopener noreferrer">
        {{ titulo }}
      </a>
    </h3>
  </div>
</template>
