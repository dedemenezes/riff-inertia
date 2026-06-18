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
});
