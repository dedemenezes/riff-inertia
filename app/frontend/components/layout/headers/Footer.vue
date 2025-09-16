<script setup>
import { IconInstagram, IconFacebook, IconTikTok, IconYoutube, IconLetterboxd, IconX, IconThreads, IconBlueSky, IconFlickr } from '@/components/common/icons/';
import TwContainer from '@/components/layout/TwContainer.vue';
import { usePage } from "@inertiajs/vue3";

const page = usePage()
const locale = page.props.currentLocale

</script>

<template>

  <div class="bg-neutrals-200 py-1200 text-neutrals-900">
    <TwContainer class="flex flex-col gap-1200">
      <div class="flex lg:justify-end lg:gap-1200 lg:flex-row flex-col gap-600 items-center">
        <div class="flex gap-1200">
          <a href="https://www.instagram.com/festivaldorio/">
            <IconInstagram
              color="text-neutrals-900"
            />
          </a>

          <a href="https://www.facebook.com/festivaldecinemadorio/">
            <IconFacebook
              color="text-neutrals-900"
            />
          </a>

          <a href="https://www.tiktok.com/@festivaldorio">
            <IconTikTok
              color="text-neutrals-900"
            />
          </a>

          <a href="https://www.youtube.com/@FestivaldoRio">
            <IconYoutube
              color="text-neutrals-900"
            />
          </a>
          <a href="https://letterboxd.com/festivaldorio/">
            <IconLetterboxd
            color="text-neutrals-900"
            />
          </a>
        </div>
        <div class="flex gap-1200">
          <a href="https://x.com/festivaldorio">
            <IconX
              color="text-neutrals-900"
            />
          </a>

          <a href="https://www.threads.net/@festivaldorio">
            <IconThreads
              color="text-neutrals-900"
            />
          </a>

          <a href="https://bsky.app/profile/festivaldorio.bsky.social">
            <IconBlueSky
              color="text-neutrals-900"
            />
          </a>

          <a href="https://www.flickr.com/photos/festivaldorio/">
            <IconFlickr
              color="text-neutrals-900"
            />
          </a>
        </div>
      </div>
      <div>
        <!-- TODO: Add rotas!!!!! -->
        <div class="flex lg:gap-1200 gap-400 text-body-regular border-b-1 py-300 flex-wrap lg:justify-start justify-center">
          <a :href="`/${locale}/`" class="p-200">O Festival</a>
          <a :href="`/${locale}/edicoes_anteriores`" class="p-200">Edições Anteriores</a>
          <a :href="`/${locale}/`" class="p-200">Talents Rio</a>
          <a :href="`/${locale}/`" class="p-200">Parceiros</a>
        </div>
        <div class="flex lg:gap-1200 gap-400 text-body-regular border-b-1 py-300 flex-wrap lg:justify-start justify-center">
          <a :href="`/${locale}/`" class="p-200">Fotos & Vídeos</a>
          <a :href="`/${locale}/`" class="p-200">Impressos</a>
        </div>
        <div class="flex lg:gap-1200 gap-400 text-body-regular border-b-1 py-300 flex-wrap lg:justify-start justify-center">
          <a :href="`/${locale}/`" class="p-200">Ingressos</a>
          <a :href="`/${locale}/`" class="p-200">Imprensa</a>
          <a :href="`/${locale}/`" class="p-200">Acessibilidade</a>
          <a :href="`/${locale}/`" class="p-200">Contatos</a>
        </div>
      </div>

      <h4 class="text-overline text-center">COPYRIGHT © FESTIVAL DO RIO 2025. TODOS OS DIREITOS RESERVADOS.</h4>
    </TwContainer>
  </div>
</template>

<style scoped></style>
