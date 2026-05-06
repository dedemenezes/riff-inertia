import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";
import SectionHeader from "@components/common/SectionHeader.vue";

describe("SectionHeader", () => {
  it("renders slot content inside h2", () => {
    const wrapper = mount(SectionHeader, {
      slots: { default: "Coordenadores" },
    });

    const heading = wrapper.find("h2");
    expect(heading.exists()).toBe(true);
    expect(heading.text()).toBe("Coordenadores");
  });

  it("applies header typography classes", () => {
    const wrapper = mount(SectionHeader, {
      slots: { default: "Title" },
    });

    const heading = wrapper.find("h2");
    expect(heading.classes()).toContain("text-header-xl");
    expect(heading.classes()).toContain("text-primary");
  });

  it("renders gradient divider below heading", () => {
    const wrapper = mount(SectionHeader, {
      slots: { default: "Title" },
    });

    const divider = wrapper.find("div.h-px");
    expect(divider.exists()).toBe(true);
    expect(divider.classes()).toContain("bg-gradient-to-r");
    expect(divider.classes()).toContain("from-magenta-600");
    expect(divider.classes()).toContain("to-laranja-600");
  });
});
