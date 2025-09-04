<script setup>
import Breadcrumb from '@/components/common/Breadcrumb.vue';
import TwContainer from '@/components/layout/TwContainer.vue';
import PagyPagination from '../PagyPagination.vue';
import NavbarSecondary from '@/components/layout/navbar/NavbarSecondary.vue';

const props = defineProps({
  mainItems: { type: Array },
  secondaryItems: { type: Array },
  breadcrumbs: { type: Array, default: () => []},
  noticias: { type: Array, default: () => []},
  currentUrl: { type: String, default: '/pt/noticias'},
  // searchQuery: { type: String, default: ''},
  pagy: { type: Object, required: true }
})

</script>

<template>
  <NavbarSecondary :mainItems="props.mainItems" :secondaryItems="props.secondaryItems" />
  <TwContainer>
    <Breadcrumb  :crumbs="props.breadcrumbs"/>
    <!-- Filtros -->

    <div class="grid grid-cols-12">
      <div class="col-span-12">
        <PagyPagination
          :noticias="props.noticias"
          :pagy="props.pagy"
          >
          <!-- :filters="props.filters" -->
        </PagyPagination>
      </div>
      <div class="hidden col-span-5 col-start-8">
        <p>Flamengo</p>
      </div>
    </div>
  </TwContainer>
</template>

<style scoped></style>
