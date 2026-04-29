<script setup>
import { ref, computed } from "vue";
import TwContainer from "./TwContainer.vue";
import VideoBanner from "@/components/features/peliculas/VideoBanner.vue";
import { useVideoSelection } from "@/composables/useVideoSelection";

const props = defineProps({
  youtubeVideos: {
    type: Array,
    required: true,
    default: () => [],
  },
});

const { activeIndex, mainVideo, sideVideos, selectVideo } = useVideoSelection(
  computed(() => props.youtubeVideos),
);
</script>

<template>
  <div class="tv-festival bg-neutrals-1000 py-1600">
    <TwContainer>
      <div v-if="mainVideo" class="text-white">
        <!-- DESKTOP: grid 3 colunas -->
        <div class="hidden lg:grid grid-cols-3 gap-8 mx-auto">
          <!-- LEFT -->
          <div class="col-span-2 flex flex-col gap-4 justify-center">
            <div class="aspect-video bg-black rounded-200">
              <VideoBanner
                :youtube-video-id="
                  mainVideo['snippet']['resourceId']['videoId']
                "
                :title="mainVideo['snippet']['title']"
                :show-title="false"
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
                realidade.<br /><br />
                Nos vemos novamente em 2025!!
              </p>
            </div>
          </div>

          <!-- RIGHT -->
          <div class="flex flex-col gap-800 justify-between h-full">
            <div
              v-for="{ video, index } in sideVideos"
              :key="video['id']"
              class="flex flex-col cursor-pointer group"
              @click="selectVideo(index)"
            >
              <div
                class="aspect-video w-full max-h-[180px] bg-neutral-700 rounded-md overflow-hidden ring-2 ring-transparent group-hover:ring-white/40 transition-all duration-200"
              >
                <VideoBanner
                  :youtube-video-id="video['snippet']['resourceId']['videoId']"
                  :title="video['snippet']['title']"
                  :show-title="false"
                  :show-play="false"
                />
              </div>
              <p
                class="text-sm mt-2 line-clamp-2 text-neutral-300 group-hover:text-white transition-colors"
              >
                {{ video["snippet"]["title"] }}
              </p>
            </div>
          </div>
        </div>

        <!-- MOBILE: vídeo principal + carrossel -->
        <div v-if="mainVideo" class="flex flex-col gap-4 lg:hidden">
          <!-- Vídeo principal -->
          <div class="aspect-video bg-black rounded-200">
            <VideoBanner
              :youtube-video-id="mainVideo['snippet']['resourceId']['videoId']"
              :title="mainVideo['snippet']['title']"
              :show-title="false"
            />
          </div>

          <!-- Título e descrição -->
          <div>
            <h2 class="text-body-regular-md mb-2">
              {{ mainVideo["snippet"]["title"] }}
            </h2>
            <p class="text-body-regular">
              A 26ª edição do #FestivaldoRio foi um marco inesquecível, repleta
              de histórias emocionantes, trocas culturais e encontros que
              celebraram a magia do cinema! Agradecemos imensamente o apoio de
              nossos patrocinadores Shell Brasil e Prefeitura do Rio de Janeiro,
              que todo ano se comprometem em tornar o sonho realidade.<br /><br />
              Nos vemos novamente em 2025!!
            </p>
          </div>
          <!-- Carrossel horizontal -->
          <div
            class="flex gap-3 overflow-x-auto pb-2 px-4 snap-x snap-mandatory scrollbar-hide"
          >
            <div
              v-for="{ video, index } in sideVideos"
              :key="video['id']"
              class="flex-none w-[240px] cursor-pointer group snap-start flex flex-col gap-2"
              @click="selectVideo(index)"
            >
              <!-- Vídeo: aspect-video fluido -->
              <div
                class="w-full aspect-video bg-neutral-700 rounded-md overflow-hidden ring-2 ring-transparent group-hover:ring-white/40 transition-all duration-200"
                :class="{ 'ring-white/60': activeIndex === index }"
              >
                <VideoBanner
                  :youtube-video-id="video['snippet']['resourceId']['videoId']"
                  :title="video['snippet']['title']"
                  :show-play="false"
                  :show-title="false"
                />
              </div>

              <!-- Texto -->
              <p
                class="text-sm line-clamp-2 text-neutral-300 group-hover:text-white transition-colors leading-snug"
              >
                {{ video["snippet"]["title"] }}
              </p>
            </div>
          </div>
        </div>
      </div>
    </TwContainer>
  </div>
</template>
