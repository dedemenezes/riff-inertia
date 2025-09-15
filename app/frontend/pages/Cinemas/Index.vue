<script setup>
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import SearchBar from "@/components/features/filters/SearchBar.vue";
import IconPin from "@/components/common/icons/misc/IconPin.vue";
import IconPhone from "@/components/common/icons/misc/IconPhone.vue";
import IconWholeTicket from "@/components/common/icons/misc/IconWholeTicket.vue";
import IconSeat from "@/components/common/icons/misc/IconSeat.vue";
import { reactive } from "vue";

const props = defineProps({
  cinemas: { type: Object, default: () => []},
  crumbs: { type: Array, required: true}
})

console.log(props.cinemas)

const cinemas = reactive([...props.cinemas])

const filterCinemas = (value) => {
  const v = value.trim().toLowerCase()
  const filtered = props.cinemas.filter(cinema =>
    cinema.name.toLowerCase().startsWith(v)
  )
  cinemas.splice(0, cinemas.length, ...filtered)
}
</script>

<template>
  <TwContainer>
    <Breadcrumb :crumbs="props.crumbs" />
  </TwContainer>
  <MenuContext
    nav="edicao"
  />

  <TwContainer
    class="grid grid-cols-1 lg:grid-cols-3 gap-800"
  >
    <SearchBar
      class="py-400"
      @input="filterCinemas"
    />
  </TwContainer>

  <hr class="text-neutrals-300">

  <TwContainer>
    <ul class="flex flex-col py-1200 gap-800">
      <li
        v-for="cinema in cinemas"

        class="flex flex-col gap-300"
      >
        <h2 class="text-header-medium-sm p-150 cinema-name">
          {{ cinema.name }}
        </h2>

        <div class="flex flex-col gap-50">
          <div class="flex gap-50 items-center">
            <IconWholeTicket
              active="True"
              height="16"
              width="16"
            />
            <!-- TODO: trocar o preço do ingresso -->
            <p>imagine o PREÇO DO INGRESSO aqui</p>
          </div>

          <div v-if="cinema.cinema.endereco" class="flex gap-50 items-center">
            <IconPin
              active="True"
              height="16"
              width="16"
            />
            <p>{{ cinema.cinema.endereco }}</p>
          </div>

          <div v-if="cinema.cinema.telefone" class="flex gap-50 items-center">
            <IconPhone
              active="True"
              height="16"
              width="16"
            />
            <p>{{ cinema.cinema.telefone }}</p>
          </div>

          <div class="flex flex-col gap-300">
            <div class="flex gap-50 items-center">
              <IconSeat
                active="True"
                height="16"
                width="16"
              />
              <p>Lotação: <span v-if="cinema.capacidade">{{ cinema.capacidade }}</span></p>
            </div>


            <li v-for="sala in cinema.salas" class="list-disc ms-400">
              {{ sala.nome }} — {{ sala.capacidade }}
            </li>
          </div>
        </div>
      </li>
    </ul>
  </TwContainer>
</template>

<style scoped>
  .cinema-name {
    border-bottom-width: 1px;
    border-image: linear-gradient(90deg, #FF007F 0%, #FF7F00 100%);
    border-style: solid;
    border-image-slice: 1;
  }
</style>
