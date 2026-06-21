import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";
import { h } from "vue";
import { parseDate } from "@internationalized/date";
import NewsDateRangePicker from "@/components/features/filters/NewsDateRangePicker.vue";

const passthrough = {
  template: `<div><slot /></div>`,
};

const stubs = {
  Popover: passthrough,
  PopoverTrigger: passthrough,
  PopoverContent: {
    template: `<div><slot /></div>`,
  },
  Button: {
    props: ["variant", "class"],
    template: `<button data-testid="button" :class="$props.class"><slot /></button>`,
  },
  CalendarIcon: {
    template: `<svg />`,
  },
  ChevronLeft: {
    template: `<svg />`,
  },
  ChevronRight: {
    template: `<svg />`,
  },
  RangeCalendarRoot: {
    props: ["modelValue", "defaultPlaceholder", "minValue", "maxValue", "numberOfMonths"],
    emits: ["update:modelValue"],
    setup(props, { emit, slots }) {
      return () =>
        h("div", {
          "data-testid": "range-calendar",
          "data-min": props.minValue?.toString(),
          "data-max": props.maxValue?.toString(),
          "data-default-placeholder": props.defaultPlaceholder?.toString(),
        }, [
          slots.default?.({ grid: [], weekDays: [] }),
          h("button", {
            "data-testid": "select-range",
            onClick: () => emit("update:modelValue", {
              start: parseDate("2024-10-04"),
              end: parseDate("2024-10-10"),
            }),
          }, "select range"),
        ]);
    },
  },
  RangeCalendarHeader: passthrough,
  RangeCalendarPrev: passthrough,
  RangeCalendarHeading: passthrough,
  RangeCalendarNext: passthrough,
  RangeCalendarGrid: passthrough,
  RangeCalendarGridHead: passthrough,
  RangeCalendarGridRow: passthrough,
  RangeCalendarHeadCell: passthrough,
  RangeCalendarGridBody: passthrough,
  RangeCalendarCell: passthrough,
  RangeCalendarCellTrigger: passthrough,
};

describe("NewsDateRangePicker", () => {
  it("formats the selected range and forwards calendar bounds", () => {
    const wrapper = mount(NewsDateRangePicker, {
      props: {
        modelValue: {
          filter_params: {
            data_inicio: "2024-10-04",
            data_fim: "2024-10-10",
          },
        },
        label: "Data de publicação",
        locale: "pt-BR",
        min: "2024-10-02",
        max: "2024-10-23",
        defaultMonth: "2024-10-02",
      },
      global: { stubs },
    });

    expect(wrapper.find('[data-testid="button"]').text()).toContain("4 de outubro de 2024");
    expect(wrapper.find('[data-testid="button"]').text()).toContain("10 de outubro de 2024");
    expect(wrapper.find('[data-testid="range-calendar"]').attributes("data-min")).toBe("2024-10-02");
    expect(wrapper.find('[data-testid="range-calendar"]').attributes("data-max")).toBe("2024-10-23");
    expect(wrapper.find('[data-testid="range-calendar"]').attributes("data-default-placeholder")).toBe("2024-10-02");
  });

  it("emits one visual filter with multiple query params", async () => {
    const wrapper = mount(NewsDateRangePicker, {
      props: {
        label: "Data de publicação",
      },
      global: { stubs },
    });

    await wrapper.find('[data-testid="select-range"]').trigger("click");

    expect(wrapper.emitted("update:modelValue")[0][0]).toEqual({
      filter_display: "2024-10-04 - 2024-10-10",
      filter_value: "2024-10-04..2024-10-10",
      filter_label: "Data de publicação",
      filter_params: {
        data_inicio: "2024-10-04",
        data_fim: "2024-10-10",
      },
    });
  });
});
