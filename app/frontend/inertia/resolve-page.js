import PageLayout from '@pages/PageLayout.vue'

const wrappedPages = new WeakSet()
const pages = import.meta.glob('../pages/**/*.vue')

export async function resolvePage(name) {
  const loadPage = pages[`../pages/${name}.vue`]

  if (!loadPage) {
    throw new Error(`Inertia page not found: ${name}`)
  }

  const page = await loadPage()
  wrapWithDefaultLayout(page.default)

  return page
}

function wrapWithDefaultLayout(component) {
  if (wrappedPages.has(component)) return

  const childLayout = component.layout
  component.layout = childLayout ? [PageLayout, childLayout] : PageLayout
  wrappedPages.add(component)
}
