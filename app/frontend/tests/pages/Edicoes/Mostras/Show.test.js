import { describe, it, expect, vi } from "vitest";
import { mount, shallowMount } from "@vue/test-utils";
import EdicoesMostrasShow from "@/pages/Edicoes/Mostras/Show.vue";
import EdicaoHeader from "@/components/common/EdicaoHeader.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MostraShowContent from "@/components/features/mostras/MostraShowContent.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: {
      currentLocale: "pt",
      menuContext: { edicoes_anteriores: [] },
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

const baseProps = {
  edicao: { id: 12, descricao: "2024", cartazURL: "https://example.com/cartaz.jpg" },
  fallBackUrl: "/pt/edicoes_anteriores",
  activePage: "Mostras",
  categoria: "Première Brasil",
  tag_class: "tag-premiere-brasil",
  tabBaseUrl: "/pt/edicoes_anteriores/12/mostras/premiere-brasil",
  mostras: [{ id: 1, nome_abreviado: "Première Brasil-Longas", imagem: "longas.jpg" }],
  elements: [{ url: "/pt/peliculas/filme-premiere-longa", display_titulo: "Filme Première Longa" }],
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

describe("Edicoes/Mostras/Show", () => {
  it("renders the historical shell with non-clickable cards delegated to MostraShowContent", () => {
    const wrapper = mount(EdicoesMostrasShow, {
      props: baseProps,
      global: {
        stubs: {
          MostraShowContent: true,
        },
      },
    });

    expect(wrapper.findComponent(EdicaoHeader).exists()).toBe(true);

    const menu = wrapper.findComponent(MenuContext);
    expect(menu.props("nav")).toBe("edicoes_anteriores");
    expect(menu.props("activePage")).toBe("Mostras");

    const content = wrapper.findComponent(MostraShowContent);
    expect(content.exists()).toBe(true);
    expect(content.props("elements")).toEqual(baseProps.elements);
    expect(content.props("filmCardsLinkable")).toBe(false);
  });

  it("delegates the listing body to MostraShowContent", () => {
    const wrapper = shallowMount(EdicoesMostrasShow, { props: baseProps });
    const content = wrapper.findComponent(MostraShowContent);

    expect(content.exists()).toBe(true);
    expect(content.props("tabBaseUrl")).toBe(baseProps.tabBaseUrl);
    expect(content.props("categoria")).toBe("Première Brasil");
  });
});
