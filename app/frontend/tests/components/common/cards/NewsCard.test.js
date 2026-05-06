import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";
import NewsCard from "@components/common/cards/NewsCard.vue";

const baseProps = {
  image: "https://example.com/foo.jpg",
  title: "Talents Rio 2025",
  date: "22.07.2025",
  category: "TALENTS RIO",
  permalink: "/pt/noticias/talents-rio-2025",
};

const stubs = { Link: { template: "<a><slot /></a>", props: ["href"] } };

describe("NewsCard", () => {
  it("renders image, title, date and category", () => {
    const wrapper = mount(NewsCard, { props: baseProps, global: { stubs } });

    expect(wrapper.text()).toContain("Talents Rio 2025");
    expect(wrapper.text()).toContain("22.07.2025");
    expect(wrapper.text()).toContain("TALENTS RIO");
    const img = wrapper.findAll("img").find((i) => i.attributes("src") === baseProps.image);
    expect(img).toBeTruthy();
    expect(img.attributes("alt")).toBe(baseProps.title);
  });

  it("renders content paragraph on principal variant", () => {
    const wrapper = mount(NewsCard, {
      props: { ...baseProps, content: "Lede here." },
      global: { stubs },
    });

    expect(wrapper.text()).toContain("Lede here.");
  });

  it("does not render content on secundaria variant", () => {
    const wrapper = mount(NewsCard, {
      props: { ...baseProps, variant: "secundaria", content: "Hidden lede." },
      global: { stubs },
    });

    expect(wrapper.text()).not.toContain("Hidden lede.");
  });

  it("clamps title on secundaria variant", () => {
    const wrapper = mount(NewsCard, {
      props: { ...baseProps, variant: "secundaria" },
      global: { stubs },
    });

    expect(wrapper.find("h3").classes()).toContain("line-clamp-3");
  });

  it("clamps title and truncates content on horizontal-2 variant", () => {
    const wrapper = mount(NewsCard, {
      props: { ...baseProps, variant: "horizontal-2", content: "Lede." },
      global: { stubs },
    });

    expect(wrapper.find("h3").classes()).toContain("line-clamp-4");
    expect(wrapper.find("p").classes()).toContain("truncate");
  });

  it("renders content on horizontal variant without truncate", () => {
    const wrapper = mount(NewsCard, {
      props: { ...baseProps, variant: "horizontal", content: "Lede." },
      global: { stubs },
    });

    const p = wrapper.find("p");
    expect(p.exists()).toBe(true);
    expect(p.classes()).not.toContain("truncate");
  });

  it("does not render paragraph when content empty", () => {
    const wrapper = mount(NewsCard, {
      props: { ...baseProps, variant: "principal" },
      global: { stubs },
    });

    expect(wrapper.find("p").exists()).toBe(false);
  });

  it("validates variant prop", () => {
    const validator = NewsCard.props.variant.validator;
    expect(validator("principal")).toBe(true);
    expect(validator("secundaria")).toBe(true);
    expect(validator("horizontal")).toBe(true);
    expect(validator("horizontal-2")).toBe(true);
    expect(validator("bogus")).toBe(false);
  });
});
