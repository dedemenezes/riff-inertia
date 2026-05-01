import { describe, it, expect, vi, beforeEach } from "vitest";
import { mount } from "@vue/test-utils";
import CinemaMap from "@/components/features/cinemas/CinemaMap.vue";

const mockRemove = vi.fn();
const mockAddTo = vi.fn().mockReturnThis();
const mockSetPopup = vi.fn().mockReturnThis();
const mockSetLngLat = vi.fn().mockReturnThis();
const mockSetDOMContent = vi.fn().mockReturnThis();
const mockExtend = vi.fn();
const mockIsEmpty = vi.fn().mockReturnValue(false);
const mockFitBounds = vi.fn();
const mockAddControl = vi.fn();
const mockMapRemove = vi.fn();
const mockMarkerConstructor = vi.fn();

vi.mock("@inertiajs/vue3", () => ({
  usePage: () => ({
    props: { mapboxAccessToken: "pk.test-token" },
  }),
}));

vi.mock("@/assets/logos/festival-logo-mobile.svg?raw", () => ({
  default: '<svg xmlns="http://www.w3.org/2000/svg" width="85" height="29"><path d="M0 0"/></svg>',
}));

vi.mock("mapbox-gl", () => {
  class MarkerMock {
    constructor(opts) { mockMarkerConstructor(opts); }
    setLngLat(...args) { mockSetLngLat(...args); return this; }
    setPopup(...args) { mockSetPopup(...args); return this; }
    addTo(...args) { mockAddTo(...args); return this; }
    remove(...args) { mockRemove(...args); }
  }

  class PopupMock {
    constructor() {}
    setDOMContent(...args) { mockSetDOMContent(...args); return this; }
  }

  class MapMock {
    constructor() {}
    addControl(...args) { mockAddControl(...args); }
    fitBounds(...args) { mockFitBounds(...args); }
    remove(...args) { mockMapRemove(...args); }
  }

  class LngLatBoundsMock {
    constructor() {}
    extend(...args) { mockExtend(...args); }
    isEmpty() { return mockIsEmpty(); }
  }

  class NavigationControlMock {}

  return {
    default: {
      Map: MapMock,
      Marker: MarkerMock,
      Popup: PopupMock,
      LngLatBounds: LngLatBoundsMock,
      NavigationControl: NavigationControlMock,
      accessToken: "",
    },
  };
});

const cinemaWithCoords = (name, lat, lng, endereco = "Rua Teste, 123") => ({
  name,
  latitude: lat,
  longitude: lng,
  cinema: { id: 1, endereco },
});

const cinemaWithoutCoords = (name) => ({
  name,
  latitude: null,
  longitude: null,
  cinema: { id: 2, endereco: "Rua Sem Coords" },
});

describe("CinemaMap", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("renders a map container div", () => {
    const wrapper = mount(CinemaMap, {
      props: { cinemas: [] },
    });

    expect(wrapper.find("div").exists()).toBe(true);
  });

  it("creates markers for cinemas with coordinates", () => {
    const cinemas = [
      cinemaWithCoords("Cine Odeon", -22.91, -43.17),
      cinemaWithCoords("Estação Botafogo", -22.95, -43.18),
    ];

    mount(CinemaMap, { props: { cinemas } });

    expect(mockSetLngLat).toHaveBeenCalledTimes(2);
    expect(mockSetLngLat).toHaveBeenCalledWith([-43.17, -22.91]);
    expect(mockSetLngLat).toHaveBeenCalledWith([-43.18, -22.95]);
    expect(mockAddTo).toHaveBeenCalledTimes(2);
  });

  it("skips cinemas without coordinates", () => {
    const cinemas = [
      cinemaWithCoords("Cine Odeon", -22.91, -43.17),
      cinemaWithoutCoords("Parque Susana"),
    ];

    mount(CinemaMap, { props: { cinemas } });

    expect(mockSetLngLat).toHaveBeenCalledTimes(1);
    expect(mockAddTo).toHaveBeenCalledTimes(1);
  });

  it("creates no markers when all cinemas lack coordinates", () => {
    const cinemas = [
      cinemaWithoutCoords("Cinema A"),
      cinemaWithoutCoords("Cinema B"),
    ];

    mount(CinemaMap, { props: { cinemas } });

    expect(mockSetLngLat).not.toHaveBeenCalled();
    expect(mockFitBounds).not.toHaveBeenCalled();
  });

  it("fits bounds when cinemas have coordinates", () => {
    const cinemas = [
      cinemaWithCoords("Cine Odeon", -22.91, -43.17),
    ];

    mount(CinemaMap, { props: { cinemas } });

    expect(mockExtend).toHaveBeenCalledWith([-43.17, -22.91]);
    expect(mockFitBounds).toHaveBeenCalled();
  });

  it("creates popup with cinema name and address using safe DOM content", () => {
    const cinemas = [
      cinemaWithCoords("Cine Odeon", -22.91, -43.17, "Praça Floriano, 7"),
    ];

    mount(CinemaMap, { props: { cinemas } });

    expect(mockSetDOMContent).toHaveBeenCalledTimes(1);
    const popupEl = mockSetDOMContent.mock.calls[0][0];
    expect(popupEl.querySelector("strong").textContent).toBe("Cine Odeon");
    expect(popupEl.textContent).toContain("Praça Floriano, 7");
  });

  it("creates popup without address when endereco is missing", () => {
    const cinemas = [{
      name: "Cinema Teste",
      latitude: -22.91,
      longitude: -43.17,
      cinema: { id: 1 },
    }];

    mount(CinemaMap, { props: { cinemas } });

    expect(mockSetDOMContent).toHaveBeenCalledTimes(1);
    const popupEl = mockSetDOMContent.mock.calls[0][0];
    expect(popupEl.querySelector("strong").textContent).toBe("Cinema Teste");
    expect(popupEl.childNodes.length).toBe(1);
  });

  it("creates markers with custom SVG element instead of default pin", () => {
    const cinemas = [
      cinemaWithCoords("Cine Odeon", -22.91, -43.17),
    ];

    mount(CinemaMap, { props: { cinemas } });

    expect(mockMarkerConstructor).toHaveBeenCalledTimes(1);
    const opts = mockMarkerConstructor.mock.calls[0][0];
    expect(opts).toHaveProperty("element");
    expect(opts.element).toBeInstanceOf(HTMLElement);
    expect(opts.element.querySelector("svg")).not.toBeNull();
  });
});
