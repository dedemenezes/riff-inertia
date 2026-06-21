import { describe, it, expect } from "vitest";
import { shallowMount } from "@vue/test-utils";
import { Link } from "@inertiajs/vue3";
import PeliculaCard from "@components/common/cards/PeliculaCard.vue";

const pelicula = {
  url: "/pt/peliculas/batman-link",
  display_titulo: "Batman",
  display_paises: "EUA",
  genre: "Ação",
  duracao_coord_int: 140,
  imageURL: "https://example.com/batman.jpg",
  card_image: {
    src: "https://example.com/medium2/batman.jpg",
    srcset:
      "https://example.com/medium/batman.jpg 400w, https://example.com/medium2/batman.jpg 600w, https://example.com/large/batman.jpg 800w",
    sizes: "(min-width: 1024px) 33vw, (min-width: 768px) 50vw, 100vw",
  },
  mostra_tag_class: "sci-fi",
  mostra_display_name: "Sci-Fi",
};

describe("PeliculaCard", () => {
  it("wraps the card in an Inertia Link by default", () => {
    const wrapper = shallowMount(PeliculaCard, { props: { pelicula } });

    const link = wrapper.findComponent(Link);
    expect(link.exists()).toBe(true);
    expect(link.props("href")).toBe(pelicula.url);
  });

  it("renders a non-clickable wrapper when linkable is false", () => {
    const wrapper = shallowMount(PeliculaCard, {
      props: { pelicula, linkable: false },
    });

    expect(wrapper.findComponent(Link).exists()).toBe(false);
    expect(wrapper.find("div.w-full").exists()).toBe(true);
  });

  it("does not show the hover underline when non-clickable", async () => {
    const wrapper = shallowMount(PeliculaCard, {
      props: { pelicula, linkable: false },
    });

    await wrapper.find(".flex.flex-col").trigger("mouseenter");

    const underline = wrapper
      .findAll("span")
      .find((span) => span.classes().includes("transition-height"));
    expect(underline.attributes("style")).toContain("height: 0px");
  });

  it("renders the responsive card image when provided", () => {
    const wrapper = shallowMount(PeliculaCard, {
      props: { pelicula, linkable: false },
    });

    const img = wrapper.find("img");
    expect(img.attributes("src")).toBe(pelicula.card_image.src);
    expect(img.attributes("srcset")).toBe(pelicula.card_image.srcset);
    expect(img.attributes("sizes")).toBe(pelicula.card_image.sizes);
    expect(img.attributes("loading")).toBe("lazy");
    expect(img.attributes("decoding")).toBe("async");
  });

  it("renders eager loading when lazy is false", () => {
    const wrapper = shallowMount(PeliculaCard, {
      props: { pelicula, linkable: false, lazy: false },
    });

    expect(wrapper.find("img").attributes("loading")).toBe("eager");
  });

  it("falls back to the legacy imageURL when card_image is absent", () => {
    const legacyPelicula = { ...pelicula, card_image: null };
    const wrapper = shallowMount(PeliculaCard, {
      props: { pelicula: legacyPelicula, linkable: false },
    });

    const img = wrapper.find("img");
    expect(img.attributes("src")).toBe(legacyPelicula.imageURL);
    expect(img.attributes("srcset")).toBeUndefined();
    expect(img.attributes("sizes")).toBeUndefined();
  });

  it("falls back to the default image when no image URL is available", () => {
    const peliculaWithoutImage = {
      ...pelicula,
      card_image: null,
      imageURL: null,
    };
    const wrapper = shallowMount(PeliculaCard, {
      props: { pelicula: peliculaWithoutImage, linkable: false },
    });

    const img = wrapper.find("img");
    expect(img.attributes("src")).toBeTruthy();
    expect(img.attributes("src")).not.toBe(pelicula.card_image.src);
    expect(img.attributes("src")).not.toBe(pelicula.imageURL);
  });
});
