<script setup>
const props = defineProps({
  cartaz: { type: String, required: true },
  descricao: { type: String, required: true}
})
</script>

<template>
  <li>
    <img :src="props.cartaz" :alt="`Poster do Festival de ${props.descricao}`">
    <p class="p-400">
      {{ props.descricao }}
      <!-- <hr> -->
    </p>
  </li>
</template>

<style scoped>
  li {
    position: relative;
  }

  li::after {
    position: absolute;
    content:"";
    height:100%;
    width:100%;
    top:0;
    left:0;
    background: linear-gradient(180deg, rgba(0, 0, 0, 0.30) 73.08%, rgba(0, 0, 0, 0.64) 100%);
  }

  p {
    position: absolute;
    bottom: 0;
    left: 0;
    color: white;
    z-index: 1;
    width: 100%;
  }

  img {
    width: 100%;
    height: auto;
  }

  /* hr {
    visibility: hidden;
    transition: visibility 0.2s ease, margin-top .3s ease
  }

  li:hover hr {
    visibility: visible;
    margin-top: 1rem;
  } */
</style>
