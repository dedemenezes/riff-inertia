/**
 * Extracts filter values from objects that follow the filter_value/filter_display pattern
 * @param {Object} filters - Object containing filter key-value pairs
 * @returns {Object} - Cleaned filters with extracted values
 */
export function extractFilterValues(filters) {
  const cleanedFilters = {}

  for (const [key, value] of Object.entries(filters)) {
    if (value == null) continue
    const filterParams = value?.filter_params
    const filterVal = value?.filter_value

    const isPrimitive = ['string', 'number', 'boolean'].includes(typeof filterVal)

    if (filterParams && typeof filterParams === 'object') {
      for (const [paramKey, paramValue] of Object.entries(filterParams)) {
        if (paramValue !== null && paramValue !== undefined && paramValue !== '') {
          cleanedFilters[paramKey] = paramValue
        }
      }
    } else if (typeof value === 'object' && isPrimitive) {
      cleanedFilters[key] = filterVal
    } else if (key === "query" && typeof value === 'string') {
      cleanedFilters[key] = value
    }
  }

  return cleanedFilters
}
