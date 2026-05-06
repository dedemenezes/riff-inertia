import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";
import NavTab from "@components/common/tabs/NavTab.vue";

const LinkStub = {
  name: "Link",
  props: ["href"],
  template: '<a :href="href"><slot /></a>',
};

const mountTab = (props = {}, slotContent = "SOBRE") =>
  mount(NavTab, {
    props: { href: "/about", ...props },
    slots: { default: slotContent },
    global: { stubs: { Link: LinkStub } },
  });

describe("NavTab", () => {
  it("renders slot label inside link", () => {
    const wrapper = mountTab();

    const link = wrapper.find("a");
    expect(link.exists()).toBe(true);
    expect(link.attributes("href")).toBe("/about");
    expect(link.text()).toBe("SOBRE");
  });

  it("applies active text and gradient indicator when active", () => {
    const wrapper = mountTab({ active: true });

    const label = wrapper.find("span.text-body-strong-sm");
    expect(label.classes()).toContain("text-primary");

    const indicator = wrapper.findAll("span").at(-1);
    expect(indicator.classes()).toContain("bg-gradient-to-r");
    expect(indicator.classes()).toContain("from-magenta-600");
    expect(indicator.classes()).toContain("to-laranja-600");
  });

  it("applies muted text and transparent indicator when inactive", () => {
    const wrapper = mountTab({ active: false });

    const label = wrapper.find("span.text-body-strong-sm");
    expect(label.classes()).toContain("text-secondary-gray");

    const indicator = wrapper.findAll("span").at(-1);
    expect(indicator.classes()).toContain("bg-transparent");
    expect(indicator.classes()).not.toContain("bg-gradient-to-r");
  });
});
