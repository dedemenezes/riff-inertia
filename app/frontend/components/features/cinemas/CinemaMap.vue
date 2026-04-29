<script setup>
import { ref, onMounted, onUnmounted, watch } from "vue";
import { usePage } from "@inertiajs/vue3";
import mapboxgl from "mapbox-gl";

const props = defineProps({
  cinemas: { type: Array, required: true },
});

const mapContainer = ref(null);
let map = null;
const markers = ref([]);

const RIO_CENTER = [-43.1729, -22.9068];

const buildMap = () => {
  const page = usePage();
  mapboxgl.accessToken = page.props.mapboxAccessToken;

  map = new mapboxgl.Map({
    container: mapContainer.value,
    style: "mapbox://styles/mapbox/streets-v12",
    center: RIO_CENTER,
    zoom: 11,
  });

  map.addControl(new mapboxgl.NavigationControl(), "top-right");

  syncMarkers(props.cinemas);
};

const syncMarkers = (cinemas) => {
  markers.value.forEach((m) => m.remove());
  markers.value = [];

  const bounds = new mapboxgl.LngLatBounds();
  let hasCoords = false;

  cinemas.forEach((cinema) => {
    if (cinema.latitude == null || cinema.longitude == null) return;

    hasCoords = true;
    const lngLat = [cinema.longitude, cinema.latitude];

    const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(
      `<strong>${cinema.name}</strong>${cinema.cinema?.endereco ? `<br>${cinema.cinema.endereco}` : ""}`
    );

    const marker = new mapboxgl.Marker({ color: "#FF007F" })
      .setLngLat(lngLat)
      .setPopup(popup)
      .addTo(map);

    markers.value.push(marker);
    bounds.extend(lngLat);
  });

  if (hasCoords && !bounds.isEmpty()) {
    map.fitBounds(bounds, { padding: 60, maxZoom: 14 });
  }
};

watch(
  () => props.cinemas,
  (newCinemas) => {
    if (map) syncMarkers(newCinemas);
  },
  { deep: true }
);

onMounted(() => {
  buildMap();
});

onUnmounted(() => {
  markers.value.forEach((m) => m.remove());
  if (map) map.remove();
});
</script>

<template>
  <div ref="mapContainer" class="w-full h-full min-h-[400px] rounded-lg" />
</template>
