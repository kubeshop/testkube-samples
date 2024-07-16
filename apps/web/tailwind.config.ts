import type { Config } from "tailwindcss";
import tailwindcssRadixColors from "tailwindcss-radix-colors";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [tailwindcssRadixColors],
} satisfies Config;
