import { describe, it, expect, vi } from "vitest";
import { mount } from "@vue/test-utils";
import Index from "@/pages/Juri/Index.vue";

vi.mock("@inertiajs/vue3", () => ({
  Head: {
    name: "Head",
    template: "<div><slot /></div>",
  },
  usePage: () => ({
    props: { currentLocale: "pt" },
  }),
}));

vi.mock("@/components/common/icons", () => ({
  IconSearch: {
    name: "IconSearch",
    template: "<span data-test='icon-search' />",
  },
  IconClose: {
    name: "IconClose",
    template: "<span data-test='icon-close' />",
  },
  IconFilter: {
    name: "IconFilter",
    template: "<span data-test='icon-filter' />",
  },
}));

const sections = [
  {
    id: "premiere-brasil-competicao-principal",
    title: "PREMIERE BRASIL: COMPETIÇÃO PRINCIPAL",
    tab_label: "Première Brasil",
    jurors: [
      {
        name: "Eric Lagesse",
        role: "Presidente do Júri",
        photo: "https://example.com/eric.jpg",
        bio: [ "Distribuidor, agente de vendas e produtor francês." ],
      },
      {
        name: "Ana Souza",
        role: "Jurade",
        photo: "https://example.com/ana.jpg",
        bio: [ "Crítica de cinema brasileira." ],
      },
    ],
  },
  {
    id: "novos-rumos",
    title: "PREMIÈRE BRASIL: NOVOS RUMOS",
    tab_label: "Novos Rumos",
    jurors: [
      {
        name: "Beth Formaggini",
        role: "Presidenta do Júri",
        photo: "https://example.com/beth.jpg",
        bio: [ "Dirigiu os longas Memória para Uso Diário." ],
      },
    ],
  },
];

const mountPage = () => mount(Index, {
  props: {
    titulo: "Júri 2025",
    activePage: "Júri",
    crumbs: [],
    sections,
  },
  global: {
    stubs: {
      Breadcrumb: true,
      MenuContext: true,
      TwContainer: {
        template: "<div><slot /></div>",
      },
    },
  },
});

describe("Juri Index", () => {
  it("renders tabs and first section by default", () => {
    const wrapper = mountPage();

    expect(wrapper.findAll("[role='tab']")).toHaveLength(2);
    expect(wrapper.text()).toContain("Première Brasil");
    expect(wrapper.text()).toContain("Eric Lagesse");
    expect(wrapper.text()).toContain("Presidente do Júri");
    expect(wrapper.text()).toContain("Distribuidor, agente de vendas e produtor francês.");
    expect(wrapper.text()).not.toContain("Beth Formaggini");

    const images = wrapper.findAll("img");
    expect(images.map((img) => img.attributes("src"))).toContain("https://example.com/eric.jpg");
    expect(images.map((img) => img.attributes("alt"))).toContain("Eric Lagesse");
  });

  it("renders the mobile filter bar and compact section title", () => {
    const wrapper = mountPage();

    expect(wrapper.find("[data-test='juri-filter-bar']").exists()).toBe(true);
    expect(wrapper.find("input").attributes("placeholder")).toBe("Pesquisar");
    expect(wrapper.find("[data-test='juri-sort-button']").text()).toContain("A - Z");
    expect(wrapper.find("[data-test='juri-filter-button']").text()).toContain("Filtros");
    expect(wrapper.find("[data-test='juri-title-block']").attributes("class")).not.toContain("border-t");
    expect(wrapper.find("[role='tablist']").classes()).not.toContain("px-400");
  });

  it("switches visible jurors when another tab is selected", async () => {
    const wrapper = mountPage();

    await wrapper.findAll("[role='tab']")[1].trigger("click");

    expect(wrapper.text()).toContain("Novos Rumos");
    expect(wrapper.text()).toContain("Beth Formaggini");
    expect(wrapper.text()).toContain("Presidenta do Júri");
    expect(wrapper.text()).not.toContain("Eric Lagesse");
  });

  it("filters visible jurors by search text", async () => {
    const wrapper = mountPage();

    await wrapper.find("input").setValue("ana");

    expect(wrapper.text()).toContain("Ana Souza");
    expect(wrapper.text()).not.toContain("Eric Lagesse");
  });

  it("toggles jury sort order", async () => {
    const wrapper = mountPage();

    const namesBeforeSort = wrapper.findAllComponents({ name: "JuriCard" }).map((card) => card.props("name"));
    expect(namesBeforeSort).toEqual([ "Eric Lagesse", "Ana Souza" ]);

    await wrapper.find("[data-test='juri-sort-button']").trigger("click");

    const namesAfterSort = wrapper.findAllComponents({ name: "JuriCard" }).map((card) => card.props("name"));
    expect(namesAfterSort).toEqual([ "Ana Souza", "Eric Lagesse" ]);
  });
});
