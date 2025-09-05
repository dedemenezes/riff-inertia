export function applyFiltersToQuery(filters) {
  const params = new URLSearchParams();

  for (const [key, value] of Object.entries(filters)) {
    if (value?.permalink_pt) {
      params.append(key, value.permalink_pt);
    }
  }

  return params.toString();
}
