import { describe, it, expect, vi } from "vitest";
import { shallowMount } from "@vue/test-utils";
import MostrasShow from "@/pages/Mostras/Show.vue";
import MenuContext from "@/components/layout/navbar/MenuContext.vue";
import MostraShowContent from "@/components/features/mostras/MostraShowContent.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: {
      currentLocale: "pt",
      menuContext: { edicao: [] },
    },
  }),
  router: {
    get: vi.fn(),
  },
}));

const baseProps = {
  categoria: "Sci-Fi",
  tag_class: "tag-default",
  tabBaseUrl: "/pt/mostras/sci-fi",
  mostras: [{ id: 1, nome_abreviado: "Sci-Fi", imagem: "sci-fi.jpg" }],
  elements: [],
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

describe("Mostras/Show", () => {
  it("keeps the current edition menu and delegates the body to MostraShowContent", () => {
    const wrapper = shallowMount(MostrasShow, { props: baseProps });

    const menu = wrapper.findComponent(MenuContext);
    expect(menu.props("nav")).toBe("edicao");
    expect(menu.props("activePage")).toBe("Mostras");

    const content = wrapper.findComponent(MostraShowContent);
    expect(content.exists()).toBe(true);
    expect(content.props("tabBaseUrl")).toBe(baseProps.tabBaseUrl);
  });
});
