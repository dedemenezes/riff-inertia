// composables/useFilterSearch.js

// Import core Vue features
import { ref, computed, watch, isRef } from "vue";
// Import Inertia.js router
import { router } from "@inertiajs/vue3";
// Utility function to remove null/empty values
import { cleanObject } from "@/lib/utils";

// Export composable function
export function useFilterSearch(initialParams = {}) {
  // Safely extract the initial query string (supporting both ref and raw values)
  const initialQuery = isRef(initialParams.query)
    ? initialParams.query.value
    : (initialParams.query || "");

  // Safely extract selected filters (ref or raw object)
  const initialSelectedFilters = isRef(initialParams.selectedFilters)
    ? initialParams.selectedFilters.value
    : (initialParams.selectedFilters || {});

  // Remove nested 'selectedFilters' key if it exists (prevents nesting inside filters)
  const { selectedFilters, ...cleanSelectedFilters } = initialSelectedFilters;

  // Store all filters (including the search query) as a reactive object
  const filters = ref({
    query: initialQuery,
    ...cleanSelectedFilters, // Spread any other filters (e.g. mostrasFilter)
  });

  // If the query param is a ref, keep it in sync with local `filters.query`
  if (isRef(initialParams.query)) {
    watch(initialParams.query, (newQuery) => {
      filters.value.query = newQuery || "";
    }, { immediate: false });
  }

  // Watch selectedFilters ref and update filters object when it changes
  if (isRef(initialParams.selectedFilters)) {
    watch(initialParams.selectedFilters, (newSelectedFilters) => {
      filters.value = {
        query: filters.value.query, // preserve query
        ...(newSelectedFilters || {}) // update filters
      };
    }, { deep: true, immediate: false });
  }

  // Computed property to check if any filter is active (non-empty)
  const hasActiveFilters = computed(() => {
    return Object.values(filters.value).some(
      (v) => v !== null && v !== "" && v !== undefined
    );
  });

  // Method to update a single field in the filters
  const updateField = (key, value) => {
    filters.value[key] = value;

    // If updating the query and it’s bound to a ref, update the source ref too
    if (key === 'query' && isRef(initialParams.query)) {
      initialParams.query.value = value;
    }
  };

  // Method to clear all filters (sets them to null)
  const clearAll = () => {
    Object.keys(filters.value).forEach((key) => {
      filters.value[key] = null;
    });

    // Also clear external query ref if it exists
    if (isRef(initialParams.query)) {
      initialParams.query.value = "";
    }
  };

  // Submits the filters via Inertia router.visit
  const submit = (baseUrl, options = {}) => {
    // Remove empty/null values from filters
    const cleaned = cleanObject(filters.value);

    // Merge with existing query params (if passed) and build query string
    const newQueryParams = buildQueryParams(
      options.existingParams || {},
      cleaned
    );

    // Compose final URL with query params
    const url = `${baseUrl}?${newQueryParams}`;

    // Inertia visit with common props preserved
    router.visit(url, {
      preserveState: true,
      only: options.only || [
        "elements",
        "searchQuery",
        "selectedFilters",
        "available_dates",
        "selected_date",
      ],
    });
  };

  // Builds the query string from params
  const buildQueryParams = (existingParams = {}, overrides = {}) => {
    const params = new URLSearchParams();

    // Merge existing and new filters
    const merged = { ...existingParams, ...overrides };

    // Add only valid params
    Object.entries(merged).forEach(([key, value]) => {
      if (value !== null && value !== undefined && value !== "") {
        // If it's a tag-like object, use permalink_pt
        if ((typeof(value) === 'object') && ("tag_class" in value)) {
          params.set(key, value.permalink_pt);
        } else {
          params.set(key, value);
        }
      }
    });

    return params.toString(); // Final query string
  }

  // Return reactive state and methods
  return {
    filters,            // reactive object with all filters and query
    hasActiveFilters,   // computed bool if anything is set
    updateField,        // function to update a specific filter
    clearAll,           // reset all filters
    submit,             // perform Inertia visit with filters
  };
}
