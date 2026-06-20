import { describe, expect, it, vi } from "vitest";
import { mount } from "@vue/test-utils";
import ProgramSessionTypeNav from "@/components/features/program/ProgramSessionTypeNav.vue";

const IconStub = {
  template: "<span data-test='icon' />",
};

vi.mock("@/components/common/icons/misc/IconProgram.vue", () => ({ default: IconStub }));
vi.mock("@/components/common/icons/misc/IconStar.vue", () => ({ default: IconStub }));
vi.mock("@/components/common/icons/misc/IconTicket.vue", () => ({ default: IconStub }));
vi.mock("@/components/common/icons/misc/IconChatDots.vue", () => ({ default: IconStub }));

vi.mock("@inertiajs/vue3", () => ({
  Link: {
    name: "Link",
    props: {
      href: { type: String, required: true },
      only: { type: Array, default: () => [] },
      preserveState: { type: Boolean, default: false },
      preserveScroll: { type: Boolean, default: false },
      replace: { type: Boolean, default: false },
    },
    template: `
      <a
        :href="href"
        :data-only="only.join(',')"
        :data-preserve-state="String(preserveState)"
        :data-preserve-scroll="String(preserveScroll)"
        :data-replace="String(replace)"
      >
        <slot />
      </a>
    `,
  },
  usePage: () => ({ url: "/pt/programacao" }),
}));

const items = [
  {
    label: "Programação",
    href: "/pt/programacao",
    icon: "program",
    session_type: null,
    active: false,
  },
  {
    label: "Sessões especiais",
    href: "/pt/programacao?tipo_sessao=especial",
    icon: "star",
    session_type: "especial",
    active: true,
  },
];

const mountNav = () => mount(ProgramSessionTypeNav, { props: { items } });

describe("ProgramSessionTypeNav", () => {
  it("renders the session type labels", () => {
    const wrapper = mountNav();

    expect(wrapper.text()).toContain("Programação");
    expect(wrapper.text()).toContain("Sessões especiais");
  });

  it("configures links as partial Inertia reloads", () => {
    const wrapper = mountNav();
    const links = wrapper.findAll("a");
    const partialProps = links[0].attributes("data-only").split(",");

    expect(links).toHaveLength(2);
    expect(links[1].attributes("href")).toBe("/pt/programacao?tipo_sessao=especial");
    expect(partialProps).toEqual(expect.arrayContaining([
      "elements",
      "pagy",
      "session_type_nav",
      "current_session_type",
      "current_filters",
      "has_active_filters",
    ]));
    expect(links[0].attributes("data-preserve-state")).toBe("true");
    expect(links[0].attributes("data-preserve-scroll")).toBe("true");
    expect(links[0].attributes("data-replace")).toBe("true");
  });
});
