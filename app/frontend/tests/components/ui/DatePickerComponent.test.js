import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";
import DatePickerComponent from "@/components/ui/DatePickerComponent.vue";

const stubs = {
  Popover: {
    template: `<div><slot /></div>`,
  },
  PopoverTrigger: {
    template: `<div><slot /></div>`,
  },
  PopoverContent: {
    props: ["align", "class"],
    template: `<div data-testid="popover-content" :data-align="align" :class="$props.class"><slot /></div>`,
  },
  Button: {
    props: ["variant", "class"],
    template: `<button data-testid="datepicker-trigger" :data-variant="variant" :class="$props.class"><slot /></button>`,
  },
  Calendar: {
    template: `<div data-testid="calendar" />`,
  },
  CalendarIcon: {
    props: ["class"],
    template: `<svg data-testid="calendar-icon" :class="$props.class" />`,
  },
};

describe("DatePickerComponent", () => {
  it("matches the filter input visual language", () => {
    const wrapper = mount(DatePickerComponent, {
      props: {
        placeholder: "Escolha uma data",
        locale: "pt-BR",
      },
      global: { stubs },
    });

    const trigger = wrapper.find('[data-testid="datepicker-trigger"]');
    expect(trigger.text()).toContain("Escolha uma data");
    expect(trigger.classes()).toContain("h-[45px]");
    expect(trigger.classes()).toContain("rounded-[5px]");
    expect(trigger.classes()).toContain("border-neutrals-300");
    expect(trigger.classes()).toContain("text-neutrals-400");

    const popover = wrapper.find('[data-testid="popover-content"]');
    expect(popover.classes()).toContain("w-auto");
    expect(popover.classes()).not.toContain("min-w-[var(--reka-popper-anchor-width)]");
  });

  it("formats selected values with the provided locale", () => {
    const wrapper = mount(DatePickerComponent, {
      props: {
        modelValue: "2024-10-04",
        locale: "pt-BR",
      },
      global: { stubs },
    });

    expect(wrapper.find('[data-testid="datepicker-trigger"]').text()).toContain("4 de outubro de 2024");
  });
});
