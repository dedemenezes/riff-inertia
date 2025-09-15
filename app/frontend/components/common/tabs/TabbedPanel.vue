<script setup>
const props = defineProps({
  tabs: { type: Array, required: true }, // [{ id: 'profile', label: 'Profile' }]
  modelValue: String
})

const emit = defineEmits(['update:modelValue'])

function select(tabId) {
  emit('update:modelValue', tabId)
}
</script>

<template>
  <nav role="tablist" class="bg-white-transp-1000 flex gap-300 overflow-x-auto no-scroll-bar py-3">
    <div class="w-full flex items-center justify-around md:justify-evenly">
      <button
        v-for="(tab, index) in props.tabs"
        :key="tab.id"
        @click="select(tab.id)"
        class="p-0"
      >
        <!-- Border gradient wrapper -->
        <div
          :class="[
            'pb-[2px]',
            modelValue === tab.id
              ? 'bg-gradient-to-r from-magenta-600 to-laranja-600'
              : 'bg-neutrals-200'
          ]"
        >
          <!-- Inner tab content -->
          <div
            class="bg-white px-[7.3px] lg:px-[33.3px] pt-[6px] flex items-center justify-center text-body-strong-sm uppercase"
            :class="modelValue === tab.id ? 'text-neutrals-900' : 'text-neutrals-700'"
          >
            {{ tab.label }}
          </div>
        </div>
      </button>

    </div>
  </nav>
</template>
