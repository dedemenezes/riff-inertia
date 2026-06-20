import { afterEach, describe, expect, it, vi } from "vitest";
import { mount } from "@vue/test-utils";
import { computed, nextTick } from "vue";
import { useTabScroll } from "@/components/common/tabs/useTabScroll";

const Harness = {
  props: {
    active: { type: Boolean, default: false },
  },
  setup(props) {
    const tabRef = useTabScroll(computed(() => props.active));

    return { tabRef };
  },
  template: `
    <div class="overflow-x-auto" data-test="container">
      <div ref="tabRef" data-test="tab">Tab</div>
    </div>
  `,
};

function stubScrollGeometry(wrapper) {
  const container = wrapper.find("[data-test='container']").element;
  const tab = wrapper.find("[data-test='tab']").element;

  Object.defineProperty(container, "getBoundingClientRect", {
    configurable: true,
    value: () => ({ width: 100 }),
  });
  Object.defineProperty(tab, "getBoundingClientRect", {
    configurable: true,
    value: () => ({ width: 20 }),
  });
  Object.defineProperty(tab, "offsetLeft", {
    configurable: true,
    value: 80,
  });

  return container;
}

describe("useTabScroll", () => {
  afterEach(() => {
    vi.useRealTimers();
  });

  it("centers the tab when the active state becomes true", async () => {
    vi.useFakeTimers();
    const wrapper = mount(Harness, { props: { active: false } });
    const container = stubScrollGeometry(wrapper);

    await wrapper.setProps({ active: true });
    await vi.advanceTimersByTimeAsync(50);
    await nextTick();

    expect(container.scrollLeft).toBe(40);
  });
});
