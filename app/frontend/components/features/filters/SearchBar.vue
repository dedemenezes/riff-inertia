<script setup>
import { computed } from "vue";
import { IconSearch, IconClose } from "@/components/common/icons";

const props = defineProps({
  modelValue: String,
});

const emit = defineEmits(["update:modelValue", "search", "clear"]);

let debounceTimeout = null
const handleInput = (event) => {
  const content = event.target.value
  clearTimeout(debounceTimeout)

  debounceTimeout = setTimeout(() => {
    emit("update:modelValue", content)
  }, 300)
};

const cleanInput = () => {
  emit("update:modelValue", "");
  emit("clear");
};
const showClearButton = computed(() => props.modelValue && props.modelValue.length > 0)
</script>

<template>
  <div class="input">
    <div class="relative">
      <div
        class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none"
      >
        <IconSearch color="text-primary" />
      </div>
      <input
        :value="props.modelValue"
        @input="handleInput"
        @keyup.enter="emit('search', props.modelValue)"
        type="text"
        placeholder="Pesquisar"
        class="w-full md:w-96 pl-10 pr-8 py-2.5 border border-neutrals-300 rounded-[5px] font-body leading-[150%] text-sm text-neutrals-900 placeholder-neutrals-400 focus:outline-none focus:border-neutrals-600 disabled:bg-neutrals-300 disabled:placeholder-neutrals-600 disabled:text-neutrals-600 disabled:border-neutrals-300 disabled:shadow-none transition-all duration-200"
      />
      <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
        <button v-if="showClearButton" @click="cleanInput" :aria-label="'Clear search'">
          <IconClose />
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
