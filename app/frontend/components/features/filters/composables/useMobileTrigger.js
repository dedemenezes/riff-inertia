import { ref } from "vue"

export function useMobileTrigger() {
  const isFilterMenuOpen = ref(false);

  const openMenu = () => {
    // console.log(props.selectedFilters);

    isFilterMenuOpen.value = true;
    document.body.style.overflow = "hidden";
  };

  const closeMenu = () => {
    isFilterMenuOpen.value = false;
    document.body.style.overflow = "";
  };

  return {
    isFilterMenuOpen,
    openMenu,
    closeMenu
  }
}
