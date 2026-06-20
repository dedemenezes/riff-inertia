import { describe, expect, it, vi } from "vitest";
import { mount } from "@vue/test-utils";
import SearchBar from "@/components/features/filters/SearchBar.vue";

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: {
      currentLocale: "pt",
    },
  }),
}));

describe("SearchBar", () => {
  it("uses the shared Figma input field styling", () => {
    const wrapper = mount(SearchBar, {
      global: {
        stubs: {
          IconSearch: { template: "<span />" },
          IconClose: { template: "<span />" },
        },
      },
    });

    const input = wrapper.find("input");

    expect(input.classes()).toContain("h-[45px]");
    expect(input.classes()).toContain("rounded-100");
    expect(input.classes()).toContain("border-neutrals-300");
    expect(input.classes()).toContain("bg-white");
    expect(input.classes()).toContain("py-300");
    expect(input.classes()).toContain("font-body");
    expect(input.classes()).toContain("text-sm");
    expect(input.classes()).toContain("leading-[150%]");
  });
});
