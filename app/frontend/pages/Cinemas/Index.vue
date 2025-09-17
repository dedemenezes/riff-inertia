<script setup>
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import TwContainer from "@/components/layout/TwContainer.vue";
import Breadcrumb from "@/components/common/Breadcrumb.vue";
import SearchBar from "@/components/features/filters/SearchBar.vue";
import { IconPin, IconPhone, IconWholeTicket, IconSeat, IconArrowDown } from "@/components/common/icons";
import { ref, reactive } from "vue";

const props = defineProps({
  cinemas: { type: Object, default: () => []},
  crumbs: { type: Array, required: true}
})

const cinemas = reactive([...props.cinemas])
const asc = ref(true)
const query = ref('')
const arrowClass = ref('')

const fold = (s) => {
  return s.normalize('NFD').replace(/\p{Diacritic}/gu, '').toLowerCase().trim()
}

const filterList = (src, q) => {
  const v = fold(q)
  if (!v) return src.slice()

  return src.filter(p => fold(p.name).includes(v))
}

const apply = () => {
  const filtered = filterList(props.cinemas, query.value)

  // ordena pt-BR ignorando acentos; inverte se asc=false
  filtered.sort((a, b) =>
    asc.value
      ? a.name.localeCompare(b.name, 'pt', { sensitivity: 'base' })
      : b.name.localeCompare(a.name, 'pt', { sensitivity: 'base' })
  )

  // atualiza o array reativo SEM trocar a referência
  cinemas.splice(0, cinemas.length, ...filtered)
}

const onInput = (e) => {
  const v =
    typeof e === 'string'
      ? e
      : (e && e.target && typeof e.target.value === 'string')
      ? e.target.value
      : ''
  query.value = v
  apply()
}

const toggleOrder = () => {
  asc.value = !asc.value
  apply()
  arrowClass.value = arrowClass.value === "" ? "up" : ""
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
    class="grid grid-cols-1 lg:grid-cols-3 gap-800 sticky top-0 bg-white-transp-1000"
  >
    <SearchBar
      class="py-400"
      @input="onInput"
    />

    <div class="col-start-3 flex justify-end items-center">
      <button
        type="button"
        @click="toggleOrder"
        class="cursor-pointer flex items-center gap-200 p-200"
      >
        <IconArrowDown
          :className="arrowClass"
        ></IconArrowDown>
        {{ asc ? 'A–Z' : 'Z–A' }}
      </button>
    </div>
  </TwContainer>

  <hr class="text-neutrals-300">

  <TwContainer>
    <ul class="flex flex-col py-1200 gap-800 text-body-regular">
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
              :active="true"
              height="16"
              width="16"
            />
            <!-- TODO: trocar o preço do ingresso -->
            <p>imagine o PREÇO DO INGRESSO aqui</p>
          </div>

          <div v-if="cinema.cinema.endereco" class="flex gap-50 items-center">
            <IconPin
              :active="true"
              height="16"
              width="16"
            />
            <p>{{ cinema.cinema.endereco }}</p>
          </div>

          <div v-if="cinema.cinema.telefone" class="flex gap-50 items-center">
            <IconPhone
              :active="true"
              height="16"
              width="16"
            />
            <p>{{ cinema.cinema.telefone }}</p>
          </div>

          <div class="flex flex-col gap-300">
            <div class="flex gap-50 items-center">
              <IconSeat
                :active="true"
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
