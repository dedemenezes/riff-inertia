<script setup>
import BaseIcon from "@/components/common/icons/BaseIcon.vue";
const props = defineProps({
  color: { type: String, default: undefined },
  active: { type: Boolean, default: false },
});
</script>

<template>
  <BaseIcon viewBox="0 0 21 20" :active="active" :className="props.color">
    <template #default="{ fill }">
      <path
        d="M10 18C10 18 16 11.9586 16 7.375C16 5.68425 15.3679 4.06274 14.2426 2.86719C13.1174 1.67165 11.5913 1 10 1C8.4087 1 6.88258 1.67165 5.75736 2.86719C4.63214 4.06274 4 5.68425 4 7.375C4 11.9586 10 18 10 18ZM10 10.5625C9.20435 10.5625 8.44129 10.2267 7.87868 9.6289C7.31607 9.03113 7 8.22038 7 7.375C7 6.52962 7.31607 5.71887 7.87868 5.1211C8.44129 4.52332 9.20435 4.1875 10 4.1875C10.7956 4.1875 11.5587 4.52332 12.1213 5.1211C12.6839 5.71887 13 6.52962 13 7.375C13 8.22038 12.6839 9.03113 12.1213 9.6289C11.5587 10.2267 10.7956 10.5625 10 10.5625Z"
        :fill="fill"
      />
    </template>
  </BaseIcon>
</template>

<style scoped></style>
