import { describe, it, expect, vi } from "vitest";
import { mount, flushPromises } from "@vue/test-utils";
import NoticiasFilterForm from "@/components/features/filters/NoticiasFilterForm.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: {
      currentLocale: "pt",
      locale_messages: {
        placeholder: {
          select: "Escolha um(a)",
        },
      },
    },
  }),
}));

const stubs = {
  NewsDateRangePicker: {
    props: ["modelValue", "placeholder", "locale", "label", "min", "max", "defaultMonth", "clearLabel"],
    template: `
      <button
        data-testid="date-picker"
        :data-min="min"
        :data-max="max"
        :data-default-month="defaultMonth"
        @click="$emit('update:modelValue', {
          filter_display: '2024-10-04 - 2024-10-10',
          filter_value: '2024-10-04..2024-10-10',
          filter_label: label,
          filter_params: { data_inicio: '2024-10-04', data_fim: '2024-10-10' },
        })"
      >
        {{ placeholder }} {{ locale }} {{ clearLabel }}
      </button>
    `,
  },
  ComboboxComponent: {
    props: ["collection", "modelValue", "placeholder"],
    template: `<button data-testid="caderno-combobox" @click="$emit('update:modelValue', 'talents-rio')">{{ placeholder }}</button>`,
  },
  SearchBar: {
    props: ["modelValue"],
    template: `<input data-testid="keyword-search" :value="modelValue" @input="$emit('update:modelValue', $event.target.value)" />`,
  },
};

const caderno = {
  filter_label: "Caderno",
  filter_display: "Talents Rio",
  filter_value: "talents-rio",
};

describe("NoticiasFilterForm", () => {
  it("renders publication date, subject and keyword fields", async () => {
    const wrapper = mount(NoticiasFilterForm, {
      props: {
        modelValue: {},
        updateField: vi.fn(),
        dataLabel: "Data de publicação",
        dateFilter: {
          min: "2024-10-02",
          max: "2024-10-23",
          default_month: "2024-10-02",
        },
        cadernos: [caderno],
      },
      global: { stubs },
    });
    await flushPromises();

    expect(wrapper.text()).toContain("Data de publicação");
    expect(wrapper.text()).toContain("Escolha uma data pt-BR Limpar");
    expect(wrapper.text()).toContain("Assunto");
    expect(wrapper.text()).toContain("Palavra-chave");
    expect(wrapper.find('[data-testid="date-picker"]').exists()).toBe(true);
    expect(wrapper.find('[data-testid="date-picker"]').attributes("data-min")).toBe("2024-10-02");
    expect(wrapper.find('[data-testid="date-picker"]').attributes("data-max")).toBe("2024-10-23");
    expect(wrapper.find('[data-testid="date-picker"]').attributes("data-default-month")).toBe("2024-10-02");
    expect(wrapper.find('[data-testid="caderno-combobox"]').exists()).toBe(true);
    expect(wrapper.find('[data-testid="keyword-search"]').exists()).toBe(true);
  });

  it("updates data, caderno and query fields", async () => {
    const updateField = vi.fn();
    const wrapper = mount(NoticiasFilterForm, {
      props: {
        modelValue: {},
        updateField,
        dataLabel: "Data de publicação",
        cadernos: [caderno],
      },
      global: { stubs },
    });
    await flushPromises();

    await wrapper.find('[data-testid="date-picker"]').trigger("click");
    await wrapper.find('[data-testid="caderno-combobox"]').trigger("click");
    await wrapper.find('[data-testid="keyword-search"]').setValue("paradiso");

    expect(updateField).toHaveBeenCalledWith("data", {
      filter_display: "2024-10-04 - 2024-10-10",
      filter_value: "2024-10-04..2024-10-10",
      filter_label: "Data de publicação",
      filter_params: { data_inicio: "2024-10-04", data_fim: "2024-10-10" },
    });
    expect(updateField).toHaveBeenCalledWith("caderno", caderno);
    expect(updateField).toHaveBeenCalledWith("query", {
      filter_display: "paradiso",
      filter_value: "paradiso",
      filter_label: "Busca",
    });
  });
});
