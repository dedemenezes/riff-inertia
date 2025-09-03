import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import path from "path"
import { fileURLToPath, URL } from 'node:url'

export default defineConfig({
  plugins: [
    vue(),
    tailwindcss(),
    RubyPlugin(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./app/frontend', import.meta.url)),
      '@/components': fileURLToPath(new URL('./app/frontend/components', import.meta.url)),
      '@/lib': fileURLToPath(new URL('./app/frontend/lib', import.meta.url)),
      '@/pages': fileURLToPath(new URL('./app/frontend/pages', import.meta.url)),
      '@/assets': fileURLToPath(new URL('./app/frontend/assets', import.meta.url)),
      "@assets": path.resolve(__dirname, "app/frontend/assets"),
      "@components": path.resolve(__dirname, "app/frontend/components"),
      "@pages": path.resolve(__dirname, "app/frontend/pages"),
    },
  },
})
