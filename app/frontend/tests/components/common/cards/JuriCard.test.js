import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";
import JuriCard from "@components/common/cards/JuriCard.vue";

const baseProps = {
  photo: "https://example.com/mercedes.jpg",
  name: "Mercedes Morán",
};

describe("JuriCard", () => {
  it("renders name and photo", () => {
    const wrapper = mount(JuriCard, { props: baseProps });

    expect(wrapper.text()).toContain("Mercedes Morán");
    const img = wrapper.find("img");
    expect(img.attributes("src")).toBe(baseProps.photo);
    expect(img.attributes("alt")).toBe(baseProps.name);
  });

  it("uses compact mobile image sizing from the jury design", () => {
    const wrapper = mount(JuriCard, { props: baseProps });

    const img = wrapper.find("img");
    expect(img.classes()).toContain("size-[107px]");
    expect(img.classes()).toContain("md:size-[180px]");
    expect(img.classes()).toContain("rounded-100");
  });

  it("renders role when provided", () => {
    const wrapper = mount(JuriCard, {
      props: { ...baseProps, role: "Presidenta do júri" },
    });

    expect(wrapper.text()).toContain("Presidenta do júri");
  });

  it("does not render role paragraph when omitted", () => {
    const wrapper = mount(JuriCard, { props: baseProps });

    expect(wrapper.findAll("p")).toHaveLength(1);
  });

  it("renders bio passed as string", () => {
    const wrapper = mount(JuriCard, {
      props: { ...baseProps, bio: "Atriz argentina." },
    });

    expect(wrapper.text()).toContain("Atriz argentina.");
    expect(wrapper.findAll("p")).toHaveLength(2);
  });

  it("renders bio passed as array of paragraphs", () => {
    const wrapper = mount(JuriCard, {
      props: { ...baseProps, bio: [ "Para 1.", "Para 2.", "Para 3." ] },
    });

    expect(wrapper.text()).toContain("Para 1.");
    expect(wrapper.text()).toContain("Para 3.");
    expect(wrapper.findAll("p")).toHaveLength(4);
  });

  it("does not render bio when empty array", () => {
    const wrapper = mount(JuriCard, {
      props: { ...baseProps, bio: [] },
    });

    expect(wrapper.findAll("p")).toHaveLength(1);
  });

  it("does not render bio when empty string", () => {
    const wrapper = mount(JuriCard, {
      props: { ...baseProps, bio: "" },
    });

    expect(wrapper.findAll("p")).toHaveLength(1);
  });

  it("uses default bio class by default", () => {
    const wrapper = mount(JuriCard, {
      props: { ...baseProps, bio: "Bio text." },
    });

    const bioParagraph = wrapper.findAll("p").at(-1);
    expect(bioParagraph.classes()).toContain("text-body-regular");
  });

  it("uses double-spaced bio class when bioVariant is 'double-spaced'", () => {
    const wrapper = mount(JuriCard, {
      props: { ...baseProps, bio: "Bio text.", bioVariant: "double-spaced" },
    });

    const bioParagraph = wrapper.findAll("p").at(-1);
    expect(bioParagraph.classes()).toContain("text-body-regular-double");
    expect(bioParagraph.classes()).not.toContain("text-body-regular");
  });
});
