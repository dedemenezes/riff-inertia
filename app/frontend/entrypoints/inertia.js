import { createInertiaApp } from '@inertiajs/vue3'
import { createApp, h } from 'vue'
import { FocusTrap } from 'focus-trap-vue'
import { resolvePage } from '../inertia/resolve-page'

createInertiaApp({
  resolve: resolvePage,

  setup({ el, App, props, plugin }) {
    createApp({ render: () => h(App, props) })
      .component('FocusTrap', FocusTrap)
      .use(plugin)
      .mount(el)
  },
})
