import { describe, it, expect, vi } from "vitest";
import { mount } from "@vue/test-utils";
import IndexArticleCard from "@/components/common/cards/IndexArticleCard.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: {
      currentLocale: "en",
    },
  }),
  Link: {
    name: "Link",
    props: ["href"],
    template: `<a :href="href"><slot /></a>`,
  },
}));

const baseProps = {
  date: "04.10.2024",
  category: "Talents Rio",
  permalink: "talents-rio-news",
  imagem: "news.jpg",
  title: "Talents Rio News",
  chamada: "News lede",
};

describe("IndexArticleCard", () => {
  it("uses the current locale for default news links", () => {
    const wrapper = mount(IndexArticleCard, { props: baseProps });

    const links = wrapper.findAll("a");
    expect(links).toHaveLength(2);
    expect(links.every((link) => link.attributes("href") === "/en/noticias/talents-rio-news")).toBe(true);
  });

  it("uses an explicit href when provided", () => {
    const wrapper = mount(IndexArticleCard, {
      props: {
        ...baseProps,
        href: "/pt/edicoes_anteriores/12/noticias/talents-rio-news",
      },
    });

    const links = wrapper.findAll("a");
    expect(links.every((link) => link.attributes("href") === "/pt/edicoes_anteriores/12/noticias/talents-rio-news")).toBe(true);
  });
});
