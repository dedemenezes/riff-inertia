import { createInertiaApp } from '@inertiajs/vue3'
import { createApp, h } from 'vue'
import PageLayout from '@pages/PageLayout.vue'
import { FocusTrap } from 'focus-trap-vue'

const wrappedPages = new WeakSet()

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob('../pages/**/*.vue', {
      eager: true,
    })
    const page = pages[`../pages/${name}.vue`]
    if (!wrappedPages.has(page.default)) {
      const childLayout = page.default.layout
      page.default.layout = childLayout ? [PageLayout, childLayout] : PageLayout
      wrappedPages.add(page.default)
    }
    return page
  },

  setup({ el, App, props, plugin }) {
    createApp({ render: () => h(App, props) })
      .component('FocusTrap', FocusTrap)
      .use(plugin)
      .mount(el)
  },
})
