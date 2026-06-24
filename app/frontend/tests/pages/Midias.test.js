import { describe, it, expect, vi } from "vitest";
import { mount } from "@vue/test-utils";
import FotosEVideos from "@/pages/Midias/FotosEVideos.vue";
import Impressos from "@/pages/Midias/Impressos.vue";

vi.mock("@inertiajs/vue3", () => ({
  Head: {
    name: "Head",
    template: "<div><slot /></div>",
  },
}));

const stubs = {
  TwContainer: {
    template: `<div><slot /></div>`,
  },
  MenuContext: {
    name: "MenuContext",
    props: ["nav", "activePage"],
    template: `<nav data-testid="menu-context">{{ nav }} {{ activePage }}</nav>`,
  },
  MediaExternalLink: {
    props: ["href", "label"],
    template: `<a :href="href" data-testid="external-link">{{ label }}</a>`,
  },
  MediaPdfCard: {
    props: ["material"],
    template: `<article data-testid="pdf-card">{{ material.title }}</article>`,
  },
  MediaVideoEmbed: {
    props: ["video"],
    template: `<article data-testid="video-card">{{ video.title }}</article>`,
  },
};

describe("Midias FotosEVideos", () => {
  it("renders the media context menu, external links, hero photo and videos", () => {
    const wrapper = mount(FotosEVideos, {
      props: {
        title: "Fotos & Vídeos",
        activePage: "Fotos & Vídeos",
        galleryLink: {
          label: "Ir para Flickr do Festival",
          href: "https://www.flickr.com/photos/festivaldorio/",
        },
        youtubeLink: {
          label: "Ir para YouTube do Festival",
          href: "https://www.youtube.com/@FestivaldoRio",
        },
        heroPhoto: {
          title: "Troféu Redentor",
          caption: "Troféu Redentor",
          imageKey: "trofeu-redentor",
        },
        videos: [
          { title: "TV Festival", embedUrl: "" },
          { title: "Entrevistas", embedUrl: "" },
        ],
      },
      global: { stubs },
    });

    expect(wrapper.find('[data-testid="menu-context"]').text()).toContain("midias Fotos & Vídeos");
    expect(wrapper.text()).toContain("Ir para Flickr do Festival");
    expect(wrapper.find('img[alt="Troféu Redentor"]').exists()).toBe(true);
    expect(wrapper.findAll('[data-testid="video-card"]')).toHaveLength(2);
  });
});

describe("Midias Impressos", () => {
  it("renders the media context menu and print cards", () => {
    const wrapper = mount(Impressos, {
      props: {
        title: "Impressos",
        activePage: "Impressos",
        printMaterials: [
          { title: "Revista de programação", pdfUrl: null, coverImageKey: "revista-programacao" },
          { title: "Catálogo oficial", pdfUrl: null, coverImageKey: "catalogo-oficial" },
          { title: "Cartazes", pdfUrl: null, coverImageKey: "cartazes" },
        ],
      },
      global: { stubs },
    });

    expect(wrapper.find('[data-testid="menu-context"]').text()).toContain("midias Impressos");
    expect(wrapper.findAll('[data-testid="pdf-card"]')).toHaveLength(3);
    expect(wrapper.text()).toContain("Catálogo oficial");
  });
});
