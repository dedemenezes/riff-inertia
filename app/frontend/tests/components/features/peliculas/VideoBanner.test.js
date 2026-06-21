import { describe, it, expect, vi } from "vitest";
import { mount } from "@vue/test-utils";
import VideoBanner from "@/components/features/peliculas/VideoBanner.vue";

vi.mock("@/components/common/icons", () => ({
  IconPlay: { template: '<span data-test="icon-play" />' },
}));

describe("VideoBanner", () => {
  it("lazy-loads thumbnails with low priority by default", () => {
    const wrapper = mount(VideoBanner, {
      props: {
        youtubeVideoId: "video-123",
        title: "Festival TV",
      },
    });

    const thumbnail = wrapper.find("img");

    expect(thumbnail.attributes()).toMatchObject({
      src: "https://i.ytimg.com/vi/video-123/maxresdefault.jpg",
      alt: "Festival TV",
      width: "1280",
      height: "720",
      loading: "lazy",
      fetchpriority: "low",
      decoding: "async",
    });
  });

  it("allows callers to promote thumbnail loading when needed", () => {
    const wrapper = mount(VideoBanner, {
      props: {
        youtubeVideoId: "video-123",
        thumbnailLoading: "eager",
        thumbnailFetchPriority: "high",
      },
    });

    expect(wrapper.find("img").attributes()).toMatchObject({
      loading: "eager",
      fetchpriority: "high",
    });
  });

  it("validates thumbnail loading attributes", () => {
    const { thumbnailLoading, thumbnailFetchPriority } =
      VideoBanner.props ?? VideoBanner.__props;

    expect(thumbnailLoading.validator("lazy")).toBe(true);
    expect(thumbnailLoading.validator("eager")).toBe(true);
    expect(thumbnailLoading.validator("auto")).toBe(false);

    expect(thumbnailFetchPriority.validator("high")).toBe(true);
    expect(thumbnailFetchPriority.validator("low")).toBe(true);
    expect(thumbnailFetchPriority.validator("auto")).toBe(true);
    expect(thumbnailFetchPriority.validator("lazy")).toBe(false);
  });
});
