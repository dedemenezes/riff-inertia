<script setup>
import { computed } from "vue";
import { IconSearch, IconClose } from "@/components/common/icons";
import { simpleTranslation } from "@/lib/utils";

const props = defineProps({
  modelValue: String,
});

const emit = defineEmits(["update:modelValue", "search", "clear", "input"]);

let debounceTimeout = null
const handleInput = (event) => {
  const content = event.target.value
  clearTimeout(debounceTimeout)

  emit("input", event.target.value)

  debounceTimeout = setTimeout(() => {
    emit("update:modelValue", content)
  }, 300)
};

const cleanInput = () => {
  emit("update:modelValue", null);
  emit("clear");
};
const showClearButton = computed(() => props.modelValue && props.modelValue.length > 0)
const activeSearchIcon = computed(() => props.modelValue && props.modelValue.length > 0)
</script>

<template>
  <div class="input w-full mb-0 lg:flex-grow">
    <div class="relative">
      <div
        class="absolute inset-y-0 left-0 pl-3 flex items-center"
      >
        <IconSearch
          :color="activeSearchIcon ? 'text-neutrals-900 z-10 cursor-pointer' : 'text-neutrals-400' "
          @click="emit('search', props.modelValue)"
        />
      </div>
      <input
        :value="props.modelValue"
        @input="handleInput"
        @keyup.enter="emit('search', props.modelValue)"
        type="text"
        :placeholder="simpleTranslation('Pesquisar', 'Search')"
        class="w-full pl-10 pr-8 py-2.5 border border-neutrals-300 rounded-[5px] font-body leading-[150%] text-sm text-neutrals-900 placeholder-neutrals-400 focus:outline-none focus:border-neutrals-600 disabled:bg-neutrals-300 disabled:placeholder-neutrals-600 disabled:text-neutrals-600 disabled:border-neutrals-300 disabled:shadow-none transition-all duration-200"
      />
      <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
        <button v-if="showClearButton" class="cursor-pointer" @click="cleanInput" :aria-label="'Clear search'">
          <IconClose />
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
