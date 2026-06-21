import { describe, it, expect, vi } from "vitest";
import { mount } from "@vue/test-utils";
import HomePage from "@/pages/HomePage.vue";

vi.mock("@inertiajs/vue3", () => ({
  Head: {
    name: "Head",
    template: '<div data-test="head"><slot /></div>',
  },
  usePage: () => ({
    props: {
      currentLocale: "pt",
    },
  }),
}));

const webdoors = [
  {
    id: 1,
    titulo: "Primeiro webdoor",
    mobile_image_url: "https://s3.amazonaws.com/festivaldorio/mobile-1.jpg",
    desktop_image_url: "https://s3.amazonaws.com/festivaldorio/desktop-1.jpg",
  },
  {
    id: 2,
    titulo: "Segundo webdoor",
    mobile_image_url: "https://s3.amazonaws.com/festivaldorio/mobile-2.jpg",
    desktop_image_url: "https://s3.amazonaws.com/festivaldorio/desktop-2.jpg",
  },
];

function mountHomePage(props = {}) {
  return mount(HomePage, {
    props: {
      quickLinksConfig: [],
      noticias: [],
      noticasUrl: "/noticias",
      youtubeVideos: [],
      nextSessions: [],
      destaques: [],
      webdoors,
      ...props,
    },
    global: {
      stubs: {
        HomeBanner: { template: "<section><slot /></section>" },
        CarouselComponent: {
          template: '<div data-test="carousel"><slot name="items" /></div>',
        },
        CarouselItem: {
          template: '<article data-test="carousel-item"><slot /></article>',
        },
        QuickLinkSection: true,
        ArticlesSection: true,
        SessionCard: true,
        HorizontalScrollLayout: {
          template:
            '<section><slot name="header" /><slot name="content" /></section>',
        },
        TvFestival: true,
        TwContainer: { template: "<div><slot /></div>" },
        DestaquesSection: true,
      },
    },
  });
}

describe("HomePage", () => {
  it("preloads the first webdoor images with responsive media queries", () => {
    const wrapper = mountHomePage();

    const preloadLinks = wrapper.findAll('[rel="preload"][as="image"]');

    expect(preloadLinks).toHaveLength(2);
    expect(preloadLinks[0].attributes()).toMatchObject({
      href: webdoors[0].mobile_image_url,
      media: "(max-width: 1023px)",
      fetchpriority: "high",
    });
    expect(preloadLinks[1].attributes()).toMatchObject({
      href: webdoors[0].desktop_image_url,
      media: "(min-width: 1024px)",
      fetchpriority: "high",
    });
  });

  it("renders webdoors as picture/img elements with desktop sources", () => {
    const wrapper = mountHomePage();

    const pictures = wrapper.findAll("picture");
    const images = wrapper.findAll("picture img");
    const sources = wrapper.findAll("picture source");

    expect(pictures).toHaveLength(2);
    expect(images).toHaveLength(2);
    expect(sources[0].attributes()).toMatchObject({
      media: "(min-width: 1024px)",
      srcset: webdoors[0].desktop_image_url,
    });
    expect(images[0].attributes()).toMatchObject({
      src: webdoors[0].mobile_image_url,
      alt: webdoors[0].titulo,
      width: "600",
      height: "800",
      decoding: "async",
    });
  });

  it("prioritizes only the first webdoor image", () => {
    const wrapper = mountHomePage();

    const images = wrapper.findAll("picture img");

    expect(images[0].attributes()).toMatchObject({
      loading: "eager",
      fetchpriority: "high",
    });
    expect(images[1].attributes()).toMatchObject({
      loading: "lazy",
      fetchpriority: "auto",
    });
  });

  it("does not render empty image tags or preloads when a webdoor has no urls", () => {
    const wrapper = mountHomePage({
      webdoors: [
        {
          id: 1,
          titulo: "Sem imagem",
          mobile_image_url: "",
          desktop_image_url: null,
        },
      ],
    });

    expect(wrapper.find("picture").exists()).toBe(false);
    expect(wrapper.find("img").exists()).toBe(false);
    expect(wrapper.find('[rel="preload"]').exists()).toBe(false);
  });
});
