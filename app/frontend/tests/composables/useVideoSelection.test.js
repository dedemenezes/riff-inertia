import { describe, it, expect, beforeEach } from "vitest";
import { computed, ref } from "vue";
import { useVideoSelection } from "@/composables/useVideoSelection";

const mockVideos = [
  { id: "1", snippet: { title: "Video A", resourceId: { videoId: "aaaa" } } },
  { id: "2", snippet: { title: "Video B", resourceId: { videoId: "bbbb" } } },
  { id: "3", snippet: { title: "Video C", resourceId: { videoId: "cccc" } } },
  { id: "4", snippet: { title: "Video D", resourceId: { videoId: "dddd" } } },
  { id: "5", snippet: { title: "Video E", resourceId: { videoId: "eeee" } } },
];

const makeVideos = (list = mockVideos) => computed(() => list);

describe("useVideoSelection", () => {
  it("starts with activeIndex 0", () => {
    const { activeIndex } = useVideoSelection(makeVideos());
    expect(activeIndex.value).toBe(0);
  });

  it("mainVideo returns the video at activeIndex", () => {
    const { mainVideo } = useVideoSelection(makeVideos());
    expect(mainVideo.value.id).toBe("1");
  });

  it("sideVideos excludes the main video", () => {
    const { sideVideos } = useVideoSelection(makeVideos());
    const ids = sideVideos.value.map(({ video }) => video.id);
    expect(ids).not.toContain("1");
  });

  it("sideVideos returns at most 3 items", () => {
    const { sideVideos } = useVideoSelection(makeVideos());
    expect(sideVideos.value.length).toBeLessThanOrEqual(3);
  });

  it("sideVideos preserves original index", () => {
    const { sideVideos } = useVideoSelection(makeVideos());

    expect(sideVideos.value[0].index).toBe(1);
  });

  it("selectVideo updates activeIndex", () => {
    const { activeIndex, selectVideo } = useVideoSelection(makeVideos());
    selectVideo(2);
    expect(activeIndex.value).toBe(2);
  });

  it("mainVideo updates reactively after selectVideo", () => {
    const { mainVideo, selectVideo } = useVideoSelection(makeVideos());
    selectVideo(3);
    expect(mainVideo.value.id).toBe("4");
  });

  it("sideVideos updates reactively after selectVideo", () => {
    const { sideVideos, selectVideo } = useVideoSelection(makeVideos());
    selectVideo(1);
    const ids = sideVideos.value.map(({ video }) => video.id);
    expect(ids).not.toContain("2");
    expect(ids).toContain("1");
  });

  it("works with exactly 1 video", () => {
    const { mainVideo, sideVideos } = useVideoSelection(
      makeVideos([mockVideos[0]]),
    );
    expect(mainVideo.value.id).toBe("1");
    expect(sideVideos.value.length).toBe(0);
  });

  it("works with exactly 4 videos — sideVideos caps at 3", () => {
    const { sideVideos } = useVideoSelection(
      makeVideos(mockVideos.slice(0, 4)),
    );
    expect(sideVideos.value.length).toBe(3);
  });
});
