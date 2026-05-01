import { describe, it, expect, beforeEach } from "vitest";
import { mount } from "@vue/test-utils";
import BaseButton from "@components/common/buttons/BaseButton.vue";

describe("BaseButton", () => {
  it("renders button by default", () => {
    const wrapper = mount(BaseButton, {
      slots: {
        default: "Click me!",
      },
    });

    const button = wrapper.find("button");
    expect(button.exists()).toBe(true);
    expect(button.text()).toBe("Click me!");
  });

  it("renders anchor when as='a'", () => {
    const wrapper = mount(BaseButton, {
      props: {
        as: "a",
      },
      slots: {
        default: "Anchor tag",
      },
    });

    const anchor_tag = wrapper.find("a");
    expect(anchor_tag.exists()).toBe(true);
    expect(anchor_tag.text()).toBe("Anchor tag");
  });

  it("is disabled when disabled=true", () => {
    const wrapper = mount(BaseButton, {
      props: {
        disabled: true,
      },
      slots: {
        default: "Disabled",
      },
    });

    const button = wrapper.find("button");
    expect(button.attributes("disabled")).toBeDefined();
  });

  it("applies type attribute when as='button'", () => {
    const wrapper = mount(BaseButton, {
      props: {
        type: "submit",
      },
      slots: {
        default: "Button tag",
      },
    });

    expect(wrapper.find("button").attributes("type")).toBe("submit");
  });

  it("does not applies type attribute when as='a'", () => {
    const wrapper = mount(BaseButton, {
      props: {
        as: "a",
        type: "submit",
      },
      slots: {
        default: "Anchor tag",
      },
    });

    expect(wrapper.find("a").attributes("type")).toBeUndefined();
  });

  it("applies variant classes correctly", () => {
    const wrapper = mount(BaseButton, {
      props: {
        variant: "cta",
      },
      slots: {
        default: "CTA Button",
      },
    });

    expect(wrapper.find("button").classes()).toContain("bg-gradient-to-r");
  });

  it.each([
    ["dark", "bg-neutrals-900"],
    ["gray", "bg-neutrals-200"],
    ["rioMarket", "bg-vermelho-600"],
  ])("applies %s variant with expected class", (variant, expectedClass) => {
    const wrapper = mount(BaseButton, {
      props: { variant },
      slots: {
        default: "Button",
      },
    });

    expect(wrapper.find("button").classes()).toContain(expectedClass);
  });
});
