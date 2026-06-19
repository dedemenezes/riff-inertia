import { describe, it, expect, vi } from "vitest";
import { mount, flushPromises } from "@vue/test-utils";
import MostrasFilterForm from "@/components/features/filters/MostrasFilterForm.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: {
      currentLocale: "pt",
    },
  }),
}));

const stubs = {
  AccordionGroup: {
    props: ["text", "isOpen"],
    template: `
      <details :open="isOpen">
        <summary>{{ text }}</summary>
        <slot name="content" />
      </details>
    `,
  },
  ComboboxComponent: {
    props: ["collection", "modelValue", "placeholder"],
    template: `<div data-testid="combobox-control">{{ placeholder }}</div>`,
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

const baseProps = {
  modelValue: {},
  updateField: vi.fn(),
  submostras: [option("Mostra", "premiere-brasil"), option("Mostra", "novos-rumos")],
  genres: [option("Genero", "ficcao")],
  paises: [option("País", "brasil")],
  directors: [option("Direção", "alfonso-cuaron")],
  actors: [option("Elenco", "alice-braga")],
};

describe("MostrasFilterForm", () => {
  it("renders filter labels and fields without accordion markup", async () => {
    const wrapper = mount(MostrasFilterForm, { props: baseProps, global: { stubs } });
    await flushPromises();

    expect(wrapper.find("details").exists()).toBe(false);
    expect(wrapper.find("summary").exists()).toBe(false);

    ["Mostra", "Genero", "País", "Direção", "Elenco"].forEach((label) => {
      expect(wrapper.text()).toContain(label);
    });

    expect(wrapper.find('[data-testid="search-bar"]').exists()).toBe(true);
    expect(wrapper.findAll('[data-testid="combobox-control"]')).toHaveLength(5);
  });

  it("only renders the submostra field when there is more than one option", async () => {
    const wrapper = mount(MostrasFilterForm, {
      props: {
        ...baseProps,
        submostras: [option("Mostra", "premiere-brasil")],
      },
      global: { stubs },
    });
    await flushPromises();

    expect(wrapper.text()).not.toContain("Mostra");
    expect(wrapper.findAll('[data-testid="combobox-control"]')).toHaveLength(4);
  });
});
