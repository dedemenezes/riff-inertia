<script setup>
import { ref, onMounted, onUnmounted, useTemplateRef} from "vue";
import { Link, usePage } from "@inertiajs/vue3";

import AccordionGroup from "@/components/AccordionGroup.vue";
import TheLanguageSwitcher from "@components/TheLanguageSwitcher.vue";
import { IconBoxArrowUp } from "@/components/common/icons";

// import { FocusTrap } from "focus-trap-vue"; //=> Imported globally inside inertia.js
const closeMenuButton = useTemplateRef('close-menu-button')

const page = usePage()

// Controls menu visibility
const isMobileMenuOpen = ref(false);

const openMenu = () => {
  isMobileMenuOpen.value = true;
  document.body.style.overflow = "hidden"; // prevent background scroll
};
const closeMenu = () => {
  isMobileMenuOpen.value = false;
  document.body.style.overflow = ""; // restore scroll
};

const handleKeydown = (e) => {
  if (e.key === 'Escape' && isMobileMenuOpen.value) {
    closeMenu();
  }
};

onMounted(() => {
  document.addEventListener('keydown', handleKeydown);
});

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeydown);
});
</script>
<template>
  <div class="md:hidden pt-100">
    <button
      @click="openMenu"
      class="text-neutrals-900 hover:bg-white/5 focus:outline-2 focus:-outline-offset-1 focus:outline-laranja-600"
      aria-controls="mobile-menu"
      aria-label="Open navigation menu"
      v-bind:aria-expanded="isMobileMenuOpen"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="33"
        height="33"
        viewBox="0 0 33 33"
        fill="currentColor"
        aria-hidden="true"
      >
        <path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d="M5.55078 24.5C5.55078 24.2348 5.65614 23.9804 5.84367 23.7929C6.03121 23.6054 6.28556 23.5 6.55078 23.5H26.5508C26.816 23.5 27.0704 23.6054 27.2579 23.7929C27.4454 23.9804 27.5508 24.2348 27.5508 24.5C27.5508 24.7652 27.4454 25.0196 27.2579 25.2071C27.0704 25.3946 26.816 25.5 26.5508 25.5H6.55078C6.28556 25.5 6.03121 25.3946 5.84367 25.2071C5.65614 25.0196 5.55078 24.7652 5.55078 24.5ZM5.55078 16.5C5.55078 16.2348 5.65614 15.9804 5.84367 15.7929C6.03121 15.6054 6.28556 15.5 6.55078 15.5H26.5508C26.816 15.5 27.0704 15.6054 27.2579 15.7929C27.4454 15.9804 27.5508 16.2348 27.5508 16.5C27.5508 16.7652 27.4454 17.0196 27.2579 17.2071C27.0704 17.3946 26.816 17.5 26.5508 17.5H6.55078C6.28556 17.5 6.03121 17.3946 5.84367 17.2071C5.65614 17.0196 5.55078 16.7652 5.55078 16.5ZM5.55078 8.5C5.55078 8.23478 5.65614 7.98043 5.84367 7.79289C6.03121 7.60536 6.28556 7.5 6.55078 7.5H26.5508C26.816 7.5 27.0704 7.60536 27.2579 7.79289C27.4454 7.98043 27.5508 8.23478 27.5508 8.5C27.5508 8.76522 27.4454 9.01957 27.2579 9.20711C27.0704 9.39464 26.816 9.5 26.5508 9.5H6.55078C6.28556 9.5 6.03121 9.39464 5.84367 9.20711C5.65614 9.01957 5.55078 8.76522 5.55078 8.5Z"
        />
      </svg>
    </button>
    <!-- Mobile menu -->
    <transition name="slide">
      <FocusTrap
        v-model:active="isMobileMenuOpen"
        :initial-focus="() => $refs.closeMenuButton"
        v-if="isMobileMenuOpen"
      >
        <div
          v-show="isMobileMenuOpen"
          class="fixed inset-0 z-50 bg-white flex flex-col w-full max-w-full right-0 shadow-lg overflow-y-auto"
          id="mobile-menu"
        >
          <!-- Close Button -->
          <div class="flex justify-between p-400">
            <Link @click="closeMenu" href="/">
              <img
                src="@assets/logos/festival-logo-mobile.svg"
                alt="Logo Festival do Rio"
              />
            </Link>

            <TheLanguageSwitcher />
            <button ref="closeMenuButton" @click="closeMenu" class="text-neutrals-900">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="32"
                height="33"
                viewBox="0 0 32 33"
                fill="none"
              >
                <path
                  d="M9.29379 9.79183C9.38668 9.69871 9.49703 9.62482 9.61852 9.57441C9.74001 9.524 9.87025 9.49805 10.0018 9.49805C10.1333 9.49805 10.2636 9.524 10.3851 9.57441C10.5065 9.62482 10.6169 9.69871 10.7098 9.79183L16.0018 15.0858L21.2938 9.79183C21.3868 9.69886 21.4971 9.62511 21.6186 9.57479C21.7401 9.52447 21.8703 9.49857 22.0018 9.49857C22.1333 9.49857 22.2635 9.52447 22.385 9.57479C22.5064 9.62511 22.6168 9.69886 22.7098 9.79183C22.8028 9.88481 22.8765 9.99519 22.9268 10.1167C22.9771 10.2381 23.003 10.3683 23.003 10.4998C23.003 10.6313 22.9771 10.7615 22.9268 10.883C22.8765 11.0045 22.8028 11.1149 22.7098 11.2078L17.4158 16.4998L22.7098 21.7918C22.8028 21.8848 22.8765 21.9952 22.9268 22.1167C22.9771 22.2381 23.003 22.3683 23.003 22.4998C23.003 22.6313 22.9771 22.7615 22.9268 22.883C22.8765 23.0045 22.8028 23.1149 22.7098 23.2078C22.6168 23.3008 22.5064 23.3746 22.385 23.4249C22.2635 23.4752 22.1333 23.5011 22.0018 23.5011C21.8703 23.5011 21.7401 23.4752 21.6186 23.4249C21.4971 23.3746 21.3868 23.3008 21.2938 23.2078L16.0018 17.9138L10.7098 23.2078C10.6168 23.3008 10.5064 23.3746 10.385 23.4249C10.2635 23.4752 10.1333 23.5011 10.0018 23.5011C9.8703 23.5011 9.7401 23.4752 9.61862 23.4249C9.49714 23.3746 9.38676 23.3008 9.29379 23.2078C9.20081 23.1149 9.12706 23.0045 9.07674 22.883C9.02642 22.7615 9.00052 22.6313 9.00052 22.4998C9.00052 22.3683 9.02642 22.2381 9.07674 22.1167C9.12706 21.9952 9.20081 21.8848 9.29379 21.7918L14.5878 16.4998L9.29379 11.2078C9.20066 11.1149 9.12677 11.0046 9.07636 10.8831C9.02595 10.7616 9 10.6314 9 10.4998C9 10.3683 9.02595 10.2381 9.07636 10.1166C9.12677 9.99508 9.20066 9.88473 9.29379 9.79183Z"
                  fill="#3B3935"
                />
              </svg>
            </button>
          </div>

          <!-- Menu Content -->
          <nav class="flex-1 px-400 py-600 space-y-800">
            <AccordionGroup
              :isOpen="false"
              v-for="[navText, subItems] in Object.entries(page.props.mainItems)"
              :key="navText"
              :text="navText"
            >
            <template v-slot:content>
                <ul class="ps-600 pt-400 space-y-800">
                  <li
                    v-for="item in subItems"
                    :key="item.path"
                  >
                    <Link
                      @click="closeMenu"
                      :href="item.path"
                    >
                      {{ item.name }}
                    </Link>
                  </li>
                </ul>
              </template>
            </AccordionGroup>
            <Link
              v-for="item in page.props.secondaryItems"
              :key="item.name"
              @click="closeMenu"
              :href="item.href"
              class="block font-body font-semibold text-neutrals-900 leadgin-[19.6px] text-sm uppercase pb-300"
            >
              {{ item.name }}
            </Link>
            <Link href="#" class="block font-body font-semibold leadgin-[19.6px] text-sm uppercase pb-300 text-vermelho-600 hover:opacity-80 flex items-center gap-300">RIOMARKET <IconBoxArrowUp height="16" width="16" color="inherit"/></Link>
          </nav>
        </div>
      </FocusTrap>

    </transition>
  </div>
</template>

<style scoped>
/* transition vue component animation classes */
.slide-enter-active,
.slide-leave-active {
  transition: transform 0.3s ease;
}
.slide-enter-from,
.slide-leave-to {
  transform: translateX(100%);
}
</style>
