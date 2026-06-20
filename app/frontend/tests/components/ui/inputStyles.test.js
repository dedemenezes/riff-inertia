import { describe, expect, it } from "vitest";
import {
  inputFieldBaseClasses,
  inputFieldButtonClasses,
  inputFieldPlaceholderTextClasses,
  inputFieldValueTextClasses,
} from "@/components/ui/inputStyles";

describe("inputStyles", () => {
  it("matches the Figma input field visual contract", () => {
    expect(inputFieldBaseClasses).toContain("h-[45px]");
    expect(inputFieldBaseClasses).toContain("rounded-100");
    expect(inputFieldBaseClasses).toContain("border-neutrals-300");
    expect(inputFieldBaseClasses).toContain("bg-white");
    expect(inputFieldBaseClasses).toContain("px-300");
    expect(inputFieldBaseClasses).toContain("py-300");
    expect(inputFieldBaseClasses).toContain("font-body");
    expect(inputFieldBaseClasses).toContain("text-sm");
    expect(inputFieldBaseClasses).toContain("leading-[150%]");
  });

  it("keeps button-backed fields aligned with plain inputs", () => {
    expect(inputFieldButtonClasses).toContain(inputFieldBaseClasses);
    expect(inputFieldButtonClasses).toContain("inline-flex");
    expect(inputFieldButtonClasses).toContain("items-center");
  });

  it("uses Figma neutral text colors for placeholders and values", () => {
    expect(inputFieldPlaceholderTextClasses).toBe("text-neutrals-700");
    expect(inputFieldValueTextClasses).toBe("text-neutrals-900");
  });
});
