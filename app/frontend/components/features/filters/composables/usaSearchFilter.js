import { ref, watch } from "vue";
import { router } from "@inertiajs/vue3"
import { extractFilterValues } from "@/lib/filterUtils";

/**
 * FILTER STATE MANAGEMENT - SINGLE SOURCE OF TRUTH
 */
export function useSearchFilter(props) {
  // Props that will change when updating filters
  const propsToUpdate = ['elements', 'pagy', 'current_filters', 'current_session_type', 'has_active_filters']

  // Main filter state - this is passed to SearchFilter via ResponsiveFilterMenu
  const filters = ref({ ...props.current_filters });

  // Watch for prop changes from server (shouldn't happen often but good to have)
  watch(
    () => props.current_filters, // what is this watching?
    (newFilters) => {
      console.log(
        "ProgramPage: current_filters changed from server:",
        newFilters,
      );
      filters.value = { ...props.current_filters };
    },
    { immediate: true, deep: true },
  );

  // ============================================================================
  // FILTER OPERATIONS - CALLED BY SEARCHFILTER VIA EVENTS
  // ============================================================================

  const withSessionType = (params = {}) => {
    const queryParams = params instanceof URLSearchParams
      ? Object.fromEntries(params)
      : { ...params };

    if (props.current_session_type) {
      queryParams.tipo_sessao = props.current_session_type;
    }

    return queryParams;
  };

  const initializeFilters = () => {
    return Object.fromEntries(
      Object.keys(props.current_filters).map((key) => [key, null])
    );
  };

  /**
   * Called when SearchFilter emits filtersApplied
   * This makes the actual router call to update the page
   * @param {Object} filtersFromSearchFilter - Filters from SearchFilter
   * @returns {void}
   */

  const filterSearch = (filtersFromSearchFilter) => {
    console.log('ProgramPage: Applying filters from SearchFilter:', filtersFromSearchFilter);

    // Build query params by rejecting any filter: null or ""
    const cleanedFilters = extractFilterValues(filtersFromSearchFilter || filters.value)
    // MAke search request and says which prop to update
    router.get(props.tabBaseUrl, withSessionType(cleanedFilters), {
      preserveScroll: true,
      only: propsToUpdate
    })
  };

  /**
   * Called when user clicks a filter tag to remove it
   * This updates the filters state and makes a router call
   * @param {Object} filterToRemove - Filter to remove
   * @returns {void}
   */

  const removeQuery = (filterToRemove) => {
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
      "Publication date": "data",
      "Busca": "query",
      "Search": "query"
    };
    const filterKey = filterKeyMap[filterToRemove.filter_label];
    if (filterKey) {
      // Updated local filter state
      filters.value[filterKey] = null;

      // Build new URL params from remaining filters
      const newParams = new URLSearchParams();
      Object.entries(filters.value).forEach(([key, value]) => {
        if (
          value !== null &&
          value !== undefined &&
          value !== "" &&
          value?.filter_value
        ) {
          newParams.set(key, value.filter_value);
        }
      });

      router.get(props.tabBaseUrl, withSessionType(newParams), {
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
   * @returns {void}
   */

  const clearSearchQuery = () => {
    console.log('ProgramPage: Clearing all filters');

    const clearedFilters = initializeFilters()
    filters.value = clearedFilters
    // Only make router call if there were actually filters applied
    const hasFiltersApplied = Object.entries(props.current_filters).some(
      ([key, value]) => value != null,
    );
    if (hasFiltersApplied) {
      router.get(props.tabBaseUrl, withSessionType(), {
          preserveState: true,
          preserveScroll: true,
        only: propsToUpdate
      });
    }
  };

  /**
   * Called when user clears search bar directly (if needed)
   * This clears the search query and makes a router call
   * @returns {void}
   */

  const handleClear = () => {
    console.log('ProgramPage: Clearing search query');
    filters.value.query = null;
    filterSearch(filters.value);
  };

  return {
    initializeFilters,
    filters,
    filterSearch,
    removeQuery,
    clearSearchQuery,
    handleClear,
  };
}
