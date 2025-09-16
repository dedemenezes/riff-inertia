<script setup>
import { ref, computed } from 'vue'
import { IconPlay } from '@/components/common/icons'

const props = defineProps({
  youtubeVideoId: { type: String, default: null },
  youtubeEmbedTrailer: { type: String, default: null },
  youtubeLinkTrailer: { type: String, default: null },
  vimeoLinkTrailer: { type: String, default: null },
  fallbackImage: { type: String, default: null },
  title: { type: String, default: 'Video Banner' }
})

const isPlaying = ref(false)

// Extract YouTube ID from URL
const getYouTubeId = (url) => {
  if (!url) return null
  const match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([^&\n?#]+)/)
  return match ? match[1] : null
}

// Extract Vimeo ID from URL
const getVimeoId = (url) => {
  if (!url) return null
  const match = url.match(/vimeo\.com\/(\d+)/)
  return match ? match[1] : null
}

// Get embed URL for video
const embedUrl = computed(() => {
  // Priority: embedded iframe > youtube link > vimeo link
  if (props.youtubeEmbedTrailer) {
    const srcMatch = props.youtubeEmbedTrailer.match(/src="([^"]+)"/)
    if (srcMatch) {
      return srcMatch[1] + '&autoplay=1'
    }
  }

  if (props.youtubeLinkTrailer) {
    const youtubeId = getYouTubeId(props.youtubeLinkTrailer)
    if (youtubeId) {
      return `https://www.youtube.com/embed/${youtubeId}?autoplay=1&rel=0`
    }
  }

  if (props.vimeoLinkTrailer) {
    const vimeoId = getVimeoId(props.vimeoLinkTrailer)
    if (vimeoId) {
      return `https://player.vimeo.com/video/${vimeoId}?autoplay=1&title=0&byline=0&portrait=0`
    }
  }

  if (props.youtubeVideoId) {
    return `https://www.youtube.com/embed/${props.youtubeVideoId}?autoplay=1&controls=1&rel=0&mute=1`
  }

  return null
})

// Get thumbnail URL
const thumbnailUrl = computed(() => {
  if (props.youtubeLinkTrailer) {
    const youtubeId = getYouTubeId(props.youtubeLinkTrailer)
    if (youtubeId) {
      return `https://i.ytimg.com/vi/${youtubeId}/maxresdefault.jpg`
    }
  }
  if (props.youtubeVideoId) {
    return `https://i.ytimg.com/vi/${props.youtubeVideoId}/maxresdefault.jpg`
  }

  // For Vimeo, we'd need API call for thumbnail, use fallback for now
  return props.fallbackImage
})

const playVideo = () => {
  isPlaying.value = true
}
</script>

<template>
  <!-- No video available -->
  <div
    v-if="!embedUrl"
    class="relative w-full aspect-video bg-neutrals-900 flex items-center justify-center rounded-200"
  >
    <p class="text-white">No video available</p>
  </div>

  <!-- Video banner wrapper -->
  <div v-else class="relative w-full aspect-video lg:mx-auto rounded-200">

    <!-- Iframe layer: mounted when playing -->
    <iframe
      v-if="isPlaying"
      :src="embedUrl"
      class="absolute inset-0 z-[100] w-full h-full rounded-200"
      frameborder="0"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
      allowfullscreen
    ></iframe>
    <!-- Thumbnail + play button overlay -->
    <div
      v-if="!isPlaying"
      @click="playVideo"
      class="absolute inset-0 w-full h-full cursor-pointer group overflow-hidden rounded-200"
    >
      <!-- Thumbnail -->
      <img
        v-if="thumbnailUrl"
        :src="thumbnailUrl"
        :alt="title"
        class="w-full h-full object-cover"
      />
      <div v-else class="w-full h-full bg-gradient-to-br from-primary to-secondary"></div>

      <!-- Dark overlay -->
      <div class="absolute inset-0 bg-black/40"></div>

      <!-- Play button -->
      <div class="absolute inset-0 flex items-center justify-center">
        <div class="bg-white-transp-1000/70 rounded-200 p-4 group-hover:bg-white-transp-1000/100 transition-all duration-300 group-hover:scale-105">
          <IconPlay class="w-8 h-8 text-neutrals-900 ml-1" />
        </div>
      </div>
    </div>
    <div class="absolute bottom-0 left-0 w-full bg-gradient-to-t from-black/80 to-transparent p-4 z-10">
      <p class="text-white text-md leading-[140%] font-body font-regular">
        {{ title }}
      </p>
    </div>
  </div>
</template>
