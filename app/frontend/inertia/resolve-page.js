import PageLayout from '@pages/PageLayout.vue'

const wrappedPages = new WeakSet()
const pages = import.meta.glob('../pages/**/*.vue', { eager: true })

export function resolvePage(name) {
  const page = pages[`../pages/${name}.vue`]

  if (!page) {
    throw new Error(`Inertia page not found: ${name}`)
  }

  wrapWithDefaultLayout(page.default)

  return page
}

function wrapWithDefaultLayout(component) {
  if (wrappedPages.has(component)) return

  const childLayout = component.layout
  component.layout = childLayout ? [PageLayout, childLayout] : PageLayout
  wrappedPages.add(component)
}
