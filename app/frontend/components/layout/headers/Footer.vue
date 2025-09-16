<script setup>
import { IconInstagram, IconFacebook, IconTikTok, IconYoutube, IconLetterboxd, IconX, IconThreads, IconBlueSky, IconFlickr } from '@/components/common/icons/';
import TwContainer from '@/components/layout/TwContainer.vue';


</script>

<template>

  <div class="bg-neutrals-200 py-1200">
    <TwContainer class="flex flex-col gap-1200">
      <div class="flex justify-end gap-1200">
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
    </TwContainer>
  </div>
</template>

<style scoped></style>
