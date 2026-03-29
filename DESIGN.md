# Design System Document: Precision Engineering & Tonal Depth

## 1. Overview & Creative North Star
### The Creative North Star: "The Technical Atelier"
Automotive service is often associated with grease and chaos; this design system reclaims that space as one of high-precision engineering and clinical reliability. We move beyond "blue boxes" by embracing a **High-End Editorial** layout—one that treats data like a luxury car’s dashboard. 

The system rejects the "template" look. We break the rigid, centered grid in favor of **intentional asymmetry** and **tonal layering**. By utilizing sophisticated overlaps and high-contrast typography scales, we create an experience that feels custom-built, authoritative, and frictionless. The interface shouldn't just look "modern"; it should look like a bespoke diagnostic tool for a premium vehicle.

---

## 2. Colors & Surface Logic
The palette is rooted in deep, technical blues and slate greys, punctuated by high-energy "ignition" accents.

### The "No-Line" Rule
**Prohibit 1px solid borders for sectioning.** Physical boundaries must be defined solely through background shifts or subtle tonal transitions. For example, a `surface-container-low` card sitting on a `surface` background provides all the definition needed. If you feel the urge to draw a line, use whitespace (`spacing-8`) instead.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers—like stacked sheets of frosted glass or fine carbon fiber. Use the container tiers to define importance:
*   **Base:** `surface` (#f9f9ff)
*   **Secondary Content:** `surface-container-low` (#f1f3ff)
*   **Interactive Cards:** `surface-container-lowest` (#ffffff)
*   **Elevated Details:** `surface-container-highest` (#d7e2ff)

### The "Glass & Gradient" Rule
To escape a flat, "out-of-the-box" feel, use **Glassmorphism** for floating navigation bars or overlays. Use semi-transparent `surface` colors with a `backdrop-blur` of 20px. 
*   **Signature Textures:** Apply subtle linear gradients (from `primary` #000000 to `primary-container` #001847) for main CTAs. This creates a "lathe-turned" metallic depth that flat colors cannot mimic.

---

## 3. Typography
We pair the technical precision of **Space Grotesk** for headlines with the utilitarian clarity of **Inter** for data.

*   **Display & Headlines (Space Grotesk):** These are your "Statement" elements. Use `display-lg` (3.5rem) with tight letter-spacing for hero metrics (e.g., "98% Engine Health"). The geometric nature of Space Grotesk mirrors automotive branding.
*   **Titles & Body (Inter):** Used for reliability. `title-md` (1.125rem) should be used for section headers to maintain a professional, "service manual" feel.
*   **Labels (Inter):** `label-sm` (0.6875rem) in `on-surface-variant` (#44474c) should be used for technical metadata (e.g., VIN numbers, torque specs) to ensure they feel like part of a sophisticated instrument cluster.

---

## 4. Elevation & Depth
In this system, depth is earned through light and tone, not drop shadows.

*   **The Layering Principle:** Stacking is the primary driver of hierarchy. Place a `surface-container-lowest` card on a `surface-container-low` section. This creates a "soft lift" that feels architectural rather than digital.
*   **Ambient Shadows:** When an element must float (e.g., a critical "Book Service" modal), use an ultra-diffused shadow. 
    *   *Spec:* `Y: 20px, Blur: 40px, Color: on-surface (10% opacity)`. This mimics natural ambient light in a clean garage environment.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility, use the `outline-variant` (#c4c6cc) at **15% opacity**. Never use a 100% opaque border.
*   **Glassmorphism:** Use `surface-tint` (#0056d2) at low opacities (5-10%) as a backdrop filter for "Active" states to create a glowing, technical aura.

---

## 5. Components

### Buttons: The "Ignition" Elements
*   **Primary:** A high-contrast gradient from `on-tertiary-container` (#dd5c00) to `on-tertiary-fixed-variant` (#7a3000). Use `rounded-md` (0.375rem) for a sharp, machined look.
*   **Secondary:** `surface-container-highest` with `on-primary-container` text. No border.
*   **Tertiary:** Text-only in `primary-fixed-dim`, used for low-priority actions like "View History."

### Input Fields: The "Diagnostic" Look
*   **Style:** No bottom line or box. Use `surface-container-low` as the background with a `rounded-sm` corner. 
*   **State:** On focus, transition the background to `surface-container-highest` and add a subtle `surface-tint` glow.

### Cards & Lists: Editorial Separation
*   **Rule:** Forbid divider lines. 
*   **Implementation:** Use `spacing-10` (2.25rem) between list items. For complex data, alternate backgrounds between `surface` and `surface-container-low`.
*   **Automotive Context:** Create "Status Cards" using `tertiary_container` (#351000) for alerts, ensuring the orange accent feels like a warning light on a dashboard.

### Service Progress Tracker (Custom Component)
Use a non-linear layout. Instead of a standard horizontal bar, use a vertical "Indented Stack" where the current status is highlighted with a `surface-tint` glass effect and `headline-sm` typography, while past/future states are dimmed to `on-surface-variant`.

---

## 6. Do's and Don'ts

### Do:
*   **Use Asymmetry:** Align technical specs to the right while headlines stay left to create an editorial feel.
*   **Embrace "Dead" Space:** Use `spacing-16` (3.5rem) to separate major service categories. Large gaps convey confidence.
*   **Layer Tones:** Use `surface-container` tiers to group related car parts or service tasks.

### Don't:
*   **Don't Use Pure Black Shadows:** It kills the "Technical Atelier" look. Always tint shadows with the `on-surface` blue-grey tone.
*   **Don't Use 1px Dividers:** They make the app look like a generic database. Use background color shifts.
*   **Don't Round Everything:** Avoid `rounded-full` for functional elements. Stick to `rounded-md` or `rounded-lg` to maintain a "machined part" aesthetic.
*   **Don't Overuse the Accent:** Save the orange (`tertiary`) for "Action" and "Alert." If everything is orange, nothing is important.