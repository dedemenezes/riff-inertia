import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import path from "path"

export default defineConfig({
  plugins: [
    vue(),
    tailwindcss(),
    RubyPlugin(),
  ],
  resolve: {
    alias: {
      "@assets": path.resolve(__dirname, "app/frontend/assets"),
      "@components": path.resolve(__dirname, "app/frontend/components"),
      "@pages": path.resolve(__dirname, "app/frontend/pages"),
    },
  },
})
