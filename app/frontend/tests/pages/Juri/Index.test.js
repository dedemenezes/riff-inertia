import { describe, it, expect, vi } from "vitest";
import { mount } from "@vue/test-utils";
import Index from "@/pages/Juri/Index.vue";

vi.mock("@inertiajs/vue3", () => ({
  Head: {
    name: "Head",
    template: "<div><slot /></div>",
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

  it("renders compact tabs and title without filter controls", () => {
    const wrapper = mountPage();

    expect(wrapper.find("[data-test='juri-filter-bar']").exists()).toBe(false);
    expect(wrapper.find("[data-test='juri-sort-button']").exists()).toBe(false);
    expect(wrapper.find("[data-test='juri-filter-button']").exists()).toBe(false);
    expect(wrapper.find("[data-test='juri-title-block']").attributes("class")).not.toContain("border-t");
    expect(wrapper.find("[data-test='juri-tabs-block']").classes()).toEqual(
      expect.arrayContaining([ "pt-600", "lg:pt-1200" ]),
    );
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
});
