import { describe, it, expect, vi, beforeEach } from "vitest";
import { mount } from "@vue/test-utils";
import EdicoesNoticias from "@/pages/Edicoes/Noticias.vue";

const { routerGet } = vi.hoisted(() => ({
  routerGet: vi.fn(),
}));

vi.mock("@inertiajs/vue3", () => ({
  router: {
    get: routerGet,
  },
  usePage: () => ({
    props: {
      currentLocale: "pt",
      menuContext: { edicoes_anteriores: [] },
      locale_messages: { placeholder: { select: "Escolha um(a)" } },
    },
  }),
  Link: {
    name: "Link",
    props: ["href"],
    template: `<a :href="href"><slot /></a>`,
  },
  Head: {
    name: "Head",
    template: "<div />",
  },
}));

const stubs = {
  TwContainer: {
    template: `<div><slot /></div>`,
  },
  EdicaoHeader: {
    props: ["edicao", "fallBackUrl"],
    template: `<header data-testid="edicao-header">{{ edicao.descricao }}</header>`,
  },
  MenuContext: {
    name: "MenuContext",
    props: ["nav", "activePage"],
    template: `<nav data-testid="menu-context">{{ activePage }}</nav>`,
  },
  SearchBar: {
    props: ["modelValue"],
    emits: ["update:modelValue", "search", "clear"],
    template: `
      <div>
        <input data-testid="search-bar" :value="modelValue" @input="$emit('update:modelValue', $event.target.value)" />
        <button data-testid="submit-search" @click="$emit('search')">search</button>
        <button data-testid="clear-search" @click="$emit('clear')">clear</button>
      </div>
    `,
  },
  SearchFilter: {
    props: ["modelValue"],
    emits: ["update:modelValue", "filtersApplied", "filtersCleared", "closeFilterMenu"],
    template: `
      <div data-testid="search-filter">
        <slot
          name="filters"
          :modelValue="modelValue"
          :updateField="(key, value) => $emit('update:modelValue', { ...modelValue, [key]: value })"
        />
        <button data-testid="apply-filters" @click="$emit('filtersApplied', modelValue)">apply</button>
      </div>
    `,
  },
  NoticiasFilterForm: {
    props: ["modelValue", "updateField", "dataLabel", "cadernos"],
    template: `<div data-testid="noticias-filter-form">{{ dataLabel }} {{ cadernos.length }}</div>`,
  },
  InfiniteScrollLayout: {
    props: ["elements", "pagy", "endMessage"],
    template: `<section data-testid="infinite-scroll"><slot name="content" :allElements="elements" /></section>`,
  },
  NewsCard: {
    props: ["title", "permalink", "image", "category", "date", "content", "variant"],
    template: `<article data-testid="news-card">{{ title }}</article>`,
  },
  TagFilter: {
    props: ["filter", "text"],
    template: `<button data-testid="tag-filter" @click="$emit('removeFilter', filter)">{{ text }}</button>`,
  },
  IconArrowDown: true,
  IconFilter: true,
  IconClose: true,
  Teleport: true,
};

const baseProps = {
  edicao: { id: 12, descricao: "2024", cartazURL: null },
  elements: [
    {
      id: 1,
      titulo: "Alpha notícia",
      permalink: "alpha-noticia",
      chamada: "Lede",
      image_url: "https://example.com/news.jpg",
      caderno_nome: "Talents Rio",
      display_date: "04.10.2024",
    },
  ],
  pagy: { page: 1, pages: 1, last: 1 },
  cadernos: [
    {
      filter_label: "Caderno",
      filter_display: "Talents Rio",
      filter_value: "talents-rio",
    },
  ],
  current_filters: {
    query: null,
    data: null,
    caderno: null,
  },
  has_active_filters: false,
  sort: "asc",
  tabBaseUrl: "/pt/edicoes_anteriores/12/noticias",
  fallBackUrl: "/pt/edicoes_anteriores",
  endMessage: "Não há mais notícias.",
  activePage: "Todas as notícias",
  dataLabel: "Data de publicação",
};

describe("Edicoes/Noticias", () => {
  beforeEach(() => {
    routerGet.mockClear();
  });

  it("renders the previous-edition shell and news grid", () => {
    const wrapper = mount(EdicoesNoticias, { props: baseProps, global: { stubs } });

    expect(wrapper.find('[data-testid="edicao-header"]').text()).toContain("2024");
    expect(wrapper.findComponent({ name: "MenuContext" }).props("nav")).toBe("edicoes_anteriores");
    expect(wrapper.findComponent({ name: "MenuContext" }).props("activePage")).toBe("Todas as notícias");
    expect(wrapper.find('[data-testid="news-card"]').text()).toContain("Alpha notícia");
    expect(wrapper.find('[data-testid="noticias-filter-form"]').text()).toContain("Data de publicação 1");
  });

  it("navigates with query and sort params from the top bar", async () => {
    const wrapper = mount(EdicoesNoticias, { props: baseProps, global: { stubs } });

    await wrapper.find('[data-testid="search-bar"]').setValue("paradiso");
    await wrapper.find('[data-testid="submit-search"]').trigger("click");

    expect(routerGet).toHaveBeenLastCalledWith(
      baseProps.tabBaseUrl,
      { query: "paradiso", sort: "asc" },
      expect.objectContaining({ preserveScroll: true, preserveState: true, replace: true }),
    );

    const sortButton = wrapper.findAll("button").find((button) => button.text().includes("A–Z"));
    await sortButton.trigger("click");

    expect(routerGet).toHaveBeenLastCalledWith(
      baseProps.tabBaseUrl,
      { query: "paradiso", sort: "desc" },
      expect.objectContaining({ preserveScroll: true, preserveState: true, replace: true }),
    );
  });
});
