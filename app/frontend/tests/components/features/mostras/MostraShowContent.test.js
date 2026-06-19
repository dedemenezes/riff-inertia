import { describe, it, expect, vi } from "vitest";
import { mount, shallowMount } from "@vue/test-utils";
import MostraShowContent from "@/components/features/mostras/MostraShowContent.vue";
import MostrasFilterForm from "@/components/features/filters/MostrasFilterForm.vue";
import PeliculaCard from "@components/common/cards/PeliculaCard.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: {
      currentLocale: "pt",
      menuContext: { edicao: [] },
    },
  }),
  Link: {
    name: "Link",
    props: ["href"],
    template: '<a :href="href"><slot /></a>',
  },
  router: {
    get: vi.fn(),
  },
}));

const mountOptions = {
  global: {
    stubs: {
      InfiniteScrollLayout: {
        props: ["elements", "pagy", "endMessage"],
        template: '<div><slot name="content" :allElements="elements" /></div>',
      },
      ResponsiveFilterMenu: {
        template: '<div><slot name="filters" :modelValue="{}" :updateField="() => {}" /></div>',
      },
      Carousel: { template: "<div><slot /></div>" },
      CarouselContent: { template: "<div><slot /></div>" },
      CarouselItem: { template: "<div><slot /></div>" },
      CarouselNext: true,
      CarouselPrevious: true,
      MobileTrigger: true,
      IconCarretUp: true,
    },
  },
};

const baseProps = {
  categoria: "Première Brasil",
  tag_class: "tag-premiere-brasil",
  tabBaseUrl: "/pt/edicoes_anteriores/12/mostras/premiere-brasil",
  mostras: [
    { id: 1, nome_abreviado: "Première Brasil-Longas", imagem: "longas.jpg" },
    { id: 2, nome_abreviado: "Première Brasil:Curtas", imagem: "curtas.jpg" },
  ],
  elements: [
    {
      id: 1,
      url: "/pt/peliculas/filme-premiere-longa",
      display_titulo: "Filme Première Longa",
    },
  ],
  pagy: { page: 1, pages: 1, last: 1 },
  submostras: [],
  paises: [],
  genres: [],
  directors: [],
  actors: [],
  current_filters: {},
  has_active_filters: false,
  endMessage: "Fim da lista",
  verFilmesLabel: "Ver filmes",
};

describe("MostraShowContent", () => {
  it("renders clickable PeliculaCard entries by default", () => {
    const wrapper = mount(MostraShowContent, { props: baseProps, ...mountOptions });
    const card = wrapper.findComponent(PeliculaCard);

    expect(card.exists()).toBe(true);
    expect(card.props("pelicula").url).toBe("/pt/peliculas/filme-premiere-longa");
    expect(card.props("linkable")).not.toBe(false);
  });

  it("can render non-clickable PeliculaCard entries for historical pages", () => {
    const wrapper = mount(MostraShowContent, {
      props: { ...baseProps, filmCardsLinkable: false },
      ...mountOptions,
    });

    expect(wrapper.findComponent(PeliculaCard).props("linkable")).toBe(false);
  });

  it("renders submostra badges and passes filter props to the form", () => {
    const wrapper = mount(MostraShowContent, {
      props: {
        ...baseProps,
        submostras: [{ filter_value: "premiere-brasil-longas-2024", filter_display: "Longas" }],
      },
      ...mountOptions,
    });

    expect(wrapper.text()).toContain("Première Brasil-Longas");
    expect(wrapper.text()).toContain("Première Brasil:Curtas");

    const filterForm = wrapper.findComponent(MostrasFilterForm);
    expect(filterForm.props("submostras")).toEqual([
      { filter_value: "premiere-brasil-longas-2024", filter_display: "Longas" },
    ]);
  });
});
