<script setup>
import { BaseIcon } from "@components/common/icons";
const props = defineProps({
  color: { type: String, default: 'text-neutrals-900' },
  active: { type: Boolean, default: false },
});
</script>

<template>
  <BaseIcon
    viewBox="0 0 21 20"
    width="20"
    :active="active"
    :className="props.color"
  >
    <template #default="{ fill }">
      <g clip-path="url(#clip0_28_1817)">
        <path
          d="M10.5026 20.0001C5.16328 20.0001 0.835938 15.6727 0.835938 10.3334C0.835938 4.99409 5.16328 0.666748 10.5026 0.666748C15.8419 0.666748 20.1693 4.99409 20.1693 10.3334C20.1693 15.6727 15.8419 20.0001 10.5026 20.0001ZM9.59635 10.3334C9.59635 10.6355 9.7474 10.9187 10.0004 11.0546L13.6254 13.4713C14.0408 13.7809 14.6034 13.6677 14.8488 13.2523C15.1585 12.8369 15.0452 12.2743 14.6298 11.9949L11.4089 9.85008V5.198C11.4089 4.69578 11.0048 4.29175 10.4686 4.29175C10.0004 4.29175 9.56237 4.69578 9.56237 5.198L9.59635 10.3334Z"
          :fill="fill"
        />
      </g>
      <defs>
        <clipPath id="clip0_28_1817">
          <rect
            width="20"
            height="20"
            fill="white"
            transform="translate(0.167969)"
          />
        </clipPath>
      </defs>
    </template>
  </BaseIcon>
</template>

<style scoped></style>
