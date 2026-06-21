import createServer from '@inertiajs/vue3/server'
import { createInertiaSsrApp } from './create-inertia-app'

const port = Number(process.env.INERTIA_SSR_PORT || 13714)

createServer((page) => createInertiaSsrApp(page), { port })
