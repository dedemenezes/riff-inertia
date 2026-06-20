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

    const img = wrapper.find("img");
    expect(img.attributes("src")).toBe("https://example.com/eric.jpg");
    expect(img.attributes("alt")).toBe("Eric Lagesse");
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
