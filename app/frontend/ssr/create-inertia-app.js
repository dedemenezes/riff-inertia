import { createInertiaApp } from '@inertiajs/vue3'
import { renderToString } from '@vue/server-renderer'
import { createSSRApp, h } from 'vue'
import { FocusTrap } from 'focus-trap-vue'
import { resolvePage } from '../inertia/resolve-page'

export function createInertiaSsrApp(page) {
  return createInertiaApp({
    page,
    render: renderToString,
    resolve: resolvePage,
    setup({ App, props, plugin }) {
      return createSSRApp({ render: () => h(App, props) })
        .component('FocusTrap', FocusTrap)
        .use(plugin)
    },
  })
}
