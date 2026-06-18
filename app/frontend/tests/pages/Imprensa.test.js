import { describe, it, expect, vi } from "vitest";
import { mount } from "@vue/test-utils";
import Index from "@/pages/Imprensa/Index.vue";

vi.mock("@inertiajs/vue3", () => ({
  Head: {
    name: "Head",
    template: "<div><slot /></div>",
  },
}));

describe("Imprensa Index", () => {
  it("renders the legacy title and html content as-is", () => {
    const wrapper = mount(Index, {
      props: {
        titulo: "Imprensa",
        conteudo: "<p>Conteúdo vindo do legado.</p><br>",
      },
    });

    expect(wrapper.find("h1").text()).toBe("Imprensa");
    expect(wrapper.find(".content").html()).toContain("<p>Conteúdo vindo do legado.</p>");
    expect(wrapper.find(".content").html()).toContain("<br>");
  });

  it("uses the gradient divider and content container", () => {
    const wrapper = mount(Index, {
      props: { titulo: "Imprensa", conteudo: "" },
    });

    expect(wrapper.find(".bg-gradient-to-r").exists()).toBe(true);
    expect(wrapper.find(".content").exists()).toBe(true);
  });
});
