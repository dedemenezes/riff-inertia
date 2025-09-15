import { ref, watch } from "vue";
import { router } from "@inertiajs/vue3"
import { extractFilterValues } from "@/lib/filterUtils";

/**
 * FILTER STATE MANAGEMENT - SINGLE SOURCE OF TRUTH
 */
export function useSearchFilter(props, filtersFromController = {}) {
  /**
   * Initialize empty filter structure
   */
  console.log(filtersFromController);

  const initializeFilters = () => (filtersFromController)

  /**
   * Override empty filters with current filter values from controller
   */
  const overrideFiltersValues = () => {
    return { ...initializeFilters(), ...props.current_filters }
  }

  // Props that will change when updating filters
  const propsToUpdate = ['elements', 'pagy', 'current_filters', 'has_active_filters', 'menuTabs']

  // Main filter state - this is passed to SearchFilter via ResponsiveFilterMenu
  const filters = ref(overrideFiltersValues())

  // Watch for prop changes from server (shouldn't happen often but good to have)
  watch(() => props.current_filters, (newFilters) => {
    console.log('ProgramPage: current_filters changed from server:', newFilters);
    filters.value = overrideFiltersValues()
  }, { immediate: true, deep: true })

  // ============================================================================
  // FILTER OPERATIONS - CALLED BY SEARCHFILTER VIA EVENTS
  // ============================================================================

  /**
   * Called when SearchFilter emits filtersApplied
   * This makes the actual router call to update the page
   */

  const filterSearch = (filtersFromSearchFilter) => {
    console.log('ProgramPage: Applying filters from SearchFilter:', filtersFromSearchFilter);

    // Build query params by rejecting any filter: null or ""
    const cleanedFilters = extractFilterValues(filtersFromSearchFilter || filters.value)
    debugger
    // MAke search request and says which prop to update
    router.get(props.tabBaseUrl, cleanedFilters, {
      preserveScroll: true,
      only: propsToUpdate
    })
  };

  /**
   * Called when user clicks a filter tag to remove it
   * This updates the filters state and makes a router call
   */

  const removeQuery = (filterToRemove) => {
    debugger
    // Clear the specific filter
    // TODO: REFAC TIP ADD FILTER_KEY FROM CONTROLLER
    // IT SHOULD MAKE AGNOSTIC
    // Map filter labels to filter keys (could be improved with a filter_key from controller)
    const filterKeyMap = {
      'Time': 'sessao',
      'Sessão': 'sessao',
      'Showcase': 'mostra',
      'Mostra': 'mostra',
      'Cinema': 'cinema',
      'Genre': 'genero',
      'Genero': 'genero',
      'Country': 'pais',
      'País': 'pais',
      'Director': 'direcao',
      'Direção': 'direcao',
      'Cast': 'elenco',
      'Elenco': 'elenco',
      "Caderno": "caderno",
      "Category": "caderno",
      "Data de publicação": "data",
      "Publication date": "data"
    };
    const filterKey = filterKeyMap[filterToRemove.filter_label];
    if (filterKey) {
      // Updated local filter state
      filters.value[filterKey] = null;

      // Build new URL params from remaining filters
      const newParams = new URLSearchParams();
      Object.entries(filters.value).forEach(([key, value]) => {
        if (value !== null && value !== undefined && value !== "" && value?.filter_value) {
          newParams.set(key, value.filter_value);
        }
      });

      router.get(props.tabBaseUrl, newParams, {
        preserveScroll: true,
        only: propsToUpdate
      })
    } else {
      console.warn('ProgramPage: Unknown filter label:', filterToRemove.filter_label);
    }
  }

  /**
   * Called when SearchFilter emits filtersCleared
   * This clears all filters and optionally makes a router call
   */
  const clearSearchQuery = () => {
    console.log('ProgramPage: Clearing all filters');

    const clearedFilters = initializeFilters()
    filters.value = clearedFilters
    // Only make router call if there were actually filters applied
    const hasFiltersApplied = Object.entries(props.current_filters).some(([key, value]) => value != null)
    if (hasFiltersApplied) {
      router.get(props.tabBaseUrl, {}, {
        preserveState: true,
        preserveScroll: true,
        only: propsToUpdate
      });
    }
  };

  /**
   * Called when user clears search bar directly (if needed)
   */
  const handleClear = () => {
    console.log('ProgramPage: Clearing search query');
    filters.value.query = null;
    filterSearch(filters.value);
  };

  return {
    initializeFilters,
    overrideFiltersValues,
    filters,
    filterSearch,
    removeQuery,
    clearSearchQuery,
    handleClear
  }
}
