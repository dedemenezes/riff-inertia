<script setup>
import { ref, computed } from "vue";
import TwContainer from "./TwContainer.vue";
import VideoBanner from "@/components/features/peliculas/VideoBanner.vue";

const props = defineProps({
  youtubeVideos: {
    type: Array,
    required: true,
    default: () => [],
  },
});

// Índice do vídeo principal
const activeIndex = ref(0);

// Vídeo principal
const mainVideo = computed(() => props.youtubeVideos[activeIndex.value]);

// Vídeos da sidebar (todos exceto o principal, limitado a 3)
const sideVideos = computed(() =>
  props.youtubeVideos
    .map((video, index) => ({ video, index }))
    .filter(({ index }) => index !== activeIndex.value)
    .slice(0, 3),
);

function selectVideo(index) {
  activeIndex.value = index;
}
</script>

<template>
  <div class="tv-festival bg-neutrals-1000 py-1600">
    <TwContainer>
      <div class="text-white">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mx-auto">
          <!-- LEFT -->
          <div class="lg:col-span-2 flex flex-col gap-4 justify-center">
            <div class="aspect-video bg-black rounded-200">
              <VideoBanner
                :youtube-video-id="
                  mainVideo['snippet']['resourceId']['videoId']
                "
                :title="mainVideo['snippet']['title']"
              />
            </div>

            <div>
              <h2 class="text-xl font-semibold mb-2">
                {{ mainVideo["snippet"]["title"] }}
              </h2>
              <p class="text-sm text-neutral-300">
                A 26ª edição do #FestivaldoRio foi um marco inesquecível,
                repleta de histórias emocionantes, trocas culturais e encontros
                que celebraram a magia do cinema! Agradecemos imensamente o
                apoio de nossos patrocinadores Shell Brasil e Prefeitura do Rio
                de Janeiro, que todo ano se comprometem em tornar o sonho
                realidade. <br /><br />
                No vemos novamente em 2025!!
              </p>
            </div>
          </div>

          <!-- RIGHT -->
          <div class="flex flex-col justify-between h-full">
            <div
              v-for="{ video, index } in sideVideos"
              :key="video['id']"
              class="flex flex-col h-[255px] cursor-pointer group"
              @click="selectVideo(index)"
            >
              <!-- item -->
              <div
                class="aspect-video w-full max-h-[180px] bg-neutral-700 rounded-md"
              >
                <VideoBanner
                  :youtube-video-id="video['snippet']['resourceId']['videoId']"
                  :title="video['snippet']['title']"
                />
              </div>

              <!-- <p class="text-sm mt-2 line-clamp-2">
                Noite de Encerramento com os vencedores do Festival do Rio 2024
              </p> -->
            </div>
          </div>
        </div>
      </div>
    </TwContainer>
  </div>
</template>
