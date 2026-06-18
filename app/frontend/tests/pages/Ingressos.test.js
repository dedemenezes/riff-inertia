import { describe, it, expect, vi } from "vitest";
import { mount } from "@vue/test-utils";
import IngressosLayout from "@/pages/Ingressos/IngressosLayout.vue";
import Conteudo from "@/pages/Ingressos/Conteudo.vue";
import ProximasSessoes from "@/pages/Ingressos/ProximasSessoes.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: {
      tabs: [
        { label: "Como comprar seu ingresso", href: "/ingressos/como-comprar", active: true },
        { label: "Pacote de ingressos", href: "/ingressos/pacotes", active: false },
        { label: "Próximas sessões", href: "/ingressos/proximas-sessoes", active: false },
      ],
    },
  }),
  Head: {
    name: "Head",
    template: "<div><slot /></div>",
  },
  Link: {
    name: "Link",
    props: [ "href" ],
    template: '<a :href="href"><slot /></a>',
  },
}));

describe("IngressosLayout", () => {
  it("renders scrollable tabs on mobile and restores stretched tabs from md", () => {
    const wrapper = mount(IngressosLayout, {
      slots: { default: "<p>Page content</p>" },
    });

    const nav = wrapper.find("nav");
    expect(nav.classes()).toContain("overflow-x-auto");
    expect(nav.classes()).toContain("no-scroll-bar");
    expect(nav.classes()).toContain("md:overflow-visible");

    const links = wrapper.findAll("a");
    expect(links).toHaveLength(3);
    expect(links[0].classes()).toContain("flex-none");
    expect(links[0].classes()).toContain("min-w-max");
    expect(links[0].classes()).toContain("md:flex-1");
    expect(links[0].classes()).toContain("md:min-w-0");
    expect(wrapper.text()).toContain("Page content");
  });

  it("uses smaller mobile spacing while preserving desktop spacing", () => {
    const wrapper = mount(IngressosLayout);

    const wrapperDiv = wrapper.find("div.py-600");
    expect(wrapperDiv.exists()).toBe(true);
    expect(wrapperDiv.classes()).toContain("md:py-800");
  });
});

describe("Ingressos Conteudo", () => {
  it("renders title and legacy html content", () => {
    const wrapper = mount(Conteudo, {
      props: {
        titulo: "Como comprar seu ingresso",
        conteudo: "<p>Conteúdo vindo do legado.</p>",
      },
    });

    expect(wrapper.find("h1").text()).toBe("Como comprar seu ingresso");
    expect(wrapper.find(".content").html()).toContain("<p>Conteúdo vindo do legado.</p>");
  });

  it("uses compact mobile spacing and desktop spacing", () => {
    const wrapper = mount(Conteudo, {
      props: { titulo: "Pacote de ingressos", conteudo: "" },
    });

    const section = wrapper.find("section");
    expect(section.classes()).toContain("gap-600");
    expect(section.classes()).toContain("md:gap-800");
    expect(section.classes()).toContain("py-800");
    expect(section.classes()).toContain("md:py-1200");
  });
});

describe("Ingressos ProximasSessoes", () => {
  it("renders description and program link", () => {
    const wrapper = mount(ProximasSessoes, {
      props: {
        titulo: "Próximas sessões",
        descricao: "Confira a programação completa.",
        cta: "Ver programação",
        programPath: "/pt/programacao",
      },
    });

    const link = wrapper.find("a");
    expect(wrapper.find("h1").text()).toBe("Próximas sessões");
    expect(wrapper.text()).toContain("Confira a programação completa.");
    expect(link.attributes("href")).toBe("/pt/programacao");
    expect(link.text()).toBe("Ver programação");
  });
});
