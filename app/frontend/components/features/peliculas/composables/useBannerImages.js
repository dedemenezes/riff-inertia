import { ref, computed, watch, toValue } from 'vue';

export function useBannerImages(pelicula) {
  const pswpDims = ref(new Map());
  const brokenSrcs = ref(new Set());

  function preloadDims(url) {
    if (!url || pswpDims.value.has(url)) return;
    const img = new Image();
    img.onload = () => {
      if (img.naturalWidth > 0) {
        pswpDims.value = new Map(pswpDims.value).set(url, {
          w: img.naturalWidth,
          h: img.naturalHeight
        });
      }
    };
    img.src = url;
  }

  watch(
    () => {
      const p = toValue(pelicula);
      return [p?.imageURL, ...(p?.carousel_images ?? []).map((i) => i.path)];
    },
    (urls) => urls.forEach(preloadDims),
    { immediate: true }
  );

  function mainImageEntry(p) {
    const src = p.banner_image?.src ?? p.imageURL;
    if (brokenSrcs.value.has(src)) return null;
    return {
      href: p.imageURL,
      src,
      srcset: p.banner_image?.srcset,
      sizes: p.banner_image?.sizes,
      ...dimsFor(p.imageURL)
    };
  }

  function dimsFor(url) {
    const d = pswpDims.value.get(url);
    return { pswpWidth: d?.w ?? 1920, pswpHeight: d?.h ?? 1080 };
  }

  function carouselEntries(p) {
    return (p.carousel_images ?? [])
      .filter((img) => !brokenSrcs.value.has(img.path))
      .map((img) => ({ href: img.path, src: img.path, ...dimsFor(img.path) }));
  }

  const bannerImages = computed(() => {
    const p = toValue(pelicula);
    if (!p?.imageURL) return [];

    const main = mainImageEntry(p);
    return [main, ...carouselEntries(p)].filter(Boolean);
  });

  function onImageError(src) {
    brokenSrcs.value = new Set([...brokenSrcs.value, src]);
  }

  return { bannerImages, onImageError, pswpDims };
}
