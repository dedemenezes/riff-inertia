<script setup>
import { usePage } from "@inertiajs/vue3"
import { ref, watch } from "vue"
import IconClose from '@/components/common/icons/actions/IconClose.vue';
const page = usePage()

const flash = ref({ ...page.props.flash })

// Remove flash after timeout
const removeFlash = () => {
  console.log(flash.value);

  flash.value = {}
  console.log(flash.value);
}

watch(
  () => page.props.flash,
  (newFlash) => {
    flash.value = { ...newFlash }

    if (newFlash.success || newFlash.error) {
      setTimeout(() => {
        removeFlash()
      }, 5000) // ⏳ 5 seconds
    }
  },
  { immediate: true, deep: true }
)
</script>

<template>
    <!-- Flash messages -->
  <div v-if="flash.success" class="fixed bottom-200 right-200 bg-verde-200 text-verde-600 p-3 rounded mb-4 flex items-center gap-200">
    {{ flash.success }} <IconClose @click="removeFlash" color="text-neutrals-900 cursor-pointer" />
  </div>
  <div v-if="flash.error" class="fixed bottom-200 right-200 bg-vermelho-100 text-vermelho-400 p-3 rounded mb-4 flex items-center gap-200">
    {{ flash.error }} <IconClose @click="removeFlash" color="text-neutrals-900 cursor-pointer"/>
  </div>
</template>

<style scoped></style>
