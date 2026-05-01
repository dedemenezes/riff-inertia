import { describe, it, expect, vi, beforeEach } from "vitest";
import { mount } from "@vue/test-utils";
import Index from "@/pages/Cinemas/Index.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: { currentLocale: "pt", mapboxAccessToken: "pk.test" },
  }),
  Link: {
    name: "Link",
    template: '<a :href="href"><slot /></a>',
    props: ["href"],
  },
}));

vi.mock("mapbox-gl", () => ({
  default: {
    Map: vi.fn(() => ({
      addControl: vi.fn(),
      fitBounds: vi.fn(),
      remove: vi.fn(),
    })),
    Marker: vi.fn(() => ({
      setLngLat: vi.fn().mockReturnThis(),
      setPopup: vi.fn().mockReturnThis(),
      addTo: vi.fn().mockReturnThis(),
      remove: vi.fn(),
    })),
    Popup: vi.fn(() => ({ setHTML: vi.fn().mockReturnThis() })),
    LngLatBounds: vi.fn(() => ({
      extend: vi.fn(),
      isEmpty: vi.fn().mockReturnValue(true),
    })),
    NavigationControl: vi.fn(),
    accessToken: "",
  },
}));

vi.mock("mapbox-gl/dist/mapbox-gl.css", () => ({}));

const makeCinema = (name, opts = {}) => ({
  name,
  latitude: opts.lat ?? -22.91,
  longitude: opts.lng ?? -43.17,
  capacidade: opts.capacidade ?? null,
  salas: opts.salas ?? undefined,
  cinema: {
    id: opts.id ?? 1,
    endereco: opts.endereco ?? "Rua Teste, 123",
    telefone: opts.telefone ?? null,
  },
});

const defaultProps = {
  cinemas: [
    makeCinema("Estação Botafogo", { id: 1, endereco: "Rua Voluntários da Pátria, 88", telefone: "2226-1988", capacidade: "200 lugares" }),
    makeCinema("Cine Odeon", { id: 2, endereco: "Praça Floriano, 7" }),
    makeCinema("Kinoplex São Luiz", {
      id: 3,
      endereco: "Rua do Catete, 311",
      salas: [
        { nome: "Sala 1", capacidade: "150 lugares" },
        { nome: "Sala 2", capacidade: "100 lugares" },
      ],
    }),
  ],
  crumbs: [
    { label: "Home", href: "/" },
    { label: "Cinemas", href: "/cinemas" },
  ],
};

const mountIndex = (propsOverride = {}) =>
  mount(Index, {
    props: { ...defaultProps, ...propsOverride },
    shallow: true,
    global: {
      stubs: {
        TwContainer: { template: "<div><slot /></div>" },
        MenuContext: { template: "<div />" },
        Breadcrumb: { template: "<div />" },
        SearchBar: {
          template: '<input @input="$emit(\'input\', $event)" />',
          emits: ["input"],
        },
        CinemaMap: { template: "<div data-testid='cinema-map' />" },
        IconPin: { template: "<span />" },
        IconPhone: { template: "<span />" },
        IconWholeTicket: { template: "<span />" },
        IconSeat: { template: "<span />" },
        IconArrowDown: { template: "<span />" },
        IconProgram: { template: "<span />" },
      },
    },
  });

describe("Cinemas/Index", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe("rendering cinema list", () => {
    it("renders all cinema names", () => {
      const wrapper = mountIndex();
      const names = wrapper.findAll(".cinema-name").map((el) => el.text());

      expect(names).toContain("Estação Botafogo");
      expect(names).toContain("Cine Odeon");
      expect(names).toContain("Kinoplex São Luiz");
    });

    it("displays cinema address when present", () => {
      const wrapper = mountIndex();

      expect(wrapper.text()).toContain("Rua Voluntários da Pátria, 88");
      expect(wrapper.text()).toContain("Praça Floriano, 7");
    });

    it("displays cinema phone when present", () => {
      const wrapper = mountIndex();

      expect(wrapper.text()).toContain("2226-1988");
    });

    it("does not render phone when absent", () => {
      const wrapper = mountIndex({
        cinemas: [makeCinema("Cinema Sem Tel", { telefone: null })],
      });

      const phoneBlocks = wrapper.findAll("div").filter(
        (d) => d.text().includes("2226-1988")
      );
      expect(phoneBlocks.length).toBe(0);
    });

    it("displays capacidade for single-room cinema", () => {
      const wrapper = mountIndex();

      expect(wrapper.text()).toContain("200 lugares");
    });

    it("displays salas for multi-room cinema", () => {
      const wrapper = mountIndex();

      expect(wrapper.text()).toContain("Sala 1 — 150 lugares");
      expect(wrapper.text()).toContain("Sala 2 — 100 lugares");
    });
  });

  describe("search filtering", () => {
    it("filters cinemas by name when typing in search bar", async () => {
      const wrapper = mountIndex();
      const input = wrapper.find("input");

      await input.setValue("Odeon");
      await input.trigger("input");

      const names = wrapper.findAll(".cinema-name").map((el) => el.text());
      expect(names).toEqual(["Cine Odeon"]);
    });

    it("shows all cinemas when search is cleared", async () => {
      const wrapper = mountIndex();
      const input = wrapper.find("input");

      await input.setValue("Odeon");
      await input.trigger("input");

      await input.setValue("");
      await input.trigger("input");

      const names = wrapper.findAll(".cinema-name").map((el) => el.text());
      expect(names).toHaveLength(3);
    });

    it("filters ignoring accents", async () => {
      const wrapper = mountIndex({
        cinemas: [
          makeCinema("Estação Botafogo"),
          makeCinema("Cine Odeon"),
        ],
      });
      const input = wrapper.find("input");

      await input.setValue("estacao");
      await input.trigger("input");

      const names = wrapper.findAll(".cinema-name").map((el) => el.text());
      expect(names).toEqual(["Estação Botafogo"]);
    });

    it("is case insensitive", async () => {
      const wrapper = mountIndex();
      const input = wrapper.find("input");

      await input.setValue("ODEON");
      await input.trigger("input");

      const names = wrapper.findAll(".cinema-name").map((el) => el.text());
      expect(names).toEqual(["Cine Odeon"]);
    });
  });

  describe("sort order toggle", () => {
    it("starts in A-Z order", () => {
      const wrapper = mountIndex();

      expect(wrapper.text()).toContain("A–Z");
    });

    it("toggles to Z-A on button click", async () => {
      const wrapper = mountIndex();
      const button = wrapper.find("button");

      await button.trigger("click");

      expect(wrapper.text()).toContain("Z–A");

      const names = wrapper.findAll(".cinema-name").map((el) => el.text());
      expect(names[0]).toBe("Kinoplex São Luiz");
      expect(names[names.length - 1]).toBe("Cine Odeon");
    });

    it("toggles back to A-Z on second click", async () => {
      const wrapper = mountIndex();
      const button = wrapper.find("button");

      await button.trigger("click");
      await button.trigger("click");

      expect(wrapper.text()).toContain("A–Z");

      const names = wrapper.findAll(".cinema-name").map((el) => el.text());
      expect(names[0]).toBe("Cine Odeon");
    });
  });

  describe("map integration", () => {
    it("renders the CinemaMap component", () => {
      const wrapper = mountIndex();

      expect(wrapper.find("[data-testid='cinema-map']").exists()).toBe(true);
    });
  });
});
