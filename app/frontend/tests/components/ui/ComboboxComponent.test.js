import { describe, expect, it } from "vitest";
import { mount } from "@vue/test-utils";
import ComboboxComponent from "@/components/ui/ComboboxComponent.vue";

const stubs = {
  Button: {
    props: ["variant", "class"],
    template: `<button data-testid="combobox-trigger" :data-variant="variant" :class="$props.class"><slot /></button>`,
  },
  Popover: {
    template: `<div><slot /></div>`,
  },
  PopoverTrigger: {
    template: `<div><slot /></div>`,
  },
  PopoverContent: {
    template: `<div><slot /></div>`,
  },
  Command: {
    template: `<div><slot /></div>`,
  },
  CommandInput: {
    template: `<input />`,
  },
  CommandEmpty: {
    template: `<div><slot /></div>`,
  },
  CommandList: {
    template: `<div><slot /></div>`,
  },
  CommandGroup: {
    template: `<div><slot /></div>`,
  },
  CommandItem: {
    props: ["value"],
    template: `<div><slot /></div>`,
  },
  Check: {
    template: `<span />`,
  },
  ChevronsUpDown: {
    template: `<span />`,
  },
};

describe("ComboboxComponent", () => {
  it("uses the shared Figma input field styling for its trigger", () => {
    const wrapper = mount(ComboboxComponent, {
      props: {
        collection: [{ label: "Assunto", value: "assunto" }],
        placeholder: "Escolha um(a)",
      },
      global: { stubs },
    });

    const trigger = wrapper.find('[data-testid="combobox-trigger"]');

    expect(trigger.classes()).toContain("h-[45px]");
    expect(trigger.classes()).toContain("rounded-100");
    expect(trigger.classes()).toContain("border-neutrals-300");
    expect(trigger.classes()).toContain("bg-white");
    expect(trigger.classes()).toContain("px-300");
    expect(trigger.classes()).toContain("py-300");
    expect(trigger.classes()).toContain("font-body");
    expect(trigger.classes()).toContain("text-sm");
    expect(trigger.classes()).toContain("leading-[150%]");
  });
});
