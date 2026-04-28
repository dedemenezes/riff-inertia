// useVideoSelection.js
import { ref, computed } from "vue";

export function useVideoSelection(videos) {
  const activeIndex = ref(0);
  const mainVideo = computed(() => videos.value[activeIndex.value]);
  const sideVideos = computed(() =>
    videos.value
      .map((video, index) => ({ video, index }))
      .filter(({ index }) => index !== activeIndex.value)
      .slice(0, 3),
  );
  function selectVideo(index) {
    activeIndex.value = index;
  }
  return { activeIndex, mainVideo, sideVideos, selectVideo };
}
