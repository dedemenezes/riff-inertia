# Styling Guide - Custom Tailwind Configuration

## Design System Overview
The application uses a custom Tailwind CSS configuration with a complete design system for the Festival do Rio brand.

## Custom Spacing Scale
We use a custom spacing scale based on 100-unit increments:
```css
/* Custom spacing tokens */
100: "0.25rem"    /* 4px */
150: "0.375rem"   /* 6px */
200: "0.5rem"     /* 8px */
300: "0.75rem"    /* 12px */
400: "1rem"       /* 16px */
500: "1.25rem"    /* 20px */
1200: "3rem"      /* 48px */
/* And so on... */
```

**Usage**: `px-400` (16px), `py-200` (8px), `mb-200` (8px margin-bottom)

## Color System

### Brand Colors
- **Primary Gradient**: `from-magenta-600 to-laranja-600`
- **Background**: `bg-azul-400` (blue variant)
- **Error/Alert**: `bg-vermelho-600` (red variant)

### Neutrals
- `neutrals-900` - Primary text
- `neutrals-700` - Secondary text
- `neutrals-600` - Disabled text
- `neutrals-300` - Borders
- `neutrals-200` - Light backgrounds

### Transparencies
- `white-transp-1000` - Fully opaque white
- `text-primary` - Theme primary text color

## Typography Classes

### Custom Font Classes
- `text-header-base` - Header typography
- `text-subheading` - Subheading typography
- `font-body` - Body font family
- `leading-[24px]` - Custom line heights
- `tracking-wid` - Custom letter spacing

### Text Sizes
- `text-sm` + `leading-[19.6px]`
- `text-md` + `leading-[22.4px]`
- Standard responsive: `text-2xl lg:text-3xl`

## Component Styling Patterns

### Button Variants
```javascript
// In ButtonText.vue and BaseButton.vue
variants = {
  dark: "text-neutrals-900 hover:text-neutrals-700",
  light: "text-white-transp-1000",
  color: "bg-clip-text text-transparent bg-gradient-to-r from-magenta-600 to-laranja-600",
  cta: "bg-gradient-to-r from-magenta-600 to-laranja-600 hover:bg-gradient-to-l"
}
```

### Layout Components
- **TwContainer**: Responsive container with `px-400` padding and breakpoint-aware max-widths
- **Custom Breakpoints**: `xxl:max-w-xxl` (custom breakpoint)

## Key Styling Rules

1. **Use custom spacing scale**: Always use increments of 100 (100, 200, 300, 400, etc.)
2. **Gradient patterns**: Primary brand gradient used for CTAs and highlights
3. **Consistent hover states**: Defined for all interactive elements
4. **Focus states**: `focus:outline-2 focus:outline-offset-2` pattern
5. **Disabled states**: Consistent `disabled:text-neutrals-600 disabled:pointer-events-none`

## Icon System
- **BaseIcon**: Supports gradient fills when `active` prop is true
- **Default styling**: `text-neutrals-1000` with customizable className
- **Active state**: Uses brand gradient `url(#grad)`

## Layout Patterns
- **Flexbox-first**: Most layouts use `flex flex-col` or `inline-flex`
- **Gap spacing**: `gap-y-200`, `gap-x-400` using custom scale
- **Responsive padding**: `py-1200` for larger sections
- **Border patterns**: `border-l border-neutrals-300` for visual separation


# Components & Controller Data Flow Guide

## Controller → Inertia → Vue Pattern

### Basic Data Passing
Controllers render Inertia responses with props that become Vue component props:

```ruby
# In Controller
render inertia: "HomePage", props: {
  rootUrl: @root_url,
  quickLinksConfig: [...],
  noticias: [...]
}
```

```vue
<!-- In Vue Component -->
<script setup>
const props = defineProps({
  rootUrl: { type: String, required: true },
  quickLinksConfig: { type: Array },
  noticias: { type: Array }
})
</script>
```

## Key Data Transformation Patterns

### 1. Model Serialization
```ruby
# In PagesController#home
noticias = Noticia
  .includes(:caderno)
  .last(6)
  .as_json(
    only: %i[id titulo permalink chamada imagem],
    methods: [:caderno_nome, :display_date]
  )
```

### 2. I18n Data Preparation
```ruby
# Prepare translated navigation items
mainItems = [
  I18n.t("navigation.programming"),
  I18n.t("navigation.edition2024"),
  # ...
]
```

### 3. Configuration Objects
```ruby
# Complex configuration passed as props
quickLinksConfig = [
  {
    id: 1,
    title: "Programação",
    description: "Veja a programação completa...",
    href: program_url
  }
]
```

## Component Architecture Patterns

### 1. Layout Components
**PageLayout.vue** - Global layout receiving `rootUrl` from all controllers:
```vue
<script setup>
const props = defineProps({
  rootUrl: { type: String, required: true }
});
</script>
<template>
  <SponsorHeader class="bg-azul-400" />
  <NavbarMain :root-url="props.rootUrl"/>
  <main><slot /></main>
</template>
```

### 2. Feature Components
**HomePage.vue** - Page component consuming controller data:
```vue
<script setup>
const props = defineProps({
  quickLinksConfig: { type: Array },
  mainItems: { type: Array },
  secondaryItems: { type: Array },
  noticias: { type: Array }
})
</script>
```

### 3. Reusable Components
**QuickLinkCard.vue** - Receives individual configuration objects:
```vue
<script setup>
const props = defineProps({
  title: { type: String, required: true },
  description: { type: String, required: true },
  href: { type: String, default: "#" }
});
</script>
```

## Component Composition Patterns

### 1. Flexible Button Components
```js
<!-- ButtonText supports different HTML tags -->
<ButtonText
  tag="a"
  :href="href"
  variant="dark"
  size="md"
  :text="props.title"
/>

<!-- BaseButton for complex content -->
<BaseButton as="a" variant="cta" size="lg">
  <IconPlus /> Add New
</BaseButton>
```

### 2. Icon System
```js
<!-- BaseIcon with conditional gradient -->
<BaseIcon
  :active="isSelected"
  className="text-neutrals-700"
  width="24"
  height="24"
>
  <path d="..." />
</BaseIcon>
```

## Data Flow Best Practices

### 1. Controller Responsibilities
- **Data fetching**: Include necessary associations
- **Serialization**: Use `.as_json()` with specific fields and methods
- **I18n preparation**: Translate server-side when possible
- **URL generation**: Use Rails URL helpers (`root_url`, `program_url`)

### 2. Model Methods for Frontend
```ruby
# In Noticia model
def caderno_nome
  I18n.locale == :pt ? caderno&.nome_pt : caderno&.nome_en
end

def display_date
  updated.strftime("%d.%m.%Y")
end
```

### 3. Helper Integration
```ruby
# BreadcrumbsHelper
def breadcrumbs(*crumbs)
  crumbs.map { |label, path| { label: label, href: path } }
end

# Used in controller
breadcrumbs(
  ["Home", @root_url],
  ["Notícias", noticia_url(@noticia)],
  [@noticia.titulo, ""]
)
```

### 4. Component Prop Validation
Always define prop types and defaults:
```html
<script setup>
const props = defineProps({
  // Required props
  title: { type: String, required: true },

  // Props with defaults
  variant: {
    type: String,
    default: "dark",
    validator: (value) => ["dark", "light", "color"].includes(value)
  },

  // Optional props
  extraClasses: { type: String, default: "" }
});
</script>
```

## Key Architectural Decisions

1. **Global Layout Data**: `rootUrl` passed to all pages via ApplicationController
2. **Component Flexibility**: Buttons support different HTML tags via `tag`/`as` props
3. **Design System**: All spacing/colors use custom Tailwind tokens
4. **I18n Strategy**: Server-side translation in controllers, client-side formatting in components
5. **Model Methods**: Frontend-specific methods (like `display_date`) defined in models
