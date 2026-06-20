import { build } from "vite";
import { fileURLToPath } from "node:url";

const ssrEntry = fileURLToPath(new URL("./ssr.js", import.meta.url));

await build({
  build: {
    ssr: ssrEntry,
    outDir: "public/vite-ssr",
  },
});
