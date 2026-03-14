import { defineConfig } from "vitest/config";
import { resolve } from "path";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  plugins: [vue()], // ← ADD THIS: Vitest needs to understand .vue files
  test: {
    globals: true,
    environment: "jsdom", // ← CHANGE FROM 'node' to 'jsdom'
  },
  resolve: {
    alias: {
      "@": resolve(__dirname, "app/frontend"),
      "@components": resolve(__dirname, "app/frontend/components"),
    },
  },
});
