import { describe, it, expect } from 'vitest'
import { ref } from 'vue'
import { useBannerImages } from '../useBannerImages.js'

const BASE_PELICULA = {
  imageURL: 'https://cdn.example.com/film_f01.jpg',
  banner_image: {
    src: 'https://cdn.example.com/film_f01_large.jpg',
    srcset: 'https://cdn.example.com/film_f01_large.jpg 300w, https://cdn.example.com/film_f01.jpg 1920w',
    sizes: '100vw'
  },
  carousel_images: [
    { path: 'https://cdn.example.com/film_f02.jpg' },
    { path: 'https://cdn.example.com/film_f03.jpg' }
  ]
}

describe('useBannerImages', () => {
  describe('bannerImages', () => {
    it('returns empty array when pelicula has no imageURL', () => {
      const pelicula = ref({ imageURL: null, carousel_images: [] })
      const { bannerImages } = useBannerImages(pelicula)
      expect(bannerImages.value).toEqual([])
    })

    it('includes main image as first entry', () => {
      const pelicula = ref({ ...BASE_PELICULA, carousel_images: [] })
      const { bannerImages } = useBannerImages(pelicula)
      expect(bannerImages.value[0]).toMatchObject({
        href: BASE_PELICULA.imageURL,
        src: BASE_PELICULA.banner_image.src,
        srcset: BASE_PELICULA.banner_image.srcset,
        sizes: BASE_PELICULA.banner_image.sizes
      })
    })

    it('uses imageURL as src when banner_image is absent', () => {
      const pelicula = ref({ imageURL: 'https://cdn.example.com/film_f01.jpg', banner_image: null, carousel_images: [] })
      const { bannerImages } = useBannerImages(pelicula)
      expect(bannerImages.value[0].src).toBe('https://cdn.example.com/film_f01.jpg')
    })

    it('appends carousel images after main image', () => {
      const pelicula = ref({ ...BASE_PELICULA })
      const { bannerImages } = useBannerImages(pelicula)
      expect(bannerImages.value).toHaveLength(3)
      expect(bannerImages.value[1].href).toBe('https://cdn.example.com/film_f02.jpg')
      expect(bannerImages.value[2].href).toBe('https://cdn.example.com/film_f03.jpg')
    })

    it('defaults pswp dims to 1920x1080 when not preloaded', () => {
      const pelicula = ref({ ...BASE_PELICULA })
      const { bannerImages } = useBannerImages(pelicula)
      bannerImages.value.forEach((img) => {
        expect(img.pswpWidth).toBe(1920)
        expect(img.pswpHeight).toBe(1080)
      })
    })

    it('uses preloaded pswp dims when available', () => {
      const pelicula = ref({ ...BASE_PELICULA, carousel_images: [] })
      const { bannerImages, pswpDims } = useBannerImages(pelicula)
      pswpDims.value = new Map([[BASE_PELICULA.imageURL, { w: 1280, h: 720 }]])
      expect(bannerImages.value[0].pswpWidth).toBe(1280)
      expect(bannerImages.value[0].pswpHeight).toBe(720)
    })
  })

  describe('onImageError', () => {
    it('removes main image when its src errors', () => {
      const pelicula = ref({ ...BASE_PELICULA, carousel_images: [] })
      const { bannerImages, onImageError } = useBannerImages(pelicula)
      expect(bannerImages.value).toHaveLength(1)
      onImageError(BASE_PELICULA.banner_image.src)
      expect(bannerImages.value).toHaveLength(0)
    })

    it('removes carousel image when its path errors', () => {
      const pelicula = ref({ ...BASE_PELICULA })
      const { bannerImages, onImageError } = useBannerImages(pelicula)
      expect(bannerImages.value).toHaveLength(3)
      onImageError('https://cdn.example.com/film_f02.jpg')
      expect(bannerImages.value).toHaveLength(2)
      expect(bannerImages.value.find((i) => i.href === 'https://cdn.example.com/film_f02.jpg')).toBeUndefined()
    })

    it('handles multiple errors without duplicates', () => {
      const pelicula = ref({ ...BASE_PELICULA })
      const { bannerImages, onImageError } = useBannerImages(pelicula)
      onImageError('https://cdn.example.com/film_f02.jpg')
      onImageError('https://cdn.example.com/film_f02.jpg')
      expect(bannerImages.value).toHaveLength(2)
    })
  })

  describe('accepts getter function', () => {
    it('works with getter instead of ref', () => {
      let data = { ...BASE_PELICULA, carousel_images: [] }
      const { bannerImages } = useBannerImages(() => data)
      expect(bannerImages.value).toHaveLength(1)
    })
  })
})
