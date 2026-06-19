import { describe, it, expect, vi } from "vitest";
import { mount, flushPromises } from "@vue/test-utils";
import ProgramsFilterForm from "@/components/features/filters/ProgramsFilterForm.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: {
      currentLocale: "pt",
    },
  }),
}));

const stubs = {
  ComboboxComponent: {
    props: ["collection", "modelValue", "placeholder"],
    template: `<div data-testid="combobox-control">{{ placeholder }}</div>`,
  },
  SelectComponent: {
    props: ["collection", "modelValue"],
    template: `<select data-testid="select-control"></select>`,
  },
  SearchBar: {
    props: ["modelValue"],
    template: `<input data-testid="search-bar" />`,
  },
};

const option = (label, value = "value") => ({
  filter_label: label,
  filter_display: value,
  filter_value: value,
});

const props = {
  modelValue: {},
  updateField: vi.fn(),
  sessoes: [option("Sessão", "20:00")],
  mostras: [option("Mostra", "premiere-brasil")],
  cinemas: [option("Cinema", "cine-odeon")],
  genres: [option("Genero", "ficcao")],
  paises: [option("País", "brasil")],
  directors: [option("Direção", "alfonso-cuaron")],
  actors: [option("Elenco", "alice-braga")],
};

describe("ProgramsFilterForm", () => {
  it("renders filter labels and fields without accordion markup", async () => {
    const wrapper = mount(ProgramsFilterForm, { props, global: { stubs } });
    await flushPromises();

    expect(wrapper.find("details").exists()).toBe(false);
    expect(wrapper.find("summary").exists()).toBe(false);

    ["Sessão", "Mostra", "Cinema", "Genero", "País", "Direção", "Elenco"].forEach((label) => {
      expect(wrapper.text()).toContain(label);
    });

    expect(wrapper.find('[data-testid="search-bar"]').exists()).toBe(true);
    expect(wrapper.find('[data-testid="select-control"]').exists()).toBe(true);
    expect(wrapper.findAll('[data-testid="combobox-control"]')).toHaveLength(6);
  });
});
